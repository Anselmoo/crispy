# coding: utf-8
###################################################################
# Copyright (c) 2016-2022 European Synchrotron Radiation Facility #
#                                                                 #
# Author: Marius Retegan                                          #
#                                                                 #
# This work is licensed under the terms of the MIT license.       #
# For further information, see https://github.com/mretegan/crispy #
###################################################################
"""Quanty dock widget components."""

import logging
import os

from PyQt5.QtCore import QItemSelectionModel, QModelIndex, QPoint, Qt, pyqtSignal
from PyQt5.QtGui import QIcon
from PyQt5.QtWidgets import QAction, QDockWidget, QFileDialog, QMenu, QWidget
from PyQt5.uic import loadUi

from crispy import resourceAbsolutePath
from crispy.config import Config
from crispy.models import TreeModel
from crispy.quanty.calculation import Calculation
from crispy.quanty.details import DetailsDialog
from crispy.quanty.preferences import PreferencesDialog
from crispy.quanty.progress import ProgressDialog
from crispy.utils import findQtObject, setMappings

logger = logging.getLogger(__name__)
settings = Config().read()


class AxisWidget(QWidget):
    def __init__(self, parent=None):
        super().__init__(parent=parent)

        uiPath = os.path.join("quanty", "uis", "axis.ui")
        loadUi(resourceAbsolutePath(uiPath), baseinstance=self)

        self.mappers = []

    def populate(self, axis):
        if self.mappers:
            for mapper in self.mappers:
                mapper.clearMapping()
        MAPPINGS = (
            (self.startLineEdit, axis.start),
            (self.stopLineEdit, axis.stop),
            (self.nPointsLineEdit, axis.npoints),
            (self.gaussianLineEdit, axis.gaussian),
            (self.lorentzianLineEdit, axis.lorentzian),
            (self.kLineEdit, axis.photon.k),
            (self.e1LineEdit, axis.photon.e1),
            (self.e2LineEdit, axis.photon.e2),
        )
        self.mappers = setMappings(MAPPINGS)
        self.lorentzianToolButton.setVisible(False)


class GeneralSetupPage(QWidget):

    comboBoxChanged = pyqtSignal()

    def __init__(self, parent=None):
        super().__init__(parent=parent)

        uiPath = os.path.join("quanty", "uis", "general.ui")
        loadUi(resourceAbsolutePath(uiPath), baseinstance=self)

        self.xAxis = AxisWidget()
        self.yAxis = AxisWidget()
        self.axesTabWidget.addTab(self.xAxis, None)

        self.mappers = []

        self.symbolComboBox.currentTextChanged.connect(self.comboBoxChanged)
        self.chargeComboBox.currentTextChanged.connect(self.comboBoxChanged)
        self.symmetryComboBox.currentTextChanged.connect(self.comboBoxChanged)
        self.experimentComboBox.currentTextChanged.connect(self.comboBoxChanged)
        self.edgeComboBox.currentTextChanged.connect(self.comboBoxChanged)

    def update(self):
        pass

    def populate(self, state):
        model = state.model()

        self.symbolComboBox.setItems(state.symbols, state.element.symbol)
        self.chargeComboBox.setItems(state.charges, state.element.charge)
        self.symmetryComboBox.setItems(state.symmetries, state.symmetry.value)
        self.experimentComboBox.setItems(state.experiments, state.experiment.value)
        self.edgeComboBox.setItems(state.edges, state.edge.value)

        if self.mappers:
            for mapper in self.mappers:
                mapper.clearMapping()

        MAPPINGS = (
            (self.temperatureLineEdit, state.temperature),
            (self.magneticFieldLineEdit, state.magneticField),
        )
        self.mappers = setMappings(MAPPINGS)

        self.xAxis.populate(state.axes.xaxis)
        self.axesTabWidget.setTabText(0, state.axes.xaxis.label)

        if state.experiment.isTwoDimensional:
            self.axesTabWidget.addTab(self.yAxis, None)
            self.axesTabWidget.setTabText(1, state.axes.yaxis.label)
            self.yAxis.populate(state.axes.yaxis)
        else:
            self.axesTabWidget.removeTab(1)

        self.spectraView.setModel(model)
        self.spectraView.setRootIndex(state.spectra.toCalculate.index())
        self.spectraView.hideColumn(1)
        self.spectraView.hideColumn(2)
        self.spectraView.setHeaderHidden(True)
        self.spectraView.expandAll()


class HamiltonianSetupPage(QWidget):
    def __init__(self, parent=None):
        super().__init__(parent=parent)

        uiPath = os.path.join("quanty", "uis", "hamiltonian.ui")
        loadUi(resourceAbsolutePath(uiPath), baseinstance=self)

        self.mappers = []
        # This is needed for the updateAutoStates.
        self.hamiltonian = None

    def populate(self, state):
        hamiltonian = state.hamiltonian
        self.hamiltonian = hamiltonian
        model = state.model()

        if self.mappers:
            for mapper in self.mappers:
                mapper.clearMapping()
        MAPPINGS = (
            (self.fkLineEdit, hamiltonian.fk),
            (self.gkLineEdit, hamiltonian.gk),
            (self.zetaLineEdit, hamiltonian.zeta),
            (self.syncParametersCheckBox, hamiltonian.synchronizeParameters),
            (self.nStatesLineEdit, hamiltonian.numberOfStates),
            (self.nStatesAutoCheckBox, hamiltonian.numberOfStates.auto),
            (self.nConfigurationsLineEdit, hamiltonian.numberOfConfigurations),
        )
        self.mappers = setMappings(MAPPINGS)

        self.termsView.setModel(model)

        # Set the root index of the terms view.
        terms = hamiltonian.terms
        index = model.indexFromItem(terms)
        self.termsView.setRootIndex(index)

        # Select the first Hamiltonian term.
        index = model.indexFromItem(terms.children()[0])
        selectionModel = self.termsView.selectionModel()
        selectionModel.setCurrentIndex(index, QItemSelectionModel.Select)
        selectionModel.selectionChanged.disconnect()
        selectionModel.selectionChanged.connect(self.updateParametersView)

        self.parametersView.setModel(model)
        self.parametersView.expandAll()
        # self.parametersView.setColumnWidth(0, 130)
        currentIndex = self.termsView.currentIndex()
        self.parametersView.setRootIndex(currentIndex)

        value = hamiltonian.numberOfStates.auto.value
        self.nStatesLineEdit.setEnabled(not value)
        # Having this enabled will cause the nStatesAutoCheckBox to be checked, which
        # in turn will cause the numberOfStates to be reset to the maximum number.
        # self.nStatesAutoCheckBox.stateChanged.disconnect()
        self.nStatesAutoCheckBox.stateChanged.connect(self.updateAutoStates)

    def updateParametersView(self):
        index = self.termsView.currentIndex()
        self.parametersView.setRootIndex(index)
        self.parametersView.expandAll()

    def updateAutoStates(self, value):
        # Reset the number of states to the maximum if the box is checked.
        if value == Qt.Checked:
            self.hamiltonian.numberOfStates.reset()
        self.nStatesLineEdit.setEnabled(not value)


class ResultsPage(QWidget):
    # pylint: disable=too-many-instance-attributes

    currentIndexChanged = pyqtSignal(QModelIndex)

    def __init__(self, parent=None):
        super().__init__(parent=parent)

        uiPath = os.path.join("quanty", "uis", "results.ui")
        loadUi(resourceAbsolutePath(uiPath), baseinstance=self)

        self.detailsDialog = DetailsDialog(parent=self)

        # Add a context menu to the view.
        path = os.path.join("icons", "clipboard.svg")
        icon = QIcon(resourceAbsolutePath(path))
        self.showDetailsDialogAction = QAction(
            icon, "Show Details", self, triggered=self.showDetailsDialog
        )

        path = os.path.join("icons", "save.svg")
        icon = QIcon(resourceAbsolutePath(path))
        self.saveSelectedResultsAsAction = QAction(
            icon, "Save Selected Results As...", self, triggered=self.saveSelected
        )

        path = os.path.join("icons", "trash.svg")
        icon = QIcon(resourceAbsolutePath(path))
        self.removeSelectedResultsAction = QAction(
            icon, "Remove Selected Results", self, triggered=self.removeSelected
        )

        path = os.path.join("icons", "folder-open.svg")
        icon = QIcon(resourceAbsolutePath(path))
        self.loadResultsAction = QAction(
            icon, "Load Results", self, triggered=self.load
        )

        self.contextMenu = QMenu("Results Context Menu", self)
        self.contextMenu.addAction(self.showDetailsDialogAction)
        self.contextMenu.addSeparator()
        self.contextMenu.addAction(self.saveSelectedResultsAsAction)
        self.contextMenu.addAction(self.removeSelectedResultsAction)
        self.contextMenu.addSeparator()
        self.contextMenu.addAction(self.loadResultsAction)

        self.view.setContextMenuPolicy(Qt.CustomContextMenu)
        self.view.customContextMenuRequested[QPoint].connect(
            self.showResultsContextMenu
        )

        self.model = TreeModel(parent=self)
        self.view.setModel(self.model)
        selectionModel = self.view.selectionModel()
        selectionModel.selectionChanged.connect(self.selectionChanged)

        # TODO: How to distinguish between a dataChanged related to change in
        # the name and a change in the checked state? Only the last one should
        # trigger the actions.
        self.model.dataChanged.connect(self.plot)
        self.currentIndexChanged.connect(
            lambda index: self.detailsDialog.populate(index.internalPointer())
        )

        self._currentIndex = QModelIndex()

    @property
    def currentIndex(self):
        return self._currentIndex

    @currentIndex.setter
    def currentIndex(self, value):
        self._currentIndex = value
        self.currentIndexChanged.emit(value)

    def removeSelected(self):
        indexes = self.view.selectedIndexes()

        items = []
        for index in reversed(indexes):
            item = index.internalPointer()
            items.append(item)

        for item in items:
            item.setParent(None)

        index = self.model.firstIndex()
        if index.isValid():
            # This changes the selection, and the self.currentIndex will be
            # updated.
            self.view.setCurrentIndex(index)
        else:
            self.currentIndex = QModelIndex()

        self.model.dataChanged.emit(self.currentIndex, self.currentIndex)

    def saveSelected(self):
        pass

    def load(self):
        pass

    def plot(self, *args):
        calculations = self.model.rootItem().children()

        index, *_ = args
        # Return if the index is invalid but there are still calculations in
        # the model.
        if not index.isValid() and calculations:
            return
        # Get the last item the user has changed.
        last = index.internalPointer()

        # Always reset the plot widget.
        plotWidget = findQtObject(name="plotWidget")
        plotWidget.reset()

        if not calculations:
            return

        # TODO: The logic here seems very convoluted.
        if isinstance(last, Calculation):
            self.model.blockSignals(True)
            if last.experiment.isTwoDimensional:
                for calculation in calculations:
                    if last != calculation:
                        calculation.checkState = Qt.Unchecked
            else:
                for calculation in calculations:
                    if calculation.experiment.isTwoDimensional:
                        calculation.checkState = Qt.Unchecked
            self.model.blockSignals(False)

        # Make a list with the checked calculations.
        calculations = [c for c in calculations if c.checkState]
        if not calculations:
            return

        for item in calculations:
            item.spectra.plot(plotWidget=plotWidget)

        # Reset the plot widget if nothing new was plotted.
        if plotWidget.isEmpty():
            plotWidget.reset()

        # Emit the dataChanged() signal to inform the views that some things
        # might have changed in the model. Use an invalid index to return early
        # when this function is called again.
        self.model.dataChanged.emit(QModelIndex(), QModelIndex())

    def selectionChanged(self):
        indexes = self.view.selectedIndexes()
        try:
            [index] = indexes
        except ValueError:
            return
        self.currentIndex = index

    def showResultsContextMenu(self, position):
        selected = bool(self.view.selectedIndexes())
        self.removeSelectedResultsAction.setEnabled(selected)
        self.saveSelectedResultsAsAction.setEnabled(selected)

        # Enable the action only if there is a valid item under the cursor.
        # TODO: Probably also check if the item is of a valid class.
        # No need to set the current index to the index at position. This is
        # done already when the selection changes.
        index = self.view.indexAt(position)
        self.showDetailsDialogAction.setEnabled(index.internalPointer() is not None)
        self.contextMenu.exec_(self.view.mapToGlobal(position))

    def showDetailsDialog(self):
        result = self.currentIndex.internalPointer()
        self.detailsDialog.populate(result)
        self.detailsDialog.show()
        self.detailsDialog.raise_()


class DockWidget(QDockWidget):
    # pylint: disable=too-many-instance-attributes
    def __init__(self, parent=None):
        super().__init__(parent=parent)

        uiPath = os.path.join("quanty", "uis", "main.ui")
        loadUi(resourceAbsolutePath(uiPath), baseinstance=self)

        self.model = TreeModel()

        self.preferencesDialog = PreferencesDialog(self)
        self.preferencesDialog.settingsChanged.connect(self.populate)

        # Remove the placeholder page.
        self.toolBox.removeItem(0)

        self.generalPage = GeneralSetupPage()
        self.toolBox.addItem(self.generalPage, "General Setup")

        self.hamiltonianPage = HamiltonianSetupPage()
        self.toolBox.addItem(self.hamiltonianPage, "Hamiltonian Setup")

        self.resultsPage = ResultsPage()
        self.toolBox.addItem(self.resultsPage, "Results")

        # Setup the initial state and populate the widgets.
        self.state = Calculation(parent=self.model.rootItem())

        self.generalPage.comboBoxChanged.connect(self.populate)
        self.resultsPage.currentIndexChanged.connect(self.populate)

        self.saveInputAsPushButton.clicked.connect(self.saveInputAs)
        self.calculationPushButton.clicked.connect(self.run)

        # Set up the actions.
        self.preferencesAction = QAction(
            "Preferences...", self, triggered=self.preferencesDialog.show
        )
        self.preferencesAction.setMenuRole(QAction.NoRole)

        self.saveInputAction = QAction("Save Input", self, triggered=self.saveInput)
        self.saveInputAsAction = QAction(
            "Save Input As...", self, triggered=self.saveInputAs
        )
        self.showHideAction = QAction("Show/Hide Module", self, triggered=self.showHide)

    @property
    def state(self):
        return self._state

    @state.setter
    def state(self, value):
        # Except for the case when the method is called from __init__,
        # self.state should be assigned to the results model, so disconnect
        # only the signals that are not relevant anymore.
        try:
            self.state.runner.outputUpdated.disconnect()
        except AttributeError:
            pass

        self._state = value

        self.generalPage.populate(self.state)
        self.hamiltonianPage.populate(self.state)

        self.state.runner.outputUpdated.connect(self.updateLogger)
        self.state.runner.successful.connect(self.successful)
        self.state.titleChanged.connect(self.updateMainWindowTitle)

        self.updateMainWindowTitle(self.state.value)

    def populate(self, index=None):
        # Remove the previous state from the root item's children.
        rootItem = self.model.rootItem()
        for child in rootItem.children():
            child.setParent(None)

        result = index.internalPointer() if index is not None else None

        if result is not None:
            symbol = result.element.symbol
            charge = result.element.charge
            symmetry = result.symmetry.value
            experiment = result.experiment.value
            edge = result.edge.value
        else:
            symbol = self.generalPage.symbolComboBox.currentText()
            charge = self.generalPage.chargeComboBox.currentText()
            symmetry = self.generalPage.symmetryComboBox.currentText()
            experiment = self.generalPage.experimentComboBox.currentText()
            edge = self.generalPage.edgeComboBox.currentText()

            # TODO: Try to copy some of the parameters from the previous state.
            # Things that could be copied:
            #   - temperature
            #   - magnetic field
            #   - polarizations and wave vector (partially for polarizations?)
            #   - spectra to calculate (depending on the experiment)
            # If only the symmetry is changed, all the parameters should stay the same
            # except for the Hamiltonian term of course.
            # If only the charge is changed, most of the interface parameters stay the
            # same. Maybe add an option to always reset them if the user wants.

        logger.debug("Start creating a new calculation.")
        state = Calculation(
            symbol=symbol,
            charge=charge,
            symmetry=symmetry,
            experiment=experiment,
            edge=edge,
            parent=self.model.rootItem(),
        )
        logger.debug("Finished creating the calculation.")

        logger.debug("Start copying the parameters.")
        if result is not None:
            state.copyFrom(result)
        logger.debug("Finished copying the parameters.")

        self.state = state

    def run(self):
        progress = ProgressDialog(self)
        progress.rejected.connect(self.state.stop)
        self.state.runner.successful.connect(progress.accept)
        try:
            self.state.run()
        except RuntimeError:
            return
        progress.show()

    def stop(self):
        self.state.stop()

    def saveInput(self):
        self.state.saveInput()

    def saveInputAs(self):
        path, _ = QFileDialog.getSaveFileName(
            self,
            "Save Quanty Input",
            os.path.join(self.currentPath, f"{self.state.value}.lua"),
            "Quanty Input File (*.lua)",
        )

        if path:
            basename = os.path.basename(path)
            self.state.value, _ = os.path.splitext(basename)
            self.currentPath = path
            try:
                self.state.saveInput()
            except (IOError, OSError):
                return

    def updateLogger(self, data):
        self.parent().loggerWidget.appendPlainText(data)

    def updateMainWindowTitle(self, title):
        # In the scenario that the user updates the title of a calculation in
        # the results page, we use that title to set the title of the current
        # state. Another way to achieve this is to reselect the item in the
        # view, which would trigger the generation of a new state with the new
        # title. However, this way all the parameter changes the user has
        # done would be lost.
        # This must be super confusing, but it is just a copy of the title from
        # a state that is in results model, to the current state.
        # pylint: disable=protected-access
        self.state._value = title
        self.parent().setWindowTitle(f"Crispy - {title}")

    def successful(self, successful):
        # Scroll to the bottom of the logger widget.
        scrollBar = self.parent().loggerWidget.verticalScrollBar()
        scrollBar.setValue(scrollBar.maximum())

        if not successful:
            return

        # If the "Hamiltonian Setup" page is currently selected, when the
        # current widget is set to the "Results Page", the former is not
        # displayed. To avoid this we switch first to the "General Setup" page.
        self.toolBox.setCurrentWidget(self.generalPage)
        self.toolBox.setCurrentWidget(self.resultsPage)

        # Move the state to the results model.
        self.state.setParent(self.resultsPage.model.rootItem())
        self.state.checkState = Qt.Checked
        index = self.state.index()
        self.resultsPage.view.setCurrentIndex(index)

    def showHide(self):
        self.setVisible(not self.isVisible())

    @property
    def currentPath(self):
        return settings.value("CurrentPath")

    @currentPath.setter
    def currentPath(self, value):
        path = os.path.dirname(value)
        settings.setValue("CurrentPath", path)

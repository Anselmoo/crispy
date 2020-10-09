--------------------------------------------------------------------------------
-- Quanty input file generated using Crispy. If you use this file please cite
-- the following reference: http://dx.doi.org/10.5281/zenodo.1008184.
--
-- elements: #f
-- symmetry: #symmetry
-- experiment: #experiment
-- edge: #edge
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Set the verbosity of the calculation. For increased verbosity use the values
-- 0x00FF or 0xFFFF.
--------------------------------------------------------------------------------
Verbosity($Verbosity)

--------------------------------------------------------------------------------
-- Define the parameters of the calculation.
--------------------------------------------------------------------------------
Temperature = $Temperature -- temperature (Kelvin)

NPsis = $NPsis  -- number of states to consider in the spectra calculation
NPsisAuto = $NPsisAuto  -- determine the number of state automatically
NConfigurations = $NConfigurations  -- number of configurations

Emin = $XEmin  -- minimum value of the energy range (eV)
Emax = $XEmax  -- maximum value of the energy range (eV)
NPoints = $XNPoints  -- number of points of the spectra
ExperimentalShift = $XExperimentalShift  -- experimental edge energy (eV)
ZeroShift = $XZeroShift  -- energy required to shift the calculated spectrum to start from approximately zero (eV)
Gaussian = $XGaussian  -- Gaussian FWHM (eV)
Lorentzian = $XLorentzian  -- Lorentzian FWHM (eV)
Gamma = 0.1  -- Lorentzian FWHM used in the spectra calculation (eV)

WaveVector = $XWaveVector  -- wave vector
Ev = $XFirstPolarization  -- vertical polarization
Eh = $XSecondPolarization  -- horizontal polarization

SpectraToCalculate = $SpectraToCalculate  -- types of spectra to calculate
DenseBorder = $DenseBorder -- number of determinants where we switch from dense methods to sparse methods

Prefix = "$Prefix"  -- file name prefix

--------------------------------------------------------------------------------
-- Toggle the Hamiltonian terms.
--------------------------------------------------------------------------------
AtomicTerm = $AtomicTerm
CrystalFieldTerm = $CrystalFieldTerm
LmctLigandsHybridizationTerm = $LmctLigandsHybridizationTerm
MagneticFieldTerm = $MagneticFieldTerm
ExchangeFieldTerm = $ExchangeFieldTerm

--------------------------------------------------------------------------------
-- Define the number of electrons, shells, etc.
--------------------------------------------------------------------------------
NBosons = 0
NFermions = 20

NElectrons_#i = 6
NElectrons_#f = $NElectrons_#f

IndexDn_#i = {0, 2, 4}
IndexUp_#i = {1, 3, 5}
IndexDn_#f = {6, 8, 10, 12, 14, 16, 18}
IndexUp_#f = {7, 9, 11, 13, 15, 17, 19}

if LmctLigandsHybridizationTerm then
    NFermions = 34

    NElectrons_L1 = 14

    IndexDn_L1 = {20, 22, 24, 26, 28, 30, 32}
    IndexUp_L1 = {21, 23, 25, 27, 29, 31, 33}
end

--------------------------------------------------------------------------------
-- Initialize the Hamiltonians.
--------------------------------------------------------------------------------
H_i = 0
H_f = 0
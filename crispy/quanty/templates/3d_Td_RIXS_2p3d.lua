--------------------------------------------------------------------------------
-- Quanty input file generated using Crispy. If you use this file please cite
-- the following reference: http://dx.doi.org/10.5281/zenodo.1008184.
--
-- elements: 3d
-- symmetry: Td
-- experiment: RIXS
-- edge: L2,3-M4,5 (2p3d)
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

-- X-axis parameters
Emin1 = $XEmin  -- minimum value of the energy range (eV)
Emax1 = $XEmax  -- maximum value of the energy range (eV)
NPoints1 = $XNPoints  -- number of points of the spectra
ExperimentalShift1 = $XExperimentalShift  -- experimental edge energy (eV)
ZeroShift1 = $XZeroShift  -- energy required to shift the calculated spectrum to start from approximately zero (eV)
Gaussian1 = $XGaussian  -- Gaussian FWHM (eV)
Gamma1 = $XGamma  -- Lorentzian FWHM used in the spectra calculation (eV)

WaveVector = $XWaveVector  -- wave vector
Ev = $XFirstPolarization  -- vertical polarization
Eh = $XSecondPolarization  -- horizontal polarization

-- Y-axis parameters
Emin2 = $YEmin  -- minimum value of the energy range (eV)
Emax2 = $YEmax  -- maximum value of the energy range (eV)
NPoints2 = $YNPoints  -- number of points of the spectra
ExperimentalShift2 = $YExperimentalShift  -- experimental edge energy (eV)
ZeroShift2 = $YZeroShift  -- energy required to shift the calculated spectrum to start from approximately zero (eV)
Gaussian2 = $YGaussian  -- Gaussian FWHM (eV)
Gamma2 = $YGamma  -- Lorentzian FWHM used in the spectra calculation (eV)

WaveVector = $YWaveVector  -- wave vector
Ev = $YFirstPolarization  -- vertical polarization
Eh = $YSecondPolarization  -- horizontal polarization

SpectraToCalculate = $SpectraToCalculate  -- types of spectra to calculate
DenseBorder = $DenseBorder -- number of determinants where we switch from dense methods to sparse methods

Prefix = "$Prefix"  -- file name prefix

--------------------------------------------------------------------------------
-- Toggle the Hamiltonian terms.
--------------------------------------------------------------------------------
AtomicTerm = $AtomicTerm
CrystalFieldTerm = $CrystalFieldTerm
MagneticFieldTerm = $MagneticFieldTerm
ExchangeFieldTerm = $ExchangeFieldTerm

--------------------------------------------------------------------------------
-- Define the number of electrons, shells, etc.
--------------------------------------------------------------------------------
NBosons = 0
NFermions = 16

NElectrons_2p = 6
NElectrons_3d = $NElectrons_3d

IndexDn_2p = {0, 2, 4}
IndexUp_2p = {1, 3, 5}
IndexDn_3d = {6, 8, 10, 12, 14}
IndexUp_3d = {7, 9, 11, 13, 15}

--------------------------------------------------------------------------------
-- Initialize the Hamiltonians.
--------------------------------------------------------------------------------
H_i = 0
H_m = 0
H_f = 0

--------------------------------------------------------------------------------
-- Define the atomic term.
--------------------------------------------------------------------------------
N_2p = NewOperator("Number", NFermions, IndexUp_2p, IndexUp_2p, {1, 1, 1})
     + NewOperator("Number", NFermions, IndexDn_2p, IndexDn_2p, {1, 1, 1})

N_3d = NewOperator("Number", NFermions, IndexUp_3d, IndexUp_3d, {1, 1, 1, 1, 1})
     + NewOperator("Number", NFermions, IndexDn_3d, IndexDn_3d, {1, 1, 1, 1, 1})

if AtomicTerm then
    F0_3d_3d = NewOperator("U", NFermions, IndexUp_3d, IndexDn_3d, {1, 0, 0})
    F2_3d_3d = NewOperator("U", NFermions, IndexUp_3d, IndexDn_3d, {0, 1, 0})
    F4_3d_3d = NewOperator("U", NFermions, IndexUp_3d, IndexDn_3d, {0, 0, 1})

    F0_2p_3d = NewOperator("U", NFermions, IndexUp_2p, IndexDn_2p, IndexUp_3d, IndexDn_3d, {1, 0}, {0, 0})
    F2_2p_3d = NewOperator("U", NFermions, IndexUp_2p, IndexDn_2p, IndexUp_3d, IndexDn_3d, {0, 1}, {0, 0})
    G1_2p_3d = NewOperator("U", NFermions, IndexUp_2p, IndexDn_2p, IndexUp_3d, IndexDn_3d, {0, 0}, {1, 0})
    G3_2p_3d = NewOperator("U", NFermions, IndexUp_2p, IndexDn_2p, IndexUp_3d, IndexDn_3d, {0, 0}, {0, 1})

    U_3d_3d_i = $U(3d,3d)_i_value
    F2_3d_3d_i = $F2(3d,3d)_i_value * $F2(3d,3d)_i_scaleFactor
    F4_3d_3d_i = $F4(3d,3d)_i_value * $F4(3d,3d)_i_scaleFactor
    F0_3d_3d_i = U_3d_3d_i + 2 / 63 * F2_3d_3d_i + 2 / 63 * F4_3d_3d_i

    U_3d_3d_m = $U(3d,3d)_m_value
    F2_3d_3d_m = $F2(3d,3d)_m_value * $F2(3d,3d)_m_scaleFactor
    F4_3d_3d_m = $F4(3d,3d)_m_value * $F4(3d,3d)_m_scaleFactor
    F0_3d_3d_m = U_3d_3d_m + 2 / 63 * F2_3d_3d_m + 2 / 63 * F4_3d_3d_m
    U_2p_3d_m = $U(2p,3d)_m_value
    F2_2p_3d_m = $F2(2p,3d)_m_value * $F2(2p,3d)_m_scaleFactor
    G1_2p_3d_m = $G1(2p,3d)_m_value * $G1(2p,3d)_m_scaleFactor
    G3_2p_3d_m = $G3(2p,3d)_m_value * $G3(2p,3d)_m_scaleFactor
    F0_2p_3d_m = U_2p_3d_m + 1 / 15 * G1_2p_3d_m + 3 / 70 * G3_2p_3d_m

    U_3d_3d_f = $U(3d,3d)_f_value
    F2_3d_3d_f = $F2(3d,3d)_f_value * $F2(3d,3d)_f_scaleFactor
    F4_3d_3d_f = $F4(3d,3d)_f_value * $F4(3d,3d)_f_scaleFactor
    F0_3d_3d_f = U_3d_3d_f + 2 / 63 * F2_3d_3d_f + 2 / 63 * F4_3d_3d_f

    H_i = H_i + Chop(
          F0_3d_3d_i * F0_3d_3d
        + F2_3d_3d_i * F2_3d_3d
        + F4_3d_3d_i * F4_3d_3d)

    H_m = H_m + Chop(
          F0_3d_3d_m * F0_3d_3d
        + F2_3d_3d_m * F2_3d_3d
        + F4_3d_3d_m * F4_3d_3d
        + F0_2p_3d_m * F0_2p_3d
        + F2_2p_3d_m * F2_2p_3d
        + G1_2p_3d_m * G1_2p_3d
        + G3_2p_3d_m * G3_2p_3d)

    H_f = H_f + Chop(
          F0_3d_3d_f * F0_3d_3d
        + F2_3d_3d_f * F2_3d_3d
        + F4_3d_3d_f * F4_3d_3d)

    ldots_3d = NewOperator("ldots", NFermions, IndexUp_3d, IndexDn_3d)

    ldots_2p = NewOperator("ldots", NFermions, IndexUp_2p, IndexDn_2p)

    zeta_3d_i = $zeta(3d)_i_value * $zeta(3d)_i_scaleFactor

    zeta_3d_m = $zeta(3d)_m_value * $zeta(3d)_m_scaleFactor
    zeta_2p_m = $zeta(2p)_m_value * $zeta(2p)_m_scaleFactor

    zeta_3d_f = $zeta(3d)_f_value * $zeta(3d)_f_scaleFactor

    H_i = H_i + Chop(
          zeta_3d_i * ldots_3d)

    H_m = H_m + Chop(
          zeta_3d_m * ldots_3d
        + zeta_2p_m * ldots_2p)

    H_f = H_f + Chop(
          zeta_3d_f * ldots_3d)
end

--------------------------------------------------------------------------------
-- Define the crystal field term.
--------------------------------------------------------------------------------
if CrystalFieldTerm then
    -- PotentialExpandedOnClm("Td", 2, {Ee, Et2})
    -- tenDq_3d = NewOperator("CF", NFermions, IndexUp_3d, IndexDn_3d, PotentialExpandedOnClm("Td", 2, {-0.6, 0.4}))

    Akm = {{4, 0, -2.1}, {4, -4, -1.5 * sqrt(0.7)}, {4, 4, -1.5 * sqrt(0.7)}}
    tenDq_3d = NewOperator("CF", NFermions, IndexUp_3d, IndexDn_3d, Akm)

    tenDq_3d_i = $10Dq(3d)_i_value

    io.write("Diagonal values of the initial crystal field Hamiltonian:\n")
    io.write("================\n")
    io.write("Irrep.         E\n")
    io.write("================\n")
    io.write(string.format("e       %8.3f\n", -0.6 * tenDq_3d_i))
    io.write(string.format("t2      %8.3f\n",  0.4 * tenDq_3d_i))
    io.write("================\n")
    io.write("\n")

    tenDq_3d_m = $10Dq(3d)_m_value

    tenDq_3d_f = $10Dq(3d)_f_value

    H_i = H_i + Chop(
          tenDq_3d_i * tenDq_3d)

    H_m = H_m + Chop(
          tenDq_3d_m * tenDq_3d)

    H_f = H_f + Chop(
          tenDq_3d_f * tenDq_3d)
end

--------------------------------------------------------------------------------
-- Define the magnetic field and exchange field terms.
--------------------------------------------------------------------------------
Sx_3d = NewOperator("Sx", NFermions, IndexUp_3d, IndexDn_3d)
Sy_3d = NewOperator("Sy", NFermions, IndexUp_3d, IndexDn_3d)
Sz_3d = NewOperator("Sz", NFermions, IndexUp_3d, IndexDn_3d)
Ssqr_3d = NewOperator("Ssqr", NFermions, IndexUp_3d, IndexDn_3d)
Splus_3d = NewOperator("Splus", NFermions, IndexUp_3d, IndexDn_3d)
Smin_3d = NewOperator("Smin", NFermions, IndexUp_3d, IndexDn_3d)

Lx_3d = NewOperator("Lx", NFermions, IndexUp_3d, IndexDn_3d)
Ly_3d = NewOperator("Ly", NFermions, IndexUp_3d, IndexDn_3d)
Lz_3d = NewOperator("Lz", NFermions, IndexUp_3d, IndexDn_3d)
Lsqr_3d = NewOperator("Lsqr", NFermions, IndexUp_3d, IndexDn_3d)
Lplus_3d = NewOperator("Lplus", NFermions, IndexUp_3d, IndexDn_3d)
Lmin_3d = NewOperator("Lmin", NFermions, IndexUp_3d, IndexDn_3d)

Jx_3d = NewOperator("Jx", NFermions, IndexUp_3d, IndexDn_3d)
Jy_3d = NewOperator("Jy", NFermions, IndexUp_3d, IndexDn_3d)
Jz_3d = NewOperator("Jz", NFermions, IndexUp_3d, IndexDn_3d)
Jsqr_3d = NewOperator("Jsqr", NFermions, IndexUp_3d, IndexDn_3d)
Jplus_3d = NewOperator("Jplus", NFermions, IndexUp_3d, IndexDn_3d)
Jmin_3d = NewOperator("Jmin", NFermions, IndexUp_3d, IndexDn_3d)

Tx_3d = NewOperator("Tx", NFermions, IndexUp_3d, IndexDn_3d)
Ty_3d = NewOperator("Ty", NFermions, IndexUp_3d, IndexDn_3d)
Tz_3d = NewOperator("Tz", NFermions, IndexUp_3d, IndexDn_3d)

Sx = Sx_3d
Sy = Sy_3d
Sz = Sz_3d

Lx = Lx_3d
Ly = Ly_3d
Lz = Lz_3d

Jx = Jx_3d
Jy = Jy_3d
Jz = Jz_3d

Tx = Tx_3d
Ty = Ty_3d
Tz = Tz_3d

Ssqr = Sx * Sx + Sy * Sy + Sz * Sz
Lsqr = Lx * Lx + Ly * Ly + Lz * Lz
Jsqr = Jx * Jx + Jy * Jy + Jz * Jz

if MagneticFieldTerm then
    Bx_i = $Bx_i_value * EnergyUnits.Tesla.value
    By_i = $By_i_value * EnergyUnits.Tesla.value
    Bz_i = $Bz_i_value * EnergyUnits.Tesla.value

    Bx_m = $Bx_m_value * EnergyUnits.Tesla.value
    By_m = $By_m_value * EnergyUnits.Tesla.value
    Bz_m = $Bz_m_value * EnergyUnits.Tesla.value

    Bx_f = $Bx_f_value * EnergyUnits.Tesla.value
    By_f = $By_f_value * EnergyUnits.Tesla.value
    Bz_f = $Bz_f_value * EnergyUnits.Tesla.value

    H_i = H_i + Chop(
          Bx_i * (2 * Sx + Lx)
        + By_i * (2 * Sy + Ly)
        + Bz_i * (2 * Sz + Lz))

    H_m = H_m + Chop(
          Bx_m * (2 * Sx + Lx)
        + By_m * (2 * Sy + Ly)
        + Bz_m * (2 * Sz + Lz))

    H_f = H_f + Chop(
          Bx_f * (2 * Sx + Lx)
        + By_f * (2 * Sy + Ly)
        + Bz_f * (2 * Sz + Lz))
end

if ExchangeFieldTerm then
    Hx_i = $Hx_i_value
    Hy_i = $Hy_i_value
    Hz_i = $Hz_i_value

    Hx_m = $Hx_m_value
    Hy_m = $Hy_m_value
    Hz_m = $Hz_m_value

    Hx_f = $Hx_f_value
    Hy_f = $Hy_f_value
    Hz_f = $Hz_f_value

    H_i = H_i + Chop(
          Hx_i * Sx
        + Hy_i * Sy
        + Hz_i * Sz)

    H_m = H_m + Chop(
          Hx_m * Sx
        + Hy_m * Sy
        + Hz_m * Sz)

    H_f = H_f + Chop(
          Hx_f * Sx
        + Hy_f * Sy
        + Hz_f * Sz)
end

--------------------------------------------------------------------------------
-- Define the restrictions and set the number of initial states.
--------------------------------------------------------------------------------
InitialRestrictions = {NFermions, NBosons, {"111111 0000000000", NElectrons_2p, NElectrons_2p},
                                           {"000000 1111111111", NElectrons_3d, NElectrons_3d}}

IntermediateRestrictions = {NFermions, NBosons, {"111111 0000000000", NElectrons_2p - 1, NElectrons_2p - 1},
                                                {"000000 1111111111", NElectrons_3d + 1, NElectrons_3d + 1}}

FinalRestrictions = InitialRestrictions

CalculationRestrictions = nil

--------------------------------------------------------------------------------
-- Define some helper functions.
--------------------------------------------------------------------------------
function MatrixToOperator(Matrix, StartIndex)
    -- Transform a matrix to an operator.
    local Operator = 0
    for i = 1, #Matrix do
        for j = 1, #Matrix do
            local Weight = Matrix[i][j]
            Operator = Operator + NewOperator("Number", #Matrix + StartIndex, i + StartIndex - 1, j + StartIndex - 1) * Weight
        end
    end
    Operator.Chop()
    return Operator
end

function ValueInTable(Value, Table)
    -- Check if a value is in a table.
    for _, v in ipairs(Table) do
        if Value == v then
            return true
        end
    end
    return false
end

function GetSpectrum(G, Ids, dZ, NOperators, NPsis)
    -- Extract the spectrum corresponding to the operators identified
    -- using the Ids argument. The returned spectrum is a weighted
    -- sum where the weights are the Boltzmann probabilities.
    --
    -- @param G: spectrum object as returned by the functions defined in Quanty, i.e. one spectrum
    --           for each operator and each wavefunction.
    -- @param Ids: indexes of the operators that are considered in the returned spectrum
    -- @param dZ: Boltzmann prefactors for each of the spectrum in the spectra object
    -- @param NOperators: number of transition operators
    -- @param NPsis: number of wavefunctions

    if not (type(Ids) == "table") then
        Ids = {Ids}
    end

    local Id = 1
    local dZs = {}

    for i = 1, NOperators do
        for _ = 1, NPsis do
            if ValueInTable(i, Ids) then
                table.insert(dZs, dZ[Id])
            else
                table.insert(dZs, 0)
            end
            Id = Id + 1
        end
    end
    return Spectra.Sum(G, dZs)
end

function SaveSpectrum(G, Filename, Gaussian, Lorentzian, Pcl)
    if Pcl == nil then
        Pcl = 1
    end
    G = -1 / math.pi / Pcl * G
    G.Broaden(Gaussian, Lorentzian)
    G.Print({{"file", Filename .. ".spec"}})
end

function CalculateT(Basis, Eps, K)
    -- Calculate the transition operator in the basis of tesseral harmonics for
    -- an arbitrary polarization and wave-vector (for quadrupole operators).
    --
    -- @param: Basis: operators forming the basis
    -- @param: Eps: cartesian components of the polarization vector
    -- @param: K: cartesian components of the wave-vector

    if #Basis == 3 then
        -- The basis for dipolar operators is in the order x, y, z.
        T = Eps[1] * Basis[1]
          + Eps[2] * Basis[2]
          + Eps[3] * Basis[3]
    elseif #Basis == 5 then 
        -- The basis for quadrupolar operators is in the order xy, xz, yz, x2y2, z2.
        T = (Eps[1] * K[2] + Eps[2] * K[1]) / math.sqrt(3) * Basis[1] 
          + (Eps[1] * K[3] + Eps[3] * K[1]) / math.sqrt(3) * Basis[2] 
          + (Eps[2] * K[3] + Eps[3] * K[2]) / math.sqrt(3) * Basis[3] 
          + (Eps[1] * K[1] - Eps[2] * K[2]) / math.sqrt(3) * Basis[4] 
          + Eps[3] * K[3] * Basis[5]
    end
    return Chop(T)
end

function DotProduct(a, b)
    return Chop(a[1] * b[1] + a[2] * b[2] + a[3] * b[3])
end

function WavefunctionsAndBoltzmannFactors(H, NPsis, NPsisAuto, Temperature, Threshold, StartRestrictions, CalculationRestrictions)
    -- Calculate the wavefunctions and Boltzmann factors of a Hamiltonian.
    --
    -- @param H: Hamiltonian for which to calculate the wavefunctions
    -- @param NPsis: number of wavefunctions
    -- @param NPsisAuto: determine automatically the number of wavefunctions that are populated at the specified
    --                   temperature and within the threshold
    -- @param Temperature: temperature in eV
    -- @param Threshold: threshold used to determine the number of wavefunction in the automatic procedure
    -- @param StartRestrictions: occupancy restrictions at the start of the calculation
    -- @param CalculationRestrictions: restrictions during the calculation
    -- @return Psis: wavefunctions
    -- @return dZ: Boltzmann factors

    if Threshold == nil then
        Threshold = 1e-8
    end

    local dZ = {}
    local Z = 0
    local Psis

    if NPsisAuto == true and NPsis ~= 1 then
        NPsis = 4
        local NPsisIncrement = 8
        local NPsisIsConverged = false

        while not NPsisIsConverged do
            if CalculationRestrictions == nil then
                Psis = Eigensystem(H, StartRestrictions, NPsis)
            else
                Psis = Eigensystem(H, StartRestrictions, NPsis, {{"restrictions", CalculationRestrictions}})
            end

            if not (type(Psis) == "table") then
                Psis = {Psis}
            end

            if E_gs == nil then
                E_gs = Psis[1] * H * Psis[1]
            end

            Z = 0

            for i, Psi in ipairs(Psis) do
                local E = Psi * H * Psi

                if math.abs(E - E_gs) < Threshold ^ 2 then
                    dZ[i] = 1
                else
                    dZ[i] = math.exp(-(E - E_gs) / Temperature)
                end

                Z = Z + dZ[i]

                if dZ[i] / Z < Threshold then
                    i = i - 1
                    NPsisIsConverged = true
                    NPsis = i
                    Psis = {unpack(Psis, 1, i)}
                    dZ = {unpack(dZ, 1, i)}
                    break
                end
            end

            if NPsisIsConverged then
                break
            else
                NPsis = NPsis + NPsisIncrement
            end
        end
    else
        if CalculationRestrictions == nil then
            Psis = Eigensystem(H, StartRestrictions, NPsis)
        else
            Psis = Eigensystem(H, StartRestrictions, NPsis, {{"restrictions", CalculationRestrictions}})
        end

        if not (type(Psis) == "table") then
            Psis = {Psis}
        end

        local E_gs = Psis[1] * H * Psis[1]

        Z = 0

        for i, psi in ipairs(Psis) do
            local E = psi * H * psi

            if math.abs(E - E_gs) < Threshold ^ 2 then
                dZ[i] = 1
            else
                dZ[i] = math.exp(-(E - E_gs) / Temperature)
            end

            Z = Z + dZ[i]
        end
    end

    -- Normalize the Boltzmann factors to unity.
    for i in ipairs(dZ) do
        dZ[i] = dZ[i] / Z
    end

    return Psis, dZ
end

function PrintHamiltonianAnalysis(Psis, Operators, dZ, Header, Footer)
    io.write(Header)
    for i, Psi in ipairs(Psis) do
        io.write(string.format("%5d", i))
        for j, Operator in ipairs(Operators) do
            if j == 1 then
                io.write(string.format("%12.6f", Complex.Re(Psi * Operator * Psi)))
            elseif Operator == "dZ" then
                io.write(string.format("%12.2e", dZ[i]))
            else
                io.write(string.format("%10.4f", Complex.Re(Psi * Operator * Psi)))
            end
        end
        io.write("\n")
    end
    io.write(Footer)
end

--------------------------------------------------------------------------------
-- Analyze the initial Hamiltonian.
--------------------------------------------------------------------------------
Temperature = Temperature * EnergyUnits.Kelvin.value

Sk = DotProduct(WaveVector, {Sx, Sy, Sz})
Lk = DotProduct(WaveVector, {Lx, Ly, Lz})
Jk = DotProduct(WaveVector, {Jx, Jy, Jz})
Tk = DotProduct(WaveVector, {Tx, Ty, Tz})

Operators = {H_i, Ssqr, Lsqr, Jsqr, Sk, Lk, Jk, Tk, ldots_3d, N_2p, N_3d, "dZ"}
Header = "Analysis of the %s Hamiltonian:\n"
Header = Header .. "=================================================================================================================================\n"
Header = Header .. "State         <E>     <S^2>     <L^2>     <J^2>      <Sk>      <Lk>      <Jk>      <Tk>     <l.s>    <N_2p>    <N_3d>          dZ\n"
Header = Header .. "=================================================================================================================================\n"
Footer = '=================================================================================================================================\n'

local Psis_i, dZ_i = WavefunctionsAndBoltzmannFactors(H_i, NPsis, NPsisAuto, Temperature, nil, InitialRestrictions, CalculationRestrictions)
PrintHamiltonianAnalysis(Psis_i, Operators, dZ_i, string.format(Header, "initial"), Footer)

-- Stop the calculation if no spectra need to be calculated.
if next(SpectraToCalculate) == nil then
    return
end

--------------------------------------------------------------------------------
-- Calculate and save the spectra.
--------------------------------------------------------------------------------
local t = math.sqrt(1 / 2)

Tx_2p_3d = NewOperator("CF", NFermions, IndexUp_3d, IndexDn_3d, IndexUp_2p, IndexDn_2p, {{1, -1, t    }, {1, 1, -t    }})
Ty_2p_3d = NewOperator("CF", NFermions, IndexUp_3d, IndexDn_3d, IndexUp_2p, IndexDn_2p, {{1, -1, t * I}, {1, 1,  t * I}})
Tz_2p_3d = NewOperator("CF", NFermions, IndexUp_3d, IndexDn_3d, IndexUp_2p, IndexDn_2p, {{1,  0, 1    }                })

Tx_3d_2p = NewOperator("CF", NFermions, IndexUp_2p, IndexDn_2p, IndexUp_3d, IndexDn_3d, {{1, -1, t    }, {1, 1, -t    }})
Ty_3d_2p = NewOperator("CF", NFermions, IndexUp_2p, IndexDn_2p, IndexUp_3d, IndexDn_3d, {{1, -1, t * I}, {1, 1,  t * I}})
Tz_3d_2p = NewOperator("CF", NFermions, IndexUp_2p, IndexDn_2p, IndexUp_3d, IndexDn_3d, {{1,  0, 1    }                })

T_2p_3d = {Tx_2p_3d, Ty_2p_3d, Tz_2p_3d}
T_3d_2p = {Tx_3d_2p, Ty_3d_2p, Tz_3d_2p}

Emin1 = Emin1 - (ZeroShift1 + ExperimentalShift1)
Emax1 = Emax1 - (ZeroShift1 + ExperimentalShift1)

Emin2 = Emin2 - (ZeroShift2 + ExperimentalShift2)
Emax2 = Emax2 - (ZeroShift2 + ExperimentalShift2)

if CalculationRestrictions == nil then
    G = CreateResonantSpectra(H_m, H_f, T_2p_3d, T_3d_2p, Psis_i, {{"Emin1", Emin1}, {"Emax1", Emax1}, {"NE1", NPoints1}, {"Gamma1", Gamma1}, {"Emin2", Emin2}, {"Emax2", Emax2}, {"NE2", NPoints2}, {"Gamma2", Gamma2}, {"DenseBorder", DenseBorder}})
else
    G = CreateResonantSpectra(H_m, H_f, T_2p_3d, T_3d_2p, Psis_i, {{"Emin1", Emin1}, {"Emax1", Emax1}, {"NE1", NPoints1}, {"Gamma1", Gamma1}, {"Emin2", Emin2}, {"Emax2", Emax2}, {"NE2", NPoints2}, {"Gamma2", Gamma2}, {"Restrictions1", CalculationRestrictions}, {"Restrictions2", CalculationRestrictions}, {"DenseBorder", DenseBorder}})
end

Giso = 0
Shift = 0
for i = 1, #Psis_i do
    for j = 1, #T_2p_3d * #T_3d_2p do
        Indexes = {}
        for k = 1, NPoints1 + 1 do
            table.insert(Indexes, k + Shift)
        end
        Giso = Giso + Spectra.Element(G, Indexes) * dZ_i[i]
        Shift = Shift + NPoints1 + 1
    end
end

-- The Gaussian broadening is done using the same value for the two dimensions.
Gaussian = math.min(Gaussian1, Gaussian2)
if Gaussian ~= 0 then
    Giso.Broaden(Gaussian, 0.0)
end

Giso = -1 / math.pi * Giso
Giso.Print({{"file", Prefix .. "_iso.spec"}})

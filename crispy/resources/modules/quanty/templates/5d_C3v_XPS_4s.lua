--------------------------------------------------------------------------------
-- Quanty input file generated using Crispy. If you use this file please cite
-- the following reference: http://dx.doi.org/10.5281/zenodo.1008184.
--
-- elements: 5d
-- symmetry: C3v
-- experiment: XPS
-- edge: N1 (4s)
--------------------------------------------------------------------------------
Verbosity($Verbosity)

--------------------------------------------------------------------------------
-- Initialize the Hamiltonians.
--------------------------------------------------------------------------------
H_i = 0
H_f = 0

--------------------------------------------------------------------------------
-- Toggle the Hamiltonian terms.
--------------------------------------------------------------------------------
H_atomic = $H_atomic
H_crystal_field = $H_crystal_field
H_magnetic_field = $H_magnetic_field
H_exchange_field = $H_exchange_field

--------------------------------------------------------------------------------
-- Define the number of electrons, shells, etc.
--------------------------------------------------------------------------------
NBosons = 0
NFermions = 12

NElectrons_4s = 2
NElectrons_5d = $NElectrons_5d

IndexDn_4s = {0}
IndexUp_4s = {1}
IndexDn_5d = {2, 4, 6, 8, 10}
IndexUp_5d = {3, 5, 7, 9, 11}

--------------------------------------------------------------------------------
-- Define the atomic term.
--------------------------------------------------------------------------------
N_4s = NewOperator('Number', NFermions, IndexUp_4s, IndexUp_4s, {1})
     + NewOperator('Number', NFermions, IndexDn_4s, IndexDn_4s, {1})

N_5d = NewOperator('Number', NFermions, IndexUp_5d, IndexUp_5d, {1, 1, 1, 1, 1})
     + NewOperator('Number', NFermions, IndexDn_5d, IndexDn_5d, {1, 1, 1, 1, 1})

if H_atomic == 1 then
    F0_5d_5d = NewOperator('U', NFermions, IndexUp_5d, IndexDn_5d, {1, 0, 0})
    F2_5d_5d = NewOperator('U', NFermions, IndexUp_5d, IndexDn_5d, {0, 1, 0})
    F4_5d_5d = NewOperator('U', NFermions, IndexUp_5d, IndexDn_5d, {0, 0, 1})

    F0_4s_5d = NewOperator('U', NFermions, IndexUp_4s, IndexDn_4s, IndexUp_5d, IndexDn_5d, {1}, {0})
    G2_4s_5d = NewOperator('U', NFermions, IndexUp_4s, IndexDn_4s, IndexUp_5d, IndexDn_5d, {0}, {1})

    U_5d_5d_i = $U(5d,5d)_i_value
    F2_5d_5d_i = $F2(5d,5d)_i_value * $F2(5d,5d)_i_scale
    F4_5d_5d_i = $F4(5d,5d)_i_value * $F4(5d,5d)_i_scale
    F0_5d_5d_i = U_5d_5d_i + 2 / 63 * F2_5d_5d_i + 2 / 63 * F4_5d_5d_i

    U_5d_5d_f = $U(5d,5d)_f_value
    F2_5d_5d_f = $F2(5d,5d)_f_value * $F2(5d,5d)_f_scale
    F4_5d_5d_f = $F4(5d,5d)_f_value * $F4(5d,5d)_f_scale
    F0_5d_5d_f = U_5d_5d_f + 2 / 63 * F2_5d_5d_f + 2 / 63 * F4_5d_5d_f
    U_4s_5d_f = $U(4s,5d)_f_value
    G2_4s_5d_f = $G2(4s,5d)_f_value * $G2(4s,5d)_f_scale
    F0_4s_5d_f = U_4s_5d_f + 1 / 10 * G2_4s_5d_f

    H_i = H_i + Chop(
          F0_5d_5d_i * F0_5d_5d
        + F2_5d_5d_i * F2_5d_5d
        + F4_5d_5d_i * F4_5d_5d)

    H_f = H_f + Chop(
          F0_5d_5d_f * F0_5d_5d
        + F2_5d_5d_f * F2_5d_5d
        + F4_5d_5d_f * F4_5d_5d
        + F0_4s_5d_f * F0_4s_5d
        + G2_4s_5d_f * G2_4s_5d)

    ldots_5d = NewOperator('ldots', NFermions, IndexUp_5d, IndexDn_5d)

    zeta_5d_i = $zeta(5d)_i_value * $zeta(5d)_i_scale

    zeta_5d_f = $zeta(5d)_f_value * $zeta(5d)_f_scale

    H_i = H_i + Chop(
          zeta_5d_i * ldots_5d)

    H_f = H_f + Chop(
          zeta_5d_f * ldots_5d)
end

--------------------------------------------------------------------------------
-- Define the crystal field term.
--------------------------------------------------------------------------------
if H_crystal_field == 1 then
    Dq_5d = NewOperator('CF', NFermions, IndexUp_5d, IndexDn_5d, {{4, 0, -14}, {4, 3, -2 * math.sqrt(70)}, {4, -3, 2 * math.sqrt(70)}})
    Dsigma_5d = NewOperator('CF', NFermions, IndexUp_5d, IndexDn_5d, {{2, 0, -7}})
    Dtau_5d = NewOperator('CF', NFermions, IndexUp_5d, IndexDn_5d, {{4, 0, -21}})

    Dq_5d_i = $Dq(5d)_i_value
    Dsigma_5d_i = $Dsigma(5d)_i_value
    Dtau_5d_i = $Dtau(5d)_i_value

    io.write('Energies of the 5d orbitals in the initial Hamiltonian (crystal field term only):\n')
    io.write('================\n')
    io.write('Irrep.         E\n')
    io.write('================\n')
    io.write(string.format('a1(t2g) %8.3f\n', -4 * Dq_5d_i - 2 * Dsigma_5d_i - 6 * Dtau_5d_i))
    io.write(string.format('e(eg)   %8.3f\n', 6 * Dq_5d_i + 7 / 3 * Dtau_5d_i))
    io.write(string.format('e(t2g)  %8.3f\n', -4 * Dq_5d_i + Dsigma_5d_i + 2 / 3 * Dtau_5d_i))
    io.write('================\n')
    io.write('\n')

    Dq_5d_f = $Dq(5d)_f_value
    Dsigma_5d_f = $Dsigma(5d)_f_value
    Dtau_5d_f = $Dtau(5d)_f_value

    H_i = H_i + Chop(
          Dq_5d_i * Dq_5d
        + Dsigma_5d_i * Dsigma_5d
        + Dtau_5d_i * Dtau_5d)

    H_f = H_f + Chop(
          Dq_5d_f * Dq_5d
        + Dsigma_5d_f * Dsigma_5d
        + Dtau_5d_f * Dtau_5d)
end

--------------------------------------------------------------------------------
-- Define the magnetic field and exchange field terms.
--------------------------------------------------------------------------------
Sx_5d = NewOperator('Sx', NFermions, IndexUp_5d, IndexDn_5d)
Sy_5d = NewOperator('Sy', NFermions, IndexUp_5d, IndexDn_5d)
Sz_5d = NewOperator('Sz', NFermions, IndexUp_5d, IndexDn_5d)
Ssqr_5d = NewOperator('Ssqr', NFermions, IndexUp_5d, IndexDn_5d)
Splus_5d = NewOperator('Splus', NFermions, IndexUp_5d, IndexDn_5d)
Smin_5d = NewOperator('Smin', NFermions, IndexUp_5d, IndexDn_5d)

Lx_5d = NewOperator('Lx', NFermions, IndexUp_5d, IndexDn_5d)
Ly_5d = NewOperator('Ly', NFermions, IndexUp_5d, IndexDn_5d)
Lz_5d = NewOperator('Lz', NFermions, IndexUp_5d, IndexDn_5d)
Lsqr_5d = NewOperator('Lsqr', NFermions, IndexUp_5d, IndexDn_5d)
Lplus_5d = NewOperator('Lplus', NFermions, IndexUp_5d, IndexDn_5d)
Lmin_5d = NewOperator('Lmin', NFermions, IndexUp_5d, IndexDn_5d)

Jx_5d = NewOperator('Jx', NFermions, IndexUp_5d, IndexDn_5d)
Jy_5d = NewOperator('Jy', NFermions, IndexUp_5d, IndexDn_5d)
Jz_5d = NewOperator('Jz', NFermions, IndexUp_5d, IndexDn_5d)
Jsqr_5d = NewOperator('Jsqr', NFermions, IndexUp_5d, IndexDn_5d)
Jplus_5d = NewOperator('Jplus', NFermions, IndexUp_5d, IndexDn_5d)
Jmin_5d = NewOperator('Jmin', NFermions, IndexUp_5d, IndexDn_5d)

Tz = NewOperator('Tz', NFermions, IndexUp_5d, IndexDn_5d)

Sx = Sx_5d
Sy = Sy_5d
Sz = Sz_5d

Lx = Lx_5d
Ly = Ly_5d
Lz = Lz_5d

Jx = Jx_5d
Jy = Jy_5d
Jz = Jz_5d


Ssqr = Sx * Sx + Sy * Sy + Sz * Sz
Lsqr = Lx * Lx + Ly * Ly + Lz * Lz
Jsqr = Jx * Jx + Jy * Jy + Jz * Jz

if H_magnetic_field == 1 then
    Bx_i = $Bx_i_value
    By_i = $By_i_value
    Bz_i = $Bz_i_value

    Bx_f = $Bx_f_value
    By_f = $By_f_value
    Bz_f = $Bz_f_value

    H_i = H_i + Chop(
          Bx_i * (2 * Sx + Lx)
        + By_i * (2 * Sy + Ly)
        + Bz_i * (2 * Sz + Lz))

    H_f = H_f + Chop(
          Bx_f * (2 * Sx + Lx)
        + By_f * (2 * Sy + Ly)
        + Bz_f * (2 * Sz + Lz))
end

if H_exchange_field == 1 then
    Hx_i = $Hx_i_value
    Hy_i = $Hy_i_value
    Hz_i = $Hz_i_value

    Hx_f = $Hx_f_value
    Hy_f = $Hy_f_value
    Hz_f = $Hz_f_value

    H_i = H_i + Chop(
          Hx_i * Sx
        + Hy_i * Sy
        + Hz_i * Sz)

    H_f = H_f + Chop(
          Hx_f * Sx
        + Hy_f * Sy
        + Hz_f * Sz)
end

--------------------------------------------------------------------------------
-- Define the restrictions and set the number of initial states.
--------------------------------------------------------------------------------
InitialRestrictions = {NFermions, NBosons, {'11 0000000000', NElectrons_4s, NElectrons_4s},
                                           {'00 1111111111', NElectrons_5d, NElectrons_5d}}

FinalRestrictions = {NFermions, NBosons, {'11 0000000000', NElectrons_4s - 1, NElectrons_4s - 1},
                                         {'00 1111111111', NElectrons_5d, NElectrons_5d}}

Operators = {H_i, Ssqr, Lsqr, Jsqr, Sz, Lz, Jz, Tz, ldots_5d, N_4s, N_5d, 'dZ'}
header = 'Analysis of the initial Hamiltonian:\n'
header = header .. '=================================================================================================================================\n'
header = header .. 'State         <E>     <S^2>     <L^2>     <J^2>      <Sz>      <Lz>      <Jz>      <Tz>     <l.s>    <N_4s>    <N_5d>          dZ\n'
header = header .. '=================================================================================================================================\n'
footer = '=================================================================================================================================\n'

T = $T * EnergyUnits.Kelvin.value

-- Approximate machine epsilon for single precision arithmetics.
epsilon = 1.19e-07

NPsis = $NPsis
NPsisAuto = $NPsisAuto

dZ = {}

if NPsisAuto == 1 and NPsis ~= 1 then
    NPsis = 4
    NPsisIncrement = 8
    NPsisIsConverged = false

    while not NPsisIsConverged do
        if CalculationRestrictions == nil then
            Psis_i = Eigensystem(H_i, InitialRestrictions, NPsis)
        else
            Psis_i = Eigensystem(H_i, InitialRestrictions, NPsis, {{'restrictions', CalculationRestrictions}})
        end

        if not (type(Psis_i) == 'table') then
            Psis_i = {Psis_i}
        end

        E_gs_i = Psis_i[1] * H_i * Psis_i[1]

        Z = 0

        for i, Psi in ipairs(Psis_i) do
            E = Psi * H_i * Psi

            if math.abs(E - E_gs_i) < epsilon then
                dZ[i] = 1
            else
                dZ[i] = math.exp(-(E - E_gs_i) / T)
            end

            Z = Z + dZ[i]

            if (dZ[i] / Z) < math.sqrt(epsilon) then
                i = i - 1
                NPsisIsConverged = true
                NPsis = i
                Psis_i = {unpack(Psis_i, 1, i)}
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
        Psis_i = Eigensystem(H_i, InitialRestrictions, NPsis)
    else
        Psis_i = Eigensystem(H_i, InitialRestrictions, NPsis, {{'restrictions', CalculationRestrictions}})
    end

    if not (type(Psis_i) == 'table') then
        Psis_i = {Psis_i}
    end
        E_gs_i = Psis_i[1] * H_i * Psis_i[1]

    Z = 0

    for i, Psi in ipairs(Psis_i) do
        E = Psi * H_i * Psi

        if math.abs(E - E_gs_i) < epsilon then
            dZ[i] = 1
        else
            dZ[i] = math.exp(-(E - E_gs_i) / T)
        end

        Z = Z + dZ[i]
    end
end

-- Normalize dZ to unity.
for i in ipairs(dZ) do
    dZ[i] = dZ[i] / Z
end

-- Print details about the initial Hamiltonian.
io.write(header)
for i, Psi in ipairs(Psis_i) do
    io.write(string.format('%5d', i))
    for j, Operator in ipairs(Operators) do
        if j == 1 then
            io.write(string.format('%12.6f', Complex.Re(Psi * Operator * Psi)))
        elseif Operator == 'dZ' then
            io.write(string.format('%12.2E', dZ[i]))
        else
            io.write(string.format('%10.4f', Complex.Re(Psi * Operator * Psi)))
        end
    end
    io.write('\n')
end
io.write(footer)

--------------------------------------------------------------------------------
-- Define some helper function for the spectra calculation.
--------------------------------------------------------------------------------
function ValueInTable(value, table)
    -- Check if a value is in a table.
    for k, v in ipairs(table) do
        if value == v then
            return true
        end
    end
    return false
end

function GetSpectrum(G, T, Psis, indices, dZSpectra)
    -- Extract the spectra corresponding to the operators identified
    -- using the indices argument. The returned spectrum is a weighted
    -- sum, where the weights are the Boltzmann probabilities.
    if not (type(indices) == 'table') then
        indices = {indices}
    end

    c = 1
    dZSpectrum = {}

    for i in ipairs(T) do
        for k in ipairs(Psis) do
            if ValueInTable(i, indices) then
                table.insert(dZSpectrum, dZSpectra[c])
            else
                table.insert(dZSpectrum, 0)
            end
            c = c + 1
        end
    end

    return Spectra.Sum(G, dZSpectrum)
end

function SaveSpectrum(G, suffix)
    -- Scale, broaden, and save the spectrum to disk.
    G = -1 / math.pi * G

    Gmin1 = $Gmin1 - Gamma
    Gmax1 = $Gmax1 - Gamma
    Egamma1 = ($Egamma1 - Eedge1) + DeltaE
    G.Broaden(0, {{Emin, Gmin1}, {Egamma1, Gmin1}, {Egamma1, Gmax1}, {Emax, Gmax1}})

    G.Print({{'file', '$BaseName_' .. suffix .. '.spec'}})
end

--------------------------------------------------------------------------------
-- Define the transition operators.
--------------------------------------------------------------------------------
T_4s = {}
for i = 1, NElectrons_4s / 2 do
    T_4s[2*i - 1] = NewOperator('An', NFermions, IndexDn_4s[i])
    T_4s[2*i]     = NewOperator('An', NFermions, IndexUp_4s[i])
end

-- List with the user selected spectra.
spectra = {$spectra}

if next(spectra) == nil then
    return
end

indices_4s = {}
c = 1

spectrum = 'Isotropic'
if ValueInTable(spectrum, spectra) then
    indices_4s[spectrum] = {}
    for j, operator in ipairs(T_4s) do
        table.insert(indices_4s[spectrum], c)
        c = c + 1
    end
end

--------------------------------------------------------------------------------
-- Calculate and save the spectra.
--------------------------------------------------------------------------------
E_gs_i = Psis_i[1] * H_i * Psis_i[1]

if CalculationRestrictions == nil then
    Psis_f = Eigensystem(H_f, FinalRestrictions, 1)
else
    Psis_f = Eigensystem(H_f, FinalRestrictions, 1, {{'restrictions', CalculationRestrictions}})
end

Psis_f = {Psis_f}
E_gs_f = Psis_f[1] * H_f * Psis_f[1]

Eedge1 = $Eedge1
DeltaE = E_gs_f - E_gs_i

Emin = ($Emin1 - Eedge1) + DeltaE
Emax = ($Emax1 - Eedge1) + DeltaE
NE = $NE1
Gamma = $Gamma1
DenseBorder = $DenseBorder

if CalculationRestrictions == nil then
    G_4s = CreateSpectra(H_f, T_4s, Psis_i, {{'Emin', Emin}, {'Emax', Emax}, {'NE', NE}, {'Gamma', Gamma}, {'DenseBorder', DenseBorder}})
else
    G_4s = CreateSpectra(H_f, T_4s, Psis_i, {{'Emin', Emin}, {'Emax', Emax}, {'NE', NE}, {'Gamma', Gamma}, {'restrictions', CalculationRestrictions}, {'DenseBorder', DenseBorder}})
end

-- Create a list with the Boltzmann probabilities for a given operator
-- and state.
dZ_4s = {}
for i in ipairs(T_4s) do
    for j in ipairs(Psis_i) do
        table.insert(dZ_4s, dZ[j])
    end
end

spectrum = 'Isotropic'
if ValueInTable(spectrum, spectra) then
    Giso = GetSpectrum(G_4s, T_4s, Psis_i, indices_4s[spectrum], dZ_4s)
    SaveSpectrum(Giso / #T_4s, 'iso')
end


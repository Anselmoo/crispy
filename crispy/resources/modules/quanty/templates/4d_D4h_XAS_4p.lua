--------------------------------------------------------------------------------
-- Quanty input file generated using Crispy. If you use this file please cite
-- the following reference: http://dx.doi.org/10.5281/zenodo.1008184.
--
-- elements: 4d
-- symmetry: D4h
-- experiment: XAS
-- edge: N2,3 (4p)
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
H_4d_ligands_hybridization = $H_4d_ligands_hybridization
H_magnetic_field = $H_magnetic_field
H_exchange_field = $H_exchange_field

--------------------------------------------------------------------------------
-- Define the number of electrons, shells, etc.
--------------------------------------------------------------------------------
NBosons = 0
NFermions = 16

NElectrons_4p = 6
NElectrons_4d = $NElectrons_4d

IndexDn_4p = {0, 2, 4}
IndexUp_4p = {1, 3, 5}
IndexDn_4d = {6, 8, 10, 12, 14}
IndexUp_4d = {7, 9, 11, 13, 15}

if H_4d_ligands_hybridization == 1 then
    NFermions = 26

    NElectrons_Ld = 10

    IndexDn_Ld = {16, 18, 20, 22, 24}
    IndexUp_Ld = {17, 19, 21, 23, 25}
end

--------------------------------------------------------------------------------
-- Define the atomic term.
--------------------------------------------------------------------------------
N_4p = NewOperator('Number', NFermions, IndexUp_4p, IndexUp_4p, {1, 1, 1})
     + NewOperator('Number', NFermions, IndexDn_4p, IndexDn_4p, {1, 1, 1})

N_4d = NewOperator('Number', NFermions, IndexUp_4d, IndexUp_4d, {1, 1, 1, 1, 1})
     + NewOperator('Number', NFermions, IndexDn_4d, IndexDn_4d, {1, 1, 1, 1, 1})

if H_atomic == 1 then
    F0_4d_4d = NewOperator('U', NFermions, IndexUp_4d, IndexDn_4d, {1, 0, 0})
    F2_4d_4d = NewOperator('U', NFermions, IndexUp_4d, IndexDn_4d, {0, 1, 0})
    F4_4d_4d = NewOperator('U', NFermions, IndexUp_4d, IndexDn_4d, {0, 0, 1})

    F0_4p_4d = NewOperator('U', NFermions, IndexUp_4p, IndexDn_4p, IndexUp_4d, IndexDn_4d, {1, 0}, {0, 0})
    F2_4p_4d = NewOperator('U', NFermions, IndexUp_4p, IndexDn_4p, IndexUp_4d, IndexDn_4d, {0, 1}, {0, 0})
    G1_4p_4d = NewOperator('U', NFermions, IndexUp_4p, IndexDn_4p, IndexUp_4d, IndexDn_4d, {0, 0}, {1, 0})
    G3_4p_4d = NewOperator('U', NFermions, IndexUp_4p, IndexDn_4p, IndexUp_4d, IndexDn_4d, {0, 0}, {0, 1})

    F2_4d_4d_i = $F2(4d,4d)_i_value * $F2(4d,4d)_i_scale
    F4_4d_4d_i = $F4(4d,4d)_i_value * $F4(4d,4d)_i_scale
    F0_4d_4d_i = 2 / 63 * F2_4d_4d_i + 2 / 63 * F4_4d_4d_i

    F2_4d_4d_f = $F2(4d,4d)_f_value * $F2(4d,4d)_f_scale
    F4_4d_4d_f = $F4(4d,4d)_f_value * $F4(4d,4d)_f_scale
    F0_4d_4d_f = 2 / 63 * F2_4d_4d_f + 2 / 63 * F4_4d_4d_f
    F2_4p_4d_f = $F2(4p,4d)_f_value * $F2(4p,4d)_f_scale
    G1_4p_4d_f = $G1(4p,4d)_f_value * $G1(4p,4d)_f_scale
    G3_4p_4d_f = $G3(4p,4d)_f_value * $G3(4p,4d)_f_scale
    F0_4p_4d_f = 1 / 15 * G1_4p_4d_f + 3 / 70 * G3_4p_4d_f

    H_i = H_i + Chop(
          F0_4d_4d_i * F0_4d_4d
        + F2_4d_4d_i * F2_4d_4d
        + F4_4d_4d_i * F4_4d_4d)

    H_f = H_f + Chop(
          F0_4d_4d_f * F0_4d_4d
        + F2_4d_4d_f * F2_4d_4d
        + F4_4d_4d_f * F4_4d_4d
        + F0_4p_4d_f * F0_4p_4d
        + F2_4p_4d_f * F2_4p_4d
        + G1_4p_4d_f * G1_4p_4d
        + G3_4p_4d_f * G3_4p_4d)

    ldots_4d = NewOperator('ldots', NFermions, IndexUp_4d, IndexDn_4d)

    ldots_4p = NewOperator('ldots', NFermions, IndexUp_4p, IndexDn_4p)

    zeta_4d_i = $zeta(4d)_i_value * $zeta(4d)_i_scale

    zeta_4d_f = $zeta(4d)_f_value * $zeta(4d)_f_scale
    zeta_4p_f = $zeta(4p)_f_value * $zeta(4p)_f_scale

    H_i = H_i + Chop(
          zeta_4d_i * ldots_4d)

    H_f = H_f + Chop(
          zeta_4d_f * ldots_4d
        + zeta_4p_f * ldots_4p)
end

--------------------------------------------------------------------------------
-- Define the crystal field term.
--------------------------------------------------------------------------------
if H_crystal_field == 1 then
    -- PotentialExpandedOnClm('D4h', 2, {Ea1g, Eb1g, Eb2g, Eeg})
    -- Dq_4d = NewOperator('CF', NFermions, IndexUp_4d, IndexDn_4d, PotentialExpandedOnClm('D4h', 2, { 6,  6, -4, -4}))
    -- Ds_4d = NewOperator('CF', NFermions, IndexUp_4d, IndexDn_4d, PotentialExpandedOnClm('D4h', 2, {-2,  2,  2, -1}))
    -- Dt_4d = NewOperator('CF', NFermions, IndexUp_4d, IndexDn_4d, PotentialExpandedOnClm('D4h', 2, {-6, -1, -1,  4}))

    Akm = {{4, 0, 21}, {4, -4, 1.5 * sqrt(70)}, {4, 4, 1.5 * sqrt(70)}}
    Dq_4d = NewOperator('CF', NFermions, IndexUp_4d, IndexDn_4d, Akm)

    Akm = {{2, 0, -7}}
    Ds_4d = NewOperator('CF', NFermions, IndexUp_4d, IndexDn_4d, Akm)

    Akm = {{4, 0, -21}}
    Dt_4d = NewOperator('CF', NFermions, IndexUp_4d, IndexDn_4d, Akm)

    Dq_4d_i = $Dq(4d)_i_value
    Ds_4d_i = $Ds(4d)_i_value
    Dt_4d_i = $Dt(4d)_i_value

    io.write('Energies of the 4d orbitals in the initial Hamiltonian (crystal field term only):\n')
    io.write('================\n')
    io.write('Irrep.         E\n')
    io.write('================\n')
    io.write(string.format('eg      %8.3f\n', -4 * Dq_4d_i - Ds_4d_i + 4 * Dt_4d_i))
    io.write(string.format('b2g     %8.3f\n', -4 * Dq_4d_i + 2 * Ds_4d_i - Dt_4d_i ))
    io.write(string.format('a1g     %8.3f\n', 6 * Dq_4d_i - 2 * Ds_4d_i - 6 * Dt_4d_i ))
    io.write(string.format('b1g     %8.3f\n', 6 * Dq_4d_i + 2 * Ds_4d_i - Dt_4d_i ))
    io.write('================\n')
    io.write('\n')

    Dq_4d_f = $Dq(4d)_f_value
    Ds_4d_f = $Ds(4d)_f_value
    Dt_4d_f = $Dt(4d)_f_value

    H_i = H_i + Chop(
          Dq_4d_i * Dq_4d
        + Ds_4d_i * Ds_4d
        + Dt_4d_i * Dt_4d)

    H_f = H_f + Chop(
          Dq_4d_f * Dq_4d
        + Ds_4d_f * Ds_4d
        + Dt_4d_f * Dt_4d)
end

--------------------------------------------------------------------------------
-- Define the 4d-ligands hybridization term.
--------------------------------------------------------------------------------
if H_4d_ligands_hybridization == 1 then
    N_Ld = NewOperator('Number', NFermions, IndexUp_Ld, IndexUp_Ld, {1, 1, 1, 1, 1})
         + NewOperator('Number', NFermions, IndexDn_Ld, IndexDn_Ld, {1, 1, 1, 1, 1})

    Delta_4d_Ld_i = $Delta(4d,Ld)_i_value
    e_4d_i = (10 * Delta_4d_Ld_i - NElectrons_4d * (19 + NElectrons_4d) * U_4d_4d_i / 2) / (10 + NElectrons_4d)
    e_Ld_i = NElectrons_4d * ((1 + NElectrons_4d) * U_4d_4d_i / 2 - Delta_4d_Ld_i) / (10 + NElectrons_4d)

    Delta_4d_Ld_f = $Delta(4d,Ld)_f_value
    e_4d_f = (10 * Delta_4d_Ld_f - NElectrons_4d * (31 + NElectrons_4d) * U_4d_4d_f / 2 - 90 * U_4p_4d_f) / (16 + NElectrons_4d)
    e_4p_f = (10 * Delta_4d_Ld_f + (1 + NElectrons_4d) * (NElectrons_4d * U_4d_4d_f / 2 - (10 + NElectrons_4d) * U_4p_4d_f)) / (16 + NElectrons_4d)
    e_Ld_f = ((1 + NElectrons_4d) * (NElectrons_4d * U_4d_4d_f / 2 + 6 * U_4p_4d_f) - (6 + NElectrons_4d) * Delta_4d_Ld_f) / (16 + NElectrons_4d)

    H_i = H_i + Chop(
          e_4d_i * N_4d
        + e_Ld_i * N_Ld)

    H_f = H_f + Chop(
          e_4d_f * N_4d
        + e_4p_f * N_4p
        + e_Ld_f * N_Ld)

    Dq_Ld = NewOperator('CF', NFermions, IndexUp_Ld, IndexDn_Ld, PotentialExpandedOnClm('D4h', 2, { 6,  6, -4, -4}))
    Ds_Ld = NewOperator('CF', NFermions, IndexUp_Ld, IndexDn_Ld, PotentialExpandedOnClm('D4h', 2, {-2,  2,  2, -1}))
    Dt_Ld = NewOperator('CF', NFermions, IndexUp_Ld, IndexDn_Ld, PotentialExpandedOnClm('D4h', 2, {-6, -1, -1,  4}))

    Va1g_4d_Ld = NewOperator('CF', NFermions, IndexUp_Ld, IndexDn_Ld, IndexUp_4d, IndexDn_4d, PotentialExpandedOnClm('D4h', 2, {1, 0, 0, 0}))
               + NewOperator('CF', NFermions, IndexUp_4d, IndexDn_4d, IndexUp_Ld, IndexDn_Ld, PotentialExpandedOnClm('D4h', 2, {1, 0, 0, 0}))

    Vb1g_4d_Ld = NewOperator('CF', NFermions, IndexUp_Ld, IndexDn_Ld, IndexUp_4d, IndexDn_4d, PotentialExpandedOnClm('D4h', 2, {0, 1, 0, 0}))
               + NewOperator('CF', NFermions, IndexUp_4d, IndexDn_4d, IndexUp_Ld, IndexDn_Ld, PotentialExpandedOnClm('D4h', 2, {0, 1, 0, 0}))

    Vb2g_4d_Ld = NewOperator('CF', NFermions, IndexUp_Ld, IndexDn_Ld, IndexUp_4d, IndexDn_4d, PotentialExpandedOnClm('D4h', 2, {0, 0, 1, 0}))
               + NewOperator('CF', NFermions, IndexUp_4d, IndexDn_4d, IndexUp_Ld, IndexDn_Ld, PotentialExpandedOnClm('D4h', 2, {0, 0, 1, 0}))

    Veg_4d_Ld = NewOperator('CF', NFermions, IndexUp_Ld, IndexDn_Ld, IndexUp_4d, IndexDn_4d, PotentialExpandedOnClm('D4h', 2, {0, 0, 0, 1}))
              + NewOperator('CF', NFermions, IndexUp_4d, IndexDn_4d, IndexUp_Ld, IndexDn_Ld, PotentialExpandedOnClm('D4h', 2, {0, 0, 0, 1}))

    Dq_Ld_i = $Dq(Ld)_i_value
    Ds_Ld_i = $Ds(Ld)_i_value
    Dt_Ld_i = $Dt(Ld)_i_value
    Va1g_4d_Ld_i = $Va1g(4d,Ld)_i_value
    Vb1g_4d_Ld_i = $Vb1g(4d,Ld)_i_value
    Vb2g_4d_Ld_i = $Vb2g(4d,Ld)_i_value
    Veg_4d_Ld_i = $Veg(4d,Ld)_i_value

    Dq_Ld_f = $Dq(Ld)_f_value
    Ds_Ld_f = $Ds(Ld)_f_value
    Dt_Ld_f = $Dt(Ld)_f_value
    Va1g_4d_Ld_f = $Va1g(4d,Ld)_f_value
    Vb1g_4d_Ld_f = $Vb1g(4d,Ld)_f_value
    Vb2g_4d_Ld_f = $Vb2g(4d,Ld)_f_value
    Veg_4d_Ld_f = $Veg(4d,Ld)_f_value

    H_i = H_i + Chop(
          Dq_Ld_i * Dq_Ld
        + Ds_Ld_i * Ds_Ld
        + Dt_Ld_i * Dt_Ld
        + Va1g_4d_Ld_i * Va1g_4d_Ld
        + Vb1g_4d_Ld_i * Vb1g_4d_Ld
        + Vb2g_4d_Ld_i * Vb2g_4d_Ld
        + Veg_4d_Ld_i  * Veg_4d_Ld)

    H_f = H_f + Chop(
          Dq_Ld_f * Dq_Ld
        + Ds_Ld_f * Ds_Ld
        + Dt_Ld_f * Dt_Ld
        + Va1g_4d_Ld_f * Va1g_4d_Ld
        + Vb1g_4d_Ld_f * Vb1g_4d_Ld
        + Vb2g_4d_Ld_f * Vb2g_4d_Ld
        + Veg_4d_Ld_f  * Veg_4d_Ld)
end

--------------------------------------------------------------------------------
-- Define the magnetic field and exchange field terms.
--------------------------------------------------------------------------------
Sx_4d = NewOperator('Sx', NFermions, IndexUp_4d, IndexDn_4d)
Sy_4d = NewOperator('Sy', NFermions, IndexUp_4d, IndexDn_4d)
Sz_4d = NewOperator('Sz', NFermions, IndexUp_4d, IndexDn_4d)
Ssqr_4d = NewOperator('Ssqr', NFermions, IndexUp_4d, IndexDn_4d)
Splus_4d = NewOperator('Splus', NFermions, IndexUp_4d, IndexDn_4d)
Smin_4d = NewOperator('Smin', NFermions, IndexUp_4d, IndexDn_4d)

Lx_4d = NewOperator('Lx', NFermions, IndexUp_4d, IndexDn_4d)
Ly_4d = NewOperator('Ly', NFermions, IndexUp_4d, IndexDn_4d)
Lz_4d = NewOperator('Lz', NFermions, IndexUp_4d, IndexDn_4d)
Lsqr_4d = NewOperator('Lsqr', NFermions, IndexUp_4d, IndexDn_4d)
Lplus_4d = NewOperator('Lplus', NFermions, IndexUp_4d, IndexDn_4d)
Lmin_4d = NewOperator('Lmin', NFermions, IndexUp_4d, IndexDn_4d)

Jx_4d = NewOperator('Jx', NFermions, IndexUp_4d, IndexDn_4d)
Jy_4d = NewOperator('Jy', NFermions, IndexUp_4d, IndexDn_4d)
Jz_4d = NewOperator('Jz', NFermions, IndexUp_4d, IndexDn_4d)
Jsqr_4d = NewOperator('Jsqr', NFermions, IndexUp_4d, IndexDn_4d)
Jplus_4d = NewOperator('Jplus', NFermions, IndexUp_4d, IndexDn_4d)
Jmin_4d = NewOperator('Jmin', NFermions, IndexUp_4d, IndexDn_4d)

Tz = NewOperator('Tz', NFermions, IndexUp_4d, IndexDn_4d)

Sx = Sx_4d
Sy = Sy_4d
Sz = Sz_4d

Lx = Lx_4d
Ly = Ly_4d
Lz = Lz_4d

Jx = Jx_4d
Jy = Jy_4d
Jz = Jz_4d


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

NConfigurations = $NConfigurations

--------------------------------------------------------------------------------
-- Define the restrictions and set the number of initial states.
--------------------------------------------------------------------------------
InitialRestrictions = {NFermions, NBosons, {'111111 0000000000', NElectrons_4p, NElectrons_4p},
                                           {'000000 1111111111', NElectrons_4d, NElectrons_4d}}

FinalRestrictions = {NFermions, NBosons, {'111111 0000000000', NElectrons_4p - 1, NElectrons_4p - 1},
                                         {'000000 1111111111', NElectrons_4d + 1, NElectrons_4d + 1}}

if H_4d_ligands_hybridization == 1 then
    InitialRestrictions = {NFermions, NBosons, {'111111 0000000000 0000000000', NElectrons_4p, NElectrons_4p},
                                               {'000000 1111111111 0000000000', NElectrons_4d, NElectrons_4d},
                                               {'000000 0000000000 1111111111', NElectrons_Ld, NElectrons_Ld}}

    FinalRestrictions = {NFermions, NBosons, {'111111 0000000000 0000000000', NElectrons_4p - 1, NElectrons_4p - 1},
                                             {'000000 1111111111 0000000000', NElectrons_4d + 1, NElectrons_4d + 1},
                                             {'000000 0000000000 1111111111', NElectrons_Ld, NElectrons_Ld}}


    CalculationRestrictions = {NFermions, NBosons, {'00 0000000000 1111111111', NElectrons_Ld - (NConfigurations - 1), NElectrons_Ld}}
end

Operators = {H_i, Ssqr, Lsqr, Jsqr, Sz, Lz, Jz, Tz, ldots_4d, N_4p, N_4d, 'dZ'}
header = 'Analysis of the initial Hamiltonian:\n'
header = header .. '=================================================================================================================================\n'
header = header .. 'State         <E>     <S^2>     <L^2>     <J^2>      <Sz>      <Lz>      <Jz>      <Tz>     <l.s>    <N_4p>    <N_4d>          dZ\n'
header = header .. '=================================================================================================================================\n'
footer = '=================================================================================================================================\n'

if H_4d_ligands_hybridization == 1 then
    Operators = {H_i, Ssqr, Lsqr, Jsqr, Sz, Lz, Jz, Tz, ldots_4d, N_4p, N_4d, N_Ld, 'dZ'}
    header = 'Analysis of the initial Hamiltonian:\n'
    header = header .. '===========================================================================================================================================\n'
    header = header .. 'State         <E>     <S^2>     <L^2>     <J^2>      <Sz>      <Lz>      <Jz>      <Tz>     <l.s>    <N_4p>    <N_4d>    <N_Ld>          dZ\n'
    header = header .. '===========================================================================================================================================\n'
    footer = '===========================================================================================================================================\n'
end

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
-- Define the transition operators.
--------------------------------------------------------------------------------
t = math.sqrt(1/2)

Tx_4p_4d = NewOperator('CF', NFermions, IndexUp_4d, IndexDn_4d, IndexUp_4p, IndexDn_4p, {{1, -1, t    }, {1, 1, -t    }})
Ty_4p_4d = NewOperator('CF', NFermions, IndexUp_4d, IndexDn_4d, IndexUp_4p, IndexDn_4p, {{1, -1, t * I}, {1, 1,  t * I}})
Tz_4p_4d = NewOperator('CF', NFermions, IndexUp_4d, IndexDn_4d, IndexUp_4p, IndexDn_4p, {{1,  0, 1    }                })

k = $k1
ev = $eps11
eh = $eps12

-- Calculate the right and left polarization vectors.
er = {t * (eh[1] - I * ev[1]),
      t * (eh[2] - I * ev[2]),
      t * (eh[3] - I * ev[3])}

el = {-t * (eh[1] + I * ev[1]),
      -t * (eh[2] + I * ev[2]),
      -t * (eh[3] + I * ev[3])}

function CalculateT(e)
    -- Calculate the transition operator for arbitrary
    -- polarization and wave vectors.
    T = e[1] * Tx_4p_4d + e[2] * Ty_4p_4d + e[3] * Tz_4p_4d
    return Chop(T)
end

Tv_4p_4d = CalculateT(ev, k)
Th_4p_4d = CalculateT(eh, k)
Tr_4p_4d = CalculateT(er, k)
Tl_4p_4d = CalculateT(el, k)
Tk_4p_4d = CalculateT(k, k)

-- List with the user selected spectra.
spectra = {$spectra}

if next(spectra) == nil then
    return
end

-- Create two lists, one with the operators and the second with
-- the indices of the operators required to calculate a given
-- spectrum.
T_4p_4d = {}
indices_4p_4d = {}
c = 1
for i, spectrum in ipairs(spectra) do
    if spectrum == 'Isotropic' then
        indices_4p_4d[spectrum] = {}
        for j, operator in ipairs({Tx_4p_4d, Ty_4p_4d, Tz_4p_4d}) do
            table.insert(T_4p_4d, operator)
            table.insert(indices_4p_4d[spectrum], c)
            c = c + 1
        end
    elseif spectrum == 'Circular Dichroism' then
        indices_4p_4d[spectrum] = {}
        for j, operator in ipairs({Tr_4p_4d, Tl_4p_4d}) do
            table.insert(T_4p_4d, operator)
            table.insert(indices_4p_4d[spectrum], c)
            c = c + 1
        end
    elseif spectrum == 'Linear Dichroism' then
        indices_4p_4d[spectrum] = {}
        for j, operator in ipairs({Tv_4p_4d, Th_4p_4d}) do
            table.insert(T_4p_4d, operator)
            table.insert(indices_4p_4d[spectrum], c)
            c = c + 1
        end
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
    G_4p_4d = CreateSpectra(H_f, T_4p_4d, Psis_i, {{'Emin', Emin}, {'Emax', Emax}, {'NE', NE}, {'Gamma', Gamma}, {'DenseBorder', DenseBorder}})
else
    G_4p_4d = CreateSpectra(H_f, T_4p_4d, Psis_i, {{'Emin', Emin}, {'Emax', Emax}, {'NE', NE}, {'Gamma', Gamma}, {'restrictions', CalculationRestrictions}, {'DenseBorder', DenseBorder}})
end

-- Create a list with the Boltzmann probabilities for a given operator
-- and state.
dZ_4p_4d = {}
for i in ipairs(T_4p_4d) do
    for j in ipairs(Psis_i) do
        table.insert(dZ_4p_4d, dZ[j])
    end
end

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

for i, spectrum in ipairs(spectra) do
    if spectrum == 'Isotropic' then
        Giso = GetSpectrum(G_4p_4d, T_4p_4d, Psis_i, indices_4p_4d[spectrum], dZ_4p_4d)
        Giso = Giso / 3
        SaveSpectrum(Giso, 'iso')
    elseif spectrum == 'Circular Dichroism' then
        Gr = GetSpectrum(G_4p_4d, T_4p_4d, Psis_i, indices_4p_4d[spectrum][1], dZ_4p_4d)
        Gl = GetSpectrum(G_4p_4d, T_4p_4d, Psis_i, indices_4p_4d[spectrum][2], dZ_4p_4d)
        SaveSpectrum(Gr, 'r')
        SaveSpectrum(Gl, 'l')
        SaveSpectrum(Gr - Gl, 'cd')
    elseif spectrum == 'Linear Dichroism' then
        Gv = GetSpectrum(G_4p_4d, T_4p_4d, Psis_i, indices_4p_4d[spectrum][1], dZ_4p_4d)
        Gh = GetSpectrum(G_4p_4d, T_4p_4d, Psis_i, indices_4p_4d[spectrum][2], dZ_4p_4d)
        SaveSpectrum(Gv, 'v')
        SaveSpectrum(Gh, 'h')
        SaveSpectrum(Gv - Gh, 'ld')
    end
end


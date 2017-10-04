--------------------------------------------------------------------------------
-- Quanty input file generated using Crispy.
--
-- elements: lathanides
-- symmetry: Oh
-- experiment: RIXS
-- edge: L2,3-N4,5 (2p4d)
--------------------------------------------------------------------------------
Verbosity(0x00FF)

--------------------------------------------------------------------------------
-- Initialize the Hamiltonians.
--------------------------------------------------------------------------------
H_i = 0
H_m = 0
H_f = 0

--------------------------------------------------------------------------------
-- Toggle the Hamiltonian terms.
--------------------------------------------------------------------------------
H_atomic = $H_atomic
H_cf     = $H_cf

--------------------------------------------------------------------------------
-- Define the number of electrons, shells, etc.
--------------------------------------------------------------------------------
NFermions = 30
NBosons = 0

NElectrons_2p = 6
NElectrons_4d = 10
NElectrons_4f = $NElectrons_4f

IndexDn_2p = {0, 2, 4}
IndexUp_2p = {1, 3, 5}
IndexDn_4d = {6, 8, 10, 12, 14}
IndexUp_4d = {7, 9, 11, 13, 15}
IndexDn_4f = {16, 18, 20, 22, 24, 26, 28}
IndexUp_4f = {17, 19, 21, 23, 25, 27, 29}

--------------------------------------------------------------------------------
-- Define the atomic term.
--------------------------------------------------------------------------------
N_2p = NewOperator('Number', NFermions, IndexUp_2p, IndexUp_2p, {1, 1, 1})
     + NewOperator('Number', NFermions, IndexDn_2p, IndexDn_2p, {1, 1, 1})

N_4d = NewOperator('Number', NFermions, IndexUp_4d, IndexUp_4d, {1, 1, 1, 1, 1})
     + NewOperator('Number', NFermions, IndexDn_4d, IndexDn_4d, {1, 1, 1, 1, 1})

N_4f = NewOperator('Number', NFermions, IndexUp_4f, IndexUp_4f, {1, 1, 1, 1, 1, 1, 1})
     + NewOperator('Number', NFermions, IndexDn_4f, IndexDn_4f, {1, 1, 1, 1, 1, 1, 1})

if H_atomic == 1 then
    F0_4f_4f = NewOperator('U', NFermions, IndexUp_4f, IndexDn_4f, {1, 0, 0, 0})
    F2_4f_4f = NewOperator('U', NFermions, IndexUp_4f, IndexDn_4f, {0, 1, 0, 0})
    F4_4f_4f = NewOperator('U', NFermions, IndexUp_4f, IndexDn_4f, {0, 0, 1, 0})
    F6_4f_4f = NewOperator('U', NFermions, IndexUp_4f, IndexDn_4f, {0, 0, 0, 1})

    F0_2p_4f = NewOperator('U', NFermions, IndexUp_2p, IndexDn_2p, IndexUp_4f, IndexDn_4f, {1, 0}, {0, 0})
    F2_2p_4f = NewOperator('U', NFermions, IndexUp_2p, IndexDn_2p, IndexUp_4f, IndexDn_4f, {0, 1}, {0, 0})
    G2_2p_4f = NewOperator('U', NFermions, IndexUp_2p, IndexDn_2p, IndexUp_4f, IndexDn_4f, {0, 0}, {1, 0})
    G4_2p_4f = NewOperator('U', NFermions, IndexUp_2p, IndexDn_2p, IndexUp_4f, IndexDn_4f, {0, 0}, {0, 1})

    F0_4d_4f = NewOperator('U', NFermions, IndexUp_4d, IndexDn_4d, IndexUp_4f, IndexDn_4f, {1, 0, 0}, {0, 0, 0});
    F2_4d_4f = NewOperator('U', NFermions, IndexUp_4d, IndexDn_4d, IndexUp_4f, IndexDn_4f, {0, 1, 0}, {0, 0, 0});
    F4_4d_4f = NewOperator('U', NFermions, IndexUp_4d, IndexDn_4d, IndexUp_4f, IndexDn_4f, {0, 0, 1}, {0, 0, 0});
    G1_4d_4f = NewOperator('U', NFermions, IndexUp_4d, IndexDn_4d, IndexUp_4f, IndexDn_4f, {0, 0, 0}, {1, 0, 0});
    G3_4d_4f = NewOperator('U', NFermions, IndexUp_4d, IndexDn_4d, IndexUp_4f, IndexDn_4f, {0, 0, 0}, {0, 1, 0});
    G5_4d_4f = NewOperator('U', NFermions, IndexUp_4d, IndexDn_4d, IndexUp_4f, IndexDn_4f, {0, 0, 0}, {0, 0, 1});

    U_4f_4f_i  = $U(4f,4f)_i_value * $U(4f,4f)_i_scaling
    F2_4f_4f_i = $F2(4f,4f)_i_value * $F2(4f,4f)_i_scaling
    F4_4f_4f_i = $F4(4f,4f)_i_value * $F4(4f,4f)_i_scaling
    F6_4f_4f_i = $F6(4f,4f)_i_value * $F6(4f,4f)_i_scaling
    F0_4f_4f_i = U_4f_4f_i + 4 / 195 * F2_4f_4f_i + 2 / 143 * F4_4f_4f_i + 100 / 5577 * F6_4f_4f_i

    U_4f_4f_m  = $U(4f,4f)_m_value * $U(4f,4f)_m_scaling
    F2_4f_4f_m = $F2(4f,4f)_m_value * $F2(4f,4f)_m_scaling
    F4_4f_4f_m = $F4(4f,4f)_m_value * $F4(4f,4f)_m_scaling
    F6_4f_4f_m = $F6(4f,4f)_m_value * $F6(4f,4f)_m_scaling
    F0_4f_4f_m = U_4f_4f_m + 4 / 195 * F2_4f_4f_m + 2 / 143 * F4_4f_4f_m + 100 / 5577 * F6_4f_4f_m
    U_2p_4f_m  = $U(2p,4f)_m_value * $U(2p,4f)_m_scaling
    F2_2p_4f_m = $F2(2p,4f)_m_value * $F2(2p,4f)_m_scaling
    G2_2p_4f_m = $G2(2p,4f)_m_value * $G2(2p,4f)_m_scaling
    G4_2p_4f_m = $G4(2p,4f)_m_value * $G4(2p,4f)_m_scaling
    F0_2p_4f_m = U_2p_4f_m + 3 / 70 * G2_2p_4f_m + 2 / 63 * G4_2p_4f_m

    U_4f_4f_f  = $U(4f,4f)_f_value * $U(4f,4f)_f_scaling
    F2_4f_4f_f = $F2(4f,4f)_f_value * $F2(4f,4f)_f_scaling
    F4_4f_4f_f = $F4(4f,4f)_f_value * $F4(4f,4f)_f_scaling
    F6_4f_4f_f = $F6(4f,4f)_f_value * $F6(4f,4f)_f_scaling
    F0_4f_4f_f = U_4f_4f_f + 4 / 195 * F2_4f_4f_f + 2 / 143 * F4_4f_4f_f + 100 / 5577 * F6_4f_4f_f
    U_4d_4f_f  = $U(4d,4f)_f_value * $U(4d,4f)_f_scaling
    F2_4d_4f_f = $F2(4d,4f)_f_value * $F2(4d,4f)_f_scaling
    F4_4d_4f_f = $F4(4d,4f)_f_value * $F4(4d,4f)_f_scaling
    G1_4d_4f_f = $G1(4d,4f)_f_value * $G1(4d,4f)_f_scaling
    G3_4d_4f_f = $G3(4d,4f)_f_value * $G3(4d,4f)_f_scaling
    G5_4d_4f_f = $G5(4d,4f)_f_value * $G5(4d,4f)_f_scaling
    F0_4d_4f_f = U_4d_4f_f + 3 / 70 * G1_4d_4f_f + 2 / 105 * G3_4d_4f_f + 5 / 231 * G5_4d_4f_f

    H_i = H_i
        + F0_4f_4f_i * F0_4f_4f
        + F2_4f_4f_i * F2_4f_4f
        + F4_4f_4f_i * F4_4f_4f
        + F6_4f_4f_i * F6_4f_4f

    H_m = H_m
        + F0_4f_4f_m * F0_4f_4f
        + F2_4f_4f_m * F2_4f_4f
        + F4_4f_4f_m * F4_4f_4f
        + F6_4f_4f_m * F6_4f_4f
        + F0_2p_4f_m * F0_2p_4f
        + F2_2p_4f_m * F2_2p_4f
        + G2_2p_4f_m * G2_2p_4f
        + G4_2p_4f_m * G4_2p_4f

    H_f = H_f
        + F0_4f_4f_f * F0_4f_4f
        + F2_4f_4f_f * F2_4f_4f
        + F4_4f_4f_f * F4_4f_4f
        + F6_4f_4f_f * F6_4f_4f
        + F0_4d_4f_f * F0_4d_4f
        + F2_4d_4f_f * F2_4d_4f
        + F4_4d_4f_f * F4_4d_4f
        + G1_4d_4f_f * G1_4d_4f
        + G3_4d_4f_f * G3_4d_4f
        + G5_4d_4f_f * G5_4d_4f

    ldots_4f = NewOperator('ldots', NFermions, IndexUp_4f, IndexDn_4f)

    ldots_2p = NewOperator('ldots', NFermions, IndexUp_2p, IndexDn_2p)

    ldots_4d = NewOperator('ldots', NFermions, IndexUp_4d, IndexDn_4d)

    zeta_4f_i = $zeta(4f)_i_value * $zeta(4f)_i_scaling

    zeta_4f_m = $zeta(4f)_m_value * $zeta(4f)_m_scaling
    zeta_2p_m = $zeta(2p)_m_value * $zeta(2p)_m_scaling

    zeta_4f_f = $zeta(4f)_f_value * $zeta(4f)_f_scaling
    zeta_4d_f = $zeta(4d)_f_value * $zeta(4d)_f_scaling

    H_i = H_i
        + zeta_4f_i * ldots_4f

    H_m = H_m
        + zeta_4f_m * ldots_4f
        + zeta_2p_m * ldots_2p

    H_f = H_f
        + zeta_4f_f * ldots_4f
        + zeta_4d_f * ldots_4d
end

--------------------------------------------------------------------------------
-- Define the crystal field term.
--------------------------------------------------------------------------------
if H_cf == 1 then
    -- PotentialExpandedOnClm('Oh', 3, {Ea2u, Et1u, Et2u})
    -- Et1u - Ea2u = Delta1
    -- Et2u - Ea2u = Delta2
    -- Ea2u + 3*Et1u + 3*Et2u = 0
    --
    -- Ea2u = -3/7*Delta1 - 3/7*Delta2
    -- Et1u =  4/7*Delta1 - 3/7*Delta2
    -- Et2u = -3/7*Delta1 + 4/7*Delta2
    Delta1_4f = NewOperator('CF', NFermions, IndexUp_4f, IndexDn_4f, PotentialExpandedOnClm('Oh', 3, {-3/7, 4/7, -3/7}))
    Delta2_4f = NewOperator('CF', NFermions, IndexUp_4f, IndexDn_4f, PotentialExpandedOnClm('Oh', 3, {-3/7, -3/7, 4/7}))

    Delta1_4f_i = $Delta1(4f)_i_value * $Delta1(4f)_i_scaling
    Delta2_4f_i = $Delta2(4f)_i_value * $Delta2(4f)_i_scaling

    Delta1_4f_m = $Delta1(4f)_m_value * $Delta1(4f)_m_scaling
    Delta2_4f_m = $Delta2(4f)_m_value * $Delta2(4f)_m_scaling

    Delta1_4f_f = $Delta1(4f)_f_value * $Delta1(4f)_f_scaling
    Delta2_4f_f = $Delta2(4f)_f_value * $Delta2(4f)_f_scaling

    H_i = H_i
        + Delta1_4f_i * Delta1_4f
        + Delta2_4f_i * Delta2_4f

    H_m = H_m
        + Delta1_4f_m * Delta1_4f
        + Delta2_4f_m * Delta2_4f

    H_f = H_f
        + Delta1_4f_f * Delta1_4f
        + Delta2_4f_f * Delta2_4f
end

--------------------------------------------------------------------------------
-- Define the magnetic field term.
--------------------------------------------------------------------------------
Sx_4f    = NewOperator('Sx'   , NFermions, IndexUp_4f, IndexDn_4f)
Sy_4f    = NewOperator('Sy'   , NFermions, IndexUp_4f, IndexDn_4f)
Sz_4f    = NewOperator('Sz'   , NFermions, IndexUp_4f, IndexDn_4f)
Ssqr_4f  = NewOperator('Ssqr' , NFermions, IndexUp_4f, IndexDn_4f)
Splus_4f = NewOperator('Splus', NFermions, IndexUp_4f, IndexDn_4f)
Smin_4f  = NewOperator('Smin' , NFermions, IndexUp_4f, IndexDn_4f)

Lx_4f    = NewOperator('Lx'   , NFermions, IndexUp_4f, IndexDn_4f)
Ly_4f    = NewOperator('Ly'   , NFermions, IndexUp_4f, IndexDn_4f)
Lz_4f    = NewOperator('Lz'   , NFermions, IndexUp_4f, IndexDn_4f)
Lsqr_4f  = NewOperator('Lsqr' , NFermions, IndexUp_4f, IndexDn_4f)
Lplus_4f = NewOperator('Lplus', NFermions, IndexUp_4f, IndexDn_4f)
Lmin_4f  = NewOperator('Lmin' , NFermions, IndexUp_4f, IndexDn_4f)

Jx_4f    = NewOperator('Jx'   , NFermions, IndexUp_4f, IndexDn_4f)
Jy_4f    = NewOperator('Jy'   , NFermions, IndexUp_4f, IndexDn_4f)
Jz_4f    = NewOperator('Jz'   , NFermions, IndexUp_4f, IndexDn_4f)
Jsqr_4f  = NewOperator('Jsqr' , NFermions, IndexUp_4f, IndexDn_4f)
Jplus_4f = NewOperator('Jplus', NFermions, IndexUp_4f, IndexDn_4f)
Jmin_4f  = NewOperator('Jmin' , NFermions, IndexUp_4f, IndexDn_4f)

Sx = Sx_4f
Sy = Sy_4f
Sz = Sz_4f

Lx = Lx_4f
Ly = Ly_4f
Lz = Lz_4f

Jx = Jx_4f
Jy = Jy_4f
Jz = Jz_4f

Ssqr = Sx * Sx + Sy * Sy + Sz * Sz
Lsqr = Lx * Lx + Ly * Ly + Lz * Lz
Jsqr = Jx * Jx + Jy * Jy + Jz * Jz

Bx = $Bx * EnergyUnits.Tesla.value
By = $By * EnergyUnits.Tesla.value
Bz = $Bz * EnergyUnits.Tesla.value

B = Bx * (2 * Sx + Lx)
  + By * (2 * Sy + Ly)
  + Bz * (2 * Sz + Lz)

H_i = H_i
    + B

H_m = H_m
    + B

H_f = H_f
    + B

--------------------------------------------------------------------------------
-- Define the restrictions and set the number of initial states.
--------------------------------------------------------------------------------
InitialRestrictions = {NFermions, NBosons, {'111111 0000000000 00000000000000', NElectrons_2p, NElectrons_2p},
                                           {'000000 1111111111 00000000000000', NElectrons_4d, NElectrons_4d},
                                           {'000000 0000000000 11111111111111', NElectrons_4f, NElectrons_4f}}

Operators = {H_f, Ssqr, Lsqr, Jsqr, Sz, Lz, Jz, N_2p, N_4d, N_4f}
header = '\nAnalysis of the initial Hamiltonian:\n'
header = header .. '========================================================================================================\n'
header = header .. '  i       <E>     <S^2>     <L^2>     <J^2>      <Sz>      <Lz>      <Jz>     <N_2p>    <N_4d>    <N_4f>\n'
header = header .. '========================================================================================================\n'
footer = '========================================================================================================\n'

-- Define the temperature.
T = $T * EnergyUnits.Kelvin.value

 -- Approximate machine epsilon.
epsilon = 2.22e-16
Z = 0

NPsis = $NPsis
NPsisAuto = $NPsisAuto

if NPsisAuto == 1 and NPsis ~= 1 then
    NPsis = 1
    NPsisIncrement = 8
    NPsisIsConverged = false
    dZ = {}

    while not NPsisIsConverged do
        if CalculationRestrictions == nil then
            Psis = Eigensystem(H_i, InitialRestrictions, NPsis)
        else
            Psis = Eigensystem(H_i, InitialRestrictions, NPsis, {'restrictions', CalculationRestrictions})
        end

        if not (type(Psis) == 'table') then
            Psis = {Psis}
        end

        E_gs = Psis[1] * H_i * Psis[1]

        for i, Psi in ipairs(Psis) do
            E = Psi * H_i * Psi

            if math.abs(E - E_gs) < epsilon then
                dZ[i] = 1
            else
                dZ[i] = math.exp(-(E - E_gs) / T)
            end

            Z = Z + dZ[i]

            if (dZ[i] / Z) < math.sqrt(epsilon) then
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
    Z = 0
else
        if CalculationRestrictions == nil then
            Psis = Eigensystem(H_i, InitialRestrictions, NPsis)
        else
            Psis = Eigensystem(H_i, InitialRestrictions, NPsis, {'restrictions', CalculationRestrictions})
        end

    if not (type(Psis) == 'table') then
        Psis = {Psis}
    end
end

io.write(header)
for i, Psi in ipairs(Psis) do
    io.write(string.format('%4d', i))
    for j, Operator in ipairs(Operators) do
        io.write(string.format('%10.4f', Complex.Re(Psi * Operator * Psi)))
    end
    io.write('\n')
end
io.write(footer)

--------------------------------------------------------------------------------
-- Define the transition operators.
--------------------------------------------------------------------------------
t = math.sqrt(1/2);

Txy_2p_4f   = NewOperator('CF', NFermions, IndexUp_4f, IndexDn_4f, IndexUp_2p, IndexDn_2p, {{2, -2, t * I}, {2, 2, -t * I}})
Txz_2p_4f   = NewOperator('CF', NFermions, IndexUp_4f, IndexDn_4f, IndexUp_2p, IndexDn_2p, {{2, -1, t    }, {2, 1, -t    }})
Tyz_2p_4f   = NewOperator('CF', NFermions, IndexUp_4f, IndexDn_4f, IndexUp_2p, IndexDn_2p, {{2, -1, t * I}, {2, 1,  t * I}})
Tx2y2_2p_4f = NewOperator('CF', NFermions, IndexUp_4f, IndexDn_4f, IndexUp_2p, IndexDn_2p, {{2, -2, t    }, {2, 2,  t    }})
Tz2_2p_4f   = NewOperator('CF', NFermions, IndexUp_4f, IndexDn_4f, IndexUp_2p, IndexDn_2p, {{2,  0, 1    }                })

Tx_4d_2p = NewOperator('CF', NFermions, IndexUp_2p, IndexDn_2p, IndexUp_4d, IndexDn_4d, {{1, -1, t    }, {1, 1, -t    }})
Ty_4d_2p = NewOperator('CF', NFermions, IndexUp_2p, IndexDn_2p, IndexUp_4d, IndexDn_4d, {{1, -1, t * I}, {1, 1,  t * I}})
Tz_4d_2p = NewOperator('CF', NFermions, IndexUp_2p, IndexDn_2p, IndexUp_4d, IndexDn_4d, {{1,  0, 1    }                })

--------------------------------------------------------------------------------
-- Calculate and save the spectra.
--------------------------------------------------------------------------------
Giso = 0

Emin1 = $Emin1
Emax1 = $Emax1
Gamma1 = $Gamma1
NE1 = $NE1

Emin2 = $Emin2
Emax2 = $Emax2
Gamma2 = $Gamma2
NE2 = $NE2

E_gs = Psis[1] * H_i * Psis[1]

for i, Psi in ipairs(Psis) do
    E = Psi * H_i * Psi

    if math.abs(E - E_gs) < epsilon then
        dZ = 1
    else
        dZ = math.exp(-(E - E_gs) / T)
    end

    if (dZ < math.sqrt(epsilon)) then
        break
    end

    Z = Z + dZ

    for j, OperatorIn in ipairs({Txy_2p_4f, Txz_2p_4f, Tyz_2p_4f, Tx2y2_2p_4f, Tz2_2p_4f}) do
        for k, OperatorOut in ipairs({Tx_4d_2p, Ty_4d_2p, Tz_4d_2p}) do
            Giso = Giso + CreateResonantSpectra(H_n, H_f, OperatorIn, OperatorOut, Psi, {{'Emin1', Emin1}, {'Emax1', Emax1}, {'NE1', NE1}, {'Gamma1', Gamma1}, {'Emin2', Emin2}, {'Emax2', Emax2}, {'NE2', NE2}, {'Gamma2', Gamma2}})
        end
    end
end

Giso = Giso / Z
Giso.Print({{'file', '$baseName' .. '_iso.spec'}})


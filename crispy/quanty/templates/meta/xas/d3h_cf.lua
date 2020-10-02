--------------------------------------------------------------------------------
-- Define the crystal field term.
--------------------------------------------------------------------------------
if CrystalFieldTerm then
    Dmu_#f = NewOperator("CF", NFermions, IndexUp_#f, IndexDn_#f, {{2, 0, -7}})
    Dnu_#f = NewOperator("CF", NFermions, IndexUp_#f, IndexDn_#f, {{4, 0, -21}})

    Dmu_#f_i = $Dmu(#f)_i_value
    Dnu_#f_i = $Dnu(#f)_i_value

    io.write("Energies of the #f orbitals in the initial Hamiltonian (crystal field term only):\n")
    io.write("================\n")
    io.write("Irrep.         E\n")
    io.write("================\n")
    io.write(string.format("a'1     %8.3f\n", -2 * Dmu_#f_i - 6 * Dnu_#f_i))
    io.write(string.format("e'      %8.3f\n", 2 * Dmu_#f_i - Dnu_#f_i))
    io.write(string.format("e''     %8.3f\n", -Dmu_#f_i + 4 * Dnu_#f_i))
    io.write("================\n")
    io.write("\n")

    Dmu_#f_f = $Dmu(#f)_f_value
    Dnu_#f_f = $Dnu(#f)_f_value

    H_i = H_i + Chop(
          Dmu_#f_i * Dmu_#f
        + Dnu_#f_i * Dnu_#f)

    H_f = H_f + Chop(
          Dmu_#f_f * Dmu_#f
        + Dnu_#f_f * Dnu_#f)
end
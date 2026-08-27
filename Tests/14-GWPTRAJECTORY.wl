(* ::Package:: *)

(* ========================================================================= *)
(* TEST SUITE  : GWPTools (Version 1.0.0)                                    *)
(* FILE        : 14-GWPTRAJECTORY.wl                                         *)
(* DESCRIPTION : Tests BohmianTrajectories section of GWPDeveloper.wl        *)
(* ========================================================================= *)

(* Load the Master Test Environment *)
Needs["GWPTools`GWPDiagnostics`"]

(* ========================================================== *)
(* DEFINITIONS AND CONFIGURATION                              *)
(* ========================================================== *)

(* Save the user's current global assumptions before modifying them *)
$userAssumptions = $Assumptions;

(* Optimized Parameter Sequence injecting {V0,V1,V2} to prevent zero-variance singularities in PE correlations *)
ToExpression[DEF01 = "PAR=Sequence[RA,IA,RX,RP,RG,IG,E^(IG/HBAR)*(2/Pi)^(1/4)*RA^(1/4),HBAR,MASS,{V0,V1,V2},{RA,IA,RX,0,RP,0,RG,IG}]"];

(* Evaluates and sets the global assumptions natively *)
ToExpression[DEF02 = "$Assumptions=GWPASSUMPTIONS[PAR,\"Position\"->x,\"Momentum\"->p,\"Cumulative\"->c]"];

ToExpression[STR01 = "XC0=GWPXC[0][c][PAR]"];
ToExpression[STR02 = "PC0=GWPPC[0][c][PAR]"];

(* ========================================================== *)
(* C-SPACE (TRAJECTORY INVERSION) VERIFICATION TESTS          *)
(* ========================================================== *)

VerificationTest[True, TestID -> "Definition", MetaInformation -> DEF01]
VerificationTest[True, TestID -> "Definition", MetaInformation -> DEF02]

(* ---------------------------------------------------------- *)
(* 1. Position-Space Trajectory Inversion                     *)
(* ---------------------------------------------------------- *)
VerificationTest[
  Simplify[XC0 - Quiet@First@SolveValues[GWPCX[x][PAR] == c, x, Assumptions -> None]] == 0,
  TestID -> "GWPXC-01-Inversion", MetaInformation -> STR01
]
VerificationTest[
  And @@ Table[Simplify[GWPXC[n][c][PAR] - D[XC0, {c, n}]] == 0, {n, 0, 6}],
  TestID -> "GWPXC-02-Derivatives"
]

(* ---------------------------------------------------------- *)
(* 2. Momentum-Space Trajectory Inversion                     *)
(* ---------------------------------------------------------- *)
VerificationTest[
  Simplify[PC0 - Quiet@First@SolveValues[GWPCP[p][PAR] == c, p, Assumptions -> None]] == 0,
  TestID -> "GWPPC-01-Inversion", MetaInformation -> STR02
]
VerificationTest[
  And @@ Table[Simplify[GWPPC[n][c][PAR] - D[PC0, {c, n}]] == 0, {n, 0, 6}],
  TestID -> "GWPPC-02-Derivatives"
]

(* ---------------------------------------------------------- *)
(* 3. Hydrodynamic C-Space Mappings                           *)
(* ---------------------------------------------------------- *)
VerificationTest[
  Simplify[GWPRHOC[c][PAR] - GWPRHOX[XC0][PAR]] == 0,
  TestID -> "GWPRHOC-01-Mapping"
]
VerificationTest[
  Simplify[GWPJC[c][PAR] - GWPJX[XC0][PAR]] == 0,
  TestID -> "GWPJC-01-Mapping"
]
VerificationTest[
  Simplify[GWPAC[c][PAR] - GWPAX[XC0][PAR]] == 0,
  TestID -> "GWPAC-01-Mapping"
]
VerificationTest[
  Simplify[GWPSC[c][PAR] - GWPSX[XC0][PAR]] == 0,
  TestID -> "GWPSC-01-Mapping"
]
VerificationTest[
  Simplify[GWPVC[c][PAR] - GWPVX[XC0][PAR]] == 0,
  TestID -> "GWPVC-01-Mapping"
]
VerificationTest[
  Simplify[GWPOVC[c][PAR] - GWPOVX[XC0][PAR]] == 0,
  TestID -> "GWPOVC-01-Mapping"
]
VerificationTest[
  Simplify[GWPQSC[c][PAR] - GWPQSX[XC0][PAR]] == 0,
  TestID -> "GWPQSC-01-Mapping"
]
VerificationTest[
  Simplify[GWPQPC[c][PAR] - GWPQPX[XC0][PAR]] == 0,
  TestID -> "GWPQPC-01-Mapping"
]
VerificationTest[
  Simplify[GWPQFC[c][PAR] - GWPQFX[XC0][PAR]] == 0,
  TestID -> "GWPQFC-01-Mapping"
]

(* ---------------------------------------------------------- *)
(* 4. External Potential C-Space Derivatives                  *)
(* ---------------------------------------------------------- *)
VerificationTest[
  Simplify[GWPPEC[c][PAR] - GWPPEX[XC0][PAR]] == 0,
  TestID -> "GWPPEC-01-Mapping"
]
VerificationTest[
  And @@ Table[Simplify[GWPPEC[n][c][PAR] - D[GWPPEC[0][c][PAR], {c, n}]] == 0, {n, 0, 6}],
  TestID -> "GWPPEC-02-Derivatives"
]

(* ---------------------------------------------------------- *)
(* 5. External Force C-Space Derivatives                      *)
(* ---------------------------------------------------------- *)
VerificationTest[
  Simplify[GWPFEC[c][PAR] - GWPFEX[XC0][PAR]] == 0,
  TestID -> "GWPFEC-01-Mapping"
]
VerificationTest[
  And @@ Table[Simplify[GWPFEC[n][c][PAR] - D[GWPFEC[0][c][PAR], {c, n}]] == 0, {n, 0, 6}],
  TestID -> "GWPFEC-02-Derivatives"
]

(* ---------------------------------------------------------- *)
(* 6. Information & Energy Densities in C-Space               *)
(* ---------------------------------------------------------- *)
VerificationTest[
  Simplify[GWPFIC[c][PAR] - GWPFIX[XC0][PAR]] == 0,
  TestID -> "GWPFIC-01-Mapping"
]
VerificationTest[
  Simplify[GWPCKEC[c][PAR] - GWPCKEX[XC0][PAR]] == 0,
  TestID -> "GWPCKEC-01-Mapping"
]
VerificationTest[
  Simplify[GWPIKEC[c][PAR] - GWPIKEX[XC0][PAR]] == 0,
  TestID -> "GWPIKEC-01-Mapping"
]
VerificationTest[
  Simplify[GWPTKEC[c][PAR] - GWPTKEX[XC0][PAR]] == 0,
  TestID -> "GWPTKEC-01-Mapping"
]
VerificationTest[
  Simplify[GWPTPEC[c][PAR] - GWPTPEX[XC0][PAR]] == 0,
  TestID -> "GWPTPEC-01-Mapping"
]
VerificationTest[
  Simplify[GWPTEDC[c][PAR] - GWPTEDX[XC0][PAR]] == 0,
  TestID -> "GWPTEDC-01-Mapping"
]

(* ========================================================== *)
(* CLEANUP: PREVENT NAMESPACE POLLUTION                       *)
(* ========================================================== *)

(* Restore the user's exact original assumptions *)
$Assumptions = $userAssumptions;
Remove[$userAssumptions];

(* Clear dynamically generated strings so MetaInformation renders properly *)
ClearAll["DEF*"];
ClearAll["STR*"];

(* Clear the parameter sequence and trajectory inversion variables *)
ClearAll[PAR, XC0, PC0];

(* Clear the abstract symbolic variables, coordinates, and iterators used in the tests *)
ClearAll[RA, IA, RX, RP, RG, IG, HBAR, MASS, V0, V1, V2, x, p, c, n];

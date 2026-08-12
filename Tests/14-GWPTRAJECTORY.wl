(* ::Package:: *)

Needs["GWPTools`"]

(* ========================================================== *)
(* DEFINITIONS AND CONFIGURATION                              *)
(* ========================================================== *)

(* Save the user's current global assumptions before modifying them *)
$userAssumptions = $Assumptions;

ToExpression[DEF01 = "PAR=GWPPARAM[RA+I*IA,RX+I*IX,RP+I*IP,RG+I*IG,\"HBAR\"->HBAR,\"MASS\"->MASS]"];
(* --- Alternate faster testing sequences --- *)
(* ToExpression[DEF01="PAR=GWPPARAM[RA+I*IA,RX,RP,RG+I*IG,\"HBAR\"->HBAR,\"MASS\"->MASS]"]; *)
(* ToExpression[DEF01="PAR=GWPPARAM[RA,RX,RP,RG,\"HBAR\"->HBAR,\"MASS\"->MASS]"]; *)
(* ToExpression[DEF01="PAR=GWPPARAM[\"HBAR\"->HBAR,\"MASS\"->MASS]"]; *)

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
  Simplify[GWPQPC[c][PAR] - GWPQPX[XC0][PAR]] == 0,
  TestID -> "GWPQPC-01-Mapping"
]
VerificationTest[
  Simplify[GWPQFC[c][PAR] - GWPQFX[XC0][PAR]] == 0,
  TestID -> "GWPQFC-01-Mapping"
]
VerificationTest[
  Simplify[GWPVC[c][PAR] - GWPVX[XC0][PAR]] == 0,
  TestID -> "GWPVC-01-Mapping"
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
ClearAll[RA, IA, RX, IX, RP, IP, RG, IG, HBAR, MASS, x, p, c, n];

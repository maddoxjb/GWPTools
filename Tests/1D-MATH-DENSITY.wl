(* ::Package:: *)

(* ========================================================================= *)
(* TEST SUITE  : GWPTools (Version 1.0.0)                                    *)
(* FILE        : 1D-MATH-DENSITY.wl                                          *)
(* DESCRIPTION : Tests Probabilities section of GWPEngine1D.wl               *)
(* ========================================================================= *)

(* Load the Master Test Environment *)
Needs["GWPTools`GWPDiagnostics`"]

(* ========================================================== *)
(* DEFINITIONS AND CONFIGURATION                              *)
(* ========================================================== *)

(* Save the user's current global assumptions before modifying them *)
$userAssumptions = $Assumptions;

ToExpression[DEF01 = "PAR=GWP1DPARAM[RA+I*IA,RX+I*IX,RP+I*IP,RG+I*IG,\"HBAR\"->HBAR,\"MASS\"->MASS]"];
(* --- Alternate faster testing sequences --- *)
(* ToExpression[DEF01="PAR=GWP1DPARAM[RA+I*IA,RX,RP,RG+I*IG,\"HBAR\"->HBAR,\"MASS\"->MASS]"]; *)
(* ToExpression[DEF01="PAR=GWP1DPARAM[RA,RX,RP,RG,\"HBAR\"->HBAR,\"MASS\"->MASS]"]; *)
(* ToExpression[DEF01="PAR=GWP1DPARAM[\"HBAR\"->HBAR,\"MASS\"->MASS]"]; *)

ToExpression[DEF02 = "$Assumptions=GWP1DASSUMPTIONS[PAR]"];

ToExpression[STR01 = "RHOX0=GWP1DRHOX[x][PAR]"];
ToExpression[STR02 = "RHOP0=GWP1DRHOP[p][PAR]"];
ToExpression[STR03 = "RHOE0=GWP1DRHOE[e][PAR]"];

(* ========================================================== *)
(* PROBABILITY DENSITY VERIFICATION TESTS                     *)
(* ========================================================== *)

(* 1. Definitons tests *)

VerificationTest[True, TestID -> "Definition", MetaInformation -> DEF01]
VerificationTest[True, TestID -> "Definition", MetaInformation -> DEF02]

(* ---------------------------------------------------------- *)
(* 2. Position Space Density                                  *)
(* ---------------------------------------------------------- *)
VerificationTest[
  And @@ Table[Simplify[GWP1DRHOX[n][x][PAR] - D[RHOX0, {x, n}]] == 0, {n, 0, 6}],
  TestID -> "GWP1DRHOX-01-Deriv", MetaInformation -> STR01
]
VerificationTest[
  Simplify[Integrate[RHOX0, {x, -Infinity, Infinity}] - 1] == 0,
  TestID -> "GWP1DRHOX-02-Norm"
]
VerificationTest[
  Simplify[Integrate[x*RHOX0, {x, -Infinity, Infinity}] - (GWP1DRX[PAR])] == 0,
  TestID -> "GWP1DRHOX-03-ExpX"
]

(* ---------------------------------------------------------- *)
(* 3. Momentum Space Density                                  *)
(* ---------------------------------------------------------- *)
VerificationTest[
  And @@ Table[Simplify[GWP1DRHOP[n][p][PAR] - D[RHOP0, {p, n}]] == 0, {n, 0, 6}],
  TestID -> "GWP1DRHOP-01-Deriv", MetaInformation -> STR02
]
VerificationTest[
  Simplify[Integrate[RHOP0, {p, -Infinity, Infinity}] - 1] == 0,
  TestID -> "GWP1DRHOP-02-Norm"
]
VerificationTest[
  Simplify[Integrate[p*RHOP0, {p, -Infinity, Infinity}] - (GWP1DRP[PAR])] == 0,
  TestID -> "GWP1DRHOP-03-ExpP"
]

(* ---------------------------------------------------------- *)
(* 4. Energy Space Density (Branch Cut Validations)           *)
(* ---------------------------------------------------------- *)

(* Temporarily wipe global assumptions to prevent combinatorial explosion *)
$tempAssumptions = $Assumptions;
$Assumptions = True;

VerificationTest[
  Simplify[Integrate[RHOE0, {e, 0, Infinity}, Assumptions -> GWP1DASSUMPTIONS[PAR, "RP2Sign" -> 0]] - 1] == 0,
  TestID -> "GWP1DRHOE-01-Norm", MetaInformation -> STR03
]
VerificationTest[
  Simplify[Integrate[RHOE0, {e, 0, Infinity}, Assumptions -> GWP1DASSUMPTIONS[PAR, "RP2Sign" -> 1]] - 1] == 0,
  TestID -> "GWP1DRHOE-02-Norm"
]
VerificationTest[
  Simplify[Integrate[RHOE0, {e, 0, Infinity}, Assumptions -> GWP1DASSUMPTIONS[PAR, "RP2Sign" -> -1]] - 1] == 0,
  TestID -> "GWP1DRHOE-03-Norm"
]

$Assumptions = $tempAssumptions;

(* ========================================================== *)
(* CLEANUP: PREVENT NAMESPACE POLLUTION                       *)
(* ========================================================== *)

(* Restore the user's exact original assumptions *)
$Assumptions = $userAssumptions;
Remove[$userAssumptions];
Remove[$tempAssumptions];

(* Clear dynamically generated strings so MetaInformation renders properly *)
ClearAll["DEF*"];
ClearAll["STR*"];

(* Clear the parameter sequence and density variables *)
ClearAll[PAR, RHOX0, RHOP0, RHOE0];

(* Clear the abstract symbolic variables, coordinates, and iterators used in the tests *)
ClearAll[RA, IA, RX, IX, RP, IP, RG, IG, HBAR, MASS, x, p, e, n];

(* ::Package:: *)

(* ========================================================================= *)
(* TEST SUITE  : GWPTools (Version 1.0.0)                                    *)
(* FILE        : 1D-MATH-WAVEFUNCTION.wl                                     *)
(* DESCRIPTION : Tests Wavefunctions section of GWPEngine1D.wl               *)
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
ToExpression[STR01 = "PSIX0=GWP1DPSIX[x][PAR]"];
ToExpression[STR02 = "CSIX0=GWP1DCSIX[x][PAR]"];
ToExpression[STR03 = "PSIP0=GWP1DPSIP[p][PAR]"];
ToExpression[STR04 = "CSIP0=GWP1DCSIP[p][PAR]"];

ToExpression[STR05 = "INT1=CSIX0*PSIX0"];
ToExpression[STR06 = "INT2=CSIX0*x*PSIX0"];
ToExpression[STR07 = "INT3=CSIX0*(-I*HBAR*GWP1DPSIX[1][x][PAR])"];
ToExpression[STR08 = "INT4=PSIX0*(I*HBAR*GWP1DCSIX[1][x][PAR])"];

ToExpression[STR09 = "INT5=CSIP0*PSIP0"];
ToExpression[STR10 = "INT6=CSIP0*p*PSIP0"];
ToExpression[STR11 = "INT7=CSIP0*(I*HBAR*GWP1DPSIP[1][p][PAR])"];
ToExpression[STR12 = "INT8=PSIP0*(-I*HBAR*GWP1DCSIP[1][p][PAR])"];

(* ========================================================== *)
(* WAVEFUNCTION VERIFICATION TESTS                            *)
(* ========================================================== *)

(* 1. Definitions tests *)
VerificationTest[True, TestID -> "Definition", MetaInformation -> DEF01]
VerificationTest[True, TestID -> "Definition", MetaInformation -> DEF02]

(* ---------------------------------------------------------- *)
(* 2. Real/Imaginary Cartesian Decomposition                  *)
(* ---------------------------------------------------------- *)
VerificationTest[
  Simplify[TrigToExp[GWP1DRSIX[x][PAR] + I*GWP1DISIX[x][PAR]] - PSIX0] == 0,
  TestID -> "GWP1DPSIX-01-ReIm", MetaInformation -> STR01
]
VerificationTest[
  Simplify[TrigToExp[GWP1DRSIX[x][PAR] - I*GWP1DISIX[x][PAR]] - CSIX0] == 0,
  TestID -> "GWP1DPSIX-02-ReIm", MetaInformation -> STR02
]
VerificationTest[
  Simplify[TrigToExp[GWP1DRSIP[p][PAR] + I*GWP1DISIP[p][PAR]] - PSIP0] == 0,
  TestID -> "GWP1DPSIP-01-ReIm", MetaInformation -> STR03
]
VerificationTest[
  Simplify[TrigToExp[GWP1DRSIP[p][PAR] - I*GWP1DISIP[p][PAR]] - CSIP0] == 0,
  TestID -> "GWP1DPSIP-02-ReIm", MetaInformation -> STR04
]

(* ---------------------------------------------------------- *)
(* 3. Analytical Higher-Order Derivatives                     *)
(* ---------------------------------------------------------- *)
VerificationTest[
  And @@ Table[Simplify[GWP1DPSIX[n][x]@PAR - D[PSIX0, {x, n}]] == 0, {n, 0, 6}],
  TestID -> "GWP1DPSIX-03-Deriv"
]
VerificationTest[
  And @@ Table[Simplify[GWP1DCSIX[n][x]@PAR - D[CSIX0, {x, n}]] == 0, {n, 0, 6}],
  TestID -> "GWP1DPSIX-04-Deriv"
]
VerificationTest[
  And @@ Table[Simplify[GWP1DPSIP[n][p]@PAR - D[PSIP0, {p, n}]] == 0, {n, 0, 6}],
  TestID -> "GWP1DPSIP-03-Deriv"
]
VerificationTest[
  And @@ Table[Simplify[GWP1DCSIP[n][p]@PAR - D[CSIP0, {p, n}]] == 0, {n, 0, 6}],
  TestID -> "GWP1DPSIP-04-Deriv"
]

(* ---------------------------------------------------------- *)
(* 4. Position Space Integration (Hilbert Space Projections)  *)
(* ---------------------------------------------------------- *)
VerificationTest[
  Simplify[Integrate[INT1, {x, -Infinity, Infinity}] - 1] == 0,
  TestID -> "GWP1DPSIX-05-Norm", MetaInformation -> STR05
]
VerificationTest[
  Simplify[Integrate[INT2, {x, -Infinity, Infinity}] - (GWP1DRX@PAR)] == 0,
  TestID -> "GWP1DPSIX-06-ExpX", MetaInformation -> STR06
]
VerificationTest[
  Simplify[Integrate[INT3, {x, -Infinity, Infinity}] - (GWP1DRP@PAR)] == 0,
  TestID -> "GWP1DPSIX-07-ExpP-Std", MetaInformation -> STR07
]
VerificationTest[
  Simplify[Integrate[INT4, {x, -Infinity, Infinity}] - (GWP1DRP@PAR)] == 0,
  TestID -> "GWP1DPSIX-08-ExpP-Herm", MetaInformation -> STR08
]

(* ---------------------------------------------------------- *)
(* 5. Momentum Space Integration (Hilbert Space Projections)  *)
(* ---------------------------------------------------------- *)
VerificationTest[
  Simplify[Integrate[INT5, {p, -Infinity, Infinity}] - 1] == 0,
  TestID -> "GWP1DPSIP-05-Norm", MetaInformation -> STR09
]
VerificationTest[
  Simplify[Integrate[INT6, {p, -Infinity, Infinity}] - (GWP1DRP@PAR)] == 0,
  TestID -> "GWP1DPSIP-06-ExpP", MetaInformation -> STR10
]
VerificationTest[
  Simplify[Integrate[INT7, {p, -Infinity, Infinity}] - (GWP1DRX@PAR)] == 0,
  TestID -> "GWP1DPSIP-07-ExpX-Std", MetaInformation -> STR11
]
VerificationTest[
  Simplify[Integrate[INT8, {p, -Infinity, Infinity}] - (GWP1DRX@PAR)] == 0,
  TestID -> "GWP1DPSIP-08-ExpX-Herm", MetaInformation -> STR12
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

(* Clear the parameter sequence, wavefunction variables, and integrands *)
ClearAll[PAR, PSIX0, CSIX0, PSIP0, CSIP0];
ClearAll["INT*"];

(* Clear the abstract symbolic variables, coordinates, and iterators used in the tests *)
ClearAll[RA, IA, RX, IX, RP, IP, RG, IG, HBAR, MASS, x, p, n];

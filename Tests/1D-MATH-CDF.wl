(* ::Package:: *)

(* ========================================================================= *)
(* TEST SUITE  : GWPTools (Version 1.0.0)                                    *)
(* FILE        : 1D-MATH-CDF.wl                                              *)
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

ToExpression[DEF02 = "$Assumptions=GWP1DASSUMPTIONS[PAR,\"Position\"->x,\"Momentum\"->p,\"Energy\"->e,\"Cumulative\"->c]"];

ToExpression[STR01 = "CX0=GWP1DCX[x][PAR]"];
ToExpression[STR02 = "CP0=GWP1DCP[p][PAR]"];
ToExpression[STR03 = "CE0=GWP1DCE[e][PAR]"];

ToExpression[STR04 = "RHOX0=GWP1DRHOX[x][PAR]"];
ToExpression[STR05 = "RHOP0=GWP1DRHOP[p][PAR]"];
ToExpression[STR06 = "RHOE0=GWP1DRHOE[e][PAR]"];

(* ========================================================== *)
(* CUMULATIVE DISTRIBUTION (CDF) VERIFICATION TESTS           *)
(* ========================================================== *)

(* 1. Definitions tests *)

VerificationTest[True, TestID -> "Definition", MetaInformation -> DEF01]
VerificationTest[True, TestID -> "Definition", MetaInformation -> DEF02]

(* ---------------------------------------------------------- *)
(* 2. Asymptotic Boundary Conditions (Limits)                 *)
(* ---------------------------------------------------------- *)
VerificationTest[
  Limit[CX0, x -> {-Infinity, Infinity}] == {0, 1},
  TestID -> "GWP1DCX-01-Limits", MetaInformation -> STR01
]
VerificationTest[
  Limit[CP0, p -> {-Infinity, Infinity}] == {0, 1},
  TestID -> "GWP1DCP-01-Limits", MetaInformation -> STR02
]
VerificationTest[
  Limit[CE0, e -> {0, Infinity}] == {0, 1},
  TestID -> "GWP1DCE-01-Limits", MetaInformation -> STR03
]

(* ---------------------------------------------------------- *)
(* 3. Fundamental Theorem of Calculus (Derivatives)           *)
(* ---------------------------------------------------------- *)
VerificationTest[
  Simplify[D[CX0, x] - RHOX0] == 0,
  TestID -> "GWP1DCX-02-Deriv", MetaInformation -> STR04
]
VerificationTest[
  Simplify[D[CP0, p] - RHOP0] == 0,
  TestID -> "GWP1DCP-02-Deriv", MetaInformation -> STR05
]
VerificationTest[
  Simplify[D[CE0, e] - RHOE0] == 0,
  TestID -> "GWP1DCE-02-Deriv", MetaInformation -> STR06
]

(* ---------------------------------------------------------- *)
(* 4. Interval Probability Normalization                      *)
(* ---------------------------------------------------------- *)
VerificationTest[
  Simplify[GWP1DPROBX[-Infinity, Infinity]@PAR - 1] == 0,
  TestID -> "GWP1DPROBX-01-Norm"
]
VerificationTest[
  Simplify[GWP1DPROBP[-Infinity, Infinity]@PAR - 1] == 0,
  TestID -> "GWP1DPROBP-01-Norm"
]
VerificationTest[
  Simplify[GWP1DPROBE[0, Infinity]@PAR - 1] == 0,
  TestID -> "GWP1DPROBE-01-Norm"
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

(* Clear the parameter sequence, CDF variables, and density variables *)
ClearAll[PAR, CX0, CP0, CE0, RHOX0, RHOP0, RHOE0];

(* Clear the abstract symbolic variables, coordinates, and cumulative parameters used in the tests *)
ClearAll[RA, IA, RX, IX, RP, IP, RG, IG, HBAR, MASS, x, p, e, c];

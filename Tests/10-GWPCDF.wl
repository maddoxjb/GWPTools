(* ::Package:: *)

(* ========================================================================= *)
(* TEST SUITE  : GWPTools (Version 1.0.0)                                    *)
(* FILE        : 10-GWPCDF.wl                                                *)
(* DESCRIPTION : Tests Probabilities section of GWPDeveloper.wl              *)
(* ========================================================================= *)

(* Load the Master Test Environment *)
Needs["GWPTools`GWPDiagnostics`"]

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

ToExpression[DEF02 = "$Assumptions=GWPASSUMPTIONS[PAR,\"Position\"->x,\"Momentum\"->p,\"Energy\"->e,\"Cumulative\"->c]"];

ToExpression[STR01 = "CX0=GWPCX[x][PAR]"];
ToExpression[STR02 = "CP0=GWPCP[p][PAR]"];
ToExpression[STR03 = "CE0=GWPCE[e][PAR]"];

ToExpression[STR04 = "RHOX0=GWPRHOX[x][PAR]"];
ToExpression[STR05 = "RHOP0=GWPRHOP[p][PAR]"];
ToExpression[STR06 = "RHOE0=GWPRHOE[e][PAR]"];

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
  TestID -> "GWPCX-01-Limits", MetaInformation -> STR01
]
VerificationTest[
  Limit[CP0, p -> {-Infinity, Infinity}] == {0, 1},
  TestID -> "GWPCP-01-Limits", MetaInformation -> STR02
]
VerificationTest[
  Limit[CE0, e -> {0, Infinity}] == {0, 1},
  TestID -> "GWPCE-01-Limits", MetaInformation -> STR03
]

(* ---------------------------------------------------------- *)
(* 3. Fundamental Theorem of Calculus (Derivatives)           *)
(* ---------------------------------------------------------- *)
VerificationTest[
  Simplify[D[CX0, x] - RHOX0] == 0,
  TestID -> "GWPCX-02-Deriv", MetaInformation -> STR04
]
VerificationTest[
  Simplify[D[CP0, p] - RHOP0] == 0,
  TestID -> "GWPCP-02-Deriv", MetaInformation -> STR05
]
VerificationTest[
  Simplify[D[CE0, e] - RHOE0] == 0,
  TestID -> "GWPCE-02-Deriv", MetaInformation -> STR06
]

(* ---------------------------------------------------------- *)
(* 4. Interval Probability Normalization                      *)
(* ---------------------------------------------------------- *)
VerificationTest[
  Simplify[GWPPROBX[-Infinity, Infinity]@PAR - 1] == 0,
  TestID -> "GWPPROBX-01-Norm"
]
VerificationTest[
  Simplify[GWPPROBP[-Infinity, Infinity]@PAR - 1] == 0,
  TestID -> "GWPPROBP-01-Norm"
]
VerificationTest[
  Simplify[GWPPROBE[0, Infinity]@PAR - 1] == 0,
  TestID -> "GWPPROBE-01-Norm"
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

(* ::Package:: *)

(* ========================================================================= *)
(* TEST SUITE  : GWPTools (Version 1.0.0)                                    *)
(* FILE        : 1D-MATH-TD.wl                                               *)
(* DESCRIPTION : Tests time derivatives section of GWPEngine1D.wl            *)
(* ========================================================================= *)

(* Load the Master Test Environment *)
Needs["GWPTools`GWPDiagnostics`"]

(* ========================================================== *)
(* DEFINITIONS AND METADATA STRINGS                           *)
(* ========================================================== *)

ToExpression[DEF01 = "PAR=Sequence[RA,IA,RX,RP,RG,IG,NORM,HBAR,MASS,{V0,V1,V2},INIT]"];

ToExpression[STR01 = "DERIV1=4*HBAR/MASS*RA*IA"];
ToExpression[STR02 = "DERIV2=-2*HBAR/MASS*(RA^2-IA^2)+V2/HBAR"];
ToExpression[STR03 = "DERIV3=RP/MASS"];
ToExpression[STR04 = "DERIV4=-(V1+2*V2*RX)"];
ToExpression[STR05 = "DERIV5=-((HBAR^2*RA)/MASS) + RP^2/(2*MASS) - V0 - RX*V1 - RX^2*V2"];
ToExpression[STR06 = "DERIV6=-HBAR^2/MASS*IA"];

ToExpression[STR07 = "PEXEQ = V0 + V1*x + V2*x^2"];
ToExpression[STR08 = "FEXEQ = -V1 - 2*V2*x"];

(* ========================================================== *)
(* TIME DERIVATIVE (TD) VERIFICATION TESTS                    *)
(* ========================================================== *)

VerificationTest[True, TestID -> "Definition", MetaInformation -> DEF01]

VerificationTest[
  GWP1DRATD@PAR == DERIV1, 
  TestID -> "GWP1DTD-01-RA", MetaInformation -> STR01
]

VerificationTest[
  GWP1DIATD@PAR == DERIV2, 
  TestID -> "GWP1DTD-02-IA", MetaInformation -> STR02
]

VerificationTest[
  GWP1DRXTD@PAR == DERIV3, 
  TestID -> "GWP1DTD-03-RX", MetaInformation -> STR03
]

VerificationTest[
  GWP1DRPTD@PAR == DERIV4, 
  TestID -> "GWP1DTD-04-RP", MetaInformation -> STR04
]

VerificationTest[
  GWP1DRGTD@PAR == DERIV5, 
  TestID -> "GWP1DTD-05-RG", MetaInformation -> STR05
]

VerificationTest[
  GWP1DIGTD@PAR == DERIV6, 
  TestID -> "GWP1DTD-06-IG", MetaInformation -> STR06
]

(* ========================================================== *)
(* EXTERNAL POTENTIAL AND FORCE VERIFICATION TESTS            *)
(* ========================================================== *)

(* ---------------------------------------------------------- *)
(* 1. External Potential Energy                               *)
(* ---------------------------------------------------------- *)
VerificationTest[
  Simplify[GWP1DPEX[x][PAR] - PEXEQ] == 0,
  TestID -> "GWP1DPEX-01-Definition", MetaInformation -> STR07
]
VerificationTest[
  And @@ Table[Simplify[GWP1DPEX[n][x][PAR] - D[PEXEQ, {x, n}]] == 0, {n, 0, 4}],
  TestID -> "GWP1DPEX-02-Derivatives"
]

(* ---------------------------------------------------------- *)
(* 2. External Force                                          *)
(* ---------------------------------------------------------- *)
VerificationTest[
  Simplify[GWP1DFEX[x][PAR] - FEXEQ] == 0,
  TestID -> "GWP1DFEX-01-Definition", MetaInformation -> STR08
]
VerificationTest[
  And @@ Table[Simplify[GWP1DFEX[n][x][PAR] - D[FEXEQ, {x, n}]] == 0, {n, 0, 4}],
  TestID -> "GWP1DFEX-02-Derivatives"
]
VerificationTest[
  And @@ Table[Simplify[GWP1DFEX[n][x][PAR] + GWP1DPEX[n + 1][x][PAR]] == 0, {n, 0, 4}],
  TestID -> "GWP1DFEX-03-Relationship"
]

(* ========================================================== *)
(* CLEANUP: PREVENT NAMESPACE POLLUTION                       *)
(* ========================================================== *)

(* Clear dynamically generated strings so MetaInformation renders properly *)
ClearAll["DEF*"];
ClearAll["STR*"];

(* Clear the constructed parameter sequence and expected equations *)
ClearAll[PAR, PEXEQ, FEXEQ];
ClearAll["DERIV*"];

(* Clear the abstract symbolic variables and iterators used in the tests *)
ClearAll[RA, IA, RX, RP, RG, IG, NORM, HBAR, MASS, V0, V1, V2, INIT, x, n];

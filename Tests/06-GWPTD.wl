(* ::Package:: *)

(* ========================================================================= *)
(* TEST SUITE  : GWPTools (Version 1.0.0)                                    *)
(* FILE        : 06-GWPTD.wl                                                 *)
(* DESCRIPTION : Tests Potential Models section of GWPDeveloper.wl           *)
(* ========================================================================= *)

(* Load the underlying developer math engine for raw testing *)
Needs["GWPTools`GWPDeveloper`"]

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
  GWPRATD@PAR == DERIV1, 
  TestID -> "GWPTD-01-RA", MetaInformation -> STR01
]

VerificationTest[
  GWPIATD@PAR == DERIV2, 
  TestID -> "GWPTD-02-IA", MetaInformation -> STR02
]

VerificationTest[
  GWPRXTD@PAR == DERIV3, 
  TestID -> "GWPTD-03-RX", MetaInformation -> STR03
]

VerificationTest[
  GWPRPTD@PAR == DERIV4, 
  TestID -> "GWPTD-04-RP", MetaInformation -> STR04
]

VerificationTest[
  GWPRGTD@PAR == DERIV5, 
  TestID -> "GWPTD-05-RG", MetaInformation -> STR05
]

VerificationTest[
  GWPIGTD@PAR == DERIV6, 
  TestID -> "GWPTD-06-IG", MetaInformation -> STR06
]

(* ========================================================== *)
(* EXTERNAL POTENTIAL AND FORCE VERIFICATION TESTS            *)
(* ========================================================== *)

(* ---------------------------------------------------------- *)
(* 1. External Potential Energy                               *)
(* ---------------------------------------------------------- *)
VerificationTest[
  Simplify[GWPPEX[x][PAR] - PEXEQ] == 0,
  TestID -> "GWPPEX-01-Definition", MetaInformation -> STR07
]
VerificationTest[
  And @@ Table[Simplify[GWPPEX[n][x][PAR] - D[PEXEQ, {x, n}]] == 0, {n, 0, 4}],
  TestID -> "GWPPEX-02-Derivatives"
]

(* ---------------------------------------------------------- *)
(* 2. External Force                                          *)
(* ---------------------------------------------------------- *)
VerificationTest[
  Simplify[GWPFEX[x][PAR] - FEXEQ] == 0,
  TestID -> "GWPFEX-01-Definition", MetaInformation -> STR08
]
VerificationTest[
  And @@ Table[Simplify[GWPFEX[n][x][PAR] - D[FEXEQ, {x, n}]] == 0, {n, 0, 4}],
  TestID -> "GWPFEX-02-Derivatives"
]
VerificationTest[
  And @@ Table[Simplify[GWPFEX[n][x][PAR] + GWPPEX[n + 1][x][PAR]] == 0, {n, 0, 4}],
  TestID -> "GWPFEX-03-Relationship"
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

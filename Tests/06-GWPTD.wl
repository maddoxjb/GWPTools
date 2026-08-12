(* ::Package:: *)

Needs["GWPTools`"]

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
(* CLEANUP: PREVENT NAMESPACE POLLUTION                       *)
(* ========================================================== *)

(* Clear dynamically generated strings so MetaInformation renders properly *)
ClearAll["DEF*"];
ClearAll["STR*"];

(* Clear the constructed parameter sequence and expected derivative outcomes *)
ClearAll[PAR];
ClearAll["DERIV*"];

(* Clear the abstract symbolic variables used in the time derivative tests *)
ClearAll[RA, IA, RX, RP, RG, IG, NORM, HBAR, MASS, V0, V1, V2, INIT];

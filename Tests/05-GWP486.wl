(* ::Package:: *)

Needs["GWPTools`"]

(* ========================================================== *)
(* DEFINITIONS AND METADATA STRINGS                           *)
(* ========================================================== *)

ToExpression[DEF01 = "ARG=Sequence[RA1+I*IA1,RX1+I*IX1,RP1+I*IP1,RG1+I*IG1,HBAR,MASS]"];

ToExpression[STR01 = "RX2=-1/2*(IP1+2*HBAR*IA1*IX1)/(HBAR*RA1)+RX1"];
ToExpression[STR02 = "RP2=(IA1*(IP1+2*HBAR*IA1*IX1))/RA1+2*HBAR*IX1*RA1+RP1"];
ToExpression[STR03 = "RG2=-1/4*(4*HBAR*IA1^2*IP1*IX1+4*HBAR^2*IA1^3*IX1^2+2*RA1*(-2*HBAR*RA1*RG1+IP1*RP1)+IA1*(IP1^2+4*HBAR*IX1*RA1*(HBAR*IX1*RA1+RP1)))/(HBAR*RA1^2)"];
ToExpression[STR04 = "IG2=-1/4*(IP1^2+4*HBAR*IA1*IP1*IX1+4*HBAR*(-(IG1*RA1)+HBAR*IX1^2*(IA1^2+RA1^2)+IX1*RA1*RP1))/(HBAR*RA1)"];
ToExpression[STR05 = "NORM2=((2/Pi)^(1/4)*RA1^(1/4))/E^((IP1^2+4*HBAR*IA1*IP1*IX1+4*HBAR*(-(IG1*RA1)+HBAR*IX1^2*(IA1^2+RA1^2)+IX1*RA1*RP1))/(4*HBAR^2*RA1))"];
ToExpression[STR06 = "PE={0,0,0}"];
ToExpression[STR07 = "INITVAR={RA1,IA1,RX1,IX1,RP1,IP1,RG1,IG1}"];

(* ========================================================== *)
(* GWP486 CORE ENGINE VERIFICATION TESTS                      *)
(* ========================================================== *)

VerificationTest[True, TestID -> "Definition", MetaInformation -> DEF01]

VerificationTest[GWPRA@GWP486[ARG] == RA1, TestID -> "GWP486-01-RA2"]
VerificationTest[GWPIA@GWP486[ARG] == IA1, TestID -> "GWP486-02-IA2"]

VerificationTest[
  Simplify[GWPRX@GWP486[ARG] - RX2] == 0, 
  TestID -> "GWP486-03-RX2", MetaInformation -> STR01
]

VerificationTest[
  Simplify[GWPRP@GWP486[ARG] - RP2] == 0, 
  TestID -> "GWP486-04-RP2", MetaInformation -> STR02
]

VerificationTest[
  Simplify[GWPRG@GWP486[ARG] - RG2] == 0, 
  TestID -> "GWP486-05-RG2", MetaInformation -> STR03
]

VerificationTest[
  Simplify[GWPIG@GWP486[ARG] - IG2] == 0, 
  TestID -> "GWP486-06-IG2", MetaInformation -> STR04
]

VerificationTest[
  Simplify[GWPNORM@GWP486[ARG] - NORM2] == 0, 
  TestID -> "GWP486-07-NORM", MetaInformation -> STR05
]

(* Completeness and Persistence Tests *)
VerificationTest[GWPHBAR@GWP486[ARG] == HBAR, TestID -> "GWP486-08-HBAR"]
VerificationTest[GWPMASS@GWP486[ARG] == MASS, TestID -> "GWP486-09-MASS"]

VerificationTest[
  GWPPECOEFF@GWP486[ARG] == PE, 
  TestID -> "GWP486-10-PECOEFF", MetaInformation -> STR06
]

VerificationTest[
  GWPINIT@GWP486[ARG] == INITVAR, 
  TestID -> "GWP486-11-INIT", MetaInformation -> STR07
]

(* ========================================================== *)
(* CLEANUP: PREVENT NAMESPACE POLLUTION                       *)
(* ========================================================== *)

(* Clear dynamically generated strings so MetaInformation renders properly *)
ClearAll["DEF*"];
ClearAll["STR*"];

(* Clear the constructed parameter sequences and expected outcome variables *)
ClearAll[ARG, RX2, RP2, RG2, IG2, NORM2, PE, INITVAR];

(* Clear the abstract symbolic variables used in the engine tests *)
ClearAll[RA1, IA1, RX1, IX1, RP1, IP1, RG1, IG1, HBAR, MASS];

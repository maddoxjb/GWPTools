(* ::Package:: *)

Needs["GWPTools`"]

(* Define the generic parameter sequence string and evaluate it *)
ToExpression[STR1 = "PARAM=Sequence[RA,IA,RX,RP,RG,IG,NORM,HBAR,MASS,{V0,V1,V2},INIT]"];

(* ========================================================== *)
(* EXTRACTION UTILITY VERIFICATION TESTS                      *)
(* ========================================================== *)

(* Dummy test to cleanly inject STR1 into the test report metadata *)
VerificationTest[
  True, 
  TestID -> "Definition", 
  MetaInformation -> STR1
]

VerificationTest[
  GWPRA@PARAM == RA, 
  TestID -> "GWPEXTRACT-01-RA"
]

VerificationTest[
  GWPIA@PARAM == IA, 
  TestID -> "GWPEXTRACT-02-IA"
]

VerificationTest[
  GWPRX@PARAM == RX, 
  TestID -> "GWPEXTRACT-03-RX"
]

VerificationTest[
  GWPRP@PARAM == RP, 
  TestID -> "GWPEXTRACT-04-RP"
]

VerificationTest[
  GWPRG@PARAM == RG, 
  TestID -> "GWPEXTRACT-05-RG"
]

VerificationTest[
  GWPIG@PARAM == IG, 
  TestID -> "GWPEXTRACT-06-IG"
]

VerificationTest[
  GWPNORM@PARAM == NORM, 
  TestID -> "GWPEXTRACT-07-NORM"
]

VerificationTest[
  GWPHBAR@PARAM == HBAR, 
  TestID -> "GWPEXTRACT-08-HBAR"
]

VerificationTest[
  GWPMASS@PARAM == MASS, 
  TestID -> "GWPEXTRACT-09-MASS"
]

VerificationTest[
  GWPPECOEFF@PARAM == {V0, V1, V2}, 
  TestID -> "GWPEXTRACT-10-PECOEFF"
]

VerificationTest[
  GWPINIT@PARAM == INIT, 
  TestID -> "GWPEXTRACT-11-INIT"
]

(* ========================================================== *)
(* CLEANUP: PREVENT NAMESPACE POLLUTION                       *)
(* ========================================================== *)

(* Clear dynamically generated strings so MetaInformation renders properly *)
ClearAll["STR*"];

(* Clear the abstract symbolic variables and parameter sequence used in the tests *)
ClearAll[PARAM, RA, IA, RX, RP, RG, IG, NORM, HBAR, MASS, V0, V1, V2, INIT];

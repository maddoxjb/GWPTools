(* ::Package:: *)

(* ========================================================================= *)
(* TEST SUITE  : GWPTools (Version 1.0.0)                                    *)
(* FILE        : 1D-MATH-EXTRACT.wl                                          *)
(* DESCRIPTION : Tests Parameters section of GWPEngine1D.wl                  *)
(* ========================================================================= *)

(* Load the Master Test Environment *)
Needs["GWPTools`GWPDiagnostics`"]

(* ========================================================== *)
(* DEFINITIONS AND METADATA STRINGS                           *)
(* ========================================================== *)

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
  GWP1DRA@PARAM == RA, 
  TestID -> "GWP1DEXTRACT-01-RA"
]

VerificationTest[
  GWP1DIA@PARAM == IA, 
  TestID -> "GWP1DEXTRACT-02-IA"
]

VerificationTest[
  GWP1DRX@PARAM == RX, 
  TestID -> "GWP1DEXTRACT-03-RX"
]

VerificationTest[
  GWP1DRP@PARAM == RP, 
  TestID -> "GWP1DEXTRACT-04-RP"
]

VerificationTest[
  GWP1DRG@PARAM == RG, 
  TestID -> "GWP1DEXTRACT-05-RG"
]

VerificationTest[
  GWP1DIG@PARAM == IG, 
  TestID -> "GWP1DEXTRACT-06-IG"
]

VerificationTest[
  GWP1DNORM@PARAM == NORM, 
  TestID -> "GWP1DEXTRACT-07-NORM"
]

VerificationTest[
  GWP1DHBAR@PARAM == HBAR, 
  TestID -> "GWP1DEXTRACT-08-HBAR"
]

VerificationTest[
  GWP1DMASS@PARAM == MASS, 
  TestID -> "GWP1DEXTRACT-09-MASS"
]

VerificationTest[
  GWP1DPECOEFF@PARAM == {V0, V1, V2}, 
  TestID -> "GWP1DEXTRACT-10-PECOEFF"
]

VerificationTest[
  GWP1DINPUT@PARAM == INIT, 
  TestID -> "GWP1DEXTRACT-11-INPUT"
]

VerificationTest[
  GWP1DINIT@PARAM == {RA, IA, RX, RP, RG, IG},
  TestID -> "GWP1DEXTRACT-12-INIT"
]

(* ========================================================== *)
(* CLEANUP: PREVENT NAMESPACE POLLUTION                       *)
(* ========================================================== *)

(* Clear dynamically generated strings so MetaInformation renders properly *)
ClearAll["STR*"];

(* Clear the abstract symbolic variables and parameter sequence used in the tests *)
ClearAll[PARAM, RA, IA, RX, RP, RG, IG, NORM, HBAR, MASS, V0, V1, V2, INIT];

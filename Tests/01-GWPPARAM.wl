(* ::Package:: *)

(* ========================================================================= *)
(* TEST SUITE  : GWPTools (Version 1.0.0)                                    *)
(* FILE        : 01-GWPAPARAM.wl                                             *)
(* DESCRIPTION : Tests Parameters section of GWPDeveloper.wl                 *)
(* ========================================================================= *)

(* Load the Master Test Environment *)
Needs["GWPTools`GWPDiagnostics`"]

(* ========================================================== *)
(* DEFINITIONS AND METADATA STRINGS                           *)
(* ========================================================== *)

(* Store the function's definitions in a temporary variable and clear it *)
storedGWP486 = DownValues[GWP486];
Clear[GWP486];

(* Define sequence strings for MetaInformation and evaluate them *)
ToExpression[STR1 = "OPT=Sequence[\"HBAR\"->HBAR,\"MASS\"->MASS]"];
ToExpression[STR2 = "ARG0=Sequence[ ]"];
ToExpression[STR3 = "ARG1=Sequence[AA]"];
ToExpression[STR4 = "ARG2=Sequence[AA,XX]"];
ToExpression[STR5 = "ARG3=Sequence[AA,XX,PP]"];
ToExpression[STR6 = "ARG4=Sequence[AA,XX,PP,GG]"];

(* ========================================================== *)
(* VERIFICATION TESTS                                         *)
(* ========================================================== *)

VerificationTest[
  GWPPARAM[ARG0] == GWP486[1/4, 0, 0, 0, 1, 1], 
  TestID -> "GWPPARAM-01-Default", 
  MetaInformation -> STR2
]

VerificationTest[
  GWPPARAM[ARG1] == GWP486[ARG1, 0, 0, 0, 1, 1], 
  TestID -> "GWPPARAM-02-A", 
  MetaInformation -> STR3
]

VerificationTest[
  GWPPARAM[ARG2] == GWP486[ARG2, 0, 0, 1, 1], 
  TestID -> "GWPPARAM-03-AX", 
  MetaInformation -> STR4
]

VerificationTest[
  GWPPARAM[ARG3] == GWP486[ARG3, 0, 1, 1], 
  TestID -> "GWPPARAM-04-AXP", 
  MetaInformation -> STR5
]

VerificationTest[
  GWPPARAM[ARG4] == GWP486[ARG4, 1, 1], 
  TestID -> "GWPPARAM-05-AXPG", 
  MetaInformation -> STR6
]

(* Dummy test to inject STR1 into the test report metadata cleanly *)
VerificationTest[
  True, 
  TestID -> "Definition", 
  MetaInformation -> STR1
]

VerificationTest[
  GWPPARAM[ARG0, OPT] == GWP486[1/4, 0, 0, 0, HBAR, MASS], 
  TestID -> "GWPPARAM-06-Default-Opts"
]

VerificationTest[
  GWPPARAM[ARG1, OPT] == GWP486[ARG1, 0, 0, 0, HBAR, MASS], 
  TestID -> "GWPPARAM-07-A-Opts"
]

VerificationTest[
  GWPPARAM[ARG2, OPT] == GWP486[ARG2, 0, 0, HBAR, MASS], 
  TestID -> "GWPPARAM-08-AX-Opts"
]

VerificationTest[
  GWPPARAM[ARG3, OPT] == GWP486[ARG3, 0, HBAR, MASS], 
  TestID -> "GWPPARAM-09-AXP-Opts"
]

VerificationTest[
  GWPPARAM[ARG4, OPT] == GWP486[ARG4, HBAR, MASS], 
  TestID -> "GWPPARAM-10-AXPG-Opts"
]

VerificationTest[
  GWPPARAM[ARG0, "HBAR" -> {1, 2}] === $Failed, 
  True, 
  {GWPPARAM::posval},
  TestID -> "GWPPARAM-11-HBAR-List-Fail"
]

VerificationTest[
  GWPPARAM[ARG0, "MASS" -> {1, 2}] === $Failed, 
  True, 
  {GWPPARAM::posval},
  TestID -> "GWPPARAM-12-MASS-List-Fail"
]


(* ========================================================== *)
(* CLEANUP: PREVENT NAMESPACE POLLUTION (Snapshot Revert)     *)
(* ========================================================== *)

(* Put the definitions back! *)
DownValues[GWP486] = storedGWP486;
(* Remove the temporary storage variable completely *)
Remove[storedGWP486];

(* Clear the values of dynamically generated strings and options *)
ClearAll["STR*"];
ClearAll["ARG*"];
ClearAll[OPT];

(* Clear the abstract symbolic variables used in the tests *)
ClearAll[AA, XX, PP, GG, HBAR, MASS];

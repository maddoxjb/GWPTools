(* ::Package:: *)

Needs["GWPTools`"]

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

(* Put the definitions back! *)
DownValues[GWP486] = storedGWP486;

(* ========================================================== *)
(* CLEANUP: PREVENT NAMESPACE POLLUTION                       *)
(* ========================================================== *)

(* Remove the temporary storage variable completely *)
Remove[storedGWP486];

(* Clear the values of dynamically generated strings and options, 
   but leave the symbol names intact so TestReport can display them. *)
ClearAll["STR*"];
ClearAll["ARG*"];
ClearAll[OPT];

(* Clear the abstract symbolic variables used in the tests *)
ClearAll[AA, XX, PP, GG, HBAR, MASS];

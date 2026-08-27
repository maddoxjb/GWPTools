(* ::Package:: *)

(* ========================================================================= *)
(* TEST SUITE  : GWPTools (Version 1.0.0)                                    *)
(* FILE        : 15-GWPOBJECT-INTERFACE.wl                                   *)
(* DESCRIPTION : Tests GWP and GWPObject interface                           *)
(* ========================================================================= *)

(* Load the Master Test Environment *)
Needs["GWPTools`GWPDiagnostics`"]

(* ========================================================== *)
(* 1. MANUAL VERIFICATION TESTS: STATE & CONSTRUCTOR          *)
(* ========================================================== *)

(* Instantiate a generic default object via string for metadata injection *)
ToExpression[DEF01 = "OBJ=GWP[]"];
ToExpression[DEF02 = "DEFPOT = None"];
ToExpression[DEF03 = "DEFSUM = OptionValue[GWP, \"Summary\"]"];

VerificationTest[True, TestID -> "Definition", MetaInformation -> DEF01]
VerificationTest[True, TestID -> "Definition", MetaInformation -> DEF02]
VerificationTest[True, TestID -> "Definition", MetaInformation -> DEF03]

VerificationTest[Head[OBJ] === GWPObject, TestID -> "GWPOBJ-01-Constructor"]

(* Check Tier-2 Metadata Extraction (Dynamically referencing Option defaults) *)
VerificationTest[Head[OBJ@"Created"] === DateObject, TestID -> "GWPOBJ-02-CreatedDate"]
VerificationTest[OBJ@"Potential" === DEFPOT, TestID -> "GWPOBJ-03-DefaultSystemExtraction"]
VerificationTest[OBJ["Parameters"] === {GWPPARAM[]}, TestID -> "GWPOBJ-04-ParameterExtraction"]
VerificationTest[OBJ["Summary"] === DEFSUM, TestID -> "GWPOBJ-05-SummaryExtraction"]

(* ========================================================== *)
(* 2. TIER-1 INTROSPECTION & PARITY TESTS                     *)
(* ========================================================== *)

(* 1. Introspection Dictionaries *)
VerificationTest[Head[OBJ["PropertyInformation"]], Association, TestID -> "GWPOBJ-06-PropertyInfo"]
VerificationTest[Head[OBJ["ClassInformation"]], Association, TestID -> "GWPOBJ-07-ClassInfo"]
VerificationTest[Head[OBJ["PropertyRules"]], Association, TestID -> "GWPOBJ-08-PropertyRules"]
VerificationTest[Head[OBJ["Signatures"]], Association, TestID -> "GWPOBJ-09-Signatures"]

(* 2. GWP vs GWPObject Parity (Ignoring dynamic state keys like "Created") *)
(* 2. GWP vs GWPObject Parity (Dynamic State Exclusion) *)
VerificationTest[
  ContainsAll[OBJ["Properties"], GWP["Properties"]], 
  True, 
  TestID -> "GWPOBJ-10A-PropertiesInclusion"
]

VerificationTest[
  Complement[OBJ["Properties"], GWP["Properties"]], 
  Sort[Keys[OBJ[[1]]]], 
  TestID -> "GWPOBJ-10B-PropertiesDifference"
]

VerificationTest[OBJ["Classes"] === GWP["Classes"], True, TestID -> "GWPOBJ-11-ClassesParity"]
VerificationTest[OBJ["StructureClasses"] === GWP["StructureClasses"], True, TestID -> "GWPOBJ-12-StructureClassesParity"]
VerificationTest[OBJ["ShortKeys"] === GWP["ShortKeys"], True, TestID -> "GWPOBJ-13-ShortKeysParity"]

(* 3. Programmatic System Discoverability (Dynamic mapping to private variables) *)
ToExpression[STR1 = "EXPECTEDNAMES = Sort[Keys[GWPTools`Private`$GWPPotentialNames]]"];
ToExpression[STR2 = "EXPECTEDMODELS = GWPTools`Private`$GWPPotentialModels"];
VerificationTest[True, TestID -> "Definition", MetaInformation -> STR1]
VerificationTest[True, TestID -> "Definition", MetaInformation -> STR2]

VerificationTest[
  Sort[OBJ["PotentialNames"]], 
  EXPECTEDNAMES, 
  TestID -> "GWPOBJ-14-PotentialNamesDiscovery"
]
VerificationTest[
  OBJ["PotentialModels"], 
  EXPECTEDMODELS, 
  TestID -> "GWPOBJ-14B-PotentialModelsDiscovery"
]

(* ========================================================== *)
(* 3. EXHAUSTIVE ROUTING TESTS                                *)
(* ========================================================== *)

ToExpression[STR0="CLASS = OBJ[\"Classes\"]"];
VerificationTest[True, TestID -> "Definition", MetaInformation -> STR0];

(* Exhaustive Class Routing (Unrolled with MetaInformation and explicit ===) *)
Scan[
  Function[{cls},
    Module[{expectedSubList, testID, STR},
      (* Ask the ClassInformation dictionary for the expected short keys *)
      expectedSubList = Sort[OBJ["ClassInformation"][cls]["ShortKeys"]];
      testID = "GWPOBJ-15-ClassRouting-" <> StringReplace[cls, " " -> ""];
      
      (* Stringify the expected list using InputForm to preserve quotation marks *)
      STR = "EXPECTED = " <> ToString[expectedSubList, InputForm];
      Quiet[ToExpression[STR]];
      
      With[{c = cls},
        VerificationTest[
          OBJ["ShortKeys", c] === EXPECTED, 
          True,
          TestID -> testID,
          MetaInformation -> STR
        ]
      ]
    ]
  ],
  CLASS
];

(* ========================================================== *)
(* 4. FALLBACK & ERROR HANDLING TESTS                         *)
(* ========================================================== *)

(* 1. GWPObject missing property fallback *)
VerificationTest[
  OBJ["NonExistentPropertyTesting123"], 
  $Failed, 
  {GWPObject::invalidprop}, 
  TestID -> "GWPOBJ-16-InvalidPropFallback"
]

(* 2. GWP 1-Argument query fallback *)
VerificationTest[
  GWP["NonExistentQuery"], 
  $Failed, 
  {GWP::invalidquery}, 
  TestID -> "GWPOBJ-17-InvalidQueryFallback"
]

(* 3. GWPObject 2-Argument query fallback *)
VerificationTest[
  OBJ["PropertyInformation", "NonExistentKey"], 
  $Failed, 
  {GWP::badquery}, 
  TestID -> "GWPOBJ-18-BadArgQueryFallback"
]

(* ========================================================== *)
(* CLEANUP: PREVENT NAMESPACE POLLUTION                       *)
(* ========================================================== *)

(* Clear dynamically generated strings so MetaInformation renders properly *)
ClearAll["DEF*"];
ClearAll["STR*"];

(* Clear the global test object and dynamically assigned variables *)
ClearAll[OBJ, CLASS, EXPECTED, DEFPOT, DEFSUM, EXPECTEDNAMES, EXPECTEDMODELS];

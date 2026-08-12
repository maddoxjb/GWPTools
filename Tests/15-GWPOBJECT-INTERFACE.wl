(* ::Package:: *)

(* ::Package:: *)
(**)


Needs["GWPTools`"]

(* ========================================================== *)
(* 1. MANUAL VERIFICATION TESTS: STATE & CONSTRUCTOR          *)
(* ========================================================== *)

(* Instantiate a generic default object via string for metadata injection *)
ToExpression[DEF01 = "OBJ=GWP[]"];
VerificationTest[True, TestID -> "Definition", MetaInformation -> DEF01]
VerificationTest[Head[OBJ] === GWPObject, TestID -> "GWPOBJ-01-Constructor"]
VerificationTest[Head[OBJ@"Created"] === DateObject, TestID -> "GWPOBJ-02-CreatedDate"]
VerificationTest[OBJ@"System" === LINEAR[0], TestID -> "GWPOBJ-03-DefaultSystemExtraction"]
VerificationTest[{OBJ["Parameters"]} === {GWPPARAM[]}, TestID -> "GWPOBJ-04-ParameterExtraction"]

(* Intercept the internal package registry for dynamic testing *)
ToExpression[STR0="REG = GWPTools`Private`$GWPRegistry"];

(* ========================================================== *)
(* 1.5. EXHAUSTIVE INTERFACE & ROUTING TESTS                  *)
(* ========================================================== *)

(* Extract LongNames (Col 1) to match the user-facing interface *)
ToExpression[STR1="PROPS = REG[[All, 1]]"];
(* FIX 1: Changed reg to REG *)
ToExpression[STR2="CLASS = Union[Join[REG[[All, 3]], REG[[All, 4]]]]"];

VerificationTest[True,TestID->"Definition",MetaInformation->STR0];
VerificationTest[True,TestID->"Definition",MetaInformation->STR1];
VerificationTest[True,TestID->"Definition",MetaInformation->STR2];

(* 1. Exhaustive Properties List *)
VerificationTest[
  ContainsAll[OBJ["Properties"], PROPS] === True, 
  True, 
  TestID -> "GWPOBJ-05-ExhaustiveProperties"
]

(* 2. Exhaustive Classes List *)
VerificationTest[
  ContainsAll[OBJ["PropertyClasses"], CLASS] === True, 
  True, 
  TestID -> "GWPOBJ-06-ExhaustiveClasses"
]

(* 3. Exhaustive Class Routing (Unrolled with MetaInformation and explicit ===) *)
Scan[
  Function[{cls},
    Module[{expectedSubList, testID, STR},
      (* Extract the exact sorted list of LongNames for this class *)
      expectedSubList = Sort[Select[REG, #[[3]] === cls || #[[4]] === cls &][[All, 1]]];
      testID = "GWPOBJ-07-ClassRouting-" <> cls;
      
      (* Stringify the expected list using InputForm to preserve quotation marks *)
      STR = "EXPECTED = " <> ToString[expectedSubList, InputForm];
      Quiet[ToExpression[STR]];
      
      With[{c = cls},
        VerificationTest[
          OBJ[c] === EXPECTED, 
          True,
          TestID -> testID,
          MetaInformation -> STR
        ]
      ]
    ]
  ],
  CLASS (* FIX 2: Changed from expectedClasses to CLASS *)
];

(* 3.5. Programmatic System Discoverability *)
VerificationTest[
  Keys[GWP["Systems"]], 
  {"NamedSystems", "SystemFunctions"}, 
  TestID -> "GWPOBJ-07B-SystemDiscovery"
]

(* 4. Fallback Hierarchy (Requires standard 3-argument signature to catch the Message) *)
VerificationTest[
  OBJ["NonExistentPropertyTesting123"], 
  $Failed, 
  {GWPObject::invalidprop}, 
  TestID -> "GWPOBJ-08-InvalidPropFallback"
]

(* ========================================================== *)
(* CLEANUP: PREVENT NAMESPACE POLLUTION                       *)
(* ========================================================== *)

(* Clear dynamically generated strings so MetaInformation renders properly *)
ClearAll["DEF*"];
ClearAll["STR*"];

(* Clear the global test object and dynamically assigned registry variables *)
ClearAll[OBJ, REG, PROPS, CLASS, EXPECTED];

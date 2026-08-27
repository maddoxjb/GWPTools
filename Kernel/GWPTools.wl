(* ::Package:: *)

(* ::Title:: *)
(*GWPTools Package*)


(* ::Section::Closed:: *)
(*BeginPackage*)


(* ========================================================================= *)
(* PACKAGE     : GWPTools`                                                   *)
(* VERSION     : 1.0.0                                                       *)
(* AUTHOR      : Jeremy B. Maddox                                            *)
(* COPYRIGHT   : (c) 2026 Jeremy B. Maddox                                   *)
(* LICENSE     : MIT License (See LICENSE file in root directory)            *)
(* REPOSITORY  : https://github.com/maddoxjb/GWPTools                        *)
(* CITATION    : If you use this software, please cite the companion paper:  *)
(*               [Citation details to be added]                              *)
(* DESCRIPTION : An advanced analytical framework for generalized single     *)
(*               Gaussian Wavepackets (GWPs).                                *)
(*               This is the main Object-Oriented user API and dynamic       *)
(*               dispatcher for the GWPTools framework.                      *)
(* ========================================================================= *)

BeginPackage["GWPTools`"]


(* ::Section::Closed:: *)
(*Usage Statements*)


(* --- GWP and GWPObject Usage Statements --- *)
GWP::usage = "GWP[...] returns a GWPObject representing a generalized Gaussian wavepacket.";

GWPObject::usage = "GWPObject[...] represents a generalized Gaussian wavepacket obtained by GWP."


(* ::Section::Closed:: *)
(*Private*)


Begin["`Private`"]


(* --- Dispatcher Flag --- *)
$DispatcherActive = True;

(* --- Initialize Core Registries --- *)
$GWPRegistry = {};


(* ::Section:: *)
(*Dynamic Registry*)


(* --- Initialize Core Registries --- *)
$GWPRegistry = {};
$GWPPotentialModels = {};
$GWPPotentialNames = <||>;
$GWPPotentialHeads = <||>;
$GWPPotentialSignatures = {};

(* --- Signatures Registry --- *)
$GWPSignatures = <|
  "Static"      -> "f[params]",
  "Temporal"    -> "f[params] -> Function[t]",
  "Field"       -> "f[var][params] -> Function[{var, t}]",
  "Recursive"   -> "f[n][var][params] -> Function[{var, t}]",
  "Moment"      -> "f[n][params] -> Function[t]",
  "CrossMoment" -> "f[m, n][params] -> Function[t]",
  "Bivariate"   -> "f[v1, v2][params] -> Function[{v1, v2, t}]"
|>;

(* --- Property Extension Receiver --- *)
GWPRegisterExtension[registryChunk_] := Module[{},
  $GWPRegistry = DeleteDuplicates @ Join[$GWPRegistry, registryChunk];
  
  $GWPLongToShort = Association[#1 -> #2 & @@@ $GWPRegistry];
  $GWPShortToLong = Association[#2 -> #1 & @@@ $GWPRegistry];
  $GWPTypeMap     = Association[#2 -> #3 & @@@ $GWPRegistry];
  
  $GWPStructureClasses = GroupBy[$GWPRegistry, #[[3]] &, Map[#[[1]] &]];
  $GWPPropertyClasses  = GroupBy[$GWPRegistry, #[[5]] &, Map[#[[1]] &]];
  $GWPAllClasses       = Join[$GWPStructureClasses, $GWPPropertyClasses];
  
  (* Master dictionaries now rebuild dynamically when an extension loads! *)
  $GWPInformation = Association[
    #[[1]] -> <|
      "ShortKey"       -> #[[2]],
      "DynamicClass"   -> #[[3]],
      "StaticClass"    -> #[[4]],
      "PropertyClass"  -> #[[5]],
      "Signature"      -> $GWPSignatures[#[[3]]]
    |> & /@ $GWPRegistry
  ];
  
  $GWPClassInformation = Association @ KeyValueMap[
    Function[{className, props},
      Module[{isStruct = KeyExistsQ[$GWPStructureClasses, className]},
        className -> <|
          "ClassType" -> If[isStruct, "StructureClass", "PropertyClass"],
          "PropertyCount" -> Length[props],
          If[isStruct,
            "Signature" -> $GWPSignatures[className],
            "ContainedStructures" -> Sort[DeleteDuplicates[Lookup[$GWPInformation, props][[All, "DynamicClass"]]]]
          ],
          "Properties" -> props,
          "ShortKeys"  -> Lookup[$GWPLongToShort, props]
        |>
      ]
    ],
    $GWPAllClasses
  ];
];

(* --- Potential Extension Receiver --- *)
GWPRegisterPotentials[models_, names_, heads_, signatures_] := Module[{},
  $GWPPotentialModels = DeleteDuplicates @ Join[$GWPPotentialModels, models];
  $GWPPotentialNames  = Join[$GWPPotentialNames, names];
  $GWPPotentialHeads  = Join[$GWPPotentialHeads, heads];
  
  If[$GWPPotentialSignatures === {},
    $GWPPotentialSignatures = signatures,
    $GWPPotentialSignatures = $GWPPotentialSignatures | signatures
  ];
];


(* Load the Engine (which natively loads GWPDeveloper) *)
Needs["GWPTools`GWPEngine`"];


(* ::Section:: *)
(*GWP and GWPObject*)


(* ::Subsection::Closed:: *)
(*About*)


(* ========================================================================= *)
(* API INTERFACE & DISPATCH ENGINE                                           *)
(* ------------------------------------------------------------------------- *)
(* This section forms the user-facing bridge to the underlying physics       *)
(* engine. It defines the wavepacket constructor (GWP), the immutable data   *)
(* structure (GWPObject), and the polymorphic evaluation architecture.       *)
(*                                                                           *)
(* ARCHITECTURAL TIERS:                                                      *)
(* 1. Constructor : Validates options, safely builds the core parameter      *)
(*                  sequence, and assembles the GWPObject.                   *)
(* 2. Tier-1      : Introspection layer. Handles queries for package metadata,*)
(*                  property dictionaries, and class structures. Maintains   *)
(*                  strict parity between GWP and GWPObject.                 *)
(* 3. Tier-2      : The Main Dispatcher. Intercepts queries to a constructed *)
(*                  object, returning metadata in O(1) time and routing      *)
(*                  valid physics property requests to Tier-3.               *)
(* 4. Tier-3      : Signature Evaluator. Uses the Master Registry to map     *)
(*                  short-keys to raw package functions, dynamically wrapping*)
(*                  them in the correct functional form (e.g., Function[t]). *)
(* ========================================================================= *)


(* ::Subsection::Closed:: *)
(*Core Constructor*)


(* --- Error Messages --- *)
GWP::badsum = "The summary mode `1` is not recognized. Valid modes are Automatic or None.";
GWP::badpot = "The potential `1` is not recognized. Evaluate GWP[\"PotentialNames\"] or GWP[\"PotentialModels\"] for valid options.";

(* --- Core GWPObject Constructor --- *)
Options[GWP] = {
  "Potential" -> None, 
  "HBAR" -> 1, 
  "MASS" -> 1,
  "Summary" -> Automatic
};

(* Condition strictly prevents the constructor from eating string API queries *)
GWP[initialParams___, opts : OptionsPattern[]] /; !MatchQ[First[{initialParams}, Null], _String] := 
  Module[{params, rawSys, finalSys, h, m, sumMode, invalidOpts},
    
    (* Catch Unknown Options *)
    invalidOpts = FilterRules[{opts}, Except[Options[GWP]]];
    If[Length[invalidOpts] > 0,
      Message[General::optx, First[First[invalidOpts]], HoldForm[GWP]];
      Return[$Failed]
    ];
    
    (* Extract Option Values *)
    h = OptionValue["HBAR"];
    m = OptionValue["MASS"];   
    rawSys = OptionValue["Potential"];
    sumMode = OptionValue["Summary"];
    
    (* Validate the "Summary" Option *)
    If[!MemberQ[{Automatic, None}, sumMode],
      Message[GWP::badsum, sumMode];
      Return[$Failed]
    ];
    
    (* Intercept Parameterized List Inputs (e.g., {"Harmonic", 2.0}) *)
    If[ListQ[rawSys] && Length[rawSys] > 0 && StringQ[First[rawSys]],
      If[KeyExistsQ[$GWPPotentialHeads, First[rawSys]],
        rawSys = Apply[$GWPPotentialHeads[First[rawSys]], Rest[rawSys]]
      ]
    ];
    
    (* Validate the "Potential" Option *)
    If[rawSys =!= None,
      If[StringQ[rawSys],
        (* Validate String Names *)
        If[!KeyExistsQ[$GWPPotentialNames, rawSys],
          Message[GWP::badpot, rawSys];
          Return[$Failed]
        ],
        (* Validate the Potential Model Signature *)
        If[!MatchQ[rawSys, $GWPPotentialSignatures],
          Message[GWP::badpot, rawSys];
          Return[$Failed]
        ]
      ]
    ];
    
    (* Assign final potential *)
    finalSys = Lookup[$GWPPotentialNames, rawSys, rawSys];    
    
    (* Call GWPPARAM and safely catch any cascading failures *)
    params = If[{initialParams} === {Automatic} || {initialParams} === {}, 
       GWPPARAM["HBAR" -> h, "MASS" -> m], 
       GWPPARAM[initialParams, "HBAR" -> h, "MASS" -> m]
    ];
    
    If[params === $Failed, Return[$Failed]];
    
    (* Construct the Object *)
    GWPObject[<|
      "Parameters" -> {params}, 
      "Potential" -> OptionValue["Potential"],
      "PotentialModel" -> finalSys, 
      "Created" -> Now,
      "Summary" -> sumMode
    |>]
];


(* ::Subsection:: *)
(*Map Builders*)


(* --- Map Builders and Type Verification --- *)
$GWPLongToShort = Association[#1 -> #2 & @@@ $GWPRegistry];
$GWPShortToLong = Association[#2 -> #1 & @@@ $GWPRegistry];
$GWPTypeMap     = Association[#2 -> #3 & @@@ $GWPRegistry];

$GWPStructureClasses = GroupBy[$GWPRegistry, #[[3]] &, Map[#[[1]] &]];
(* Update index to #[[5]] for the Property Categories *)
$GWPPropertyClasses  = GroupBy[$GWPRegistry, #[[5]] &, Map[#[[1]] &]];
$GWPAllClasses       = Join[$GWPStructureClasses, $GWPPropertyClasses];


GWPTypeQ[key_, type_] := (Lookup[$GWPTypeMap, key, None] === type);


(* ::Subsection::Closed:: *)
(*Front-End Formatting*)


(* --- Object Formatting --- *)
$GWPLogo = Graphics[{
    Opacity[0.2], Blue, FilledCurve[BezierCurve[{{-1, 0}, {-0.5, 0}, {-0.2, 1}, {0, 1}, {0.2, 1}, {0.5, 0}, {1, 0}}]],
    Opacity[1], Thickness[0.08], Blue, Line[Table[{x, Exp[-4 x^2]}, {x, -1, 1, 0.05}]],
    Thickness[0.04], Darker[Cyan], Line[Table[{x, 0.2 Sin[15 x] Exp[-4 x^2] - 0.1}, {x, -0.8, 0.8, 0.02}]]
  }, ImageSize -> 32, PlotRange -> {{-1.1, 1.1}, {-0.3, 1.1}}];

(* 1. Fast-path for None mode *)
GWPObject /: MakeBoxes[obj : GWPObject[data_?AssociationQ], format_] /; Lookup[data, "Summary", Automatic] === None := 
  ToBoxes[Row[{"GWPObject", "[", "\[Ellipsis]", "]"}], format];

(* 2. Main Formatting Block *)
GWPObject /: MakeBoxes[obj : GWPObject[data_?AssociationQ], format_] := Module[
  {potModel, potDisplay, paramsList, init, h, m, initial},
  
  potDisplay = data["Potential"];
  potModel = data["PotentialModel"];
  paramsList = data["Parameters"]; 
  
  (* Safely extract the static data (8: HBAR, 9: MASS, 11: INIT) *)
  If[Length[paramsList] >= 11,
    h = paramsList[[8]];
    m = paramsList[[9]];
    init = paramsList[[11]];
  ,
    h = "Unknown"; m = "Unknown"; init = "Unknown";
  ];
  
  initial = {
    {Style["System Attributes", Bold], Style["Values", Bold]},   
    {"Input: ", InputForm[init]}, 
    {"Potential: ", potDisplay},
    {"Mass: ", m}, 
    {"HBar: ", h}
  };
  
  BoxForm`ArrangeSummaryBox[
    "GWPObject", 
    obj, 
    $GWPLogo, 
    initial,  (* Always visible *)
    {},       (* Hidden by default *)
    format
  ]
];


(* ::Subsection::Closed:: *)
(*Tier-1 Static Introspection*)


(* --- Introspection Error Messages --- *)
GWP::badquery = "The query `1` is invalid or does not support the argument `2`.";
GWPObject::invalidprop = "`1` is not a valid property, class, or data key. Try obj[\"Properties\"] or obj[\"Classes\"].";

(* --- GWPObject Introspection --- *)
GWPObject[data_]["Properties"]          := Sort[Join[Keys[data], Keys[$GWPLongToShort]]];
GWPObject[data_]["ShortKeys"]           := Sort[Values[$GWPLongToShort]];
GWPObject[data_]["PropertyRules"]       := $GWPLongToShort;
GWPObject[data_]["Classes"]             := Sort[Keys[$GWPAllClasses]];
GWPObject[data_]["PropertyClasses"]     := Sort[Keys[$GWPPropertyClasses]];
GWPObject[data_]["StructureClasses"]    := Sort[Keys[$GWPStructureClasses]];
GWPObject[data_]["Signatures"]          := $GWPSignatures;
GWPObject[data_]["PotentialModels"]     := $GWPPotentialModels;
GWPObject[data_]["PotentialNames"]      := Sort[Keys[$GWPPotentialNames]];
GWPObject[data_]["PropertyInformation"] := $GWPInformation;
GWPObject[data_]["ClassInformation"]    := $GWPClassInformation;

(* --- GWP Package-Level Introspection (Parity) --- *)
GWP["Properties"]          := Sort[Keys[$GWPLongToShort]];
GWP["ShortKeys"]           := Sort[Values[$GWPLongToShort]];
GWP["PropertyRules"]       := $GWPLongToShort;
GWP["Classes"]             := Sort[Keys[$GWPAllClasses]];
GWP["PropertyClasses"]     := Sort[Keys[$GWPPropertyClasses]];
GWP["StructureClasses"]    := Sort[Keys[$GWPStructureClasses]];
GWP["Signatures"]          := $GWPSignatures;
GWP["PotentialModels"]     := $GWPPotentialModels; 
GWP["PotentialNames"]      := Sort[Keys[$GWPPotentialNames]];
GWP["PropertyInformation"] := $GWPInformation;
GWP["ClassInformation"]    := $GWPClassInformation;

(* --- 1-Argument Class and Property Pass-Through (GWP Parity) --- *)
GWP::invalidquery = "`1` is not a recognized introspection query, class, or property. Try GWP[\"Properties\"] or GWP[\"Classes\"].";

GWP[query_String] := 
  Which[
    (* 1. Is it a Class request? *)
    KeyExistsQ[$GWPAllClasses, query],
    Sort[$GWPAllClasses[query]],
    
    (* 2. Is it a registered Property? -> Evaluate with default wavepacket *)
    KeyExistsQ[$GWPLongToShort, query] || KeyExistsQ[$GWPTypeMap, query],
    GWP[][query],
    
    (* 3. Fallback: Invalid query *)
    True,
    Message[GWP::invalidquery, query];
    $Failed
  ];


(* ::Subsection::Closed:: *)
(*Tier-1 Filtered Introspection*)


(* --- GWPObject Filtered Introspection --- *)
GWPObject[data_]["PropertyRules", class_String] /; KeyExistsQ[$GWPAllClasses, class] := 
  Association @@ FilterRules[Normal @ $GWPLongToShort, $GWPAllClasses[class]];
  
GWPObject[data_]["ShortKeys", class_String] /; KeyExistsQ[$GWPAllClasses, class] := 
  Sort[Values[FilterRules[Normal @ $GWPLongToShort, $GWPAllClasses[class]]]];
  
GWPObject[data_]["Signatures", class_String] /; KeyExistsQ[$GWPSignatures, class] := 
  $GWPSignatures[class];
  
GWPObject[data_]["ClassInformation", class_String] /; KeyExistsQ[$GWPAllClasses, class] := 
  $GWPClassInformation[class];

(* PropertyInformation routing (Class vs Property) *)
GWPObject[data_]["PropertyInformation", class_String] /; KeyExistsQ[$GWPAllClasses, class] := 
  KeyTake[$GWPInformation, $GWPAllClasses[class]];
  
GWPObject[data_]["PropertyInformation", prop_String] /; KeyExistsQ[$GWPLongToShort, prop] || KeyExistsQ[$GWPShortToLong, prop] := 
  $GWPInformation[Lookup[$GWPShortToLong, prop, prop]];

(* --- GWP Filtered Introspection (Parity) --- *)
GWP["PropertyRules", class_String] /; KeyExistsQ[$GWPAllClasses, class] := 
  Association @@ FilterRules[Normal @ $GWPLongToShort, $GWPAllClasses[class]];
  
GWP["ShortKeys", class_String] /; KeyExistsQ[$GWPAllClasses, class] := 
  Sort[Values[FilterRules[Normal @ $GWPLongToShort, $GWPAllClasses[class]]]];
  
GWP["Signatures", class_String] /; KeyExistsQ[$GWPSignatures, class] := 
  $GWPSignatures[class];
  
GWP["ClassInformation", class_String] /; KeyExistsQ[$GWPAllClasses, class] := 
  $GWPClassInformation[class];

(* PropertyInformation routing (Class vs Property) *)
GWP["PropertyInformation", class_String] /; KeyExistsQ[$GWPAllClasses, class] := 
  KeyTake[$GWPInformation, $GWPAllClasses[class]];
  
GWP["PropertyInformation", prop_String] /; KeyExistsQ[$GWPLongToShort, prop] || KeyExistsQ[$GWPShortToLong, prop] := 
  $GWPInformation[Lookup[$GWPShortToLong, prop, prop]];

(* --- Catch-All for Invalid 2-Argument Queries --- *)
GWPObject[data_][query_String, arg_String] /; MemberQ[{"PropertyRules", "ShortKeys", "Signatures", "PropertyInformation", "ClassInformation"}, query] := 
  (Message[GWP::badquery, query, arg]; $Failed);
  
GWP[query_String, arg_String] /; MemberQ[{"PropertyRules", "ShortKeys", "Signatures", "PropertyInformation", "ClassInformation"}, query] := 
  (Message[GWP::badquery, query, arg]; $Failed);


(* ::Subsection::Closed:: *)
(*Tier-2 Meta Data and Main Dispatcher*)


(* --- Meta Data Error Messages --- *)
GWPObject::reqpot = "The property \"`1`\" requires an active dynamic potential. Rebuild the wavepacket using GWP[..., \"Potential\" -> \"HO\"].";

(* --- Metadata Retrieval --- *)
GWPObject[data_][prop_String] /; KeyExistsQ[data, prop] := data[prop];

(* --- The Main Dispatcher --- *)
GWPObject[data_][query_String, args___] := Module[
  {key, info, macro, dynamicClass, staticClass, targetClass},
  
  (* Inside GWPObject[data_][query_String, args___] *)
   Which[
    (* 1. Is it a registered property? *)
    KeyExistsQ[$GWPLongToShort, query] || KeyExistsQ[$GWPTypeMap, query],
  
    (* MUST be $GWPShortToLong *)
    key = Lookup[$GWPShortToLong, query, query]; 
    info = $GWPInformation[key];
    
    macro        = info["ShortKey"];
    dynamicClass = info["DynamicClass"];
    staticClass  = info["StaticClass"];
    
    (* Route based on whether the object has an active potential *)
    targetClass = If[data["Potential"] === None, staticClass, dynamicClass];
    
    (* Graceful Failure Check *)
    If[targetClass === None,
      Message[GWPObject::reqpot, query];
      $Failed
    ,
      (* Execute Tier-3 Dispatch passing the targetClass and macro explicitly *)
      GWPPropertyDispatch[targetClass, macro, data, args]
    ],
    
    (* 2. Is it a 0-argument property class request? *)
    Length[{args}] == 0 && KeyExistsQ[$GWPAllClasses, query],
    Sort[$GWPAllClasses[query]],
    
    (* 3. Not found *)
    True,
    Message[GWPObject::invalidprop, query];
    $Failed
  ]
];


(* ::Subsection::Closed:: *)
(*Tier-3 GWPObject Dispatch Engine*)


(* --- Error Messages --- *)
GWPObject::badorder = "The requested derivative or moment order `1` must be a non-negative integer.";
GWPObject::badargs = "Invalid arguments provided for property `1`. Check the expected signature for this property class.";

(* --- Signature Dispatching (Tier 3) --- *)

(* ========================================== *)
(* DYNAMIC CLASSES (Active Potential)         *)
(* ========================================== *)

GWPPropertyDispatch["Static", macro_, data_, opts___] := 
  Symbol["GWPTools`GWPDeveloper`GWP" <> macro][Sequence @@ data["Parameters"], opts];

GWPPropertyDispatch["Recursive", macro_, data_, n_Integer : 0] /; n >= 0 := 
  Function[{var, t}, Symbol["GWPTools`GWPDeveloper`GWP" <> macro][n][var][data["PotentialModel"][t][Sequence @@ data["Parameters"]]]];

GWPPropertyDispatch["Moment", macro_, data_, n_Integer : 1] /; n >= 0 := 
  Function[t, Symbol["GWPTools`GWPDeveloper`GWP" <> macro][n][data["PotentialModel"][t][Sequence @@ data["Parameters"]]]];

GWPPropertyDispatch["CrossMoment", macro_, data_] := 
  Function[t, Symbol["GWPTools`GWPDeveloper`GWP" <> macro][data["PotentialModel"][t][Sequence @@ data["Parameters"]]]];
  
GWPPropertyDispatch["CrossMoment", macro_, data_, m_Integer, n_Integer] /; m >= 0 && n >= 0 := 
  Function[t, Symbol["GWPTools`GWPDeveloper`GWP" <> macro][m, n][data["PotentialModel"][t][Sequence @@ data["Parameters"]]]];

GWPPropertyDispatch["Field", macro_, data_] := 
  Function[{var, t}, Symbol["GWPTools`GWPDeveloper`GWP" <> macro][var][data["PotentialModel"][t][Sequence @@ data["Parameters"]]]];

GWPPropertyDispatch["Bivariate", macro_, data_] := 
  Function[{v1, v2, t}, Symbol["GWPTools`GWPDeveloper`GWP" <> macro][v1, v2][data["PotentialModel"][t][Sequence @@ data["Parameters"]]]];

GWPPropertyDispatch["Temporal", macro_, data_] := 
  Function[t, Symbol["GWPTools`GWPDeveloper`GWP" <> macro][data["PotentialModel"][t][Sequence @@ data["Parameters"]]]];


(* ========================================== *)
(* STATIC CLASSES (Potential -> None)         *)
(* ========================================== *)

GWPPropertyDispatch["Static", macro_, data_, opts___] := 
  Symbol["GWPTools`GWPDeveloper`GWP" <> macro][Sequence @@ data["Parameters"], opts];

GWPPropertyDispatch["Spatial", macro_, data_] := 
  Function[{var}, Symbol["GWPTools`GWPDeveloper`GWP" <> macro][var][Sequence @@ data["Parameters"]]];

GWPPropertyDispatch["RecursiveSpatial", macro_, data_, n_Integer : 0] /; n >= 0 := 
  Function[{var}, Symbol["GWPTools`GWPDeveloper`GWP" <> macro][n][var][Sequence @@ data["Parameters"]]];

GWPPropertyDispatch["BivariateSpatial", macro_, data_] := 
  Function[{var1, var2}, Symbol["GWPTools`GWPDeveloper`GWP" <> macro][var1, var2][Sequence @@ data["Parameters"]]];

GWPPropertyDispatch["StaticValue", macro_, data_] := 
  Symbol["GWPTools`GWPDeveloper`GWP" <> macro][Sequence @@ data["Parameters"]];

GWPPropertyDispatch["StaticMoment", macro_, data_, n_Integer : 1] /; n >= 0 := 
  Symbol["GWPTools`GWPDeveloper`GWP" <> macro][n][Sequence @@ data["Parameters"]];

GWPPropertyDispatch["StaticCrossMoment", macro_, data_] := 
  Symbol["GWPTools`GWPDeveloper`GWP" <> macro][Sequence @@ data["Parameters"]];
  
GWPPropertyDispatch["StaticCrossMoment", macro_, data_, m_Integer, n_Integer] /; m >= 0 && n >= 0 := 
  Symbol["GWPTools`GWPDeveloper`GWP" <> macro][m, n][Sequence @@ data["Parameters"]];

(* ========================================== *)
(* FALLBACKS                                  *)
(* ========================================== *)

GWPPropertyDispatch[class_, macro_, data_, badArg_Integer ? Negative] /; MemberQ[{"Recursive", "Moment", "RecursiveSpatial", "StaticMoment"}, class] := (
  Message[GWPObject::badorder, badArg];
  $Failed
);

GWPPropertyDispatch[class_, macro_, data_, badArgs___] := (
  Message[GWPObject::badargs, macro];
  $Failed
);


(* ::Section::Closed:: *)
(*End*)


(* --- End "GWPTools`Private`" --- *)
End[];


(* Hide internal code for all Public functions from the ? menu *)
SetAttributes[Evaluate[Names["GWPTools`*"]], {ReadProtected}];


(* --- End "GWPTools`" --- *)
EndPackage[];

(* ::Package:: *)

(* ::Title:: *)
(*GWPDispatcher Package*)


(* ::Section::Closed:: *)
(*GWPTools Usage Registration*)


BeginPackage["GWPTools`"]
If[TrueQ[Global`$GWPDebug], Print["[GWPDispatcher] BeginPackage GWPTools"]];

(* --- Usage Statements --- *)
GWP::usage = "GWP[type][parameters, options] returns a GWPObject representing a Gaussian wavepacket with the specified type, parameters, and options.";
GWPObject::usage = "GWPObject[...] represents the wavepacket data structure.";

If[TrueQ[Global`$GWPDebug], Print["[GWPDispatcher] EndPackage GWPTools"]];
EndPackage[]


(* ::Section::Closed:: *)
(*BeginPackage*)


(* ========================================================================= *)
(* PACKAGE     : GWPTools`GWPDispatcher`                                     *)
(* DESCRIPTION : The core constructor, polymorphic routing engine, and API   *)
(*               overloads for the GWPTools framework.                       *)
(* ========================================================================= *)
BeginPackage["GWPTools`GWPDispatcher`"]

If[TrueQ[Global`$GWPDebug], Print["[GWPDispatcher] BeginPackage"]];

Begin["`Private`"]
If[TrueQ[Global`$GWPDebug], Print["[GWPDispatcher] Begin Private"]];

Needs["GWPTools`"];
Needs["GWPTools`GWPRegistry`"];


(* ::Section::Closed:: *)
(*Property and Class Resolution*)


(* --- Introspection Taxonomy Keywords --- *)
$GWPIntrospectionQueries = {
  "Types",            (* Available engine types (e.g., "1D") *)
  "Classes",          (* Physics and property categories (e.g., "Wavefunctions") *)
  "SignatureClasses", (* Master list of all math signature types *)
  "DynamicClasses",   (* Signatures used when a potential is active (time-dependent) *)
  "StaticClasses",    (* Signatures used when Potential is None (time-independent) *)
  "Signatures",       (* Dictionary mapping signature classes to pure function structures *)
  "Properties",       (* Master list of all registered long-form property names *)
  "ShortKeys",        (* Macro abbreviations for quick evaluation (e.g., "RHOX") *)
  "PotentialNames",   (* String aliases for registered dynamic potentials (e.g., "HO") *)
  "PotentialModels",  (* Internal backend developer symbols and parameterized heads *)
  "PotentialRecords", (* Potential registry data extraction *)
  "Records"           (* Registry data extraction *)
};

(* --- Helper: Is it a registered Type? --- *)
GWPTypeQ[type_String] := KeyExistsQ[$GWPInformation, type];

(* --- Helper: Resolve LongName or ShortKey to LongName --- *)
ResolveGWPProperty[query_String, type_String] := Module[{typeReg, matches},
  If[!GWPTypeQ[type], Return[$Failed]];
  typeReg = $GWPInformation[type];
  
  If[KeyExistsQ[typeReg, query], Return[query]];
  
  matches = Select[Keys[typeReg], typeReg[#]["ShortKey"] == query &];
  If[Length[matches] > 0, First[matches], $Failed]
];

(* --- Helper: Is it a valid Class? --- *)
GWPClassQ[query_String, type_String] := Module[{infoVals},
  If[!GWPTypeQ[type], Return[False]];
  infoVals = Values[$GWPInformation[type]];
  MemberQ[DeleteCases[DeleteDuplicates[Join[
    Lookup[infoVals, "PropertyClass"],
    Lookup[infoVals, "DynamicClass"],
    Lookup[infoVals, "StaticClass"]
  ]], None], query]
];


(* ::Section::Closed:: *)
(*GWP Architecture (Tier-1)*)


(* ========================================================================= *)
(* PART 1: THE FACTORY ARCHITECTURE (SubValues: GWP["2D"][...])              *)
(* ========================================================================= *)


(* --- GWP Options --- *)
Options[GWP] = {
  "Potential" -> None, 
  "HBAR" -> 1, 
  "MASS" -> 1,
  "Summary" -> Automatic
};

GWP::badpot = "The potential `1` is not recognized for type `2`.";


(* --- 1A. Constructor --- *)
GWP[type_String][initialParams___, opts : OptionsPattern[]] /; GWPTypeQ[type] && !MatchQ[First[{initialParams}, Null], _String] := 
  Module[{params, rawSys, finalSys, paramBuilder, filteredOpts},

    (* Parse Potential Option *)    
    rawSys = OptionValue[GWP, FilterRules[{opts}, Options[GWP]], "Potential"];
    
    If[rawSys =!= None,
      Module[{potKey, potArgs, potData},
        (* Extract the lookup key ("HO" or "Linear") and any parameters *)
        potKey  = If[ListQ[rawSys], First[rawSys], rawSys];
        potArgs = If[ListQ[rawSys], Rest[rawSys], {}];
        
        (* Validate against the unified database *)
        If[Or[!KeyExistsQ[$GWPPotentials, type], !KeyExistsQ[$GWPPotentials[type], potKey]],
          Message[GWP::badpot, rawSys, type]; Return[$Failed]
        ];
        
        (* Construct the final evaluated backend symbol *)
        potData = $GWPPotentials[type][potKey];
        finalSys = If[Length[potArgs] > 0,
          potData["BackendSymbol"] @@ potArgs,
          potData["BackendSymbol"]
        ];
      ];
    ,
      finalSys = None;
    ];
    
    (* Resolve GWPtypePARAM Function and Options *)
    paramBuilder = Symbol["GWPTools`GWPDeveloper`GWP" <> type <> "PARAM"];
    filteredOpts = Sequence @@ FilterRules[{opts}, Options[paramBuilder]];

        (* Fetch Parameter Sequence from GWPtypePARAM *)
    params = If[{initialParams} === {Automatic} || {initialParams} === {},
      paramBuilder[filteredOpts],
      paramBuilder[initialParams, filteredOpts]
    ];   
    If[params === $Failed, Return[$Failed]];

    (* Return GWPObject *)    
    GWPObject[<| 
      "GWPType"        -> type, 
      "Parameters"     -> {params}, 
      "Potential"      -> rawSys,
      "PotentialModel" -> finalSys,
      "Summary"        -> OptionValue[GWP, FilterRules[{opts}, Options[GWP]], "Summary"]
    |>]
  ];


(* --- 1B. Quick Property Evaluation (e.g., GWP["2D"]["RHOX"]) --- *)
GWP[type_String][prop_String, args___] /; GWPTypeQ[type] && StringQ[ResolveGWPProperty[prop, type]] := 
  GWP[type][Automatic][ResolveGWPProperty[prop, type], args];


(* --- 1C. Type-Filtered Introspection --- *)
GWP[type_String][query_String, arg_String:""] /; GWPTypeQ[type] && Or[MemberQ[$GWPIntrospectionQueries, query], GWPClassQ[query, type]] := 
  Module[{filteredInfo, isFiltered},

    (* Base GWPtype property information *)
    filteredInfo = $GWPInformation[type];

    (* Check if query is actually a class name (e.g. GWP["1D"]["PhaseSpace"]) *)
    If[GWPClassQ[query, type],
      filteredInfo = Select[filteredInfo, Or[#["PropertyClass"] == query, #["DynamicClass"] == query, #["StaticClass"] == query] &];
      Return[Sort[Keys[filteredInfo]]];
    ];

    (* Safely filter by argument if it is a Class OR a Property/ShortKey *)
    isFiltered = (arg =!= "");
    If[isFiltered,
      If[GWPClassQ[arg, type],
        (* Filter down to the requested class *)
        filteredInfo = Select[filteredInfo, Or[#["PropertyClass"] == arg, #["DynamicClass"] == arg, #["StaticClass"] == arg] &];
      ,
        (* Try to resolve the argument as either a LongName or a ShortKey *)
        Module[{resolvedArg = ResolveGWPProperty[arg, type]},
          If[StringQ[resolvedArg],
            (* Filter down to a single property *)
            filteredInfo = <| resolvedArg -> filteredInfo[resolvedArg] |>;
          ,
            (* Failsafe: Argument is not a class, property, or short key *)
            filteredInfo = <||>;
          ]
        ];
      ];
    ];

    (* Dispatch the filtered query to the appropriate data extraction logic *)
    Which[
      (* Extract structured records *)
      query == "Records",
        KeyValueMap[
          <|
            "Property"     -> #1,
            "ShortKey"     -> #2["ShortKey"],
            "Class"        -> #2["PropertyClass"],
            "DynamicClass" -> #2["DynamicClass"],
            "StaticClass"  -> #2["StaticClass"]
          |> &, 
          filteredInfo
        ],
        
      (* Extract unique property/physics classes *)
      query == "Classes", 
        Sort[DeleteDuplicates[Values[filteredInfo[[All, "PropertyClass"]]]]],
      
      (* Combine and extract all unique dynamic and static math signatures *)
      query == "SignatureClasses", 
        Sort[DeleteCases[DeleteDuplicates[Join[Values[filteredInfo[[All, "DynamicClass"]]], Values[filteredInfo[[All, "StaticClass"]]]]], None]],
      
      (* Extract unique signatures used with active potentials *)
      query == "DynamicClasses", 
        Sort[DeleteCases[DeleteDuplicates[Values[filteredInfo[[All, "DynamicClass"]]]], None]],
      
      (* Extract unique signatures used when Potential is None *)
      query == "StaticClasses", 
        Sort[DeleteCases[DeleteDuplicates[Values[filteredInfo[[All, "StaticClass"]]]], None]],
      
      (* Extract long-form property names (keys of the registry) *)
      query == "Properties", 
        Sort[Keys[filteredInfo]],
      
      (* Extract macro abbreviations *)
      query == "ShortKeys",  
        Sort[Values[filteredInfo[[All, "ShortKey"]]]],
      
      (* Global engine types (e.g., "1D") *)
      query == "Types",
        Keys[$GWPInformation],
      
      (* Registered string names for potentials specific to this engine type *)
      query == "PotentialNames",
        Sort[Keys[$GWPPotentials[type]]],
      
      (* All user-facing templates for potentials *)
      query == "PotentialModels",
        Sort[Values[$GWPPotentials[type]][[All, "Template"]]],
        
      (* Structured Introspection for Potentials *)
      query == "PotentialRecords",
        KeyValueMap[
          <|
            "Potential"     -> #1,
            "Template"      -> ToString[#2["Template"]],
            "Category"      -> #2["Category"],
            "BackendSymbol" -> Last[StringSplit[ToString[#2["BackendSymbol"]], "`"]]
          |> &,
          $GWPPotentials[type]
        ],
      
(* Hardcoded mapping of signature names to their structural behavior *)
      query == "Signatures",
        <|
         (* --- 0-Argument Signatures --- *)
         "Static"                        -> <| "Category" -> "Dynamic", "Signature" -> "f[params]",            "Returns" -> "Evaluated Value"       |>, 
         "Temporal"                      -> <| "Category" -> "Dynamic", "Signature" -> "f[params]",            "Returns" -> "Function[t]"           |>, 
         "StaticValue"                   -> <| "Category" -> "Static",  "Signature" -> "f[params]",            "Returns" -> "Evaluated Value"       |>, 

         (* --- 1-Discrete-Argument Signatures --- *)
         "Moment"                        -> <| "Category" -> "Dynamic", "Signature" -> "f[n][params]",         "Returns" -> "Function[t]"           |>, 
         "StaticMoment"                  -> <| "Category" -> "Static",  "Signature" -> "f[n][params]",         "Returns" -> "Evaluated Value"       |>, 

         (* --- 2-Discrete-Argument Signatures --- *)
         "CrossMoment"                   -> <| "Category" -> "Dynamic", "Signature" -> "f[m, n][params]",      "Returns" -> "Function[t]"           |>, 
         "StaticCrossMoment"             -> <| "Category" -> "Static",  "Signature" -> "f[m, n][params]",      "Returns" -> "Evaluated Value"       |>, 

         (* --- 1-Spatial-Argument Signatures --- *)
         "Field"                         -> <| "Category" -> "Dynamic", "Signature" -> "f[var][params]",       "Returns" -> "Function[{var, t}]"    |>, 
         "Spatial"                       -> <| "Category" -> "Static",  "Signature" -> "f[var][params]",       "Returns" -> "Function[{var}]"       |>, 

         (* --- 1-Discrete, 1-Spatial-Argument Signatures --- *)
         "Recursive"                     -> <| "Category" -> "Dynamic", "Signature" -> "f[n][var][params]",    "Returns" -> "Function[{var, t}]"    |>, 
         "RecursiveSpatial"              -> <| "Category" -> "Static",  "Signature" -> "f[n][var][params]",    "Returns" -> "Function[{var}]"       |>, 

         (* --- 2-Spatial-Argument Signatures --- *)
         "Bivariate"                     -> <| "Category" -> "Dynamic", "Signature" -> "f[v1, v2][params]",    "Returns" -> "Function[{v1, v2, t}]" |>, 
         "BivariateSpatial"              -> <| "Category" -> "Static",  "Signature" -> "f[v1, v2][params]",    "Returns" -> "Function[{v1, v2}]"    |>, 

         (* --- Parameterized Signatures --- *)
         "ParameterizedTemporal"         -> <| "Category" -> "Dynamic", "Signature" -> "f[s][params]",         "Returns" -> "Function[t]"           |>, 
         "ParameterizedStaticValue"      -> <| "Category" -> "Static",  "Signature" -> "f[s][params]",         "Returns" -> "Evaluated Value"       |>, 

         "ParameterizedBivariate"        -> <| "Category" -> "Dynamic", "Signature" -> "f[s][v1, v2][params]", "Returns" -> "Function[{v1, v2, t}]" |>, 
         "ParameterizedBivariateSpatial" -> <| "Category" -> "Static",  "Signature" -> "f[s][v1, v2][params]", "Returns" -> "Function[{v1, v2}]"    |>
        |>,
      
      (* Fallback *)
      True, 
        "Filtered query not fully implemented yet."
    ]
  ];


(* ========================================================================= *)
(* PART 2: THE LEGACY FALLBACKS (DownValues: GWP[...])                       *)
(* ========================================================================= *)

(* 2A. Default to 1D Constructor *)
GWP[initialParams___, opts : OptionsPattern[]] /; !MatchQ[First[{initialParams}, Null], _String] := 
  GWP["1D"][initialParams, opts];

(* 2B. Default to 1D Quick Property (e.g. GWP["RHOX"]) *)
GWP[prop_String, args___] /; StringQ[ResolveGWPProperty[prop, "1D"]] := 
  GWP["1D"][Automatic][ResolveGWPProperty[prop, "1D"], args];

(* 2C. Global Introspection *)
GWP::invalidquery = "`1` is not a recognized introspection query, wavepacket type, class, or property.";
GWP[query_String, arg_String:""] /; !GWPTypeQ[query] := 
  If[query == "Types",
    Keys[$GWPInformation],
    If[MemberQ[$GWPIntrospectionQueries, query] || GWPClassQ[query, "1D"],
      GWP["1D"][query, arg],
      Message[GWP::invalidquery, query]; $Failed
    ]
  ];


(* ::Section::Closed:: *)
(*GWPObject Formatting*)


(* ========================================================================= *)
(* FRONT-END FORMATTING & UI DISPATCHER                                      *)
(* ========================================================================= *)

(* --- GWPObject with None Format --- *)
GWPObject /: MakeBoxes[obj : GWPObject[data_], format_] /; Lookup[data, "Summary", Automatic] === None := 
  ToBoxes[Row[{"GWPObject", "[", "\[Ellipsis]", "]"}], format];

(* --- GWPObject with Association Format --- *)
GWPObject /: MakeBoxes[obj : GWPObject[data_], format_] /; Lookup[data, "Summary", Automatic] === "Association" := 
  RowBox[{"GWPObject", "[", ToBoxes[data, format], "]"}];

(* --- GWPObject with MakeBoxes Format ---*)
GWPObject /: MakeBoxes[obj : GWPObject[data_], format_] := Module[
  {type, uiBuilderName, uiBuilder, uiData, uiBoxes = $Failed},

  (* Resolve GWPtypeUI Function *)  
  type = data["GWPType"];
  uiBuilderName = "GWPTools`GWPDeveloper`GWP" <> type <> "UI";
  (* Fetch Format Data from GWPtypeUI *)
  If[NameQ[uiBuilderName],
    uiBuilder = Symbol[uiBuilderName];
    If[DownValues[Evaluate[uiBuilder]] =!= {},
      uiData = uiBuilder[data];
      If[ListQ[uiData] && Length[uiData] === 3,
        uiBoxes = BoxForm`ArrangeSummaryBox["GWPObject", obj, uiData[[1]], uiData[[2]], uiData[[3]], format];
      ];
    ];
  ];
  (* Construct Formatted Output *)
  If[uiBoxes =!= $Failed,
    uiBoxes,
    RowBox[{"GWPObject", "[", ToBoxes[data, format], "]"}]
  ]
];


(* ::Section::Closed:: *)
(*GWPObject Main Dispatcher (Tier-2)*)


(* ========================================================================= *)
(* PART 3: TIER-2 MAIN DISPATCHER                                            *)
(* ========================================================================= *)

GWPObject::reqpot = "The property \"`1`\" requires an active dynamic potential. Rebuild the wavepacket using GWP[..., \"Potential\" -> \"HO\"].";
GWPObject::invalidprop = "`1` is not a valid property or short key.";

GWPObject[data_][query_String, args___] := Module[
  {actualQuery, info, macro, type, dynamicClass, staticClass, targetClass},
  
  type = data["GWPType"];

  (* 0. Intercept Internal State Queries *)
  If[KeyExistsQ[data, query], Return[data[query]]];  

  (* 1. Intercept Introspection Queries on the Object *)
  If[Or[MemberQ[$GWPIntrospectionQueries, query], GWPClassQ[query, type]],
    Return[GWP[type][query, If[Length[{args}] > 0, First[{args}], ""]]]
  ];
  
  (* 2. Resolve the query filtered by Type *)
  actualQuery = ResolveGWPProperty[query, type];
  
  If[actualQuery === $Failed,
    Message[GWPObject::invalidprop, query];
    Return[$Failed];
  ];
  
  (* Look up in the Nested Registry *)
  info         = $GWPInformation[type][actualQuery];
  macro        = info["ShortKey"];
  dynamicClass = info["DynamicClass"];
  staticClass  = info["StaticClass"];
  
  (* 3. Route based on whether the object has an active potential *)
  targetClass = If[data["Potential"] === None, staticClass, dynamicClass];
  
  If[targetClass === None,
    Message[GWPObject::reqpot, query];
    Return[$Failed];
  ];
  
  (* 4. Execute Tier-3 Math Wrappers *)
  GWPPropertyDispatch[targetClass, macro, type, data, args]
];


(* ::Section::Closed:: *)
(*Property Signature Evaluator (Tier-3)*)


(* ========================================================================= *)
(* PART 4: TIER-3 SIGNATURE EVALUATOR                                        *)
(* ========================================================================= *)

GWPObject::badorder = "The requested derivative or moment order `1` must be a non-negative integer.";
GWPObject::badargs = "Invalid arguments provided for property `1`. Check the expected signature for this property class.";

(* --- Dynamic Classes (Active Potential) --- *)
GWPPropertyDispatch["Static", macro_, type_, data_, opts___] := 
  Symbol["GWPTools`GWPDeveloper`GWP" <> type <> macro][Sequence @@ data["Parameters"], opts];

GWPPropertyDispatch["Recursive", macro_, type_, data_, n_Integer : 0] /; n >= 0 := 
  Function[{var, t}, Symbol["GWPTools`GWPDeveloper`GWP" <> type <> macro][n][var][data["PotentialModel"][t][Sequence @@ data["Parameters"]]]];

GWPPropertyDispatch["Moment", macro_, type_, data_, n_Integer : 1] /; n >= 0 := 
  Function[t, Symbol["GWPTools`GWPDeveloper`GWP" <> type <> macro][n][data["PotentialModel"][t][Sequence @@ data["Parameters"]]]];

GWPPropertyDispatch["CrossMoment", macro_, type_, data_] := 
  Function[t, Symbol["GWPTools`GWPDeveloper`GWP" <> type <> macro][data["PotentialModel"][t][Sequence @@ data["Parameters"]]]];
  
GWPPropertyDispatch["CrossMoment", macro_, type_, data_, m_Integer, n_Integer] /; m >= 0 && n >= 0 := 
  Function[t, Symbol["GWPTools`GWPDeveloper`GWP" <> type <> macro][m, n][data["PotentialModel"][t][Sequence @@ data["Parameters"]]]];

GWPPropertyDispatch["Field", macro_, type_, data_] := 
  Function[{var, t}, Symbol["GWPTools`GWPDeveloper`GWP" <> type <> macro][var][data["PotentialModel"][t][Sequence @@ data["Parameters"]]]];

GWPPropertyDispatch["Bivariate", macro_, type_, data_] := 
  Function[{v1, v2, t}, Symbol["GWPTools`GWPDeveloper`GWP" <> type <> macro][v1, v2][data["PotentialModel"][t][Sequence @@ data["Parameters"]]]];

GWPPropertyDispatch["Temporal", macro_, type_, data_] := 
  Function[t, Symbol["GWPTools`GWPDeveloper`GWP" <> type <> macro][data["PotentialModel"][t][Sequence @@ data["Parameters"]]]];
  
GWPPropertyDispatch["ParameterizedBivariate", macro_, type_, data_] := 
  Function[{v1, v2, t}, Symbol["GWPTools`GWPDeveloper`GWP" <> type <> macro][v1, v2][data["PotentialModel"][t][Sequence @@ data["Parameters"]]]];

GWPPropertyDispatch["ParameterizedBivariate", macro_, type_, data_, s_] := 
  Function[{v1, v2, t}, Symbol["GWPTools`GWPDeveloper`GWP" <> type <> macro][s][v1, v2][data["PotentialModel"][t][Sequence @@ data["Parameters"]]]];
  
GWPPropertyDispatch["ParameterizedTemporal", macro_, type_, data_] := 
  Function[t, Symbol["GWPTools`GWPDeveloper`GWP" <> type <> macro][data["PotentialModel"][t][Sequence @@ data["Parameters"]]]];

GWPPropertyDispatch["ParameterizedTemporal", macro_, type_, data_, s_] := 
  Function[t, Symbol["GWPTools`GWPDeveloper`GWP" <> type <> macro][s][data["PotentialModel"][t][Sequence @@ data["Parameters"]]]];


(* --- Static Classes (Potential -> None) --- *)
GWPPropertyDispatch["Spatial", macro_, type_, data_] := 
  Function[{var}, Symbol["GWPTools`GWPDeveloper`GWP" <> type <> macro][var][Sequence @@ data["Parameters"]]];

GWPPropertyDispatch["RecursiveSpatial", macro_, type_, data_, n_Integer : 0] /; n >= 0 := 
  Function[{var}, Symbol["GWPTools`GWPDeveloper`GWP" <> type <> macro][n][var][Sequence @@ data["Parameters"]]];

GWPPropertyDispatch["BivariateSpatial", macro_, type_, data_] := 
  Function[{var1, var2}, Symbol["GWPTools`GWPDeveloper`GWP" <> type <> macro][var1, var2][Sequence @@ data["Parameters"]]];

GWPPropertyDispatch["StaticValue", macro_, type_, data_] := 
  Symbol["GWPTools`GWPDeveloper`GWP" <> type <> macro][Sequence @@ data["Parameters"]];

GWPPropertyDispatch["StaticMoment", macro_, type_, data_, n_Integer : 1] /; n >= 0 := 
  Symbol["GWPTools`GWPDeveloper`GWP" <> type <> macro][n][Sequence @@ data["Parameters"]];

GWPPropertyDispatch["StaticCrossMoment", macro_, type_, data_] := 
  Symbol["GWPTools`GWPDeveloper`GWP" <> type <> macro][Sequence @@ data["Parameters"]];
  
GWPPropertyDispatch["StaticCrossMoment", macro_, type_, data_, m_Integer, n_Integer] /; m >= 0 && n >= 0 := 
  Symbol["GWPTools`GWPDeveloper`GWP" <> type <> macro][m, n][Sequence @@ data["Parameters"]];
  
GWPPropertyDispatch["ParameterizedBivariateSpatial", macro_, type_, data_] := 
  Function[{v1, v2}, Symbol["GWPTools`GWPDeveloper`GWP" <> type <> macro][v1, v2][Sequence @@ data["Parameters"]]];

GWPPropertyDispatch["ParameterizedBivariateSpatial", macro_, type_, data_, s_] := 
  Function[{v1, v2}, Symbol["GWPTools`GWPDeveloper`GWP" <> type <> macro][s][v1, v2][Sequence @@ data["Parameters"]]];
  
GWPPropertyDispatch["ParameterizedStaticValue", macro_, type_, data_] := 
  Symbol["GWPTools`GWPDeveloper`GWP" <> type <> macro][Sequence @@ data["Parameters"]];

GWPPropertyDispatch["ParameterizedStaticValue", macro_, type_, data_, s_] := 
  Symbol["GWPTools`GWPDeveloper`GWP" <> type <> macro][s][Sequence @@ data["Parameters"]];


(* --- Fallbacks --- *)
GWPPropertyDispatch[class_, macro_, type_, data_, badArg_Integer ? Negative] /; MemberQ[{"Recursive", "Moment", "RecursiveSpatial", "StaticMoment"}, class] := (
  Message[GWPObject::badorder, badArg]; $Failed
);

GWPPropertyDispatch[class_, macro_, type_, data_, badArgs___] := (
  Message[GWPObject::badargs, macro]; $Failed
);


(* ::Section::Closed:: *)
(*End*)


(* --- End "GWPTools`GWPDispatcher`Private`" --- *)
If[TrueQ[Global`$GWPDebug], Print["[GWPDispatcher] End Private"]];
End[]

(* Hide internal code for all Developer functions from the ? menu *)
SetAttributes[Evaluate[Names["GWPTools`GWPDispatcher`*"]], {ReadProtected}];

SetAttributes[GWP, {ReadProtected}];
SetAttributes[GWPObject, {ReadProtected}];

(* --- End "GWPTools`GWPDispatcher`" --- *)
If[TrueQ[Global`$GWPDebug], Print["[GWPDispatcher] EndPackage"]];
EndPackage[]

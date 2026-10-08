(* ::Package:: *)

(* ::Title:: *)
(*GWPRegistry Package*)


(* ::Section::Closed:: *)
(*BeginPackage*)


(* ========================================================================= *)
(* PACKAGE     : GWPTools`GWPRegistry`                                       *)
(* DESCRIPTION : Tools for property and potential model registration.        *)
(* ========================================================================= *)
BeginPackage["GWPTools`GWPRegistry`"]
If[TrueQ[Global`$GWPDebug], Print["[GWPRegistry] BeginPackage"]];

(* --- Usage Statements --- *)
$GWPRegistry::usage = "$GWPRegistry is a flat list storing the raw registration chunks for all active physical properties.";
$GWPInformation::usage = "$GWPInformation is a nested Association mapping each engine type and property to its structural metadata, such as its ShortKey and Signature Classes.";
$GWPPotentials::usage = "$GWPPotentials is a nested Association mapping each engine type to its registered potential models, including their backend developer symbols, user-facing templates, and categories.";

(* --- Registry Functions --- *)
GWPRegisterExtension::usage = "GWPRegisterExtension[chunk] parses a formatted list of physical properties (a registry chunk) and injects them into $GWPRegistry and $GWPInformation.";
GWPRegisterPotentials::usage = "GWPRegisterPotentials[potChunk, type] parses a formatted list of potential models (a potential chunk) and injects them into the unified $GWPPotentials database for the specified engine type.";

(* --- Messages --- *)
GWPRegisterExtension::reinit = "Warning: The GWPRegistry is being re-initialized. All previous registrations have been cleared.";
GWPRegisterExtension::badformat = "Invalid property registration chunk format. Expected 6 elements, but received `1`: `2`";
GWPRegisterPotentials::badformat = "Invalid potential registration chunk format for engine `1`. Expected 4 elements, but received `2`: `3`";

Begin["`Private`"]
If[TrueQ[Global`$GWPDebug], Print["[GWPRegistry] Begin Private"]];


(* ::Section::Closed:: *)
(*Initialize Registry*)


(* --- Initialize Registry Lists --- *)
If[ValueQ[$GWPRegistry] && Length[$GWPRegistry] > 0,
  Message[GWPRegisterExtension::reinit]
];

(* --- Initialize Registry Lists --- *)
$GWPRegistry = {};
$GWPInformation = Association[];

(* --- Unified Potential Database --- *)
$GWPPotentials = Association[];


(* ::Section::Closed:: *)
(*Property Registration*)


(* --- Property Registration --- *)
GWPRegisterExtension[registryChunk_List] := Module[{},
  $GWPRegistry = DeleteDuplicates[Join[$GWPRegistry, registryChunk]];
  $GWPInformation = Association[];
  
  Scan[
    Function[{row},
      If[Length[row] == 6,
        Module[{long, short, dyn, stat, cat, type},
          {long, short, dyn, stat, cat, type} = row;
          
          If[!KeyExistsQ[$GWPInformation, type], $GWPInformation[type] = Association[]];
          
          $GWPInformation[type][long] = Association[
            "ShortKey"      -> short,
            "DynamicClass"  -> dyn,
            "StaticClass"   -> stat,
            "PropertyClass" -> cat
          ];
        ],
        (* If format is wrong, message and skip *)
        Message[GWPRegisterExtension::badformat, Length[row], row]
      ]
    ],
    $GWPRegistry
  ];
];


(* ::Section::Closed:: *)
(*Potential Model Registration*)


(* --- Potential Model Registration --- *)
GWPRegisterPotentials[potChunk_List, type_String] := Module[{},
  If[!KeyExistsQ[$GWPPotentials, type], $GWPPotentials[type] = Association[]];
  
  Scan[
    Function[{row},
      If[Length[row] == 4,
        Module[{name, sym, template, category},
          {name, sym, template, category} = row;
          $GWPPotentials[type][name] = Association[
            "BackendSymbol" -> sym,
            "Template"      -> template,
            "Category"      -> category
          ];
        ],
        (* If format is wrong, message and skip *)
        Message[GWPRegisterPotentials::badformat, type, Length[row], row]
      ]
    ],
    potChunk
  ];
];


(* ::Section::Closed:: *)
(*End*)


(* --- End "GWPTools`GWPRegistry`Private`" --- *)
If[TrueQ[Global`$GWPDebug], Print["[GWPRegistry] End Private"]];
End[]

(* Hide internal code for all Developer functions from the ? menu *)
SetAttributes[Evaluate[Names["GWPTools`GWPRegistry`*"]], {ReadProtected}];

(* --- End "GWPTools`GWPRegistry`" --- *)
If[TrueQ[Global`$GWPDebug], Print["[GWPRegistry] EndPackage"]];
EndPackage[]

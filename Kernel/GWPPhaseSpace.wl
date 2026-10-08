(* ::Package:: *)

(* ::Title:: *)
(*GWPPhaseSpace Package*)


(* ::Section::Closed:: *)
(*BeginPackage*)


(* ========================================================================= *)
(* PACKAGE     : GWPTools`GWPPhaseSpace`                                     *)
(* DESCRIPTION : Master orchestrator for Phase Space extensions.             *)
(*               Dynamically loads subpackages based on active GWP engines.  *)
(* ========================================================================= *)

BeginPackage["GWPTools`GWPPhaseSpace`"]
If[TrueQ[Global`$GWPDebug], Print["[GWPPhaseSpace] BeginPackage"]];

Begin["`Private`"]
If[TrueQ[Global`$GWPDebug], Print["[GWPPhaseSpace] Begin Private"]];


(* ::Section::Closed:: *)
(*Load Engine Extensions*)


(* Helper to safely load a subpackage if its parent engine is active *)
LoadPhaseSpaceExtension[type_, context_] := Module[{engineParamSymbol, packagePath},
  (* We check if the engine's core parameter builder exists in the kernel *)
  engineParamSymbol = "GWPTools`GWPDeveloper`GWP" <> type <> "PARAM";
  
  If[NameQ[engineParamSymbol],
    packagePath = "GWPTools`" <> context <> "`";
    If[TrueQ[Global`$GWPDebug], Print["[GWPPhaseSpace] Loading Extension: ", packagePath]];
    Quiet[Needs[packagePath]];
  ]
];

(* Dynamically load available phase space modules *)
LoadPhaseSpaceExtension["1D", "GWPPhaseSpace1D"];
LoadPhaseSpaceExtension["SS1D", "GWPPhaseSpaceSS1D"];
(* Add 2D and SS2D later as they are developed *)


(* ::Section::Closed:: *)
(*End*)


(* --- End "GWPTools`GWPPhaseSpace`Private`" --- *)
If[TrueQ[Global`$GWPDebug], Print["[GWPPhaseSpace] End Private"]];
End[]

(* Hide internal code for all Developer functions from the ? menu *)
SetAttributes[Evaluate[Names["GWPTools`GWPPhaseSpace`*"]], {ReadProtected}];

(* --- End "GWPTools`GWPPhaseSpace`" --- *)
If[TrueQ[Global`$GWPDebug], Print["[GWPPhaseSpace] EndPackage"]];
EndPackage[]

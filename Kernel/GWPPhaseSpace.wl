(* ::Package:: *)

(* ========================================================================= *)
(* PACKAGE     : GWPTools`GWPPhaseSpace`                                     *)
(* DESCRIPTION : Master orchestrator for Phase Space extensions.             *)
(*               Dynamically loads subpackages based on active GWP engines.  *)
(* ========================================================================= *)

BeginPackage["GWPTools`GWPPhaseSpace`"]
(* You can place general Master Usage statements here if needed, or leave blank *)

Begin["`Private`"]

(* Helper to safely load a subpackage if its parent engine is active *)
LoadPhaseSpaceExtension[type_, context_] := Module[{engineParamSymbol, packagePath},
  (* We check if the engine's core parameter builder exists in the kernel *)
  engineParamSymbol = "GWPTools`GWPDeveloper`GWP" <> type <> "PARAM";
  
  If[NameQ[engineParamSymbol],
    packagePath = "GWPTools`" <> context <> "`";
    Quiet[Needs[packagePath]];
  ]
];

(* Dynamically load available phase space modules *)
LoadPhaseSpaceExtension["1D", "GWPPhaseSpace1D"];
LoadPhaseSpaceExtension["SS1D", "GWPPhaseSpaceSS1D"];
(* Add 2D and SS2D later as they are developed *)

End[]
EndPackage[]

(* ::Package:: *)

(* ========================================================================= *)
(* PACKAGE     : GWPTools`GWPHydrodynamics`                                  *)
(* DESCRIPTION : Master orchestrator for Quantum Fluid Dynamics extensions.  *)
(*               Dynamically loads subpackages based on active GWP engines.  *)
(* ========================================================================= *)

BeginPackage["GWPTools`GWPHydrodynamics`"]
(* You can place general Master Usage statements here if needed, or leave blank *)

Begin["`Private`"]

(* Helper to safely load a subpackage if its parent engine is active *)
LoadHydroExtension[type_, context_] := Module[{engineParamSymbol, packagePath},
  (* We check if the engine's core parameter builder exists in the kernel *)
  engineParamSymbol = "GWPTools`GWPDeveloper`GWP" <> type <> "PARAM";
  
  If[NameQ[engineParamSymbol],
    packagePath = "GWPTools`" <> context <> "`";
    Quiet[Needs[packagePath]];
  ]
];

(* Dynamically load available hydrodynamics modules *)
LoadHydroExtension["1D", "GWPHydrodynamics1D"];
LoadHydroExtension["SS1D", "GWPHydrodynamicsSS1D"];
(*
LoadHydroExtension["2D", "GWPHydrodynamics2D"];
*)

End[]
EndPackage[]

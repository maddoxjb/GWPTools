(* ::Package:: *)

(* ::Title:: *)
(*GWPHydrodynamics Package*)


(* ::Section::Closed:: *)
(*BeginPackage*)


(* ========================================================================= *)
(* PACKAGE     : GWPTools`GWPHydrodynamics`                                  *)
(* DESCRIPTION : Master orchestrator for Quantum Hydrodynamics extensions.   *)
(* ========================================================================= *)

BeginPackage["GWPTools`GWPHydrodynamics`"]
If[TrueQ[Global`$GWPDebug], Print["[GWPHydrodynamics] BeginPackage"]];

Begin["`Private`"]
If[TrueQ[Global`$GWPDebug], Print["[GWPHydrodynamics] Begin Private"]];

Needs["GWPTools`"];
Needs["GWPTools`GWPRegistry`"];


(* ::Section::Closed:: *)
(*Load Engine Extensions*)


LoadHydroExtension[type_, context_] := Module[{engineParamSymbol, packagePath},
  engineParamSymbol = "GWPTools`GWPDeveloper`GWP" <> type <> "PARAM";
  If[NameQ[engineParamSymbol],
    packagePath = "GWPTools`" <> context <> "`";
    If[TrueQ[Global`$GWPDebug], Print["[GWPHydrodynamics] Loading Extension: ", packagePath]];
    Quiet[Needs[packagePath]];
  ]
];

LoadHydroExtension["1D", "GWPHydrodynamics1D"];
LoadHydroExtension["SS1D", "GWPHydrodynamicsSS1D"];
LoadHydroExtension["MC1D", "GWPHydrodynamicsMC1D"];
LoadHydroExtension["2D", "GWPHydrodynamics2D"];


(* ::Section::Closed:: *)
(*End*)


(* --- End "GWPTools`GWPHydrodynamics`Private`" --- *)
If[TrueQ[Global`$GWPDebug], Print["[GWPHydrodynamics] End Private"]];
End[]

(* Hide internal code for all Developer functions from the ? menu *)
SetAttributes[Evaluate[Names["GWPTools`GWPHydrodynamics`*"]], {ReadProtected}];

(* --- End "GWPTools`GWPHydrodynamics`" --- *)
If[TrueQ[Global`$GWPDebug], Print["[GWPHydrodynamics] EndPackage"]];
EndPackage[]

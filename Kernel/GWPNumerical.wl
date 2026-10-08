(* ::Package:: *)

(* ::Title:: *)
(*GWPNumerical Package*)


(* ::Section::Closed:: *)
(*GWPTools Usage Registration*)


(*BeginPackage["GWPTools`"]
If[TrueQ[Global`$GWPDebug], Print["[GWPNumerical] BeginPackage GWPTools"]];

(* The Numerical Extension operates entirely via the Potential Registry. *)
(* No new top-level GWPTools usage symbols are strictly required.        *)

If[TrueQ[Global`$GWPDebug], Print["[GWPNumerical] EndPackage GWPTools"]];
EndPackage[]*)


(* ::Section::Closed:: *)
(*BeginPackage*)


(* ========================================================================= *)
(* PACKAGE     : GWPTools`GWPNumerical`                                      *)
(* DESCRIPTION : Master orchestrator for Numerical Potential extensions.     *)
(* ========================================================================= *)

BeginPackage["GWPTools`GWPNumerical`"]
If[TrueQ[Global`$GWPDebug], Print["[GWPNumerical] BeginPackage"]];
Begin["`Private`"]
If[TrueQ[Global`$GWPDebug], Print["[GWPNumerical] Begin Private"]];

Needs["GWPTools`"];
Needs["GWPTools`GWPRegistry`"];


(* ::Section::Closed:: *)
(*Load Engine Extensions*)


LoadNumericalExtension[type_, context_] := Module[{engineParamSymbol, packagePath},
  engineParamSymbol = "GWPTools`GWPDeveloper`GWP" <> type <> "PARAM";
  If[NameQ[engineParamSymbol],
    packagePath = "GWPTools`" <> context <> "`";
    If[TrueQ[Global`$GWPDebug], Print["[GWPNumerical] Loading Extension: ", packagePath]];
    Quiet[Needs[packagePath]];
  ]
];

LoadNumericalExtension["1D", "GWPNumerical1D"];
LoadNumericalExtension["SS1D", "GWPNumericalSS1D"];
LoadNumericalExtension["MC1D", "GWPNumericalMC1D"];
LoadNumericalExtension["RDM1D", "GWPNumericalRDM1D"];
LoadNumericalExtension["2D", "GWPNumerical2D"];


(* ::Section::Closed:: *)
(*End*)


(* --- End "GWPTools`GWPNumerical`Private`" --- *)
If[TrueQ[Global`$GWPDebug], Print["[GWPNumerical] End Private"]];
End[]

(* Hide internal code for all Developer functions from the ? menu *)
SetAttributes[Evaluate[Names["GWPTools`GWPNumerical`*"]], {ReadProtected}];

(* --- End "GWPTools`GWPNumerical`" --- *)
If[TrueQ[Global`$GWPDebug], Print["[GWPNumerical] EndPackage"]];
EndPackage[]
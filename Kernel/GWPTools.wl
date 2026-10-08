(* ::Package:: *)

(* ::Title:: *)
(*GWPTools Package*)


(* ========================================================================= *)
(* PACKAGE     : GWPTools`                                                   *)
(* DESCRIPTION : The Master Paclet Loader (Facade). Orchestrates the loading *)
(*               sequence for the core registries, dispatchers, and engines. *)
(* ========================================================================= *)

Quiet[Remove["Global`GWP"]];

BeginPackage["GWPTools`"]

If[TrueQ[Global`$GWPDebug], Print["[GWPTools] Initiating Master Boot Sequence..."]];

(* 1. Load the Database *)
If[TrueQ[Global`$GWPDebug], Print["[GWPTools] Loading GWPTools`GWPRegistry`..."]];
Needs["GWPTools`GWPRegistry`"];

(* 2. Load the Dispatcher *)
If[TrueQ[Global`$GWPDebug], Print["[GWPTools] Loading GWPTools`GWPDispatcher`..."]];
Needs["GWPTools`GWPDispatcher`"];

(* 3. Load Stable Math Engines *)
If[TrueQ[Global`$GWPDebug], Print["[GWPTools] Loading GWPTools`GWPEngine1D`..."]];
Needs["GWPTools`GWPEngine1D`"];

(* 4. Load Experimental Engines and Extensions (Gated by Global Flag) *)
If[TrueQ[Global`$GWPExperimental],
  If[TrueQ[Global`$GWPDebug], Print["[GWPTools] Loading Experimental Extensions..."]];
  Needs["GWPTools`GWPEngine2D`"];
  Needs["GWPTools`GWPEngineRDM1D`"];
  Needs["GWPTools`GWPEngineSS1D`"];
  Needs["GWPTools`GWPEngineMC1D`"];
  Needs["GWPTools`GWPHydrodynamics`"];
  Needs["GWPTools`GWPPhaseSpace`"]; 
  (* Expose the Developer context directly *)
  If[TrueQ[Global`$GWPDebug], Print["[GWPTools] Loading GWPDeveloper Context..."]];
  Get["GWPTools`GWPDeveloper`"];
];

If[TrueQ[Global`$GWPDebug], Print["[GWPTools] Master Loading Sequence Complete."]];

EndPackage[]

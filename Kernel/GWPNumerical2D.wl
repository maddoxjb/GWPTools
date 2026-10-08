(* ::Package:: *)

(* ::Title:: *)
(*GWPNumerical2D Package*)


(* ::Section::Closed:: *)
(*GWPDeveloper Usage Registration*)


(* ::Subsection::Closed:: *)
(*BeginPackage*)


(* --- Hoist Usage Statements into the Developer Context --- *)
Needs["GWPTools`GWPDeveloper`"];
BeginPackage["GWPTools`GWPDeveloper`"]

If[TrueQ[Global`$GWPDebug], Print["[GWPNumerical2D] BeginPackage GWPDeveloper"]];

Off[General::shdw];


(* ::Subsection::Closed:: *)
(*Usage Statements*)


GWP2DNUMERICAL::usage = "GWP2DNUMERICAL[V00, V10, V01, V20, V02, V11, tMin, tMax, opts][t][param] evaluates the numerically integrated 2D wavepacket parameters at time t.";
GWP2DNDSolveCache::usage = "GWP2DNDSolveCache is the internal memoization engine for the 2D numerical differential equations.";


(* ::Subsection::Closed:: *)
(*End Package*)


Off[General::shdw];

If[TrueQ[Global`$GWPDebug], Print["[GWPNumerical2D] EndPackage GWPDeveloper"]];

Quiet[EndPackage[], General::shdw]

(* Scrub the Developer context from the global path immediately *)
$ContextPath = DeleteCases[$ContextPath, "GWPTools`GWPDeveloper`"];


(* ::Section::Closed:: *)
(*BeginPackage*)


(* ========================================================================= *)
(* PACKAGE     : GWPTools`GWPNumerical2D`                                    *)
(* DESCRIPTION : Numerical NDSolve integration extensions for 2D GWPs.       *)
(* ========================================================================= *)

BeginPackage["GWPTools`GWPNumerical2D`"]
If[TrueQ[Global`$GWPDebug], Print["[GWPNumerical2D] BeginPackage"]];
Begin["`Private`"]
If[TrueQ[Global`$GWPDebug], Print["[GWPNumerical2D] Begin Private"]];

(* Load dependencies strictly internally *)
Needs["GWPTools`GWPDeveloper`"];
Needs["GWPTools`GWPRegistry`"];
Needs["GWPTools`GWPEngine2D`"];


(* ::Section::Closed:: *)
(*The Numerical Engine*)


GWP2DNUMERICAL::outofbounds = "The requested time `1` is outside the simulated time domain [`2`, `3`].";

(* The internal cache for NDSolve. Runs exactly once per unique 2D configuration. *)
GWP2DNDSolveCache[v00_, v10_, v01_, v20_, v02_, v11_, initList_, tMin_, tMax_, opts___] := 
  GWP2DNDSolveCache[v00, v10, v01, v20, v02, v11, initList, tMin, tMax, opts] = Module[
  {raxx0, iaxx0, rayy0, iayy0, raxy0, iaxy0, rx0, ry0, rpx0, rpy0, rg0, ig0, hbar, mass,
   raxx, iaxx, rayy, iayy, raxy, iaxy, x, y, px, py, rg, ig, t, eqs, inits},
  
  {raxx0, iaxx0, rayy0, iayy0, raxy0, iaxy0, rx0, ry0, rpx0, rpy0, rg0, ig0, hbar, mass} = initList;
  
  eqs = {
    (* 2x2 Real Shape Matrix (AR) Evolution *)
    raxx'[t] == (4 * hbar / mass) * (raxx[t]*iaxx[t] + raxy[t]*iaxy[t]),
    rayy'[t] == (4 * hbar / mass) * (rayy[t]*iayy[t] + raxy[t]*iaxy[t]),
    raxy'[t] == (2 * hbar / mass) * (raxx[t]*iaxy[t] + raxy[t]*iayy[t] + iaxx[t]*raxy[t] + iaxy[t]*rayy[t]),

    (* 2x2 Imaginary Chirp Matrix (AI) Evolution *)
    iaxx'[t] == -(2 * hbar / mass) * (raxx[t]^2 + raxy[t]^2 - iaxx[t]^2 - iaxy[t]^2) + (v20[t] / hbar),
    iayy'[t] == -(2 * hbar / mass) * (rayy[t]^2 + raxy[t]^2 - iayy[t]^2 - iaxy[t]^2) + (v02[t] / hbar),
    iaxy'[t] == -(2 * hbar / mass) * (raxy[t]*(raxx[t] + rayy[t]) - iaxy[t]*(iaxx[t] + iayy[t])) + (v11[t] / (2 * hbar)),

    (* Classical Trajectories in 2D *)
    x'[t]  == px[t] / mass,
    y'[t]  == py[t] / mass,
    px'[t] == -v10[t] - 2 * v20[t] * x[t] - v11[t] * y[t],
    py'[t] == -v01[t] - 2 * v02[t] * y[t] - v11[t] * x[t],

    (* Global Phase Evolution *)
    rg'[t] == ((px[t]^2 + py[t]^2) / (2 * mass)) - (v00[t] + v10[t]*x[t] + v01[t]*y[t] + v20[t]*x[t]^2 + v02[t]*y[t]^2 + v11[t]*x[t]*y[t]) - (hbar^2 / mass) * (raxx[t] + rayy[t]),
    ig'[t] == -(hbar^2 / mass) * (iaxx[t] + iayy[t])
  };

  inits = {
    raxx[tMin] == raxx0, iaxx[tMin] == iaxx0,
    rayy[tMin] == rayy0, iayy[tMin] == iayy0,
    raxy[tMin] == raxy0, iaxy[tMin] == iaxy0,
    x[tMin] == rx0, y[tMin] == ry0,
    px[tMin] == rpx0, py[tMin] == rpy0,
    rg[tMin] == rg0, ig[tMin] == ig0
  };

  Quiet @ NDSolveValue[Join[eqs, inits], 
    {raxx, iaxx, rayy, iayy, raxy, iaxy, x, y, px, py, rg, ig}, 
    {t, tMin, tMax}, opts]
];

(* The Temporal Router maps directly into the standard 17-element 2D parameter bus *)
GWP2DNUMERICAL[v00_, v10_, v01_, v20_, v02_, v11_, tMin_, tMax_, opts___][t_?NumericQ][GWP2DARG] := Module[
  {sol, initList, 
   sRAXX, sIAXX, sRAYY, sIAYY, sRAXY, sIAXY, sX, sY, sPX, sPY, sRG, sIG},
  
  If[t < tMin || t > tMax, 
    Message[GWP2DNUMERICAL::outofbounds, t, tMin, tMax];
    Return[$Failed];
  ];
  
  (* Pack parameters from the automatically bound GWP2DARG macro *)
  initList = {RAXX, IAXX, RAYY, IAYY, RAXY, IAXY, RX, RY, RPX, RPY, RG, IG, HBAR, MASS};
  
  sol = GWP2DNDSolveCache[v00, v10, v01, v20, v02, v11, initList, tMin, tMax, opts];
  
  {sRAXX, sIAXX, sRAYY, sIAYY, sRAXY, sIAXY, sX, sY, sPX, sPY, sRG, sIG} = Through[sol[t]];
  
  (* Output exact parameter sequence mapping expected by the 2D Engine *)
  Sequence @@ {
    sRAXX, sIAXX, sRAYY, sIAYY, sRAXY, sIAXY, 
    sX, sY, sPX, sPY, sRG, sIG, 
    NORM, HBAR, MASS, 
    {v00[t], v10[t], v01[t], v20[t], v02[t], v11[t]}, 
    INIT
  }
];


(* ::Section::Closed:: *)
(*GWPRegistry Setup*)


(* Register the Numerical Potential Model directly to the 2D type *)
$potentialsNumerical2D = {
  {"Numerical", GWP2DNUMERICAL, "{\"Numerical\", V00, V10, V01, V20, V02, V11, TMin, TMax, Opts___}", "Parameterized"}
};

GWPTools`GWPRegistry`GWPRegisterPotentials[$potentialsNumerical2D, "2D"];
Clear[$potentialsNumerical2D];


(* ::Section::Closed:: *)
(*End*)


(* --- End "GWPTools`GWPNumerical2D`Private`" --- *)
If[TrueQ[Global`$GWPDebug], Print["[GWPNumerical2D] End Private"]];
End[]

(* Hide internal code for all Developer functions from the ? menu *)
SetAttributes[Evaluate[Names["GWPTools`GWPNumerical2D`*"]], {ReadProtected}];

(* --- End "GWPTools`GWPNumerical2D`" --- *)
If[TrueQ[Global`$GWPDebug], Print["[GWPNumerical2D] EndPackage"]];
EndPackage[]
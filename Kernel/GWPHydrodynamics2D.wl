(* ::Package:: *)

(* ::Title:: *)
(*GWPHydrodynamics2D Package*)


(* ::Section::Closed:: *)
(*GWPDeveloper Usage Declarations*)


(* ::Subsection::Closed:: *)
(*BeginPackage*)


Needs["GWPTools`GWPDeveloper`"];
BeginPackage["GWPTools`GWPDeveloper`"]
If[TrueQ[Global`$GWPDebug], Print["[GWPHydrodynamics2D] BeginPackage GWPDeveloper"]];
Off[General::shdw];



(* ::Subsection::Closed:: *)
(*Usage Declarations*)


(* ::Subsubsection::Closed:: *)
(*x-Space Hydrodynamic Fields*)


(* --- x-Space Hydrodynamic Fields --- *)
GWP2DAX::usage = "GWP2DAX[x, y][param] evaluates the 2D x-space real-valued amplitude.";
GWP2DSX::usage = "GWP2DSX[x, y][param] evaluates the 2D x-space real-valued phase function.";
GWP2DQPX::usage = "GWP2DQPX[x, y][param] evaluates the 2D x-space quantum potential.";

GWP2DVX::usage = "GWP2DVX[x, y][param] evaluates the full 2D x-space velocity vector field. GWP2DVX[c][x, y][param] evaluates the c-th component.";
GWP2DQFX::usage = "GWP2DQFX[x, y][param] evaluates the full 2D x-space quantum force vector field. GWP2DQFX[c][x, y][param] evaluates the c-th component.";



(* ::Subsubsection::Closed:: *)
(*Bohmian Trajectories*)


(* --- Bohmian Trajectories --- *)
GWP2DXC::usage = "GWP2DXC[cr, ct][param] evaluates the full 2D C-space trajectory vector field. GWP2DXC[c][cr, ct][param] evaluates the c-th component.";



(* ::Subsection::Closed:: *)
(*End*)


Off[General::shdw];
If[TrueQ[Global`$GWPDebug], Print["[GWPHydrodynamics2D] EndPackage GWPDeveloper"]];
Quiet[EndPackage[], General::shdw]
$ContextPath = DeleteCases[$ContextPath, "GWPTools`GWPDeveloper`"];



(* ::Section::Closed:: *)
(*BeginPackage*)


(* ========================================================================= *)
(* PACKAGE     : GWPTools`GWPHydrodynamics2D`                                *)
(* DESCRIPTION : 2D Quantum fluid dynamics and Bohmian trajectories          *)
(* ========================================================================= *)
BeginPackage["GWPTools`GWPHydrodynamics2D`"]
If[TrueQ[Global`$GWPDebug], Print["[GWPHydrodynamics2D] BeginPackage"]];
Begin["`Private`"]
If[TrueQ[Global`$GWPDebug], Print["[GWPHydrodynamics2D] Begin Private"]];

Needs["GWPTools`GWPDeveloper`"];
Needs["GWPTools`GWPRegistry`"];
Needs["GWPTools`GWPEngine2D`"];



(* ::Section::Closed:: *)
(*x-Space Hydrodynamic Fields*)


(* --- x-Space Fields --- *)
GWP2DAX[x_, y_][GWP2DARG] = NORM * Exp[-(RAXX*(x - RX)^2 + RAYY*(y - RY)^2 + 2*RAXY*(x - RX)*(y - RY))];

(* --- x-Space Phase Field --- *)
GWP2DSX[x_, y_][GWP2DARG] = RG + RPX*(x - RX) + RPY*(y - RY) - 
  HBAR*IAXX*(x - RX)^2 - HBAR*IAYY*(y - RY)^2 - 2*HBAR*IAXY*(x - RX)*(y - RY);

(* --- x-Space Velocity Vector Field --- *)
GWP2DVX[1][x_, y_][GWP2DARG] = (RPX - 2*HBAR*IAXX*(x - RX) - 2*HBAR*IAXY*(y - RY))/MASS;
GWP2DVX[2][x_, y_][GWP2DARG] = (RPY - 2*HBAR*IAYY*(y - RY) - 2*HBAR*IAXY*(x - RX))/MASS;

GWP2DVX[x_, y_][GWP2DARG] = {
  GWP2DVX[1][x, y][GWP2DVAL], 
  GWP2DVX[2][x, y][GWP2DVAL]
};

GWP2DQPX[x_, y_][GWP2DARG] = (HBAR^2/MASS) * ((RAXX + RAYY) - 
  2*(RAXX*(x - RX) + RAXY*(y - RY))^2 - 
  2*(RAYY*(y - RY) + RAXY*(x - RX))^2);

(* --- x-Space Quantum Force Vector Field --- *)
GWP2DQFX[1][x_, y_][GWP2DARG] = (4*HBAR^2/MASS) * 
  (RAXX*(RAXX*(x - RX) + RAXY*(y - RY)) + RAXY*(RAYY*(y - RY) + RAXY*(x - RX)));

GWP2DQFX[2][x_, y_][GWP2DARG] = (4*HBAR^2/MASS) * 
  (RAXY*(RAXX*(x - RX) + RAXY*(y - RY)) + RAYY*(RAYY*(y - RY) + RAXY*(x - RX)));

GWP2DQFX[x_, y_][GWP2DARG] = {
  GWP2DQFX[1][x, y][GWP2DVAL], 
  GWP2DQFX[2][x, y][GWP2DVAL]
};



(* ::Section::Closed:: *)
(*Bohmian Trajectories*)


(* --- C-Space Trajectories --- *)
With[{VAL = GWP2DVAL},
  
  (* Component 1: X-Coordinate Mapping *)
  GWP2DXC[1][cr_, ct_][GWP2DARG] := Module[{phi},
    phi = If[RAXX == RAYY && RAXY == 0, 0, ArcTan[RAXX - RAYY, 2*RAXY]/2];
    RX + (Cos[2*ct*Pi]*Cos[phi]*
       Sqrt[((RAXX - Sqrt[4*RAXY^2 + (RAXX - RAYY)^2] + RAYY)*
          Log[1 - cr])/(RAXY^2 - RAXX*RAYY)])/2 - 
     (Sqrt[((RAXX + Sqrt[4*RAXY^2 + (RAXX - RAYY)^2] + RAYY)*Log[1 - cr])/
         (RAXY^2 - RAXX*RAYY)]*Sin[2*ct*Pi]*Sin[phi])/2
  ];

  (* Component 2: Y-Coordinate Mapping *)
  GWP2DXC[2][cr_, ct_][GWP2DARG] := Module[{phi},
    phi = If[RAXX == RAYY && RAXY == 0, 0, ArcTan[RAXX - RAYY, 2*RAXY]/2];
    (2*RY + Cos[phi]*
       Sqrt[((RAXX + Sqrt[4*RAXY^2 + (RAXX - RAYY)^2] + RAYY)*
          Log[1 - cr])/(RAXY^2 - RAXX*RAYY)]*Sin[2*ct*Pi] + 
     Cos[2*ct*Pi]*Sqrt[((RAXX - Sqrt[4*RAXY^2 + (RAXX - RAYY)^2] + RAYY)*
          Log[1 - cr])/(RAXY^2 - RAXX*RAYY)]*Sin[phi])/2
  ];

  (* Full Vector Field Output *)
  GWP2DXC[cr_, ct_][GWP2DARG] := {
    GWP2DXC[1][cr, ct][VAL], 
    GWP2DXC[2][cr, ct][VAL]
  };
]



(* ::Section::Closed:: *)
(*GWPObject Registration*)


(* --- GWPObject Registry (2D Hydrodynamics) --- *)
$regHydroX2D = Join[#, {"HydrodynamicsX", "2D"}] & /@ {
  (* Scalar Fields: [x, y] -> Scalar *)
  {"AmplitudeX",        "AX",  "Bivariate",            "BivariateSpatial"},
  {"PhaseX",            "SX",  "Bivariate",            "BivariateSpatial"},
  {"QuantumPotentialX", "QPX", "Bivariate",            "BivariateSpatial"},
  
  (* Vector Fields: [x, y] -> {vx, vy} *)
  {"VelocityX",         "VX",  "BivariateVectorField", "BivariateVectorFieldSpatial"},
  {"QuantumForceX",     "QFX", "BivariateVectorField", "BivariateVectorFieldSpatial"}
};

$regTraj2D = Join[#, {"BohmianTrajectories", "2D"}] & /@ {
  {"TrajectoryFieldX",  "XC",  "BivariateVectorField", "BivariateVectorFieldSpatial"}
};

(* Register the new fields *)
GWPTools`GWPRegistry`GWPRegisterExtension[Join[$regHydroX2D,$regTraj2D]];

(* Clean up temporary registry variables *)
Clear[$regHydroX2D,$regTraj2D];



(* ::Section::Closed:: *)
(*End*)


(* --- End "GWPTools`GWPHydrodynamics2D`Private`" --- *)
If[TrueQ[Global`$GWPDebug], Print["[GWPHydrodynamics2D] End Private"]];
End[]

SetAttributes[Evaluate[Names["GWPTools`GWPHydrodynamics2D`*"]], {ReadProtected}];

(* --- End "GWPTools`GWPHydrodynamics2D`" --- *)
If[TrueQ[Global`$GWPDebug], Print["[GWPHydrodynamics2D] EndPackage"]];
EndPackage[]

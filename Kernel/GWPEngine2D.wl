(* ::Package:: *)

(* ::Title:: *)
(*GWPEngine2D Package*)


(* ::Section::Closed:: *)
(*GWPDeveloper Usage Registration*)


(* ::Subsection::Closed:: *)
(*BeginPackage*)


(* --- Hoist Usage Statements into the Developer Context --- *)
Needs["GWPTools`GWPDeveloper`"]
BeginPackage["GWPTools`GWPDeveloper`"]

If[TrueQ[Global`$GWPDebug], Print["[GWPEngine2D] BeginPackage GWPDeveloper"]];

Off[General::shdw];


(* ::Subsection::Closed:: *)
(*Usage Statements*)


(* ::Subsubsection::Closed:: *)
(*Parameters*)


(* --- GWP2D Paramater Bus --- *)
GWP2DARG::usage = "GWP2DARG is the developer macro for the parameter sequence pattern.";
GWP2DVAL::usage = "GWP2DVAL is the developer macro for the parameter sequence values.";

(* --- GWP2D Parameter Generation --- *)
GWP2DPARAM::usage = "GWP2DPARAM[AA, XX, PP, GG, opts] constructs the 17-element 2D GWP parameter sequence. Unprovided arguments default to standardized zero-states.";

(* --- GWP2D Parameter Extraction --- *)
GWP2DRAXX::usage = "GWP2DRAXX[param] extracts the real xx shape parameter (RAXX).";
GWP2DIAXX::usage = "GWP2DIAXX[param] extracts the imaginary xx shape parameter (IAXX).";
GWP2DRAYY::usage = "GWP2DRAYY[param] extracts the real yy shape parameter (RAYY).";
GWP2DIAYY::usage = "GWP2DIAYY[param] extracts the imaginary yy shape parameter (IAYY).";
GWP2DRAXY::usage = "GWP2DRAXY[param] extracts the real xy cross-shape parameter (RAXY).";
GWP2DIAXY::usage = "GWP2DIAXY[param] extracts the imaginary xy cross-shape parameter (IAXY).";
GWP2DRX::usage = "GWP2DRX[param] extracts the position center x-coordinate (RX).";
GWP2DRY::usage = "GWP2DRY[param] extracts the position center y-coordinate (RY).";
GWP2DRPX::usage = "GWP2DRPX[param] extracts the momentum center x-coordinate (RPX).";
GWP2DRPY::usage = "GWP2DRPY[param] extracts the momentum center y-coordinate (RPY).";
GWP2DRG::usage = "GWP2DRG[param] extracts the real global phase (RG).";
GWP2DIG::usage = "GWP2DIG[param] extracts the imaginary global phase (IG).";
GWP2DNORM::usage = "GWP2DNORM[param] extracts the normalization constant.";
GWP2DHBAR::usage = "GWP2DHBAR[param] extracts the reduced Planck constant.";
GWP2DMASS::usage = "GWP2DMASS[param] extracts the system mass.";
GWP2DPECOEFF::usage = "GWP2DPECOEFF[param] extracts the list of potential energy coefficients {V00, V10, V01, V20, V02, V11}.";
GWP2DINPUT::usage = "GWP2DINPUT[param] extracts the original user input parameter list.";
GWP2DINIT::usage = "GWP2DINIT[param] extracts the core 12-element initial wavepacket parameter list.";

(* --- GWP2D Parameter Assumptions --- *)
GWP2DASSUMPTIONS::usage = "GWP2DASSUMPTIONS[GWP2DARG, opts] generates the core physical, geometric, and domain assumptions for 2D wavepacket parameters to aid symbolic integration and simplification. Accepts options for Position, Momentum, Time, Energy, Cumulative, and IntegerVariables.";

(* --- GWP2D Four-Eight-Six Parameter Engine --- *)
GWP2D486::usage = "GWP2D486[A1, X1, P1, G1, HBAR, MASS] is the internal 2D parser that resolves complex inputs into purely real phase space centers.";

(* --- Vectors and Matrices --- *)
GWP2DRMAT::usage = "GWP2DRMAT[param] constructs the 2D position vector {RX, RY}.";
GWP2DRPMAT::usage = "GWP2DRPMAT[param] constructs the 2D momentum vector {RPX, RPY}.";

GWP2DSHAPEMAT::usage = "GWP2DSHAPEMAT[param] constructs the 2x2 real shape matrix (AR).";
GWP2DCHIRPMAT::usage = "GWP2DCHIRPMAT[param] constructs the 2x2 imaginary chirp matrix (AI).";
GWP2DALPHAMAT::usage = "GWP2DALPHAMAT[param] constructs the 2x2 complex width matrix (Alpha = AR + i AI).";

(* --- Covariance and Spread --- *)
GWP2DCOVMAT::usage = "GWP2DCOVMAT[param] calculates the 2x2 spatial covariance matrix (Inverse[4 AR]).";
GWP2DUX::usage = "GWP2DUX[param] calculates the spatial uncertainty (spread) along the x-axis.";
GWP2DUY::usage = "GWP2DUY[param] calculates the spatial uncertainty (spread) along the y-axis.";
GWP2DCOVXY::usage = "GWP2DCOVXY[param] calculates the spatial covariance between the x and y axes.";

GWP2DINJECTPOTENTIAL::usage = "GWP2DINJECTPOTENTIAL[PARAM, newPECOEFF] takes a valid 2D parameter sequence and replaces the potential array slot with newPECOEFF, returning the updated Sequence.";

(* --- UI Builder --- *)
GWP2DUI::usage = "GWP2DUI[data] generates the formatted visible and hidden grid elements for the frontend 2D Summary Box.";


(* ::Subsubsection::Closed:: *)
(*Potential Models*)


(* --- GWP2D Potential Models --- *) 
GWP2DFREE::usage = "GWP2DFREE[t][GWP2DARG] propagates the 2D wavepacket in free space (zero potential) by evaluating GWP2DLINEAR[0, 0, 0].";
GWP2DHO::usage = "GWP2DHO[t][GWP2DARG] propagates the 2D wavepacket in a standard, uncoupled unit-frequency harmonic oscillator.";
GWP2DCOUPLEDHO::usage = "GWP2DCOUPLEDHO[t][GWP2DARG] propagates the 2D wavepacket in a standard coupled harmonic oscillator with unit base frequencies and a 1/2 coupling strength.";
GWP2DLINEAR::usage = "GWP2DLINEAR[V00, V10, V01][t][GWP2DARG] propagates the 2D wavepacket in a uniform linear field defined by V(x,y) = V00 + V10 x + V01 y.";
GWP2DHARMONIC::usage = "GWP2DHARMONIC[omegaX, omegaY, omegaXY][t][GWP2DARG] propagates the 2D wavepacket in a coupled harmonic oscillator potential defined by V(x,y) = 1/2 m omegaX^2 x^2 + 1/2 m omegaY^2 y^2 + m omegaXY^2 x y.";

(* --- GWP2D Potential Energy and Force Functions --- *)
GWP2DPEX::usage = "GWP2DPEX[x, y][param] evaluates the 2D spatial external potential energy field.";
GWP2DFEX::usage = "GWP2DFEX[x, y][param] evaluates the full 2D spatial external force vector field. GWP2DFEX[c][x, y][param] evaluates the c-th component.";


(* ::Subsubsection::Closed:: *)
(*Properties*)


(* --- 2D Core Functions --- *)
GWP2DPSIX::usage = "GWP2DPSIX[x, y][param] evaluates the complex-valued spatial wavefunction in 2D.";
GWP2DRHOX::usage = "GWP2DRHOX[x, y][param] evaluates the real-valued spatial probability density in 2D.";


(* ::Subsection::Closed:: *)
(*EndPackage*)


Off[General::shdw];

If[TrueQ[Global`$GWPDebug], Print["[GWPEngine2D] EndPackage GWPDeveloper"]];

Quiet[EndPackage[], General::shdw]

(* Scrub the Developer context from the global path immediately *)
$ContextPath = DeleteCases[$ContextPath, "GWPTools`GWPDeveloper`"];


(* ::Section::Closed:: *)
(*BeginPackage*)


(* ========================================================================= *)
(* PACKAGE     : GWPTools`GWPEngine2D`                                       *)
(* DESCRIPTION : 2D Gaussian Wavepacket Core Engine                          *)
(* ========================================================================= *)

BeginPackage["GWPTools`GWPEngine2D`"]
If[TrueQ[Global`$GWPDebug], Print["[GWPEngine2D] BeginPackage"]];

Begin["`Private`"]
If[TrueQ[Global`$GWPDebug], Print["[GWPEngine2D] Begin Private"]];

Needs["GWPTools`GWPDeveloper`"];
Needs["GWPTools`GWPRegistry`"];


(* ::Section::Closed:: *)
(*Parameters*)


(* ::Subsection::Closed:: *)
(*GWP2DARG/GWP2DVAL*)


(* --- 2D Parameter Sequence Macros --- *)
GWP2DARG = Sequence[RAXX_, IAXX_, RAYY_, IAYY_, RAXY_, IAXY_, RX_, RY_, RPX_, RPY_, RG_, IG_, NORM_, HBAR_, MASS_, {V00_, V10_, V01_, V20_, V02_, V11_}, INIT_];
GWP2DVAL = Sequence[RAXX, IAXX, RAYY, IAYY, RAXY, IAXY, RX, RY, RPX, RPY, RG, IG, NORM, HBAR, MASS, {V00, V10, V01, V20, V02, V11}, INIT];

GWP2DINJECTPOTENTIAL[GWP2DARG, newPECOEFF_] := Sequence[
  RAXX, IAXX, RAYY, IAYY, RAXY, IAXY, 
  RX, RY, RPX, RPY, RG, IG, 
  NORM, HBAR, MASS, 
  newPECOEFF,
  INIT
];


(* ::Subsection::Closed:: *)
(*GWP2DPARAM*)


(* --- Constructor Options --- *)
Options[GWP2DPARAM] = {"HBAR" -> 1, "MASS" -> 1};

(* --- Parameter Generator --- *)
GWP2DPARAM[
  AA : Except[_Rule | _RuleDelayed] : {{1, 0}, {0, 1}}, 
  XX : Except[_Rule | _RuleDelayed] : {0, 0}, 
  PP : Except[_Rule | _RuleDelayed] : {0, 0}, 
  GG : Except[_Rule | _RuleDelayed] : 0, 
  opts : OptionsPattern[]
] := Module[{h, m, invalidOpts},
  
  (* Catch Unknown Options *)
  invalidOpts = FilterRules[{opts}, Except[Options[GWP2DPARAM]]];
  If[Length[invalidOpts] > 0,
    Message[General::optx, First[First[invalidOpts]], HoldForm[GWP2DPARAM]];
    Return[$Failed]
  ];

  (* Extract Option Values *)  
  h = OptionValue["HBAR"];
  m = OptionValue["MASS"];

  (* Enforce strictly positive physical constants and completely reject lists *)
  If[!GWPScalarQ[h] || TrueQ[h <= 0], Message[GWP2DPARAM::posval, "HBAR", h]; Return[$Failed]];
  If[!GWPScalarQ[m] || TrueQ[m <= 0], Message[GWP2DPARAM::posval, "MASS", m]; Return[$Failed]];

  (* Proceed to parser *)
  GWP2D486[AA, XX, PP, GG, h, m]
];


(* ::Subsection::Closed:: *)
(*GWP2D486*)


(* --- Messages --- *)
GWP2D486::unnorm = "The determinant of the real shape matrix (`1`) must be strictly positive.";
GWP2D486::complex = "Width matrix parameters must evaluate to numeric real or complex values.";

(* --- The Core Parser --- *)
GWP2D486[A1_, X1_, P1_, G1_, HBAR_, MASS_] := Module[
  {RAXX1, IAXX1, RAYY1, IAYY1, RAXY1, IAXY1, RX1, IX1, RY1, IY1, RPX1, IPX1, RPY1, IPY1, RG1, IG1,
   RAXX2, IAXX2, RAYY2, IAYY2, RAXY2, IAXY2, RX2, RY2, RPX2, RPY2, RG2, IG2, 
   NORM, PECOEFF, INIT, detRA, PARAM},

  (* --- Complex Expand Input Parameters --- *)  
  (* Extract Complex Matrix Elements *)
  {RAXX1, IAXX1} = ComplexExpand[ReIm[A1[[1, 1]]]];
  {RAYY1, IAYY1} = ComplexExpand[ReIm[A1[[2, 2]]]];
  {RAXY1, IAXY1} = ComplexExpand[ReIm[A1[[1, 2]]]];  
  (* Extract Complex Vectors *)
  {RX1, IX1} = ComplexExpand[ReIm[X1[[1]]]];
  {RY1, IY1} = ComplexExpand[ReIm[X1[[2]]]];
  {RPX1, IPX1} = ComplexExpand[ReIm[P1[[1]]]];
  {RPY1, IPY1} = ComplexExpand[ReIm[P1[[2]]]];  
  (* Extract Complex Phase *)
  {RG1, IG1} = ComplexExpand[ReIm[G1]];
  
  (* --- Physics Validation --- *)
  detRA = RAXX1 * RAYY1 - RAXY1^2;
  If[TrueQ[detRA <= 0], Message[GWP2D486::unnorm, detRA]; Return[$Failed]];

  (* --- Rearrange to Double-Primed Real Parameters --- *)  
  (* Unchanged Shape Parameters *)
  RAXX2 = RAXX1; IAXX2 = IAXX1;
  RAYY2 = RAYY1; IAYY2 = IAYY1;
  RAXY2 = RAXY1; IAXY2 = IAXY1;
  (* Real Position Center *)
  RX2 = (-((IPY1 + 2*HBAR*(IAXY1*IX1 + IAYY1*IY1))*RAXY1) + (IPX1 + 2*HBAR*(IAXX1*IX1 + IAXY1*IY1))*RAYY1)/(2*HBAR*(RAXY1^2 - RAXX1*RAYY1)) + RX1;
  RY2 = (IPY1*RAXX1 + 2*HBAR*(IAXY1*IX1 + IAYY1*IY1)*RAXX1 - (IPX1 + 2*HBAR*(IAXX1*IX1 + IAXY1*IY1))*RAXY1)/(2*HBAR*(RAXY1^2 - RAXX1*RAYY1)) + RY1;
  (* Real Momentum Center *)
  RPX2 = (2*HBAR*IAXY1^2*(-(IX1*RAXX1) + IY1*RAXY1) - 2*HBAR*IAXX1^2*IX1*RAYY1 + IAXX1*(IPY1*RAXY1 + 2*HBAR*IAYY1*IY1*RAXY1 - IPX1*RAYY1) + IAXY1*(-(IPY1*RAXX1) + IPX1*RAXY1 - 2*HBAR*(IAYY1*IY1*RAXX1 - 2*IAXX1*IX1*RAXY1 + IAXX1*IY1*RAYY1)) + (RAXY1^2 - RAXX1*RAYY1)*(2*HBAR*IX1*RAXX1 + 2*HBAR*IY1*RAXY1 + RPX1))/(RAXY1^2 - RAXX1*RAYY1);
  RPY2 = (-(IAYY1*(IPY1 + 2*HBAR*IAXY1*IX1)*RAXX1) - 2*HBAR*IAYY1^2*IY1*RAXX1 + IAXY1*IPY1*RAXY1 + IAYY1*(IPX1 + 2*HBAR*IAXX1*IX1 + 4*HBAR*IAXY1*IY1)*RAXY1 - IAXY1*(IPX1 + 2*HBAR*IAXX1*IX1)*RAYY1 + 2*HBAR*IAXY1^2*(IX1*RAXY1 - IY1*RAYY1) + (RAXY1^2 - RAXX1*RAYY1)*(2*HBAR*IX1*RAXY1 + 2*HBAR*IY1*RAYY1 + RPY1))/(RAXY1^2 - RAXX1*RAYY1);
  (* Shifted Phase *)
  RG2 = -1/4*(4*HBAR^2*IAYY1^3*IY1^2*RAXX1^2 + IAXX1*IPY1^2*RAXY1^2 + 4*HBAR^2*IAXX1*IX1^2*RAXY1^4 - 4*HBAR*IAYY1^2*IY1*(-((IPY1 + 2*HBAR*IAXY1*IX1)*RAXX1^2) + (IPX1 + 2*HBAR*IAXX1*IX1 + 4*HBAR*IAXY1*IY1)*RAXX1*RAXY1 - HBAR*IAXX1*IY1*RAXY1^2) - 2*IAXX1*IPX1*IPY1*RAXY1*RAYY1 - 4*HBAR*IAXX1^2*IPY1*IX1*RAXY1*RAYY1 - 8*HBAR^2*IAXX1*IX1^2*RAXX1*RAXY1^2*RAYY1 + IAXX1*IPX1^2*RAYY1^2 + 4*HBAR*IAXX1^2*IPX1*IX1*RAYY1^2 + 4*HBAR^2*IAXX1^3*IX1^2*RAYY1^2 + 4*HBAR^2*IAXX1*IX1^2*RAXX1^2*RAYY1^2 - 8*HBAR^2*IAXY1^3*(IX1*RAXX1 - IY1*RAXY1)*(IX1*RAXY1 - IY1*RAYY1) + 4*HBAR*IAXY1^2*(-2*IPY1*IX1*RAXX1*RAXY1 + IX1*(IPX1 + 3*HBAR*IAXX1*IX1)*RAXY1^2 + IX1*(IPX1 + 2*HBAR*IAXX1*IX1)*RAXX1*RAYY1 - 2*(IPX1 + 3*HBAR*IAXX1*IX1)*IY1*RAXY1*RAYY1 + HBAR*IAXX1*IY1^2*RAYY1^2 + IPY1*IY1*(RAXY1^2 + RAXX1*RAYY1)) - 4*HBAR*RAXY1^4*RG1 + 8*HBAR*RAXX1*RAXY1^2*RAYY1*RG1 - 4*HBAR*RAXX1^2*RAYY1^2*RG1 + 2*IPY1*RAXY1^3*RPX1 - 2*IPY1*RAXX1*RAXY1*RAYY1*RPX1 - 2*IPX1*RAXY1^2*RAYY1*RPX1 - 4*HBAR*IAXX1*IX1*RAXY1^2*RAYY1*RPX1 + 2*IPX1*RAXX1*RAYY1^2*RPX1 + 4*HBAR*IAXX1*IX1*RAXX1*RAYY1^2*RPX1 + 2*(-(IPY1*RAXX1) + (IPX1 + 2*HBAR*IAXX1*IX1)*RAXY1)*(RAXY1^2 - RAXX1*RAYY1)*RPY1 + IAYY1*(IPY1^2*RAXX1^2 + 4*HBAR*IAXY1*IPY1*IX1*RAXX1^2 - 2*IPY1*(IPX1 + 2*HBAR*IAXX1*IX1 + 6*HBAR*IAXY1*IY1)*RAXX1*RAXY1 + IPX1^2*RAXY1^2 + 4*HBAR*IAXX1*IPY1*IY1*RAXY1^2 + 4*HBAR^2*(IAXX1^2*IX1*RAXY1*(IX1*RAXY1 - 2*IY1*RAYY1) + IY1^2*(RAXY1^2 - RAXX1*RAYY1)^2 + 2*IAXX1*IAXY1*(IX1*RAXY1*(-(IX1*RAXX1) + 3*IY1*RAXY1) + IY1*(IX1*RAXX1 - IY1*RAXY1)*RAYY1) + IAXY1^2*(IX1^2*RAXX1^2 - 6*IX1*IY1*RAXX1*RAXY1 + IY1^2*(3*RAXY1^2 + 2*RAXX1*RAYY1))) + 4*HBAR*(IAXX1*IPX1*RAXY1*(IX1*RAXY1 - IY1*RAYY1) + IAXY1*IPX1*(-(IX1*RAXX1*RAXY1) + 2*IY1*RAXY1^2 + IY1*RAXX1*RAYY1) + IY1*(RAXY1^2 - RAXX1*RAYY1)*(RAXY1*RPX1 - RAXX1*RPY1))) - 2*IAXY1*(IPY1^2*RAXX1*RAXY1 + IPX1^2*RAXY1*RAYY1 - IPY1*(IPX1*(RAXY1^2 + RAXX1*RAYY1) + 2*HBAR*IAXX1*(2*IX1*RAXY1^2 + IX1*RAXX1*RAYY1 - IY1*RAXY1*RAYY1)) + 4*HBAR^2*IX1*(2*IAXX1^2*IX1*RAXY1*RAYY1 - IY1*(RAXY1^4 - 2*RAXX1*RAXY1^2*RAYY1 + (IAXX1^2 + RAXX1^2)*RAYY1^2)) + 2*HBAR*(IAXX1*IPX1*RAYY1*(3*IX1*RAXY1 - IY1*RAYY1) - (RAXY1^2 - RAXX1*RAYY1)*(IX1*RAXY1*RPX1 - IY1*RAYY1*RPX1 - IX1*RAXX1*RPY1 + IY1*RAXY1*RPY1))))/(HBAR*(RAXY1^2 - RAXX1*RAYY1)^2);
  IG2 = (IPY1^2*RAXX1 + 4*HBAR*IPY1*(IAXY1*IX1 + IAYY1*IY1)*RAXX1 - 2*IPY1*(IPX1 + 2*HBAR*(IAXX1*IX1 + IAXY1*IY1))*RAXY1 + IPX1^2*RAYY1 + 4*HBAR^2*(IAYY1^2*IY1^2*RAXX1 - 2*IAXX1*IAYY1*IX1*IY1*RAXY1 - IX1*RAXY1^2*(IX1*RAXX1 + 2*IY1*RAXY1) + (IX1^2*(IAXX1^2 + RAXX1^2) + 2*IX1*IY1*RAXX1*RAXY1 - IY1^2*RAXY1^2)*RAYY1 + IY1^2*RAXX1*RAYY1^2 + IAXY1^2*(IX1^2*RAXX1 - 2*IX1*IY1*RAXY1 + IY1^2*RAYY1) + 2*IAXY1*(IAYY1*IY1*(IX1*RAXX1 - IY1*RAXY1) + IAXX1*IX1*(-(IX1*RAXY1) + IY1*RAYY1))) + 4*HBAR*(-(IAYY1*IPX1*IY1*RAXY1) + IAXX1*IPX1*IX1*RAYY1 + IAXY1*IPX1*(-(IX1*RAXY1) + IY1*RAYY1) + (RAXY1^2 - RAXX1*RAYY1)*(IG1 - IX1*RPX1 - IY1*RPY1)))/(4*HBAR*(RAXY1^2 - RAXX1*RAYY1));
  
  (* --- Normalization, Environment, and Metadata --- *)
  NORM = (4 * detRA / Pi^2)^(1/4) * Exp[IG2 / HBAR];  
  PECOEFF = {0, 0, 0, 0, 0, 0};
  INIT = {RAXX1, IAXX1, RAYY1, IAYY1, RAXY1, IAXY1, RX1, IX1, RY1, IY1, RPX1, IPX1, RPY1, IPY1, RG1, IG1};

  (* --- Return Evaluated Parameter Sequence --- *)  
  PARAM = Sequence @@ {RAXX2, IAXX2, RAYY2, IAYY2, RAXY2, IAXY2, RX2, RY2, RPX2, RPY2, RG2, IG2, NORM, HBAR, MASS, PECOEFF, INIT};
  Sequence @@ Simplify[{PARAM}, GWP2DASSUMPTIONS@PARAM]
];


(* ::Subsection::Closed:: *)
(*Parameter Extractors*)


(* --- GWP2D Parameter Extraction ---*)
GWP2DRAXX[GWP2DARG] = RAXX;
GWP2DIAXX[GWP2DARG] = IAXX;
GWP2DRAYY[GWP2DARG] = RAYY;
GWP2DIAYY[GWP2DARG] = IAYY;
GWP2DRAXY[GWP2DARG] = RAXY;
GWP2DIAXY[GWP2DARG] = IAXY;
GWP2DRX[GWP2DARG] = RX;
GWP2DRY[GWP2DARG] = RY;
GWP2DRPX[GWP2DARG] = RPX;
GWP2DRPY[GWP2DARG] = RPY;
GWP2DRG[GWP2DARG] = RG;
GWP2DIG[GWP2DARG] = IG;
GWP2DNORM[GWP2DARG] = NORM;
GWP2DMASS[GWP2DARG] = MASS;
GWP2DHBAR[GWP2DARG] = HBAR;
GWP2DPECOEFF[GWP2DARG] = {V00, V10, V01, V20, V02, V11};
GWP2DINPUT[GWP2DARG]   = INIT;
GWP2DINIT[GWP2DARG]    = {RAXX, IAXX, RAYY, IAYY, RAXY, IAXY, RX, RY, RPX, RPY, RG, IG};


(* --- Vectors and Matrices --- *)
GWP2DRMAT[GWP2DARG] = {RX, RY};
GWP2DRPMAT[GWP2DARG] = {RPX, RPY};

GWP2DSHAPEMAT[GWP2DARG] = {{RAXX, RAXY}, {RAXY, RAYY}};
GWP2DCHIRPMAT[GWP2DARG] = {{IAXX, IAXY}, {IAXY, IAYY}};
GWP2DALPHAMAT[GWP2DARG] = {{RAXX + I*IAXX, RAXY + I*IAXY}, {RAXY + I*IAXY, RAYY + I*IAYY}};

(* --- Covariance and Spread --- *)
GWP2DCOVMAT[GWP2DARG] = {{RAYY, -RAXY}, {-RAXY, RAXX}} / (4 * (RAXX * RAYY - RAXY^2));
GWP2DUX[GWP2DARG]    = Sqrt[RAYY / (4 * (RAXX * RAYY - RAXY^2))];
GWP2DUY[GWP2DARG]    = Sqrt[RAXX / (4 * (RAXX * RAYY - RAXY^2))];
GWP2DCOVXY[GWP2DARG] = -RAXY / (4 * (RAXX * RAYY - RAXY^2));


(* ::Subsection::Closed:: *)
(*GWP2DASSUMPTIONS*)


(* --- Default Options --- *)
Options[GWP2DASSUMPTIONS] = {
  "Position"         -> None, 
  "Momentum"         -> None, 
  "Cumulative"       -> None, 
  "Time"             -> None, 
  "Energy"           -> None, 
  "IntegerVariables" -> None
};

(* --- GWP2D Assumption Generator Engine --- *)
GWP2DASSUMPTIONS[GWP2DARG, opts : OptionsPattern[]] := Module[{
  symbs, realSymbs, intSymbs, shapeCond,
  base, cond, extra, x, p, c, t, e, 
  intVars, invalidOpts
},

  (* Catch Unknown Options *)
  invalidOpts = FilterRules[{opts}, Except[Options[GWP2DASSUMPTIONS]]];
  If[Length[invalidOpts] > 0,
    Message[General::optx, First[First[invalidOpts]], HoldForm[GWP2DASSUMPTIONS]];
    Return[$Failed]
  ];

  (* Extract all atomic symbols directly from the bound macro variables. *)
  symbs = Select[
    Union @ Cases[
      {RAXX, IAXX, RAYY, IAYY, RAXY, IAXY, RX, RY, RPX, RPY, RG, IG, NORM, HBAR, MASS, V00, V10, V01, V20, V02, V11, INIT}, 
      _Symbol, Infinity
    ], 
    Context[#] =!= "System`" &
  ];

  intVars   = OptionValue["IntegerVariables"];
  intSymbs  = If[intVars === None, {}, Flatten[{intVars}]];
  realSymbs = Complement[symbs, intSymbs];

  (* Construct core real and integer domain assumptions *)
  base = True;
  If[Length[realSymbs] > 0, base = base && Element[Alternatives @@ realSymbs, Reals]];
  If[Length[intSymbs] > 0,  base = base && Element[Alternatives @@ intSymbs, Integers]];

  (* 2D Shape Conditions: Enforce positive-definite width matrix *)
  shapeCond = (RAXX > 0) && (RAYY > 0) && (RAXX * RAYY - RAXY^2 > 0);
  cond      = shapeCond && HBAR > 0 && MASS > 0;
  
  (* Extract dynamic coordinate Options *)
  x = OptionValue["Position"];
  p = OptionValue["Momentum"];
  c = OptionValue["Cumulative"];
  t = OptionValue["Time"];
  e = OptionValue["Energy"];

  (* Build dynamic coordinate assumptions *)
  extra = True;
  If[x =!= None, extra = extra && Element[Alternatives @@ Flatten[{x}], Reals]];
  If[p =!= None, extra = extra && Element[Alternatives @@ Flatten[{p}], Reals]];
  If[t =!= None, extra = extra && Element[t, Reals]];
  If[c =!= None, extra = extra && Element[Alternatives @@ Flatten[{c}], Reals]];
  If[e =!= None, extra = extra && Element[e, Reals] && 0 < e];
  
  (* Return perfectly merged assumption sequence *)
  base && FullSimplify[cond, Assumptions -> True] && extra
];


(* ::Section::Closed:: *)
(*Potential Models*)


(* ::Subsection::Closed:: *)
(*Named Potential Models*)


(* --- Named Systems --- *)
GWP2DFREE[t_][GWP2DARG] = GWP2DLINEAR[0, 0, 0][t][GWP2DVAL];
GWP2DHO[t_][GWP2DARG] = GWP2DHARMONIC[1, 1, 0][t][GWP2DVAL];
GWP2DCOUPLEDHO[t_][GWP2DARG] = GWP2DHARMONIC[1, 1, 1/2][t][GWP2DVAL];


(* ::Subsection::Closed:: *)
(*Linear Potential*)


(* ========================================================================= *)
(* 2D LINEAR & FREE PARTICLE SYSTEM                                          *)
(* ========================================================================= *)

GWP2DLINEARFUN = {
  GWP2DLINEARRAXXT, GWP2DLINEARIAXXT, GWP2DLINEARRAYYT, GWP2DLINEARIAYYT, 
  GWP2DLINEARRAXYT, GWP2DLINEARIAXYT, GWP2DLINEARRXT, GWP2DLINEARRYT, 
  GWP2DLINEARPXT, GWP2DLINEARPYT, GWP2DLINEARRGT, GWP2DLINEARIGT
};

SetAttributes[GWP2DLINEARFUN, Listable];

(* Constructor: F00 (Constant), F10 (x-force), F01 (y-force) *)
GWP2DLINEAR[F00_:0, F10_:0, F01_:0][t_][GWP2DARG] = Sequence @@ {
  Sequence @@ Through[Through[GWP2DLINEARFUN[t, F00, F10, F01]][GWP2DVAL]], 
  NORM, HBAR, MASS, 
  {F00, F10, F01, 0, 0, 0}, 
  INIT
};

(* --- Width Matrix Evolution --- *)
GWP2DLINEARRAXXT[t_, F00_, F10_, F01_][GWP2DARG] = (MASS^2*(MASS^2*RAXX + 4*HBAR*MASS*(-(IAYY*RAXX) + IAXY*RAXY)*t + 4*HBAR^2*(IAYY^2*RAXX - 2*IAXY*IAYY*RAXY + RAYY*(IAXY^2 - RAXY^2 + RAXX*RAYY))*t^2))/(MASS^4 - 4*HBAR*(IAXX + IAYY)*MASS^3*t + 4*HBAR^2*MASS^2*(IAXX^2 - 2*IAXY^2 + 4*IAXX*IAYY + IAYY^2 + RAXX^2 + 2*RAXY^2 + RAYY^2)*t^2 - 16*HBAR^3*MASS*(IAXX^2*IAYY - IAXY^2*IAYY + IAYY*(RAXX^2 + RAXY^2) - 2*IAXY*RAXY*(RAXX + RAYY) + IAXX*(-IAXY^2 + IAYY^2 + RAXY^2 + RAYY^2))*t^3 + 16*HBAR^4*(IAXY^4 + 2*IAXX*IAYY*RAXY^2 + RAXY^4 - 4*IAXY*RAXY*(IAYY*RAXX + IAXX*RAYY) + 2*IAXY^2*(-(IAXX*IAYY) + RAXY^2 + RAXX*RAYY) + IAXX^2*(IAYY^2 + RAYY^2) + RAXX*(-2*RAXY^2*RAYY + RAXX*(IAYY^2 + RAYY^2)))*t^4);
GWP2DLINEARIAXXT[t_, F00_, F10_, F01_][GWP2DARG] = (MASS*(IAXX*MASS^3 - 2*HBAR*MASS^2*(IAXX^2 - IAXY^2 + 2*IAXX*IAYY + RAXX^2 + RAXY^2)*t + 4*HBAR^2*MASS*(2*IAXX^2*IAYY - IAXY^2*IAYY + IAYY*(2*RAXX^2 + RAXY^2) - 2*IAXY*RAXY*(2*RAXX + RAYY) + IAXX*(-2*IAXY^2 + IAYY^2 + 2*RAXY^2 + RAYY^2))*t^2 - 8*HBAR^3*(IAXY^4 + 2*IAXX*IAYY*RAXY^2 + RAXY^4 - 4*IAXY*RAXY*(IAYY*RAXX + IAXX*RAYY) + 2*IAXY^2*(-(IAXX*IAYY) + RAXY^2 + RAXX*RAYY) + IAXX^2*(IAYY^2 + RAYY^2) + RAXX*(-2*RAXY^2*RAYY + RAXX*(IAYY^2 + RAYY^2)))*t^3))/(MASS^4 - 4*HBAR*(IAXX + IAYY)*MASS^3*t + 4*HBAR^2*MASS^2*(IAXX^2 - 2*IAXY^2 + 4*IAXX*IAYY + IAYY^2 + RAXX^2 + 2*RAXY^2 + RAYY^2)*t^2 - 16*HBAR^3*MASS*(IAXX^2*IAYY - IAXY^2*IAYY + IAYY*(RAXX^2 + RAXY^2) - 2*IAXY*RAXY*(RAXX + RAYY) + IAXX*(-IAXY^2 + IAYY^2 + RAXY^2 + RAYY^2))*t^3 + 16*HBAR^4*(IAXY^4 + 2*IAXX*IAYY*RAXY^2 + RAXY^4 - 4*IAXY*RAXY*(IAYY*RAXX + IAXX*RAYY) + 2*IAXY^2*(-(IAXX*IAYY) + RAXY^2 + RAXX*RAYY) + IAXX^2*(IAYY^2 + RAYY^2) + RAXX*(-2*RAXY^2*RAYY + RAXX*(IAYY^2 + RAYY^2)))*t^4);
GWP2DLINEARRAYYT[t_, F00_, F10_, F01_][GWP2DARG] = (MASS^2*(MASS^2*RAYY + 4*HBAR*MASS*(IAXY*RAXY - IAXX*RAYY)*t + 4*HBAR^2*(IAXY^2*RAXX - 2*IAXX*IAXY*RAXY - RAXX*RAXY^2 + (IAXX^2 + RAXX^2)*RAYY)*t^2))/(MASS^4 - 4*HBAR*(IAXX + IAYY)*MASS^3*t + 4*HBAR^2*MASS^2*(IAXX^2 - 2*IAXY^2 + 4*IAXX*IAYY + IAYY^2 + RAXX^2 + 2*RAXY^2 + RAYY^2)*t^2 - 16*HBAR^3*MASS*(IAXX^2*IAYY - IAXY^2*IAYY + IAYY*(RAXX^2 + RAXY^2) - 2*IAXY*RAXY*(RAXX + RAYY) + IAXX*(-IAXY^2 + IAYY^2 + RAXY^2 + RAYY^2))*t^3 + 16*HBAR^4*(IAXY^4 + 2*IAXX*IAYY*RAXY^2 + RAXY^4 - 4*IAXY*RAXY*(IAYY*RAXX + IAXX*RAYY) + 2*IAXY^2*(-(IAXX*IAYY) + RAXY^2 + RAXX*RAYY) + IAXX^2*(IAYY^2 + RAYY^2) + RAXX*(-2*RAXY^2*RAYY + RAXX*(IAYY^2 + RAYY^2)))*t^4);
GWP2DLINEARIAYYT[t_, F00_, F10_, F01_][GWP2DARG] = (MASS*(IAYY*MASS^3 - 2*HBAR*MASS^2*(-IAXY^2 + 2*IAXX*IAYY + IAYY^2 + RAXY^2 + RAYY^2)*t + 4*HBAR^2*MASS*(IAXX^2*IAYY - 2*IAXY^2*IAYY + IAYY*(RAXX^2 + 2*RAXY^2) - 2*IAXY*RAXY*(RAXX + 2*RAYY) + IAXX*(-IAXY^2 + 2*IAYY^2 + RAXY^2 + 2*RAYY^2))*t^2 - 8*HBAR^3*(IAXY^4 + 2*IAXX*IAYY*RAXY^2 + RAXY^4 - 4*IAXY*RAXY*(IAYY*RAXX + IAXX*RAYY) + 2*IAXY^2*(-(IAXX*IAYY) + RAXY^2 + RAXX*RAYY) + IAXX^2*(IAYY^2 + RAYY^2) + RAXX*(-2*RAXY^2*RAYY + RAXX*(IAYY^2 + RAYY^2)))*t^3))/(MASS^4 - 4*HBAR*(IAXX + IAYY)*MASS^3*t + 4*HBAR^2*MASS^2*(IAXX^2 - 2*IAXY^2 + 4*IAXX*IAYY + IAYY^2 + RAXX^2 + 2*RAXY^2 + RAYY^2)*t^2 - 16*HBAR^3*MASS*(IAXX^2*IAYY - IAXY^2*IAYY + IAYY*(RAXX^2 + RAXY^2) - 2*IAXY*RAXY*(RAXX + RAYY) + IAXX*(-IAXY^2 + IAYY^2 + RAXY^2 + RAYY^2))*t^3 + 16*HBAR^4*(IAXY^4 + 2*IAXX*IAYY*RAXY^2 + RAXY^4 - 4*IAXY*RAXY*(IAYY*RAXX + IAXX*RAYY) + 2*IAXY^2*(-(IAXX*IAYY) + RAXY^2 + RAXX*RAYY) + IAXX^2*(IAYY^2 + RAYY^2) + RAXX*(-2*RAXY^2*RAYY + RAXX*(IAYY^2 + RAYY^2)))*t^4);
GWP2DLINEARRAXYT[t_, F00_, F10_, F01_][GWP2DARG] = (MASS^2*(MASS^2*RAXY + 2*HBAR*MASS*(-((IAXX + IAYY)*RAXY) + IAXY*(RAXX + RAYY))*t + 4*HBAR^2*(-(IAXY*IAYY*RAXX) + IAXY^2*RAXY + IAXX*IAYY*RAXY + RAXY^3 - (IAXX*IAXY + RAXX*RAXY)*RAYY)*t^2))/(MASS^4 - 4*HBAR*(IAXX + IAYY)*MASS^3*t + 4*HBAR^2*MASS^2*(IAXX^2 - 2*IAXY^2 + 4*IAXX*IAYY + IAYY^2 + RAXX^2 + 2*RAXY^2 + RAYY^2)*t^2 - 16*HBAR^3*MASS*(IAXX^2*IAYY - IAXY^2*IAYY + IAYY*(RAXX^2 + RAXY^2) - 2*IAXY*RAXY*(RAXX + RAYY) + IAXX*(-IAXY^2 + IAYY^2 + RAXY^2 + RAYY^2))*t^3 + 16*HBAR^4*(IAXY^4 + 2*IAXX*IAYY*RAXY^2 + RAXY^4 - 4*IAXY*RAXY*(IAYY*RAXX + IAXX*RAYY) + 2*IAXY^2*(-(IAXX*IAYY) + RAXY^2 + RAXX*RAYY) + IAXX^2*(IAYY^2 + RAYY^2) + RAXX*(-2*RAXY^2*RAYY + RAXX*(IAYY^2 + RAYY^2)))*t^4);
GWP2DLINEARIAXYT[t_, F00_, F10_, F01_][GWP2DARG] = (MASS^2*(IAXY*MASS^2 - 2*HBAR*MASS*(IAXY*(IAXX + IAYY) + RAXY*(RAXX + RAYY))*t - 4*HBAR^2*(IAXY^3 - RAXY*(IAYY*RAXX + IAXX*RAYY) + IAXY*(-(IAXX*IAYY) + RAXY^2 + RAXX*RAYY))*t^2))/(MASS^4 - 4*HBAR*(IAXX + IAYY)*MASS^3*t + 4*HBAR^2*MASS^2*(IAXX^2 - 2*IAXY^2 + 4*IAXX*IAYY + IAYY^2 + RAXX^2 + 2*RAXY^2 + RAYY^2)*t^2 - 16*HBAR^3*MASS*(IAXX^2*IAYY - IAXY^2*IAYY + IAYY*(RAXX^2 + RAXY^2) - 2*IAXY*RAXY*(RAXX + RAYY) + IAXX*(-IAXY^2 + IAYY^2 + RAXY^2 + RAYY^2))*t^3 + 16*HBAR^4*(IAXY^4 + 2*IAXX*IAYY*RAXY^2 + RAXY^4 - 4*IAXY*RAXY*(IAYY*RAXX + IAXX*RAYY) + 2*IAXY^2*(-(IAXX*IAYY) + RAXY^2 + RAXX*RAYY) + IAXX^2*(IAYY^2 + RAYY^2) + RAXX*(-2*RAXY^2*RAYY + RAXX*(IAYY^2 + RAYY^2)))*t^4);

(* --- Classical Trajectories --- *)
GWP2DLINEARRXT[t_, F00_, F10_, F01_][GWP2DARG] = RX + (RPX*t)/MASS - (t^2*F10)/(2*MASS);
GWP2DLINEARRYT[t_, F00_, F10_, F01_][GWP2DARG] = RY + (RPY*t)/MASS - (t^2*F01)/(2*MASS);
GWP2DLINEARPXT[t_, F00_, F10_, F01_][GWP2DARG] = RPX - t*F10;
GWP2DLINEARPYT[t_, F00_, F10_, F01_][GWP2DARG] = RPY - t*F01;

(* --- Lagrangian & Phases --- *)
GWP2DLINEARLCT[t_, F00_, F10_, F01_][GWP2DARG] = (t*(3*RPX^2 + 3*RPY^2 - 6*RPY*t*F01 - 6*RPX*t*F10 - 6*MASS*(F00 + RY*F01 + RX*F10) + 2*t^2*(F01^2 + F10^2)))/(6*MASS);
GWP2DLINEARRGT[t_, F00_, F10_, F01_][GWP2DARG] = RG + GWP2DLINEARLCT[t, F00, F10, F01][GWP2DVAL] - 1/2*(HBAR*ArcTan[(MASS^2 - 2*HBAR*(IAXX + IAYY)*MASS*t + 4*HBAR^2*(-IAXY^2 + IAXX*IAYY + RAXY^2 - RAXX*RAYY)*t^2)/MASS^2, (2*HBAR*t*(MASS*(RAXX + RAYY) - 2*HBAR*(IAYY*RAXX - 2*IAXY*RAXY + IAXX*RAYY)*t))/MASS^2]);
GWP2DLINEARIGT[t_, F00_, F10_, F01_][GWP2DARG] = IG + (HBAR*Log[(4*HBAR^2*t^2*(MASS*(RAXX + RAYY) - 2*HBAR*(IAYY*RAXX - 2*IAXY*RAXY + IAXX*RAYY)*t)^2 + (MASS^2 - 2*HBAR*(IAXX + IAYY)*MASS*t + 4*HBAR^2*(-IAXY^2 + IAXX*IAYY + RAXY^2 - RAXX*RAYY)*t^2)^2)/MASS^4])/4;


(* ::Subsection::Closed:: *)
(*Harmonic Oscillator Potential*)


(* --- Phase Space Center Sub-Module --- *)
GWP2DHARMONICCENTERT[t_, w1_, w2_, theta_][GWP2DARG] := Module[
  {RXT, RYT, RPXT, RPYT},
  RXT = (w2*RPX*Cos[theta]^2*Sin[w1*t] - Cos[theta]*(MASS*w1*w2*RY*Cos[w2*t] - w2*RPY*Sin[w1*t] + w1*RPY*Sin[w2*t])*Sin[theta] + w1*(MASS*w2*RX*Cos[w2*t] + RPX*Sin[w2*t])*Sin[theta]^2 + MASS*w1*w2*Cos[w1*t]*Cos[theta]*(RX*Cos[theta] + RY*Sin[theta]))/(MASS*w1*w2);
  RYT = (w1*RPY*Cos[theta]^2*Sin[w2*t] + Cos[theta]*(MASS*w1*w2*RX*Cos[w1*t] + w2*RPX*Sin[w1*t] - w1*RPX*Sin[w2*t])*Sin[theta] + w2*(MASS*w1*RY*Cos[w1*t] + RPY*Sin[w1*t])*Sin[theta]^2 + MASS*w1*w2*Cos[w2*t]*Cos[theta]*(RY*Cos[theta] - RX*Sin[theta]))/(MASS*w1*w2);
  RPXT = Cos[w2*t]*Sin[theta]*(-(RPY*Cos[theta]) + RPX*Sin[theta]) + Cos[w1*t]*Cos[theta]*(RPX*Cos[theta] + RPY*Sin[theta]) + MASS*w2*Sin[w2*t]*Sin[theta]*(RY*Cos[theta] - RX*Sin[theta]) - MASS*w1*Cos[theta]*Sin[w1*t]*(RX*Cos[theta] + RY*Sin[theta]);
  RPYT = Cos[w2*t]*Cos[theta]*(RPY*Cos[theta] - RPX*Sin[theta]) + Cos[w1*t]*Sin[theta]*(RPX*Cos[theta] + RPY*Sin[theta]) + MASS*w2*Cos[theta]*Sin[w2*t]*(-(RY*Cos[theta]) + RX*Sin[theta]) - MASS*w1*Sin[w1*t]*Sin[theta]*(RX*Cos[theta] + RY*Sin[theta]);
  
  Simplify /@ {RXT, RYT, RPXT, RPYT}
];

(* --- Shape & Z-Matrix Sub-Module --- *)
GWP2DHARMONICSHAPET[t_, w1_, w2_, theta_][GWP2DARG] := Module[
  {R, OM, INOM, CM, SM, P0, P0T, ZTr, PTr, ZT, PT, AT},
  R = {{Cos[theta], -Sin[theta]}, {Sin[theta], Cos[theta]}};
  OM = DiagonalMatrix[{w1, w2}];
  INOM = DiagonalMatrix[{1/w1, 1/w2}];
  CM = {{Cos[w1 t], 0}, {0, Cos[w2 t]}};
  SM = {{Sin[w1 t], 0}, {0, Sin[w2 t]}};
  
  P0 = (2 I HBAR / MASS) * {{RAXX + I IAXX, RAXY + I IAXY}, {RAXY + I IAXY, RAYY + I IAYY}};
  P0T = Transpose[R] . P0 . R;
  
  ZTr = CM + (1/MASS) * INOM . SM . P0T;
  PTr = -MASS * OM . SM + CM . P0T;
  ZT = R . ZTr . Transpose[R];
  PT = R . PTr . Transpose[R];
  AT = (MASS / (2 I HBAR)) * PT . Inverse[ZT];
  
  Simplify /@ {
    ComplexExpand[Re[AT[[1,1]]]], ComplexExpand[Im[AT[[1,1]]]],
    ComplexExpand[Re[AT[[2,2]]]], ComplexExpand[Im[AT[[2,2]]]],
    ComplexExpand[Re[AT[[1,2]]]], ComplexExpand[Im[AT[[1,2]]]],
    Det[ZT]
  }
];

(* --- Master Assembler --- *)
With[{VAL = GWP2DVAL},
  GWP2DHARMONIC[OMEGAX_, OMEGAY_, OMEGAXY_][t_][GWP2DARG] := Module[
    {w1, w2, theta, rxt, ryt, rpxt, rpyt, raxx, iaxx, rayy, iayy, raxy, iaxy, 
     detZT, reDet, imDet, lct, rgt, igt, pecoeff},

    (* 1. Normal Modes *)
    w1 = Sqrt[(OMEGAX^2 + OMEGAY^2)/2 - Sqrt[(OMEGAX^2 - OMEGAY^2)^2 + 4 OMEGAXY^4]/2];
    w2 = Sqrt[(OMEGAX^2 + OMEGAY^2)/2 + Sqrt[(OMEGAX^2 - OMEGAY^2)^2 + 4 OMEGAXY^4]/2];
    theta = If[OMEGAXY == 0, 0, ArcTan[OMEGAX^2 - OMEGAY^2, 2 OMEGAXY^2] / 2];

    (* 2. Sub-Modules *)
    {rxt, ryt, rpxt, rpyt} = GWP2DHARMONICCENTERT[t, w1, w2, theta][VAL];
    {raxx, iaxx, rayy, iayy, raxy, iaxy, detZT} = GWP2DHARMONICSHAPET[t, w1, w2, theta][VAL];

    (* 3. Explicit Real/Imaginary Separation of the Determinant *)
    reDet = Simplify[ComplexExpand[Re[detZT]]];
    imDet = Simplify[ComplexExpand[Im[detZT]]];

    (* 4. Phases *)
    lct = 1/2 * (rxt*rpxt + ryt*rpyt - RX*RPX - RY*RPY);
    rgt = RG + lct - (HBAR / 2) * ArcTan[reDet, imDet] + 
          HBAR * Pi * (Floor[(Pi - w1*t)/(2*Pi)] + Floor[(Pi - w2*t)/(2*Pi)]);
    igt = IG + (HBAR / 4) * Log[Simplify[reDet^2 + imDet^2]];

    (* 5. Potential Array & Output *)
    pecoeff = {0, 0, 0, MASS*OMEGAX^2/2, MASS*OMEGAY^2/2, MASS*OMEGAXY^2};

    Sequence @@ {
      raxx, iaxx, rayy, iayy, raxy, iaxy, 
      rxt, ryt, rpxt, rpyt, 
      rgt, igt, 
      NORM, HBAR, MASS, pecoeff, INIT
    }
  ]
];


(* ::Subsection::Closed:: *)
(*External Potential and Force*)


(* --- x-Space External Potential Energy Field --- *)
GWP2DPEX[x_, y_][GWP2DARG] = V00 + V10*x + V01*y + V20*x^2 + V02*y^2 + V11*x*y;

(* --- x-Space External Force Field --- *)
GWP2DFEX[1][x_, y_][GWP2DARG] = -V10 - 2*V20*x - V11*y;
GWP2DFEX[2][x_, y_][GWP2DARG] = -V01 - 2*V02*y - V11*x;

GWP2DFEX[x_, y_][GWP2DARG] = {
  GWP2DFEX[1][x, y][GWP2DVAL], 
  GWP2DFEX[2][x, y][GWP2DVAL]
};


(* ::Section::Closed:: *)
(*Properties*)


(* --- Base Wavefunction and Density --- *)
GWP2DPSIX[x_, y_][GWP2DARG] = NORM * Exp[-(RAXX + I*IAXX)*(x - RX)^2 - (RAYY + I*IAYY)*(y - RY)^2 - 2*(RAXY + I*IAXY)*(x - RX)*(y - RY) + (I / HBAR)*(RPX*(x - RX) + RPY*(y - RY) + RG + I*IG)];

GWP2DRHOX[x_, y_][GWP2DARG] = (2/Pi) * Sqrt[RAXX*RAYY - RAXY^2] * Exp[-2*RAXX*(x - RX)^2 - 2*RAYY*(y - RY)^2 - 4*RAXY*(x - RX)*(y - RY)];


(* ::Section::Closed:: *)
(*GWPObject Registration*)


(* ::Subsection::Closed:: *)
(*Potential Model Resolution*)


(* --- Unified Potential Registry Chunk --- *)
$potentials2D = {
  {"Free",      GWP2DFREE,      "\"Free\"",                                "Named"},
  {"HO",        GWP2DHO,        "\"HO\"",                                  "Named"},
  {"CoupledHO", GWP2DCOUPLEDHO, "\"CoupledHO\"",                           "Named"},
  {"Linear",    GWP2DLINEAR,    "{\"Linear\", V00, V10, V01}",             "Parameterized"},
  {"Harmonic",  GWP2DHARMONIC,  "{\"Harmonic\", OMEGAX, OMEGAY, OMEGAXY}", "Parameterized"}
};

GWPTools`GWPRegistry`GWPRegisterPotentials[$potentials2D, "2D"];
Clear[$potentials2D];


(* ::Subsection::Closed:: *)
(*Property Resolution and Dispatch*)


(* --- Property Resolution and Dispatch (2D) --- *)
$regStatic2D = Join[#, {"StaticParameters", "2D"}] & /@ {
  {"Normalization",         "NORM",  "Static", "Static"},
  {"ReducedPlanckConstant", "HBAR",  "Static", "Static"},
  {"Mass",                  "MASS",  "Static", "Static"},
  {"InputParameters",       "INPUT", "Static", "Static"},
  {"InitialParameters",     "INIT",  "Static", "Static"}
};

$regDynamic2D = Join[#, {"DynamicParameters", "2D"}] & /@ {
  {"RealShapeXX",           "RAXX",     "Temporal", "StaticValue"},
  {"ImaginaryShapeXX",      "IAXX",     "Temporal", "StaticValue"},
  {"RealShapeYY",           "RAYY",     "Temporal", "StaticValue"},
  {"ImaginaryShapeYY",      "IAYY",     "Temporal", "StaticValue"},
  {"RealShapeXY",           "RAXY",     "Temporal", "StaticValue"},
  {"ImaginaryShapeXY",      "IAXY",     "Temporal", "StaticValue"},
  
  {"PositionCenterX",       "RX",       "Temporal", "StaticValue"},
  {"PositionCenterY",       "RY",       "Temporal", "StaticValue"},
  {"MomentumCenterX",       "RPX",      "Temporal", "StaticValue"},
  {"MomentumCenterY",       "RPY",      "Temporal", "StaticValue"},
  
  {"RealPhase",             "RG",       "Temporal", "StaticValue"},
  {"ImaginaryPhase",        "IG",       "Temporal", "StaticValue"},
  
  {"PositionVector",        "RMAT",     "Temporal", "StaticValue"},
  {"MomentumVector",        "RPMAT",    "Temporal", "StaticValue"},
  {"ShapeMatrix",           "SHAPEMAT", "Temporal", "StaticValue"},
  {"ChirpMatrix",           "CHIRPMAT", "Temporal", "StaticValue"},
  {"AlphaMatrix",           "ALPHAMAT", "Temporal", "StaticValue"},
  
  {"PotentialCoefficients", "PECOEFF",  "Temporal", None}
};

$regWave2D = Join[#, {"Wavefunctions", "2D"}] & /@ {
  {"WavefunctionX",         "PSIX",     "Bivariate", "BivariateSpatial"}
};

$regProb2D = Join[#, {"Probabilities", "2D"}] & /@ {
  {"DensityX",              "RHOX",     "Bivariate", "BivariateSpatial"}
};

$regExp2D = Join[#, {"ExpectationValues", "2D"}] & /@ {
  {"PositionUncertaintyX",  "UX",       "Temporal", "StaticValue"},
  {"PositionUncertaintyY",  "UY",       "Temporal", "StaticValue"},
  {"PositionCovarianceXY",  "COVXY",    "Temporal", "StaticValue"},
  {"CovarianceMatrix",      "COVMAT",   "Temporal", "StaticValue"}
};

$regExt2D = Join[#, {"ExternalFields", "2D"}] & /@ {
  {"ExternalPotentialX", "PEX", "Bivariate",            "BivariateSpatial"},
  {"ExternalForceX",     "FEX", "BivariateVectorField", "BivariateVectorFieldSpatial"}
};

(* --- Registry Assembly --- *)
$reg2D = Join[$regStatic2D, $regDynamic2D, $regWave2D, $regProb2D, $regExp2D, $regExt2D];
Clear[$regStatic2D, $regDynamic2D, $regWave2D, $regProb2D, $regExp2D, $regExt2D];

GWPTools`GWPRegistry`GWPRegisterExtension[$reg2D];
Clear[$reg2D];


(* ::Subsection::Closed:: *)
(*User Interface Builder*)


(* ========================================================================= *)
(* FRONT-END FORMATTING (UI Builder)                                         *)
(* ========================================================================= *)

$GWP2DLogo=Graphics[{
Darker[Blue],
Opacity[0.1],Rotate[Disk[{0,0},{1,0.5}],Pi/4],
Opacity[0.2],Rotate[Disk[{0,0},{0.8,0.4}],Pi/4],
Opacity[0.4],Rotate[Disk[{0,0},{0.5,0.25}],Pi/4],
Opacity[0.8],Rotate[Disk[{0,0},{0.2,0.1}],Pi/4],
Thickness[0.025],Opacity[0.8],Darker[Blue],
Opacity[0.2],Rotate[Circle[{0,0},{1,0.5}],Pi/4],
Opacity[0.4],Rotate[Circle[{0,0},{0.8,0.4}],Pi/4],
Opacity[0.8],Rotate[Circle[{0,0},{0.5,0.25}],Pi/4],
Opacity[1],Rotate[Circle[{0,0},{0.2,0.1}],Pi/4]},
ImageSize->32,PlotRange->{{-1,1},{-1,1}},AspectRatio->1];

GWPTools`GWPDeveloper`GWP2DUI[data_] := Module[
  {potDisplay, paramsList, h, m, init, visible, hidden},
  
  potDisplay = data["Potential"];
  paramsList = data["Parameters"];
  
  If[Length[paramsList] >= 17,
    h = paramsList[[14]]; m = paramsList[[15]]; init = paramsList[[17]];
  ,
    h = "?"; m = "?"; init = "?";
  ];
  
  visible = {Grid[{
    {Style["Attributes", Bold], Style["Values", Bold]},
    {"Initial State: ", InputForm[init]},
    {"Potential: ", potDisplay}
  }, Alignment -> Left]};
  
  hidden = {Grid[{
    {"Mass: ", m},
    {"HBar: ", h}
  }, Alignment -> Left]};
  
  {$GWP2DLogo, visible, hidden}
];


(* ::Section::Closed:: *)
(*End*)


(* --- End "GWPTools`GWPEngine2D`Private`" --- *)
If[TrueQ[Global`$GWPDebug], Print["[GWPEngine2D] End Private"]];
End[]

(* Hide internal code for all Developer functions from the ? menu *)
SetAttributes[Evaluate[Names["GWPTools`GWPEngine2D`*"]], {ReadProtected}];

(* --- End "GWPTools`GWPEngine2D`" --- *)
If[TrueQ[Global`$GWPDebug], Print["[GWPEngine2D] EndPackage"]];
EndPackage[]

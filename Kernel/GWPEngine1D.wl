(* ::Package:: *)

(* ::Title:: *)
(*GWPEngine1D Package*)


(* ::Section::Closed:: *)
(*GWPDeveloper Usage Registration*)


(* ::Subsection::Closed:: *)
(*BeginPackage*)


(* --- Hoist Usage Statements into the Developer Context --- *)
Get["GWPTools`GWPDeveloper`"];
BeginPackage["GWPTools`GWPDeveloper`"]


(* ::Subsection::Closed:: *)
(*Usage Statements*)


(* ::Subsubsection::Closed:: *)
(*Parameters*)


GWP1DARG::usage = "GWP1DARG is the developer macro for the parameter sequence pattern.";
GWP1DVAL::usage = "GWP1DVAL is the developer macro for the parameter sequence values.";


GWP1DScalarQ::usage="GWP1DScalarQ[exp] returns True if exp is a scalar symbol or number."


(* --- GWP1D Parameter Generation --- *)
GWP1DPARAM::usage = "GWP1DPARAM[A, X, P, G] returns a sequence of GWP1D parameters.\n" <>
  "GWP1DPARAM[A, X, P] assumes a default phase G.\n" <>
  "GWP1DPARAM[A, X] assumes default momentum P and phase G.\n" <>
  "GWP1DPARAM[A] assumes default position X, momentum P, and phase G.\n" <>
  "GWP1DPARAM[] assumes default GWP1D parameters.";
  
(* --- GWP1D Parameter Extraction --- *)
GWP1DRA::usage = "GWP1DRA[param] extracts the real shape parameter.";
GWP1DIA::usage = "GWP1DIA[param] extracts the imaginary shape parameter.";
GWP1DRX::usage = "GWP1DRX[param] extracts the position center.";
GWP1DRP::usage = "GWP1DRP[param] extracts the momentum center.";
GWP1DRG::usage = "GWP1DRG[param] extracts the real phase parameter.";
GWP1DIG::usage = "GWP1DIG[param] extracts the imaginary phase parameter.";
GWP1DNORM::usage = "GWP1DNORM[param] extracts the normalization constant.";
GWP1DMASS::usage = "GWP1DMASS[param] extracts the mass.";
GWP1DHBAR::usage = "GWP1DHBAR[param] extracts the reduced Planck constant.";
GWP1DPECOEFF::usage = "GWP1DPECOEFF[param] extracts the external potential coefficients.";
GWP1DINPUT::usage = "GWP1DINPUT[param] extracts the input parameters.";
GWP1DINIT::usage = "GWP1DINIT[param] extracts the processed initial parameters.";

(* --- GWP1D Four-Eight-Six Parameter Engine --- *)
GWP1D486::usage = "GWP1D486 is the internal engine used by GWP1DPARAM to convert single-primed complex parameters into the double-primed real-parameter model.";

(* --- GWP1D Parameter Parsers Usage Statements --- *)
GWP1DSHAPE::usage = "GWP1DSHAPE[A1, HBAR, MASS] parses the user-provided wavepacket shape parameter A1 and translates it into the foundational real and imaginary width components {RA, IA}.\n" <>
  "A1 = RA + I*IA\n" <>
  "A1 = {\"Covariance\", UX, COVXP}\n" <>
  "A1 = {\"Uncertainty\", UX, UP, chirpSign}";

GWP1DMOMENTUM::usage = "GWP1DMOMENTUM[P1, MASS] parses the user-provided momentum parameter P1 and translates it into the foundational real and imaginary momentum components {RP1, IP1}.\n" <>
  "P1 = RP + I*IP\n" <>
  "P1 = {\"KineticEnergy\", Energy, pSign}";

GWP1DPOSITION::usage = "GWP1DPOSITION[X1] parses the user-provided position parameter X1 and translates it into the foundational real and imaginary position components {RX, IX}.\n" <>
  "X1 = RX + I*IX";

GWP1DPHASE::usage = "GWP1DPHASE[G1, HBAR, RA, RX, RP] parses the user-provided global phase parameter G1 and translates it into the real and imaginary phase components {RG, IG}.\n" <>
  "G1 = RG + I*IG\n" <>
  "G1 = {\"Action\", S, mu}\n" <>
  "G1 = {\"Displacement\", X0, P0}\n" <>
  "G1 = {\"Coefficient\", PhaseAngle, AmplitudeWeight}\n" <>
  "G1 = {\"Evolution\", Energy, Time}";
  
(* --- GWP1D Parameter Assumptions --- *)
GWP1DASSUMPTIONS::usage = "GWP1DASSUMPTIONS[param, opts] generates real-domain assumptions for the parameters and variables.";


(* ::Subsubsection::Closed:: *)
(*Potential Models*)


(* --- GWP1D Parameter Time Derivatives --- *)
GWP1DRXTD::usage = "GWP1DRXTD[param] computes the time derivative of the position center.";
GWP1DRPTD::usage = "GWP1DRPTD[param] computes the time derivative of the momentum center.";
GWP1DRATD::usage = "GWP1DRATD[param] computes the time derivative of the real shape parameter.";
GWP1DIATD::usage = "GWP1DIATD[param] computes the time derivative of the imaginary shape parameter.";
GWP1DRGTD::usage = "GWP1DRGTD[param] computes the time derivative of the real phase parameter.";
GWP1DIGTD::usage = "GWP1DIGTD[param] computes the time derivative of the imaginary phase parameter.";


(* --- GWP1D Potential Models --- *) 
GWP1DFREE::usage = "GWP1DFREE[t][param] evaluates the free particle parameters.";
GWP1DHO::usage = "GWP1DHO[t][param] evaluates the standard harmonic oscillator parameters.";
GWP1DLINEAR::usage = "GWP1DLINEAR[k][t][param] evaluates the linear potential parameters.";
GWP1DHARMONIC::usage = "GWP1DHARMONIC[omega][t][param] evaluates the harmonic oscillator parameters.";
GWP1DPARABOLIC::usage = "GWP1DPARABOLIC[omega][t][param] evaluates the parabolic barrier parameters.";
GWP1DFHOLIN::usage = "GWP1DFHOLIN[omega, A][t][param] evaluates the linear-driven harmonic oscillator parameters.";
GWP1DFHORES::usage = "GWP1DFHORES[omega, A][t][param] evaluates the resonant-driven harmonic oscillator parameters.";
GWP1DFHONON::usage = "GWP1DFHONON[omega, A, omega1][t][param] evaluates the non-resonant-driven harmonic oscillator parameters.";

(* --- GWP1D Potential Energy and Force Functions --- *)
GWP1DPEX::usage = "GWP1DPEX[x][param] evaluates the external potential energy.\n" <>
  "GWP1DPEX[n][x][param] evaluates the nth spatial derivative of the external potential energy.";

GWP1DFEX::usage = "GWP1DFEX[x][param] evaluates the external force.\n" <>
  "GWP1DFEX[n][x][param] evaluates the nth spatial derivative of the external force.";


(* ::Subsubsection::Closed:: *)
(*Wavefunctions*)


(* --- Recursion Relation for Wavefunctions and Densities --- *)
GWP1DHermiteEngine::usage = "GWP1DHermiteEngine[n, p1, coeff] generates the nth-order polynomial factor for the generalized Gaussian wavepacket spatial derivatives by implementing a three-term Hermite recurrence relation.";


(* --- x-Space Wavefunctions ---*)
GWP1DPSIX::usage = "GWP1DPSIX[x][param] evaluates the x-space wavefunction.\n" <>
  "GWP1DPSIX[n][x][param] evaluates the nth derivative of the x-space wavefunction.";

GWP1DCSIX::usage = "GWP1DCSIX[x][param] evaluates the complex conjugate x-space wavefunction.\n" <>
  "GWP1DCSIX[n][x][param] evaluates the nth derivative of the complex conjugate x-space wavefunction.";

GWP1DRSIX::usage = "GWP1DRSIX[x][param] evaluates the real part of the x-space wavefunction.";
GWP1DISIX::usage = "GWP1DISIX[x][param] evaluates the imaginary part of the x-space wavefunction.";

(* --- p-Space Wavefunctions ---*)
GWP1DPSIP::usage = "GWP1DPSIP[p][param] evaluates the p-space wavefunction.\n" <>
  "GWP1DPSIP[n][p][param] evaluates the nth derivative of the p-space wavefunction.";

GWP1DCSIP::usage = "GWP1DCSIP[p][param] evaluates the complex conjugate p-space wavefunction.\n" <>
  "GWP1DCSIP[n][p][param] evaluates the nth derivative of the complex conjugate p-space wavefunction.";

GWP1DRSIP::usage = "GWP1DRSIP[p][param] evaluates the real part of the p-space wavefunction.";
GWP1DISIP::usage = "GWP1DISIP[p][param] evaluates the imaginary part of the p-space wavefunction.";


(* ::Subsubsection::Closed:: *)
(*Probabilities*)


(* --- Probability Densities --- *)
GWP1DRHOX::usage = "GWP1DRHOX[x][param] evaluates the x-space probability density.\n" <>
  "GWP1DRHOX[n][x][param] evaluates the nth derivative of the x-space probability density.";

GWP1DRHOP::usage = "GWP1DRHOP[p][param] evaluates the p-space probability density.\n" <>
  "GWP1DRHOP[n][p][param] evaluates the nth derivative of the p-space probability density.";

GWP1DRHOE::usage = "GWP1DRHOE[e][param] evaluates the energy probability density.";

(* --- Cumulative Distribution Functions --- *)
GWP1DCX::usage = "GWP1DCX[x][param] evaluates the x-space cumulative distribution function.";
GWP1DCP::usage = "GWP1DCP[p][param] evaluates the p-space cumulative distribution function.";
GWP1DCE::usage = "GWP1DCE[e][param] evaluates the energy cumulative distribution function.";

(* --- Probabilities --- *)
GWP1DPROBX::usage = "GWP1DPROBX[xmin, xmax][param] calculates the probability of finding the particle in the x-space interval.";
GWP1DPROBP::usage = "GWP1DPROBP[pmin, pmax][param] calculates the probability of finding the particle in the p-space interval.";
GWP1DPROBE::usage = "GWP1DPROBE[emin, emax][param] calculates the probability of finding the particle in the energy interval.";


(* ::Subsubsection::Closed:: *)
(*ExpectationValues*)


(* --- x-Space Expectation Values --- *)
GWP1DEX::usage = "GWP1DEX[param] evaluates the x-space expectation value.\n" <>
  "GWP1DEX[n][param] evaluates the nth x-space moment.";

(* --- p-Space Expectation Values --- *)
GWP1DEP::usage = "GWP1DEP[param] evaluates the p-space expectation value.\n" <>
  "GWP1DEP[n][param] evaluates the nth p-space moment.";

(* --- Uncertainties --- *)
GWP1DUX::usage = "GWP1DUX[param] evaluates the x-space uncertainty.";
GWP1DUP::usage = "GWP1DUP[param] evaluates the p-space uncertainty.";

(* --- x-p Cross-Correlations --- *)
GWP1DEXP::usage = "GWP1DEXP[param] evaluates the x-p product expectation value.\n" <>
  "GWP1DEXP[m, n][param] evaluates the arbitrary cross-moment expectation value of x^m p^n.";

GWP1DEPX::usage = "GWP1DEPX[param] evaluates the p-x product expectation value.\n" <>
  "GWP1DEPX[m, n][param] evaluates the arbitrary cross-moment expectation value of p^m x^n.";

GWP1DCOVXP::usage = "GWP1DCOVXP[param] evaluates the x-p covariance.";
GWP1DCORXP::usage = "GWP1DCORXP[param] evaluates the x-p correlation.";

(* --- Force Expectation Values --- *)
GWP1DEF1::usage = "GWP1DEF1[param] evaluates the force expectation value.";
GWP1DEF2::usage = "GWP1DEF2[param] evaluates the squared force expectation value.";
GWP1DUF::usage = "GWP1DUF[param] evaluates the force uncertainty.";


(* ::Subsubsection::Closed:: *)
(*Energies*)


(* --- Kinetic Energy Expectation Values --- *)
GWP1DEKE::usage = "GWP1DEKE[param] evaluates the kinetic energy expectation value.\n" <>
  "GWP1DEKE[n][param] evaluates the nth kinetic energy moment.";

(* --- Potential Energy Expectation Values --- *)
GWP1DEPE::usage = "GWP1DEPE[param] evaluates the potential energy expectation value.\n" <>
  "GWP1DEPE[n][param] evaluates the nth potential energy moment.";

(* --- Kinetic-Potential Energy Cross-Correlations --- *)
GWP1DEKEPE::usage = "GWP1DEKEPE[param] evaluates the kinetic-potential energy product expectation value.";
GWP1DEPEKE::usage = "GWP1DEPEKE[param] evaluates the potential-kinetic energy product expectation value.";
GWP1DCOVKEPE::usage = "GWP1DCOVKEPE[param] evaluates the kinetic-potential energy covariance.";
GWP1DCORKEPE::usage = "GWP1DCORKEPE[param] evaluates the kinetic-potential energy correlation.";

(* --- Total Energy Expectation Values --- *)
GWP1DETE::usage = "GWP1DETE[param] evaluates the total energy expectation value.\n" <>
  "GWP1DETE[n][param] evaluates the nth total energy moment (supported up to n=4).";
GWP1DETE1::usage = "GWP1DETE1[param] evaluates the total energy (Hamiltonian) expectation value.";
GWP1DETE2::usage = "GWP1DETE2[param] evaluates the squared total energy expectation value.";
GWP1DETE3::usage = "GWP1DETE3[param] evaluates the cubed total energy expectation value.";
GWP1DETE4::usage = "GWP1DETE3[param] evaluates the fourth-order total energy expectation value.";

(* --- Energy Uncertainty --- *)
GWP1DUKE::usage = "GWP1DUKE[param] evaluates the kinetic energy uncertainty.";
GWP1DUPE::usage = "GWP1DUPE[param] evaluates the potential energy uncertainty.";
GWP1DUTE::usage = "GWP1DUTE[param] evaluates the total energy uncertainty.";


(* ::Subsection::Closed:: *)
(*End Package*)


EndPackage[]

(* Scrub the Developer context from the global path immediately *)
$ContextPath = DeleteCases[$ContextPath, "GWPTools`GWPDeveloper`"];


(* ::Section::Closed:: *)
(*BeginPackage*)


(* ========================================================================= *)
(* PACKAGE     : GWPTools`GWPEngine1D`                                       *)
(* DESCRIPTION : The core mathematical engine for 1D generalized Gaussian    *)
(*               wavepackets.                                                *)
(* ========================================================================= *)

(* --- Open the Actual Engine Package --- *)
BeginPackage["GWPTools`GWPEngine1D`"]

Begin["`Private`"]

(* Load dependencies strictly internally *)
Needs["GWPTools`GWPDeveloper`"];
Needs["GWPTools`GWPRegistry`"];


(* ::Section::Closed:: *)
(*Parameters*)


(* ::Subsection::Closed:: *)
(*GWP1DARG/GWP1DVAL*)


(* ========================================================================= *)
(* THE PARAMETER BUS (Core Sequence Macros)                                  *)
(* ========================================================================= *)
(* These variables dynamically expand into the strict 11-element sequence    *)
(* that acts as the universal data bus for all internal physics engines.     *)
(* Do not alter this sequence unless expanding the global physical model     *)
(* (e.g., adding charge, multi-dimensions, or higher-order potentials).      *)
(*                                                                           *)
(* SEQUENCE BREAKDOWN:                                                       *)
(*  1. RA   : Real part of the width parameter \[Alpha]_t. Governs spatial spread.  *)
(*  2. IA   : Imaginary part of the width parameter \[Alpha]_t. The momentum chirp. *)
(*  3. RX   : Position center x_t.                                           *)
(*  4. RP   : Momentum center p_t.                                           *)
(*  5. RG   : Real part of the spatially-independent phase \[Gamma]_t.              *)
(*            Accumulates both the classical action and the quantum phase    *)
(*            shift driven by the shape parameter (wavepacket spreading).    *)
(*  6. IG   : Imaginary part of the spatially-independent phase \[Gamma]_t.         *)
(*            Tracks time-dependent normalization decay/growth.              *)
(*  7. NORM : Time-independent normalization constant.                       *)
(*  8. HBAR : Reduced Planck constant (\[HBar]).                                   *)
(*  9. MASS : Mass of the particle (m).                                      *)
(* 10. {V0, V1, V2} : The local harmonic potential coefficients where        *)
(*                    V(x,t) = V0(t) + V1(t)*x + V2(t)*x^2.                  *)
(* 11. INIT : The time-origin data block. Used by the time-evolution         *)
(*            engines evaluating the LCT (the time-dependent integral of     *)
(*            the classical Lagrangian, L_class(t)).                         *)
(* ========================================================================= *)

GWP1DARG = Sequence[RA_, IA_, RX_, RP_, RG_, IG_, NORM_, HBAR_, MASS_, {V0_, V1_, V2_}, INIT_];
GWP1DVAL = Sequence[RA,  IA,  RX,  RP,  RG,  IG,  NORM,  HBAR,  MASS,  {V0,  V1,  V2},  INIT];


(* --- Helper Pattern for Strict Scalar/Symbol Enforcement --- *)
GWP1DScalarQ[val_] := FreeQ[val, List];


(* ::Subsection::Closed:: *)
(*GWP1DPARAM*)


(* --- Default Options --- *)
Options[GWP1DPARAM] = {"HBAR" -> 1, "MASS" -> 1};


(* --- Error Messages --- *)
GWP1DPARAM::posval = "The value of option `1` -> `2` must be strictly positive.";


(* --- Parameter Generator --- *)
GWP1DPARAM[
  AA : Except[_Rule | _RuleDelayed] : 1/4, 
  XX : Except[_Rule | _RuleDelayed] : 0, 
  PP : Except[_Rule | _RuleDelayed] : 0, 
  GG : Except[_Rule | _RuleDelayed] : 0, 
  opts : OptionsPattern[]
] := Module[{h, m, invalidOpts},
  
  (* Catch Unknown Options *)
  invalidOpts = FilterRules[{opts}, Except[Options[GWP1DPARAM]]];
  If[Length[invalidOpts] > 0,
    Message[General::optx, First[First[invalidOpts]], HoldForm[GWP1DPARAM]];
    Return[$Failed]
  ];

  (* Extract Option Values *)  
  h = OptionValue["HBAR"];
  m = OptionValue["MASS"];

(*    
  (* Enforce strictly positive physical constants (Safely ignores symbols) *)
  If[TrueQ[h <= 0], Message[GWP1DPARAM::posval, "HBAR", h]; Return[$Failed]];
  If[TrueQ[m <= 0], Message[GWP1DPARAM::posval, "MASS", m]; Return[$Failed]];
*)
 (* Enforce strictly positive physical constants and completely reject lists *)
  If[!GWP1DScalarQ[h] || TrueQ[h <= 0], Message[GWP1DPARAM::posval, "HBAR", h]; Return[$Failed]];
  If[!GWP1DScalarQ[m] || TrueQ[m <= 0], Message[GWP1DPARAM::posval, "MASS", m]; Return[$Failed]];

    (* Proceed to engine *)
  GWP1D486[AA, XX, PP, GG, h, m]
];


(* ::Subsection::Closed:: *)
(*GWP1D486*)


GWP1D486::unnorm = "The real shape parameter RA = `1` must be strictly positive.";
GWP1D486::complexia = "The calculated imaginary shape parameter IA = `1` must be strictly real. Check your uncertainty bounds.";


GWP1D486[A1_, X1_, P1_, G1_, HBAR_, MASS_] := Module[{
  RA1, IA1, RX1, IX1, RP1, IP1, RG1, IG1,
  RA2, IA2, RX2, RP2, RG2, IG2, NORM, PECOEFF, INIT, PARAM
},
  (* --- Complex Expand Input Parameters --- *)
  {RA1, IA1} = GWP1DSHAPE[A1, HBAR, MASS];
  {RX1, IX1} = GWP1DPOSITION[X1];
  {RP1, IP1} = GWP1DMOMENTUM[P1, MASS];
  
  (* Fail Fast before GWP1DPHASE if primary kinematics failed *)
  If[ContainsAny[{RA1, RX1, RP1}, {$Failed}], Return[$Failed]];  
  
  {RG1, IG1} = GWP1DPHASE[G1, HBAR, RA1, RX1, RP1];
  If[RG1 === $Failed, Return[$Failed]];

  (* --- Fail Fast if any parser returned $Failed --- *)
  If[ContainsAny[{RA1, RX1, RP1, RG1}, {$Failed}], Return[$Failed]];

  (* --- Physics Validation --- *)
  If[TrueQ[RA1 <= 0], Message[GWP1D486::unnorm, RA1]; Return[$Failed]];
  If[TrueQ[!Element[IA1, Reals]], Message[GWP1D486::complexia, IA1]; Return[$Failed]];
  
  (* --- Rearrange to Double-Primed Real Parameters --- *)
  RA2 = RA1;
  IA2 = IA1;
  RX2 = -1/2*(IP1 + 2*HBAR*IA1*IX1)/(HBAR*RA1) + RX1;
  RP2 = (IA1*(IP1 + 2*HBAR*IA1*IX1))/RA1 + 2*HBAR*IX1*RA1 + RP1;
  RG2 = -(HBAR*IA1*IX1^2) - (IA1*IP1^2)/(4*HBAR*RA1^2) - (IA1^2*IP1*IX1)/RA1^2 - (HBAR*IA1^3*IX1^2)/RA1^2 + RG1 - (IP1*RP1)/(2*HBAR*RA1) - (IA1*IX1*RP1)/RA1;
  IG2 = IG1 - IP1^2/(4*HBAR*RA1) - (IA1*IP1*IX1)/RA1 - (HBAR*IA1^2*IX1^2)/RA1 - HBAR*IX1^2*RA1 - IX1*RP1;
  
  (* --- Normalization, Environment, and Metadata --- *)
  NORM    = E^(IG1/HBAR - IP1^2/(4*HBAR^2*RA1) - (IA1*IP1*IX1)/(HBAR*RA1) - (IX1^2*(IA1^2 + RA1^2))/RA1 - (IX1*RP1)/HBAR)*(2/Pi)^(1/4)*RA1^(1/4);
  PECOEFF = {0, 0, 0};
  INIT    = {RA1, IA1, RX1, IX1, RP1, IP1, RG1, IG1};

  (* --- Return Evaluated Parameter Sequence --- *)
  PARAM = Sequence @@ {RA2, IA2, RX2, RP2, RG2, IG2, NORM, HBAR, MASS, PECOEFF, INIT};
  Sequence @@ Simplify[{PARAM}, GWP1DASSUMPTIONS@PARAM]
];


(* ::Subsection::Closed:: *)
(*Parameter Parsers*)


(* --- Error Messages --- *)
GWP1DSHAPE::badform = "The shape parameter format `1` is invalid. Provide a scalar, {\"Covariance\", UX, COVXP}, or {\"Uncertainty\", UX, UP, Sign}.";
GWP1DPOSITION::badform = "The position parameter format `1` is invalid. Provide a scalar or complex number.";
GWP1DMOMENTUM::badform = "The momentum parameter format `1` is invalid. Provide a scalar or {\"KineticEnergy\", E, Sign}.";
GWP1DPHASE::badform = "The phase parameter format `1` is invalid. See documentation for valid list formats.";

(* --- Shape Parser --- *)
GWP1DSHAPE[A1_, HBAR_, MASS_] := Replace[A1, {
  (* Spatial Uncertainty and x-p Covariance *)
  {"Covariance", ux_?GWP1DScalarQ, covxp_?GWP1DScalarQ} :> 
    {1 / (4 * ux^2), -covxp / (2 * HBAR * ux^2)},
  
  (* Spatial and Momentum Uncertainties with Chirp Direction (+1 or -1) *)
  {"Uncertainty", ux_?GWP1DScalarQ, up_?GWP1DScalarQ, chirp_?GWP1DScalarQ} :> 
    {1 / (4 * ux^2), Sign[chirp] * Sqrt[(up^2 / (4 * HBAR^2 * ux^2)) - 1 / (16 * ux^4)]},
  
  (* Restrict fallback to strictly list-free scalar/symbolic expressions *)
  alpha_?GWP1DScalarQ :> ComplexExpand @ ReIm @ alpha,
  
  (* Catch everything else (including nested lists) *)
  bad_ :> (Message[GWP1DSHAPE::badform, bad]; {$Failed, $Failed})
}]

(* --- Position Parser --- *)
GWP1DPOSITION[X1_] := Replace[X1, {
  x_?GWP1DScalarQ :> ComplexExpand @ ReIm @ x,
  bad_ :> (Message[GWP1DPOSITION::badform, bad]; {$Failed, $Failed})
}]

(* --- Momentum Parser --- *)
GWP1DMOMENTUM[P1_, MASS_] := Replace[P1, {
  {"KineticEnergy", ek_?GWP1DScalarQ, sign_?GWP1DScalarQ} :> 
    {Sign[sign] * Sqrt[2 * MASS * ek], 0},
  
  p_?GWP1DScalarQ :> ComplexExpand @ ReIm @ p,
  bad_ :> (Message[GWP1DMOMENTUM::badform, bad]; {$Failed, $Failed})
}]

(* --- Phase Parser --- *)
GWP1DPHASE[G1_, HBAR_, RA_, RX_, RP_] := Replace[G1, {
  {"Action", action_?GWP1DScalarQ, mu_?GWP1DScalarQ} :> 
    {action - HBAR * mu * Pi / 2, -(HBAR / 4) * Log[(2 * RA) / Pi]},
    
  {"Action", action_?GWP1DScalarQ} :> 
    {action, -(HBAR / 4) * Log[(2 * RA) / Pi]},
    
  {"Displacement", X0_?GWP1DScalarQ, P0_?GWP1DScalarQ} :> 
    {(RX - X0) * (RP - P0) / 2, -(HBAR / 4) * Log[(2 * RA) / Pi]},
    
  {"Coefficient", phi_?GWP1DScalarQ, weight_?GWP1DScalarQ} :> 
    {HBAR * phi, -HBAR * Log[weight]},
    
  {"Evolution", en_?GWP1DScalarQ, t_?GWP1DScalarQ} :> 
    {-en * t, 0},
    
  gamma_?GWP1DScalarQ :> ComplexExpand @ ReIm @ gamma,
  bad_ :> (Message[GWP1DPHASE::badform, bad]; {$Failed, $Failed})
}]


(* ::Subsection::Closed:: *)
(*Parameter Extractors*)


(* --- GWP1D Parameter Extraction ---*)
GWP1DRA[GWP1DARG]=RA;
GWP1DIA[GWP1DARG]=IA;
GWP1DRX[GWP1DARG]=RX;
GWP1DRP[GWP1DARG]=RP;
GWP1DRG[GWP1DARG]=RG;
GWP1DIG[GWP1DARG]=IG;
GWP1DNORM[GWP1DARG]=NORM;
GWP1DMASS[GWP1DARG]=MASS;
GWP1DHBAR[GWP1DARG]=HBAR;
GWP1DPECOEFF[GWP1DARG]={V0,V1,V2};
GWP1DINPUT[GWP1DARG]=INIT;
GWP1DINIT[GWP1DARG]={RA,IA,RX,RP,RG,IG};


(* ::Subsection::Closed:: *)
(*GWP1DASSUMPTIONS*)


(* --- Default Options --- *)
Options[GWP1DASSUMPTIONS] = {
  "Position"         -> None, 
  "Momentum"         -> None, 
  "Cumulative"       -> None, 
  "Time"             -> None, 
  "Energy"           -> None, 
  "RP2Sign"          -> None,
  "IntegerVariables" -> None
};


(* --- Error Messages --- *)
GWP1DASSUMPTIONS::rp2conflict = "The requested RP2Sign (`1`) explicitly contradicts the evaluated effective momentum (RP2 = `2`).";


(* --- GWP1D Assumption Generator Engine --- *)
GWP1DASSUMPTIONS[GWP1DARG, opts : OptionsPattern[]] := Module[{
  RA1, IA1, RX1, IX1, RP1, IP1, RG1, IG1, 
  symbs, realSymbs, intSymbs, raSymbs, iaSqrts, shapeCondList, shapeCond,
  base, cond, extra, x, p, c, t, e, rp2sign, RP2val, requestedCond,
  intVars, invalidOpts
},

  (* Catch Unknown Options *)
  invalidOpts = FilterRules[{opts}, Except[Options[GWP1DASSUMPTIONS]]];
  If[Length[invalidOpts] > 0,
    Message[General::optx, First[First[invalidOpts]], HoldForm[GWP1DASSUMPTIONS]];
    Return[$Failed]
  ];
  
  (* Extract raw initial parameters from the bound INIT list *)
  {RA1, IA1, RX1, IX1, RP1, IP1, RG1, IG1} = INIT;

  (* Extract atomic symbols for real-domain declarations *)
  symbs = Select[
    Union @ Cases[{INIT, HBAR, MASS, V0, V1, V2}, _Symbol, Infinity], 
    Context[#] =!= "System`" &
  ];

  (* Extract integer options and filter generic symbols *)
  intVars   = OptionValue["IntegerVariables"];
  intSymbs  = If[intVars === None, {}, Flatten[{intVars}]];
  realSymbs = Complement[symbs, intSymbs];

  (* Construct core real and integer domain assumptions *)
  base = True;
  If[Length[realSymbs] > 0, base = base && Element[Alternatives @@ realSymbs, Reals]];
  If[Length[intSymbs] > 0,  base = base && Element[Alternatives @@ intSymbs, Integers]];

  (* Smart shape conditions (preventing And[] absorption) *)
  raSymbs = Select[Union @ Cases[{RA1}, _Symbol, Infinity], Context[#] =!= "System`" &];
  iaSqrts = Cases[{IA1}, Power[arg_, 1/2] :> arg, Infinity];
  
  shapeCondList = Join[
    # > 0 & /@ raSymbs,
    If[Length[iaSqrts] > 0,
      Join[
        {iaSqrts[[1]] >= 0}, 
        # > 0 & /@ Select[Union @ Cases[{iaSqrts[[1]]}, _Symbol, Infinity], Context[#] =!= "System`" &]
      ],
      {} 
    ]
  ];

  shapeCond = If[Length[shapeCondList] > 0, And @@ shapeCondList, True];
  cond      = shapeCond && HBAR > 0 && MASS > 0;
  
  (* Extract dynamic coordinate Options *)
  x       = OptionValue["Position"];
  p       = OptionValue["Momentum"];
  c       = OptionValue["Cumulative"];
  t       = OptionValue["Time"];
  e       = OptionValue["Energy"];
  rp2sign = OptionValue["RP2Sign"];

  (* Build dynamic coordinate assumptions *)
  extra = True;
  If[x =!= None, extra = extra && Element[x, Reals]];
  If[p =!= None, extra = extra && Element[p, Reals]];
  If[t =!= None, extra = extra && Element[t, Reals]];
  If[c =!= None, extra = extra && Element[c, Reals] && 0 < c < 1];
  If[e =!= None, extra = extra && Element[e, Reals] && 0 < e];
  
  (* Inject RP2 branch cut assumption *)
  If[rp2sign =!= None,
    RP2val = (IA1*(IP1 + 2*HBAR*IA1*IX1))/RA1 + 2*HBAR*IX1*RA1 + RP1;
    requestedCond = Which[
      rp2sign > 0,  RP2val > 0,
      rp2sign < 0,  RP2val < 0,
      rp2sign == 0, RP2val == 0,
      True,         True
    ];
    
    If[requestedCond === False,
      Message[GWP1DASSUMPTIONS::rp2conflict, rp2sign, RP2val];
      Return[$Failed];
    ];
    
    cond = cond && requestedCond;
  ];
  
  (* Return perfectly merged assumption sequence *)
  base && FullSimplify[cond, Assumptions -> True] && extra
];


(* ::Subsection::Closed:: *)
(*GWP1D Time-Dependent Parameters*)


(* --- GWP1D Time-Dependent Parameters ---*)
GWP1DRATD[GWP1DARG]=4*HBAR/MASS*RA*IA;
GWP1DIATD[GWP1DARG]=-2*HBAR/MASS*(RA^2-IA^2)+V2/HBAR;
GWP1DRXTD[GWP1DARG]=RP/MASS;
GWP1DRPTD[GWP1DARG]=-(V1+2*V2*RX);
GWP1DRGTD[GWP1DARG]=RP^2/(2*MASS)-(V0+V1*RX+V2*RX^2)-HBAR^2/MASS*RA;
GWP1DIGTD[GWP1DARG]=-HBAR^2/MASS*IA


(* ::Section::Closed:: *)
(*Potential Models*)


(* ::Subsection::Closed:: *)
(*Named Potential Models*)


(* --- Named Systems ---*)
GWP1DFREE[t_][GWP1DARG]=GWP1DLINEAR[0][t][GWP1DVAL];
GWP1DHO[t_][GWP1DARG]=GWP1DHARMONIC[1][t][GWP1DVAL];


(* ::Subsection::Closed:: *)
(*Linear Potential*)


(* --- Note on Phase Evolution & 'LCT' Terms --- *)
(* For non-free potentials, the exact time-dependent phase relies on the     *)
(* classical action. The 'LCT' (Lagrangian Classical Term) functions compute *)
(* the exact time-integral of the classical Lagrangian along the center of   *)
(* the wavepacket's trajectory: Integral[ L(x(t), v(t)), dt ].               *)


GWP1DLINEARFUN={GWP1DLINEARRAT,GWP1DLINEARIAT,GWP1DLINEARRXT,GWP1DLINEARRPT,GWP1DLINEARRGT,GWP1DLINEARIGT};
SetAttributes[GWP1DLINEARFUN,Listable];
GWP1DLINEAR[FK_:1][t_][GWP1DARG]=Sequence@@{Sequence@@Through[Through[GWP1DLINEARFUN[t,FK]][GWP1DVAL]],NORM,HBAR,MASS,{0,FK,0},INIT};
GWP1DLINEARRAT[t_,FK_][GWP1DARG]=(MASS^2*RA)/(MASS^2 - 4*HBAR*IA*MASS*t + 4*HBAR^2*(IA^2 + RA^2)*t^2);
GWP1DLINEARIAT[t_,FK_][GWP1DARG]=(MASS*(IA*MASS - 2*HBAR*(IA^2 + RA^2)*t))/(MASS^2 - 4*HBAR*IA*MASS*t + 4*HBAR^2*(IA^2 + RA^2)*t^2);
GWP1DLINEARRXT[t_,FK_][GWP1DARG]=RX + (RP*t)/MASS - (FK*t^2)/(2*MASS);
GWP1DLINEARRPT[t_,FK_][GWP1DARG]=RP - FK*t;
GWP1DLINEARLCT[t_,FK_][GWP1DARG]=(t*(3*RP^2 - 6*FK*RP*t + 2*FK*(-3*MASS*RX + FK*t^2)))/(6*MASS);
GWP1DLINEARRGT[t_,FK_][GWP1DARG]=RG + GWP1DLINEARLCT[t,FK][GWP1DVAL] - (HBAR*ArcTan[1 - (2*HBAR*IA*t)/MASS, (2*HBAR*RA*t)/MASS])/2;
(*LINEARIGT[t_,FK_][GWP1DARG]=IG + (HBAR*(-2*Log[MASS] + Log[4*HBAR^2*RA^2*t^2 + (MASS - 2*HBAR*IA*t)^2]))/4;*)
GWP1DLINEARIGT[t_,FK_][GWP1DARG]=IG + (HBAR*Log[4*HBAR^2*RA^2*t^2/MASS^2 + (MASS - 2*HBAR*IA*t)^2/MASS^2])/4;


(* ::Subsection::Closed:: *)
(*Harmonic Oscillator Potential*)


GWP1DHARMONICFUN={GWP1DHARMONICRAT,GWP1DHARMONICIAT,GWP1DHARMONICRXT,GWP1DHARMONICRPT,GWP1DHARMONICRGT,GWP1DHARMONICIGT};
SetAttributes[GWP1DHARMONICFUN,Listable];
GWP1DHARMONIC[OMEGA_:1][t_][GWP1DARG]=Sequence@@{Sequence@@Through[Through[GWP1DHARMONICFUN[t,OMEGA]][GWP1DVAL]],NORM,HBAR,MASS,{0,0,MASS*OMEGA^2/2},INIT};
GWP1DHARMONICRAT[t_,OMEGA_][GWP1DARG]=(MASS^2*OMEGA^2*RA)/(4*HBAR^2*(IA^2 + RA^2)*Sin[OMEGA*t]^2 + MASS*OMEGA*(MASS*OMEGA*Cos[OMEGA*t]^2 - 2*HBAR*IA*Sin[2*OMEGA*t]));
GWP1DHARMONICIAT[t_,OMEGA_][GWP1DARG]=(MASS*OMEGA*(4*HBAR*IA*MASS*OMEGA*Cos[2*OMEGA*t] + (MASS^2*OMEGA^2 - 4*HBAR^2*(IA^2 + RA^2))*Sin[2*OMEGA*t]))/(4*(4*HBAR^3*(IA^2 + RA^2)*Sin[OMEGA*t]^2 + HBAR*MASS*OMEGA*(MASS*OMEGA*Cos[OMEGA*t]^2 - 2*HBAR*IA*Sin[2*OMEGA*t])));
GWP1DHARMONICRXT[t_,OMEGA_][GWP1DARG]=RX*Cos[OMEGA*t] + (RP*Sin[OMEGA*t])/(MASS*OMEGA);
GWP1DHARMONICRPT[t_,OMEGA_][GWP1DARG]=RP*Cos[OMEGA*t] - MASS*OMEGA*RX*Sin[OMEGA*t];
GWP1DHARMONICLCT[t_,OMEGA_][GWP1DARG]=(Sin[OMEGA*t]*((RP^2/(MASS*OMEGA) - MASS*OMEGA*RX^2)*Cos[OMEGA*t] - 2*RP*RX*Sin[OMEGA*t]))/2;
GWP1DHARMONICRGT[t_,OMEGA_][GWP1DARG]=RG+GWP1DHARMONICLCT[t,OMEGA][GWP1DVAL]-1/2*(HBAR*ArcTan[(MASS*OMEGA*Cos[OMEGA*t])/HBAR - 2*IA*Sin[OMEGA*t], 2*RA*Sin[OMEGA*t]])+HBAR*Pi*Floor[(Pi - OMEGA*t)/(2*Pi)];
GWP1DHARMONICIGT[t_,OMEGA_][GWP1DARG]=IG+(HBAR*Log[(4*HBAR^2*(RA^2*Sin[OMEGA*t]^2 + (-1/2*(MASS*OMEGA*Cos[OMEGA*t])/HBAR + IA*Sin[OMEGA*t])^2))/(MASS^2*OMEGA^2)])/4;


(* ::Subsection::Closed:: *)
(*Parabolic Potential*)


GWP1DPARABOLICFUN={GWP1DPARABOLICRAT,GWP1DPARABOLICIAT,GWP1DPARABOLICRXT,GWP1DPARABOLICRPT,GWP1DPARABOLICRGT,GWP1DPARABOLICIGT};
SetAttributes[GWP1DPARABOLICFUN,Listable];
GWP1DPARABOLIC[OMEGA_:1][t_][GWP1DARG]=Sequence@@{Sequence@@Through[Through[GWP1DPARABOLICFUN[t,OMEGA]][GWP1DVAL]],NORM,HBAR,MASS,{0,0,-MASS*OMEGA^2/2},INIT};
GWP1DPARABOLICRAT[t_,OMEGA_][GWP1DARG]=(MASS^2*OMEGA^2*RA)/(4*HBAR^2*(IA^2 + RA^2)*Sinh[OMEGA*t]^2 + MASS*OMEGA*(MASS*OMEGA*Cosh[OMEGA*t]^2 - 2*HBAR*IA*Sinh[2*OMEGA*t]));
GWP1DPARABOLICIAT[t_,OMEGA_][GWP1DARG]=(MASS*OMEGA*(4*HBAR*IA*MASS*OMEGA*Cosh[2*OMEGA*t] - (MASS^2*OMEGA^2 + 4*HBAR^2*(IA^2 + RA^2))*Sinh[2*OMEGA*t]))/(4*(4*HBAR^3*(IA^2 + RA^2)*Sinh[OMEGA*t]^2 + HBAR*MASS*OMEGA*(MASS*OMEGA*Cosh[OMEGA*t]^2 - 2*HBAR*IA*Sinh[2*OMEGA*t])));
GWP1DPARABOLICRXT[t_,OMEGA_][GWP1DARG]=RX*Cosh[OMEGA*t] + (RP*Sinh[OMEGA*t])/(MASS*OMEGA);
GWP1DPARABOLICRPT[t_,OMEGA_][GWP1DARG]=RP*Cosh[OMEGA*t] + MASS*OMEGA*RX*Sinh[OMEGA*t];
GWP1DPARABOLICLCT[t_,OMEGA_][GWP1DARG]=RP*RX*Sinh[OMEGA*t]^2 + ((RP^2 + MASS^2*OMEGA^2*RX^2)*Sinh[2*OMEGA*t])/(4*MASS*OMEGA);
GWP1DPARABOLICRGT[t_,OMEGA_][GWP1DARG]= RG + GWP1DPARABOLICLCT[t,OMEGA][GWP1DVAL] + (HBAR*ArcTan[1/2*(MASS*OMEGA*Cosh[OMEGA*t])/HBAR - IA*Sinh[OMEGA*t], -RA*Sinh[OMEGA*t]])/2;
GWP1DPARABOLICIGT[t_,OMEGA_][GWP1DARG]=IG+(HBAR*Log[(MASS^2*OMEGA^2 - 4*HBAR^2*(IA^2 + RA^2) + (MASS^2*OMEGA^2 + 4*HBAR^2*(IA^2 + RA^2))*Cosh[2*OMEGA*t] - 4*HBAR*IA*MASS*OMEGA*Sinh[2*OMEGA*t])/(2*MASS^2*OMEGA^2)])/4;


(* ::Subsection::Closed:: *)
(*Forced Harmonic Oscillator with Linear Driving*)


GWP1DFHOLINFUN={GWP1DFHOLINRAT,GWP1DFHOLINIAT,GWP1DFHOLINRXT,GWP1DFHOLINRPT,GWP1DFHOLINRGT,GWP1DFHOLINIGT};
SetAttributes[GWP1DFHOLINFUN,Listable];
GWP1DFHOLIN[OMEGA_:1,FA_:1/10][t_][GWP1DARG]=Sequence@@{Sequence@@Through[Through[GWP1DFHOLINFUN[t,OMEGA,FA]][GWP1DVAL]],NORM,HBAR,MASS,{0,-FA*t,MASS*OMEGA^2/2},INIT};
GWP1DFHOLINRAT[t_,OMEGA_,FA_][GWP1DARG]=GWP1DHARMONICRAT[t,OMEGA][GWP1DVAL];
GWP1DFHOLINIAT[t_,OMEGA_,FA_][GWP1DARG]=GWP1DHARMONICIAT[t,OMEGA][GWP1DVAL];
GWP1DFHOLINRXT[t_,OMEGA_,FA_][GWP1DARG]=(FA*OMEGA*t + MASS*OMEGA^3*RX*Cos[OMEGA*t] + (-FA + OMEGA^2*RP)*Sin[OMEGA*t])/(MASS*OMEGA^3);
GWP1DFHOLINRPT[t_,OMEGA_,FA_][GWP1DARG]=(FA + (-FA + OMEGA^2*RP)*Cos[OMEGA*t] - MASS*OMEGA^3*RX*Sin[OMEGA*t])/OMEGA^2;
GWP1DFHOLINLCINT[t_,OMEGA_,FA_][GWP1DARG]=(2*FA*OMEGA*(FA*t + (FA*OMEGA^2*t^3)/3 + 2*MASS*OMEGA^2*RX*(-1 + Cos[OMEGA*t])) + 4*(FA - OMEGA^2*RP)*Sin[OMEGA*t]*(-FA + MASS*OMEGA^3*RX*Sin[OMEGA*t]) + ((FA - OMEGA^2*RP)^2 - MASS^2*OMEGA^6*RX^2)*Sin[2*OMEGA*t])/(4*MASS*OMEGA^5);
GWP1DFHOLINRGT[t_,OMEGA_,FA_][GWP1DARG]=RG+GWP1DFHOLINLCINT[t,OMEGA,FA][GWP1DVAL]-1/2*(HBAR*ArcTan[(MASS*OMEGA*Cos[OMEGA*t])/HBAR - 2*IA*Sin[OMEGA*t], 2*RA*Sin[OMEGA*t]])+HBAR*Pi*Floor[(Pi - OMEGA*t)/(2*Pi)];
GWP1DFHOLINIGT[t_,OMEGA_,FA_][GWP1DARG]=GWP1DHARMONICIGT[t,OMEGA][GWP1DVAL];


(* ::Subsection::Closed:: *)
(*Forced Harmonic Oscillator with Sinusoidal Resonant Driving*)


GWP1DFHORESFUN={GWP1DFHORESRAT,GWP1DFHORESIAT,GWP1DFHORESRXT,GWP1DFHORESRPT,GWP1DFHORESRGT,GWP1DFHORESIGT};
SetAttributes[GWP1DFHORESFUN,Listable];
GWP1DFHORES[OMEGA_:1,FA_:1/10][t_][GWP1DARG]=Sequence@@{Sequence@@Through[Through[GWP1DFHORESFUN[t,OMEGA,FA]][GWP1DVAL]],NORM,HBAR,MASS,{0,-FA*Sin[OMEGA*t],MASS*OMEGA^2/2},INIT};
GWP1DFHORESRAT[t_,OMEGA_,FA_][GWP1DARG]=GWP1DHARMONICRAT[t,OMEGA][GWP1DVAL];
GWP1DFHORESIAT[t_,OMEGA_,FA_][GWP1DARG]=GWP1DHARMONICIAT[t,OMEGA][GWP1DVAL];
GWP1DFHORESRXT[t_,OMEGA_,FA_][GWP1DARG]=(OMEGA*(2*MASS*OMEGA*RX - FA*t)*Cos[OMEGA*t] + (FA + 2*OMEGA*RP)*Sin[OMEGA*t])/(2*MASS*OMEGA^2);
GWP1DFHORESRPT[t_,OMEGA_,FA_][GWP1DARG]=RP*Cos[OMEGA*t] + ((-2*MASS*OMEGA*RX + FA*t)*Sin[OMEGA*t])/2;
GWP1DFHORESLCT[t_,OMEGA_,FA_][GWP1DARG]=(-16*MASS*OMEGA^3*RP*RX + 2*FA*OMEGA*(3*FA + 4*OMEGA*RP)*t + 8*OMEGA^2*RP*(2*MASS*OMEGA*RX - FA*t)*Cos[2*OMEGA*t] + (8*OMEGA^2*RP^2 - 8*MASS^2*OMEGA^4*RX^2 + 8*FA*MASS*OMEGA^3*RX*t - FA^2*(3 + 2*OMEGA^2*t^2))*Sin[2*OMEGA*t])/(32*MASS*OMEGA^3);
GWP1DFHORESRGT[t_,OMEGA_,FA_][GWP1DARG]=RG+GWP1DFHORESLCT[t,OMEGA,FA][GWP1DVAL]-1/2*(HBAR*ArcTan[(MASS*OMEGA*Cos[OMEGA*t])/HBAR - 2*IA*Sin[OMEGA*t], 2*RA*Sin[OMEGA*t]])+HBAR*Pi*Floor[(Pi - OMEGA*t)/(2*Pi)];
GWP1DFHORESIGT[t_,OMEGA_,FA_][GWP1DARG]=GWP1DHARMONICIGT[t,OMEGA][GWP1DVAL];


(* ::Subsection::Closed:: *)
(*Forced Harmonic Oscillator with Sinusoidal Non-resonant Driving*)


GWP1DFHONONFUN={GWP1DFHONONRAT,GWP1DFHONONIAT,GWP1DFHONONRXT,GWP1DFHONONRPT,GWP1DFHONONRGT,GWP1DFHONONIGT};
SetAttributes[GWP1DFHONONFUN,Listable];
GWP1DFHONON[OMEGA_:1,FA_:1/10,OMEGA1_:2][t_][GWP1DARG]=Sequence@@{Sequence@@Through[Through[GWP1DFHONONFUN[t,OMEGA,FA,OMEGA1]][GWP1DVAL]],NORM,HBAR,MASS,{0,-FA*Sin[OMEGA1*t],MASS*OMEGA^2/2},INIT};
GWP1DFHONONRAT[t_,OMEGA_,FA_,OMEGA1_][GWP1DARG]=GWP1DHARMONICRAT[t,OMEGA][GWP1DVAL];
GWP1DFHONONIAT[t_,OMEGA_,FA_,OMEGA1_][GWP1DARG]=GWP1DHARMONICIAT[t,OMEGA][GWP1DVAL];
GWP1DFHONONRXT[t_,OMEGA_,FA_,OMEGA1_][GWP1DARG]=(MASS*OMEGA*(OMEGA^2 - OMEGA1^2)*RX*Cos[OMEGA*t] - (FA*OMEGA1 - OMEGA^2*RP + OMEGA1^2*RP)*Sin[OMEGA*t] + FA*OMEGA*Sin[OMEGA1*t])/(MASS*OMEGA*(OMEGA^2 - OMEGA1^2));
GWP1DFHONONRPT[t_,OMEGA_,FA_,OMEGA1_][GWP1DARG]=(-((FA*OMEGA1 + (-OMEGA^2 + OMEGA1^2)*RP)*Cos[OMEGA*t]) + FA*OMEGA1*Cos[OMEGA1*t] + MASS*OMEGA*(-OMEGA^2 + OMEGA1^2)*RX*Sin[OMEGA*t])/(OMEGA^2 - OMEGA1^2);
GWP1DFHONONLCT[t_,OMEGA_,FA_,OMEGA1_][GWP1DARG]=(-2*OMEGA*(OMEGA - OMEGA1)*OMEGA1*(OMEGA + OMEGA1)*(2*MASS*(FA*OMEGA1 + (OMEGA - OMEGA1)*(OMEGA + OMEGA1)*RP)*RX - FA^2*t) + 4*MASS*OMEGA*(OMEGA - OMEGA1)*OMEGA1*(OMEGA + OMEGA1)*(OMEGA^2*RP - OMEGA1*(FA + OMEGA1*RP))*RX*Cos[2*OMEGA*t] + 8*FA*MASS*OMEGA*(OMEGA - OMEGA1)*OMEGA1^2*(OMEGA + OMEGA1)*RX*Cos[OMEGA*t]*Cos[OMEGA1*t] - 8*FA*OMEGA1^2*(-(OMEGA^2*RP) + OMEGA1*(FA + OMEGA1*RP))*Cos[OMEGA1*t]*Sin[OMEGA*t] + 2*OMEGA1*(FA*OMEGA1 + (OMEGA - OMEGA1)*(OMEGA + OMEGA1)*(-RP + MASS*OMEGA*RX))*(FA*OMEGA1 - (OMEGA - OMEGA1)*(OMEGA + OMEGA1)*(RP + MASS*OMEGA*RX))*Sin[2*OMEGA*t] - FA^2*OMEGA*(OMEGA^2 - 3*OMEGA1^2)*Sin[2*OMEGA1*t])/(8*MASS*OMEGA*OMEGA1*(OMEGA^2 - OMEGA1^2)^2);
GWP1DFHONONRGT[t_,OMEGA_,FA_,OMEGA1_][GWP1DARG]=RG+GWP1DFHONONLCT[t,OMEGA,FA,OMEGA1][GWP1DVAL]-1/2*(HBAR*ArcTan[(MASS*OMEGA*Cos[OMEGA*t])/HBAR - 2*IA*Sin[OMEGA*t], 2*RA*Sin[OMEGA*t]])+HBAR*Pi*Floor[(Pi - OMEGA*t)/(2*Pi)];
GWP1DFHONONIGT[t_,OMEGA_,FA_,OMEGA1_][GWP1DARG]=GWP1DHARMONICIGT[t,OMEGA][GWP1DVAL];


(* ::Subsection::Closed:: *)
(*External Potential and Force*)


(* --- x-Space External Potential Energy Field --- *)
GWP1DPEX[0][x_][GWP1DARG] := V0 + V1 * x + V2 * x^2;
GWP1DPEX[1][x_][GWP1DARG] := V1 + 2*V2*x;
GWP1DPEX[2][x_][GWP1DARG] := 2*V2;
GWP1DPEX[n_Integer][x_][GWP1DARG] /; n >= 3 := 0; 
(* Fallback: Route GWP1DPEX[x][...] to the 0th derivative *)
GWP1DPEX[x_][arg___] /; !MatchQ[Unevaluated[GWP1DPEX[x]], GWP1DPEX[_Integer]] := GWP1DPEX[0][x][arg];


(* --- x-Space External Force Field --- *)
GWP1DFEX[0][x_][GWP1DARG] := -V1 - 2 * V2 * x;
GWP1DFEX[1][x_][GWP1DARG] := -2 * V2;
GWP1DFEX[n_Integer][x_][GWP1DARG] /; n >= 2 := 0;
(* Fallback: Route GWP1DFEX[x][...] to the 0th derivative *)
GWP1DFEX[x_][arg___] /; !MatchQ[Unevaluated[GWP1DFEX[x]], GWP1DFEX[_Integer]] := GWP1DFEX[0][x][arg];


(* ::Section::Closed:: *)
(*Wavefunctions*)


(* --- Private Worker Function for Wavefunction Recursion --- *)
(* Implements the generalized three-term Hermite polynomial recurrence: *)
(* P_n(z) = p1 * P_{n-1}(z) - 2 * coeff * (n - 1) * P_{n-2}(z)          *)
GWP1DHermiteEngine[n_Integer, p1_, coeff_] := Module[{pPrev2, pPrev1, pCurr},
  pPrev2 = 0; 
  pPrev1 = 1; 
  pCurr = pPrev1; 
  Do[
    pCurr = Expand[If[i == 1, p1, p1 * pPrev1 - 2 * coeff * (i - 1) * pPrev2]];
    pPrev2 = pPrev1; 
    pPrev1 = pCurr,
    {i, 1, n}
  ]; 
  pCurr
];


(* --- x-Space Wavefunctions --- *)
GWP1DPSIX[n_Integer][x_][GWP1DARG] := Module[{raia, p1, poly},
  raia = RA + I*IA;
  p1 = -2 * raia * (x - RX) + (I * RP) / HBAR;  
  (* Generate the polynomial using the worker engine *)
  poly = GWP1DHermiteEngine[n, p1, raia];
  poly * NORM * Exp[-(RA + I*IA)*(x - RX)^2 + (I/HBAR)*RP*(x - RX) + (I/HBAR)*(RG + I*IG)]
];
(* Fallback: Route GWP1DPSIX[x][...] to the 0th derivative *)
GWP1DPSIX[x_][arg___] /; !MatchQ[Unevaluated[GWP1DPSIX[x]], GWP1DPSIX[_Integer]] := GWP1DPSIX[0][x][arg];


(* --- x-space Complex Conjugate Wavefunction --- *)
GWP1DCSIX[n_Integer][x_][GWP1DARG] := Module[{raia, p1, poly},
  raia = RA - I*IA;
  p1 = -2 * raia * (x - RX) + (-I * RP) / HBAR; 
  poly = GWP1DHermiteEngine[n, p1, raia]; 
  poly * NORM * Exp[-(RA - I*IA)*(x - RX)^2 - (I/HBAR)*RP*(x - RX) - (I/HBAR)*(RG - I*IG)]
];
(* Fallback: Route GWP1DCSIX[x][...] to the 0th derivative *)
GWP1DCSIX[x_][arg___] /; !MatchQ[Unevaluated[GWP1DCSIX[x]], GWP1DCSIX[_Integer]] := GWP1DCSIX[0][x][arg];


(* --- x-Space Real and Imaginary Wavefunction Components --- *)
GWP1DRSIX[x_][GWP1DARG] = NORM * Exp[-(IG/HBAR) - RA*(RX - x)^2] * Cos[(RG - (RP + HBAR*IA*(RX - x))*(RX - x))/HBAR];
GWP1DISIX[x_][GWP1DARG] = NORM * Exp[-(IG/HBAR) - RA*(RX - x)^2] * Sin[(RG - (RP + HBAR*IA*(RX - x))*(RX - x))/HBAR];


(* --- p-Space Wavefunctions --- *)
GWP1DPSIP[n_Integer][p_][GWP1DARG] := Module[{a, b, p1, poly, shift, normP, phaseP},
  a = RA + I*IA;
  b = 1 / (4 * a * HBAR^2);
  shift = p - RP;
  p1 = -2 * b * shift - (I * RX) / HBAR;
  poly = GWP1DHermiteEngine[n, p1, b];
  normP = NORM / Sqrt[2 * HBAR * a];
  phaseP = Exp[-b * shift^2 - (I/HBAR) * RX * p + (I/HBAR) * (RG + I*IG)];     
  poly * normP * phaseP
];
(* Fallback: Route GWP1DPSIP[p][...] to the 0th derivative *)
GWP1DPSIP[p_][arg___] /; !MatchQ[Unevaluated[GWP1DPSIP[p]], GWP1DPSIP[_Integer]] := GWP1DPSIP[0][p][arg];


(* --- p-Space Complex Conjugate Wavefunction --- *)
GWP1DCSIP[n_Integer][p_][GWP1DARG] := Module[{a, b, p1, poly, shift, normP, phaseP},
  a = RA - I*IA;
  b = 1 / (4 * a * HBAR^2);
  shift = p - RP;
  p1 = -2 * b * shift - (-I * RX) / HBAR; 
  poly = GWP1DHermiteEngine[n, p1, b];
  normP = NORM / Sqrt[2 * HBAR * a];
  phaseP = Exp[-b * shift^2 - (-I/HBAR) * RX * p + (-I/HBAR) * (RG - I*IG)];   
  poly * normP * phaseP
];
(* Fallback: Route GWP1DCSIP[p][...] to the 0th derivative *)
GWP1DCSIP[p_][arg___] /; !MatchQ[Unevaluated[GWP1DCSIP[p]], GWP1DCSIP[_Integer]] := GWP1DCSIP[0][p][arg];


(* --- p-Space Real and Imaginary Wavefunction Components --- *)
GWP1DRSIP[p_][GWP1DARG] = (NORM * Exp[-IG/HBAR - (RA*(p - RP)^2)/(4*HBAR^2*(RA^2 + IA^2))] * Cos[RG/HBAR - (p*RX)/HBAR + (IA*(p - RP)^2)/(4*HBAR^2*(RA^2 + IA^2)) - 1/2*ArcTan[RA, IA]]) / (4*HBAR^2*(RA^2 + IA^2))^(1/4);
GWP1DISIP[p_][GWP1DARG] = (NORM * Exp[-IG/HBAR - (RA*(p - RP)^2)/(4*HBAR^2*(RA^2 + IA^2))] * Sin[RG/HBAR - (p*RX)/HBAR + (IA*(p - RP)^2)/(4*HBAR^2*(RA^2 + IA^2)) - 1/2*ArcTan[RA, IA]]) / (4*HBAR^2*(RA^2 + IA^2))^(1/4);


(* ::Section::Closed:: *)
(*Probabilities*)


(* --- x-Space Density --- *)
GWP1DRHOX[n_Integer][x_][GWP1DARG] := Module[{alpha, p1, shift, poly},
  alpha = 2 * RA;
  shift = x - RX;
  p1 = -2 * alpha * shift;  
  (* Generate the polynomial using the worker engine *)
  poly = GWP1DHermiteEngine[n, p1, alpha];  
  poly * (Sqrt[2/Pi] * Sqrt[RA]) * Exp[-2 * RA * (x - RX)^2]
];
(* Fallback: Route GWP1DRHOX[x][...] to the 0th derivative *)
GWP1DRHOX[x_][arg___] /; !MatchQ[Unevaluated[GWP1DRHOX[x]], GWP1DRHOX[_Integer]] := GWP1DRHOX[0][x][arg];


(* --- p-Space Density --- *)
GWP1DRHOP[n_Integer][p_][GWP1DARG] := Module[{beta, p1, shift, poly},
  beta = RA / (2 * HBAR^2 * (RA^2 + IA^2));
  shift = p - RP;
  p1 = -2 * beta * shift;  
  (* Generate the polynomial using the worker engine *)
  poly = GWP1DHermiteEngine[n, p1, beta];
  
  poly * Sqrt[RA / (2*Pi*HBAR^2*(RA^2 + IA^2))] * Exp[-beta * (p - RP)^2]
];
(* Fallback: Route GWP1DRHOP[p][...] to the 0th derivative *)
GWP1DRHOP[p_][arg___] /; !MatchQ[Unevaluated[GWP1DRHOP[p]], GWP1DRHOP[_Integer]] := GWP1DRHOP[0][p][arg];


(* --- Energy Density --- *)
GWP1DRHOE[EE_][GWP1DARG] = (Sqrt[MASS/EE] * (
  Sqrt[RA / (HBAR^2*(IA^2 + RA^2))] / (Exp[(RA*(-(Sqrt[2]*Sqrt[EE*MASS]) - RP)^2) / (2*HBAR^2*(IA^2 + RA^2))] * Sqrt[2*Pi]) + 
  Sqrt[RA / (HBAR^2*(IA^2 + RA^2))] / (Exp[(RA*(Sqrt[2]*Sqrt[EE*MASS] - RP)^2) / (2*HBAR^2*(IA^2 + RA^2))] * Sqrt[2*Pi])
)) / Sqrt[2];


(* --- Cumulative Distribution Functions --- *)
GWP1DCX[x_][GWP1DARG] = (1 + Erf[Sqrt[2 * RA] * (x - RX)]) / 2;

GWP1DCP[p_][GWP1DARG] = (1 + Erf[(p - RP) / (Sqrt[2] * HBAR * Sqrt[IA^2/RA + RA])]) / 2;

GWP1DCE[e_][GWP1DARG] := (
  Erf[(Sqrt[RA / (IA^2 + RA^2)] * (2*Sqrt[e*MASS] - Sqrt[2]*RP)) / (2*HBAR)] + 
  Erf[(Sqrt[RA / (IA^2 + RA^2)] * (2*Sqrt[e*MASS] + Sqrt[2]*RP)) / (2*HBAR)]
) / 2;



(* --- Interval Probabilities --- *)
GWP1DPROBX[mn_, mx_][GWP1DARG] = GWP1DCX[mx][GWP1DVAL] - GWP1DCX[mn][GWP1DVAL];
GWP1DPROBP[mn_, mx_][GWP1DARG] = GWP1DCP[mx][GWP1DVAL] - GWP1DCP[mn][GWP1DVAL];
GWP1DPROBE[mn_, mx_][GWP1DARG] = GWP1DCE[mx][GWP1DVAL] - GWP1DCE[mn][GWP1DVAL];


(* ::Section::Closed:: *)
(*ExpectationValues*)


(* --- Position Expectation Values (Arbitrary Order) --- *)
GWP1DEX[n_Integer][GWP1DARG] := Sum[
  Binomial[n, 2*k] * (2*k - 1)!! * (1/(4*RA))^k * If[n - 2*k == 0, 1, RX^(n - 2*k)], 
  {k, 0, Floor[n/2]}
];
(* Fallback: Route GWP1DEX[...] to the 1st moment *)
GWP1DEX[param___] /; !MatchQ[{param}, {_Integer}] := GWP1DEX[1][param];


(* --- Momentum Expectation Values (Arbitrary Order) --- *)
GWP1DEP[n_Integer][GWP1DARG] := Sum[
  Binomial[n, 2*k] * (2*k - 1)!! * (HBAR^2*(RA + (IA^2 / RA)))^k * If[n - 2*k == 0, 1, RP^(n - 2*k)], 
  {k, 0, Floor[n/2]}
];
(* Fallback: Route GWP1DEP[...] to the 1st moment *)
GWP1DEP[param___] /; !MatchQ[{param}, {_Integer}] := GWP1DEP[1][param];


(* --- Position-Momentum Uncertainty --- *)
GWP1DUX[GWP1DARG]  = 1/(2*Sqrt[RA]);
GWP1DUP[GWP1DARG]  = HBAR*Sqrt[RA + IA^2/RA];


(* --- Position-Mometum Product Expectation Values (Arbitrary Order) --- *)
With[{VAL = GWP1DVAL},
  
  (* Base Case: n=0 reduces strictly to a pure position moment *)
  GWP1DEXP[m_Integer /; m >= 0, 0][GWP1DARG] := GWP1DEX[m][VAL];

  (* Recursive Step for n > 0 *)
  GWP1DEXP[m_Integer /; m >= 0, n_Integer /; n > 0][GWP1DARG] := Module[{A, B},
      
    (* Exact algebraic mapping from the Parameter Bus *)
    A = 2 * I * HBAR * (RA + I * IA); 
    B = RP - A * RX;

    (* Forward Recursion (strictly decreases momentum power n) *)
    A * GWP1DEXP[m + 1, n - 1][VAL] + 
    B * GWP1DEXP[m, n - 1][VAL] - 
    If[n >= 2, I * HBAR * A * (n - 1) * GWP1DEXP[m, n - 2][VAL], 0]
  ];
];

(* Fallback: Route default calls to m=1, n=1 *)
GWP1DEXP[args___] /; !MatchQ[{args}, {_Integer, _Integer}] := GWP1DEXP[1, 1][args];


(* --- Mometum-Position Expectation Values (Arbitrary Orders) --- *)
With[{VAL = GWP1DVAL},
  
  (* Base Case: m=0 reduces strictly to a pure position moment *)
  GWP1DEPX[0, n_Integer /; n >= 0][GWP1DARG] := GWP1DEX[n][VAL];

  (* Recursive Step for m > 0 *)
  GWP1DEPX[m_Integer /; m > 0, n_Integer /; n >= 0][GWP1DARG] := Module[{As, Bs},
      
    (* Explicitly written conjugates of A and B using Parameter Bus symbols *)
    As = -2 * I * HBAR * (RA - I * IA); 
    Bs = RP - As * RX;

    (* Reverse Recursion (strictly decreases momentum power m) *)
    As * GWP1DEPX[m - 1, n + 1][VAL] + 
    Bs * GWP1DEPX[m - 1, n][VAL] + 
    If[m >= 2, I * HBAR * As * (m - 1) * GWP1DEPX[m - 2, n][VAL], 0]
  ];
];

(* Fallback: Route default calls to m=1, n=1 *)
GWP1DEPX[args___] /; !MatchQ[{args}, {_Integer, _Integer}] := GWP1DEPX[1, 1][args];


(* --- Position-Momentum Covariance --- *)
GWP1DCOVXP[GWP1DARG] = -1/2*(HBAR*IA)/RA;
GWP1DCORXP[GWP1DARG] = -(IA/Sqrt[IA^2 + RA^2]);


(* --- Force Expectation Values --- *)
GWP1DEF1[GWP1DARG] = -V1 - 2*RX*V2;
GWP1DEF2[GWP1DARG] = (V2^2 + RA*(V1 + 2*RX*V2)^2)/RA;
GWP1DUF[GWP1DARG]  = Abs[V2]/Sqrt[RA];


(* ::Section::Closed:: *)
(*Energies*)


(* --- Note on Analytical Derivations --- *)
(* The massive algebraic expressions for high-order moments, cross-terms,    *)
(* and squared expectations are exact analytical results.*)
(* They were derived offline via exact symbolic integration of the quantum   *)
(* mechanical operators over the underlying Gaussian probability densities.  *)


(* --- Kinetic Energy Expectation Values (arbitrary order) --- *)
With[{VAL = GWP1DVAL},
  GWP1DEKE[n_Integer /; n >= 0][GWP1DARG] := GWP1DEP[2 * n][VAL] / (2 * MASS)^n;
];

(* Fallback: Route default calls to the 1st moment *)
GWP1DEKE[args___] /; !MatchQ[{args}, {_Integer}] := GWP1DEKE[1][args];


(* --- Potential Energy Expectation Values (arbitrary order) --- *)
With[{VAL = GWP1DVAL},
  GWP1DEPE[n_Integer /; n >= 0][GWP1DARG] := Module[{moments},
    moments = Table[GWP1DEX[k][VAL], {k, 0, 2 * n}];
    Sum[
      (n! / (i! * j! * (n - i - j)!)) * 
      If[i == 0, 1, V0^i] * 
      If[j == 0, 1, V1^j] * 
      If[n - i - j == 0, 1, V2^(n - i - j)] * 
      moments[[j + 2 * (n - i - j) + 1]],
      {i, 0, n}, {j, 0, n - i}
    ]
  ];
];

(* Fallback: Route default calls to the 1st moment *)
GWP1DEPE[args___] /; !MatchQ[{args}, {_Integer}] := GWP1DEPE[1][args];


(* --- Kinetic-Potential Energy Cross-Correlations --- *)
GWP1DEKEPE[GWP1DARG] = (-4*HBAR*(IA + I*RA)*RA*RP*(V1 + 2*RX*V2) + HBAR^2*(4*RA*(IA^2 + RA^2)*(V0 + RX*V1) + (IA + I*RA)*(3*IA + I*RA + 4*(IA - I*RA)*RA*RX^2)*V2) + RA*RP^2*(V2 + 4*RA*(V0 + RX*(V1 + RX*V2))))/(8*MASS*RA^2);
GWP1DEPEKE[GWP1DARG] = ((4*I)*HBAR*RA*(I*IA + RA)*RP*(V1 + 2*RX*V2) + HBAR^2*(4*RA*(IA^2 + RA^2)*(V0 + RX*V1) + (IA - I*RA)*(3*IA - I*RA + 4*(IA + I*RA)*RA*RX^2)*V2) + RA*RP^2*(V2 + 4*RA*(V0 + RX*(V1 + RX*V2))))/(8*MASS*RA^2);
GWP1DCOVKEPE[GWP1DARG] = (HBAR*(HBAR*IA^2*V2 - HBAR*RA^2*V2 - 2*IA*RA*RP*(V1 + 2*RX*V2)))/(4*MASS*RA^2);
GWP1DCORKEPE[GWP1DARG] /; (V1 == 0 && V2 == 0) := 0;
GWP1DCORKEPE[GWP1DARG] := (HBAR*(HBAR*IA^2*V2 - HBAR*RA^2*V2 - 2*IA*RA*RP*(V1 + 2*RX*V2))) / 
  (MASS*RA^2 * Sqrt[(HBAR^2*(IA^2 + RA^2)*(HBAR^2*(IA^2 + RA^2) + 2*RA*RP^2))/(MASS^2*RA^2)] * Sqrt[(V2^2 + 2*RA*(V1 + 2*RX*V2)^2)/RA^2]);


(* --- Kinetic-Potential Energy Cross-Correlations (Arbitrary Order) --- *)
With[{VAL = GWP1DVAL},
  GWP1DEKEPE[m_Integer /; m >= 0, n_Integer /; n >= 0][GWP1DARG] := Module[{moments},
    moments = Table[GWP1DEPX[2 * m, k][VAL], {k, 0, 2 * n}];
    Sum[
      (n! / (i! * j! * (n - i - j)!)) * 
      If[i == 0, 1, V0^i] * 
      If[j == 0, 1, V1^j] * 
      If[n - i - j == 0, 1, V2^(n - i - j)] * 
      moments[[j + 2 * (n - i - j) + 1]],
      {i, 0, n}, {j, 0, n - i}
    ] / (2 * MASS)^m
  ];
];

With[{VAL = GWP1DVAL},
  GWP1DEPEKE[m_Integer /; m >= 0, n_Integer /; n >= 0][GWP1DARG] := Module[{moments},
    moments = Table[GWP1DEXP[k, 2 * n][VAL], {k, 0, 2 * m}];
    Sum[
      (m! / (i! * j! * (m - i - j)!)) * 
      If[i == 0, 1, V0^i] * 
      If[j == 0, 1, V1^j] * 
      If[m - i - j == 0, 1, V2^(m - i - j)] * 
      moments[[j + 2 * (m - i - j) + 1]],
      {i, 0, m}, {j, 0, m - i}
    ] / (2 * MASS)^n
  ];
];


(* --- Total Energy Expectation Values (Arbitrary Order Router) --- *)
GWP1DETE::maxorder = "Analytically exact total energy moments are only supported up to n = 4. Requested order: `1`.";

With[{VAL = GWP1DVAL},
  GWP1DETE[n_Integer /; n >= 0][GWP1DARG] := Which[
    n == 0, 1,
    n == 1, GWP1DETE1[VAL],
    n == 2, GWP1DETE2[VAL],
    n == 3, GWP1DETE3[VAL],
    n == 4, GWP1DETE4[VAL],
    True,   Message[GWP1DETE::maxorder, n]; $Failed
  ];
];

(* Fallback: Route default calls to the 1st moment *)
GWP1DETE[args___] /; !MatchQ[{args}, {_Integer}] := GWP1DETE[1][args];


(* --- Total Energy Expectation Values --- *)
GWP1DETE1[GWP1DARG] = (HBAR^2*(IA^2/RA + RA) + RP^2)/(2*MASS) + V0 + RX*V1 + (1/(4*RA) + RX^2)*V2;
GWP1DETE2[GWP1DARG] = (12*HBAR^4*(IA^2 + RA^2)^2 + 3*MASS^2*V2^2 - 16*HBAR*IA*MASS*RA*RP*(V1 + 2*RX*V2) + 4*HBAR^2*(2*RA*(IA^2 + RA^2)*(3*RP^2 + 2*MASS*(V0 + RX*V1)) + MASS*(3*IA^2 - RA^2 + 4*RA*(IA^2 + RA^2)*RX^2)*V2) + 4*RA^2*(RP^2 + 2*MASS*(V0 + RX*(V1 + RX*V2)))^2 + 4*MASS*RA*(RP^2*V2 + MASS*(V1^2 + 6*RX*V1*V2 + 2*V2*(V0 + 3*RX^2*V2))))/(16*MASS^2*RA^2);
(* --- 3rd-Order Total Energy Moment (Semiclassical Skewness) --- *)
GWP1DETE3[GWP1DARG] = (120*HBAR^6*(IA^2 + RA^2)^3 + 15*MASS^3*V2^3 - 
  288*HBAR^3*IA*MASS*RA*(IA^2 + RA^2)*RP*(V1 + 2*RX*V2) + 
  8*RA^3*(RP^2 + 2*MASS*(V0 + RX*(V1 + RX*V2)))^3 + 
  18*MASS^2*RA*V2*(RP^2*V2 + 2*MASS*(V1^2 + 5*RX*V1*V2 + V2*(V0 + 5*RX^2*V2))) + 
  12*MASS*RA^2*(RP^2 + 2*MASS*(V0 + RX*(V1 + RX*V2)))*(RP^2*V2 + 2*MASS*(V1^2 + 5*RX*V1*V2 + V2*(V0 + 5*RX^2*V2))) - 
  48*HBAR*IA*MASS*RA*RP*(V1 + 2*RX*V2)*(3*MASS*V2 + 2*RA*(RP^2 + 2*MASS*(V0 + RX*(V1 + RX*V2)))) + 
  4*HBAR^4*(IA^2 + RA^2)*(9*IA^2*(10*RA*RP^2 + 5*MASS*V2 + 4*MASS*RA*(V0 + RX*(V1 + RX*V2))) + 
  RA^2*(90*RA*RP^2 - 11*MASS*V2 + 36*MASS*RA*(V0 + RX*(V1 + RX*V2)))) + 
  2*HBAR^2*(RA^2*(-11*MASS^2*V2^2 - 4*MASS*RA*(-(MASS*V1^2) + (RP^2 + 6*MASS*V0 + 2*MASS*RX*V1)*V2 + 2*MASS*RX^2*V2^2) + 
  12*RA^2*(RP^2 + 2*MASS*(V0 + RX*(V1 + RX*V2)))*(5*RP^2 + 2*MASS*(V0 + RX*(V1 + RX*V2)))) + 
  3*IA^2*(15*MASS^2*V2^2 + 4*RA^2*(RP^2 + 2*MASS*(V0 + RX*(V1 + RX*V2)))*(5*RP^2 + 2*MASS*(V0 + RX*(V1 + RX*V2))) + 
  12*MASS*RA*(3*RP^2*V2 + MASS*(V1^2 + 6*RX*V1*V2 + 2*V2*(V0 + 3*RX^2*V2))))))/(64*MASS^3*RA^3);
  (* --- 4th-Order Total Energy Moment (Semiclassical Kurtosis) --- *)
GWP1DETE4[GWP1DARG] = (1680*HBAR^8*(IA^2 + RA^2)^4 + 105*MASS^4*V2^4 - 5760*HBAR^5*IA*MASS*RA*(IA^2 + RA^2)^2*RP*(V1 + 2*RX*V2) + 
  16*RA^4*(RP^2 + 2*MASS*(V0 + RX*(V1 + RX*V2)))^4 + 120*MASS^3*RA*V2^2*(RP^2*V2 + MASS*(3*V1^2 + 14*RX*V1*V2 + 2*V2*(V0 + 7*RX^2*V2))) + 
  32*MASS*RA^3*(RP^2 + 2*MASS*(V0 + RX*(V1 + RX*V2)))^2*(RP^2*V2 + MASS*(3*V1^2 + 14*RX*V1*V2 + 2*V2*(V0 + 7*RX^2*V2))) + 
  24*MASS^2*RA^2*(3*RP^4*V2^2 + 12*MASS*RP^2*V2*(V1^2 + 5*RX*V1*V2 + V2*(V0 + 5*RX^2*V2)) + 
  2*MASS^2*(V1^4 + 20*RX*V1^3*V2 + 20*RX*V1*V2^2*(3*V0 + 7*RX^2*V2) + 6*V1^2*V2*(2*V0 + 15*RX^2*V2) + 2*V2^2*(3*V0^2 + 30*RX^2*V0*V2 + 35*RX^4*V2^2))) + 
  96*HBAR^6*(IA^2 + RA^2)^2*(5*IA^2*(14*RA*RP^2 + 7*MASS*V2 + 4*MASS*RA*(V0 + RX*(V1 + RX*V2))) + 
  RA^2*(70*RA*RP^2 - 9*MASS*V2 + 20*MASS*RA*(V0 + RX*(V1 + RX*V2)))) - 96*HBAR*IA*MASS*RA*RP*(V1 + 2*RX*V2)*
  (15*MASS^2*V2^2 + 4*RA^2*(RP^2 + 2*MASS*(V0 + RX*(V1 + RX*V2)))^2 + 4*MASS*RA*(3*RP^2*V2 + MASS*(V1^2 + 10*RX*V1*V2 + 2*V2*(3*V0 + 5*RX^2*V2)))) - 
  128*HBAR^3*IA*MASS*RA*RP*(V1 + 2*RX*V2)*(RA^2*(13*MASS*V2 + 6*RA*(5*RP^2 + 6*MASS*(V0 + RX*(V1 + RX*V2)))) + 
  IA^2*(45*MASS*V2 + 6*RA*(5*RP^2 + 6*MASS*(V0 + RX*(V1 + RX*V2))))) + 
  8*HBAR^4*(RA^4*(11*MASS^2*V2^2 + 12*RA^2*(35*RP^4 + 60*MASS*RP^2*(V0 + RX*(V1 + RX*V2)) + 12*MASS^2*(V0 + RX*(V1 + RX*V2))^2) - 
  4*MASS*RA*(39*RP^2*V2 + MASS*(-5*V1^2 + 2*RX*V1*V2 + 2*V2*(11*V0 + RX^2*V2)))) + 
  3*IA^4*(105*MASS^2*V2^2 + 4*RA^2*(35*RP^4 + 60*MASS*RP^2*(V0 + RX*(V1 + RX*V2)) + 12*MASS^2*(V0 + RX*(V1 + RX*V2))^2) + 
  60*MASS*RA*(5*RP^2*V2 + MASS*(V1^2 + 6*RX*V1*V2 + 2*V2*(V0 + 3*RX^2*V2)))) + 
  2*IA^2*RA^2*(51*MASS^2*V2^2 + 12*RA^2*(35*RP^4 + 60*MASS*RP^2*(V0 + RX*(V1 + RX*V2)) + 12*MASS^2*(V0 + RX*(V1 + RX*V2))^2) + 
  4*MASS*RA*(93*RP^2*V2 + MASS*(25*V1^2 + 134*RX*V1*V2 + 2*V2*(17*V0 + 67*RX^2*V2))))) + 
  8*HBAR^2*(RA^2*(-27*MASS^3*V2^3 + 8*RA^3*(RP^2 + 2*MASS*(V0 + RX*(V1 + RX*V2)))^2*(7*RP^2 + 2*MASS*(V0 + RX*(V1 + RX*V2))) - 
  2*MASS^2*RA*V2*(RP^2*V2 + 2*MASS*(7*V1^2 + 39*RX*V1*V2 + V2*(11*V0 + 39*RX^2*V2))) + 
  4*MASS*RA^2*(RP^4*V2 + 2*MASS*RP^2*(7*V1^2 + 26*RX*V1*V2 - 2*V2*(V0 - 13*RX^2*V2)) + 4*MASS^2*(-3*V0^2*V2 + V0*(V1^2 - 2*RX*V1*V2 - 2*RX^2*V2^2) + 
  RX*(V1^3 + 2*RX*V1^2*V2 + 2*RX^2*V1*V2^2 + RX^3*V2^3)))) + 
  IA^2*(105*MASS^3*V2^3 + 8*RA^3*(RP^2 + 2*MASS*(V0 + RX*(V1 + RX*V2)))^2*(7*RP^2 + 2*MASS*(V0 + RX*(V1 + RX*V2))) + 
  90*MASS^2*RA*V2*(3*RP^2*V2 + 2*MASS*(V1^2 + 5*RX*V1*V2 + V2*(V0 + 5*RX^2*V2))) + 
  36*MASS*RA^2*(5*RP^4*V2 + 6*MASS*RP^2*(V1^2 + 6*RX*V1*V2 + 2*V2*(V0 + 3*RX^2*V2)) + 4*MASS^2*(V0^2*V2 + V0*(V1^2 + 6*RX*V1*V2 + 6*RX^2*V2^2) + 
  RX*(V1^3 + 6*RX*V1^2*V2 + 10*RX^2*V1*V2^2 + 5*RX^3*V2^3))))))/(256*MASS^4*RA^4);


(* --- Energy Uncertainty --- *)
GWP1DUKE[GWP1DARG]  = Sqrt[(HBAR^2*(IA^2 + RA^2)*(HBAR^2*(IA^2 + RA^2) + 2*RA*RP^2))/(MASS^2*RA^2)]/Sqrt[2];
GWP1DUPE[GWP1DARG]  = Sqrt[(V2^2 + 2*RA*(V1 + 2*RX*V2)^2)/RA^2]/(2*Sqrt[2]);
GWP1DUTE[GWP1DARG]  = Sqrt[(4*HBAR^4*(IA^2 + RA^2)^2 + 4*HBAR^2*(2*RA*(IA^2 + RA^2)*RP^2 + MASS*(IA - RA)*(IA + RA)*V2) - 8*HBAR*IA*MASS*RA*RP*(V1 + 2*RX*V2) + MASS^2*(V2^2 + 2*RA*(V1 + 2*RX*V2)^2))/(MASS^2*RA^2)]/(2*Sqrt[2]);


(* ::Section::Closed:: *)
(*GWPObject Registration*)


(* ::Subsection::Closed:: *)
(*Potential Model Resolution*)


(* --- Unified Potential Registry Chunk --- *)
(* Format: {StringName, BackendSymbol, Template, Category} *)
$potentials1D = {
  {"Free",                GWP1DFREE,      "\"Free\"",                                     "Named"},
  {"HO",                  GWP1DHO,        "\"HO\"",                                       "Named"},
  {"Linear",              GWP1DLINEAR,    "{\"Linear\", FK}",                             "Parameterized"},
  {"Harmonic",            GWP1DHARMONIC,  "{\"Harmonic\", OMEGA}",                        "Parameterized"},
  {"ParabolicBarrier",    GWP1DPARABOLIC, "{\"ParabolicBarrier\", OMEGA}",                "Parameterized"},
  {"LinearForcedHO",      GWP1DFHOLIN,    "{\"LinearForcedHO\", OMEGA, AK}",              "Parameterized"},
  {"ResonantForcedHO",    GWP1DFHORES,    "{\"ResonantForcedHO\", OMEGA, AK}",            "Parameterized"},
  {"NonResonantForcedHO", GWP1DFHONON,    "{\"NonResonantForcedHO\", OMEGA, AK, OMEGA1}", "Parameterized"}
};


(* ::Subsection::Closed:: *)
(*Property Resolution and Dispatch*)


$regStatic = Join[#, {"StaticParameters", "1D"}] & /@ {
  {"Normalization",         "NORM",        "Static", "Static"},
  {"ReducedPlanckConstant", "HBAR",        "Static", "Static"},
  {"Mass",                  "MASS",        "Static", "Static"},
  {"InputParameters",       "INPUT",       "Static", "Static"},
  {"InitialParameters",     "INIT",        "Static", "Static"},
  {"Assumptions",           "ASSUMPTIONS", "Static", "Static"}
};


$regDynamic = Join[#, {"DynamicParameters", "1D"}] & /@ {
  {"RealShape",                    "RA",      "Temporal", "StaticValue"},
  {"ImaginaryShape",               "IA",      "Temporal", "StaticValue"},
  {"PositionCenter",               "RX",      "Temporal", "StaticValue"},
  {"MomentumCenter",               "RP",      "Temporal", "StaticValue"},
  {"RealPhase",                    "RG",      "Temporal", "StaticValue"},
  {"ImaginaryPhase",               "IG",      "Temporal", "StaticValue"},
  
  {"RealShapeTimeDerivative",      "RATD",    "Temporal", None},
  {"ImaginaryShapeTimeDerivative", "IATD",    "Temporal", None},
  {"PositionCenterTimeDerivative", "RXTD",    "Temporal", None},
  {"MomentumCenterTimeDerivative", "RPTD",    "Temporal", None},
  {"RealPhaseTimeDerivative",      "RGTD",    "Temporal", None},
  {"ImaginaryPhaseTimeDerivative", "IGTD",    "Temporal", None},
  
  {"PotentialCoefficients",        "PECOEFF", "Temporal", None} 
};


$regWave = Join[#, {"Wavefunctions", "1D"}] & /@ {
  {"WavefunctionX",          "PSIX", "Recursive", "RecursiveSpatial"},
  {"ConjugateWavefunctionX", "CSIX", "Recursive", "RecursiveSpatial"},
  {"WavefunctionP",          "PSIP", "Recursive", "RecursiveSpatial"},
  {"ConjugateWavefunctionP", "CSIP", "Recursive", "RecursiveSpatial"},
  {"RealWavefunctionX",      "RSIX", "Field",     "Spatial"},
  {"ImaginaryWavefunctionX", "ISIX", "Field",     "Spatial"},
  {"RealWavefunctionP",      "RSIP", "Field",     "Spatial"},
  {"ImaginaryWavefunctionP", "ISIP", "Field",     "Spatial"}
};


$regProb = Join[#, {"Probabilities", "1D"}] & /@ {
  {"DensityX",                  "RHOX",  "Recursive", "RecursiveSpatial"},
  {"DensityP",                  "RHOP",  "Recursive", "RecursiveSpatial"},
  {"DensityE",                  "RHOE",  "Field",     "Spatial"},
  {"CumulativeDistributionX",   "CX",    "Field",     "Spatial"},
  {"CumulativeDistributionP",   "CP",    "Field",     "Spatial"},
  {"CumulativeDistributionE",   "CE",    "Field",     "Spatial"},
  {"ProbabilityX",              "PROBX", "Bivariate", "BivariateSpatial"},
  {"ProbabilityP",              "PROBP", "Bivariate", "BivariateSpatial"},
  {"ProbabilityE",              "PROBE", "Bivariate", "BivariateSpatial"}
};


$regExp = Join[#, {"ExpectationValues", "1D"}] & /@ {
  {"PositionExpectation",                "EX",    "Moment",      "StaticMoment"},
  {"MomentumExpectation",                "EP",    "Moment",      "StaticMoment"},
  {"PositionUncertainty",                "UX",    "Temporal",    "StaticValue"},
  {"MomentumUncertainty",                "UP",    "Temporal",    "StaticValue"},
  {"PositionMomentumProductExpectation", "EXP",   "CrossMoment", "StaticCrossMoment"}, 
  {"MomentumPositionProductExpectation", "EPX",   "CrossMoment", "StaticCrossMoment"}, 
  {"PositionMomentumCovariance",         "COVXP", "Temporal",    "StaticValue"}, 
  {"PositionMomentumCorrelation",        "CORXP", "Temporal",    "StaticValue"},
  
  (* Requires Potential *)
  {"ForceExpectation",                   "EF1",   "Temporal",    None},
  {"ForceSquaredExpectation",            "EF2",   "Temporal",    None},
  {"ForceUncertainty",                   "UF",    "Temporal",    None}
};


$regEng = Join[#, {"Energies", "1D"}] & /@ {
  {"ExternalPotentialX",        "PEX",  "Recursive", None},
  {"ExternalForceX",            "FEX",  "Recursive", None},
  
  (* Kinetic Energy is strictly p-space, independent of V *)
  {"KineticEnergyExpectation",                   "EKE",     "Moment",      "StaticMoment"},  
  {"KineticEnergyUncertainty",                   "UKE",     "Temporal",    "StaticValue"},
  
  (* Requires Potential *)
  {"PotentialEnergyExpectation",                 "EPE",     "Moment",      None},  
  {"TotalEnergyExpectation",                     "ETE",     "Moment",      None},
  {"PotentialEnergyUncertainty",                 "UPE",     "Temporal",    None},  
  {"TotalEnergyUncertainty",                     "UTE",     "Temporal",    None},
  {"KineticPotentialEnergyProductExpectation",   "EKEPE",   "CrossMoment", None}, 
  {"PotentialKineticEnergyProductExpectation",   "EPEKE",   "CrossMoment", None}, 
  {"KineticPotentialEnergyCovariance",           "COVKEPE", "Temporal",    None}, 
  {"KineticPotentialEnergyCorrelation",          "CORKEPE", "Temporal",    None}
};


(* --- Registry Assembly --- *)
$reg1D = Join[$regStatic, $regDynamic, $regWave, $regProb, $regExp, $regEng];
Clear[$regStatic, $regDynamic, $regWave, $regProb, $regExp, $regEng];


(* ::Subsection::Closed:: *)
(*Register Potentials and Properties *)


GWPTools`GWPRegistry`GWPRegisterPotentials[$potentials1D, "1D"];
GWPTools`GWPRegistry`GWPRegisterExtension[$reg1D];


(* ::Subsection::Closed:: *)
(*User Interface Builder*)


(* ========================================================================= *)
(* FRONT-END FORMATTING (UI Builder)                                         *)
(* ========================================================================= *)

$GWP1DLogo = Graphics[{
    Opacity[0.2], Blue, FilledCurve[BezierCurve[{{-1, 0}, {-0.5, 0}, {-0.2, 1}, {0, 1}, {0.2, 1}, {0.5, 0}, {1, 0}}]],
    Opacity[1], Thickness[0.08], Blue, Line[Table[{x, Exp[-4 x^2]}, {x, -1, 1, 0.05}]],
    Thickness[0.04], Darker[Cyan], Line[Table[{x, 0.2 Sin[15 x] Exp[-4 x^2] - 0.1}, {x, -0.8, 0.8, 0.02}]]
}, ImageSize -> 32, PlotRange -> {{-1.1, 1.1}, {-0.3, 1.1}}];

GWPTools`GWPDeveloper`GWP1DUI[data_] := Module[
  {potDisplay, paramsList, h, m, init, visible, hidden},
  
  potDisplay = data["Potential"];
  paramsList = data["Parameters"];
  
  If[Length[paramsList] >= 11,
    h = paramsList[[8]]; m = paramsList[[9]]; init = paramsList[[11]];
  ,
    h = "?"; m = "?"; init = "?";
  ];
  
  visible = {Grid[{
    {Style["Attributes", Bold], Style["Values", Bold]},
    {"Input: ", InputForm[init]},
    {"Potential: ", potDisplay}
  }, Alignment -> Left]};
  
  hidden = {Grid[{
    {"Mass: ", m},
    {"HBar: ", h}
  }, Alignment -> Left]};
  
  {$GWP1DLogo, visible, hidden}
];


(* ::Section::Closed:: *)
(*End*)


(* --- End "GWPTools`GWPEngine1D`Private`" --- *)
End[]

(* Hide internal code for all Developer functions from the ? menu *)
SetAttributes[Evaluate[Names["GWPTools`GWPEngine1D`*"]], {ReadProtected}];

(* --- End "GWPTools`GWPEngine1D`" --- *)
EndPackage[]

(* ::Package:: *)

(* ::Title:: *)
(*GWPEngine Package*)


(* ::Section::Closed:: *)
(*GWPDeveloper Usage Registration*)


(* ::Subsection::Closed:: *)
(*BeginPackage*)


(* --- Open GWPDeveloper Package --- *)
BeginPackage["GWPTools`GWPDeveloper`"]


(* ::Subsection::Closed:: *)
(*Usage Statements*)


(* ::Subsubsection::Closed:: *)
(*Parameters*)


(* ========================================================================= *)
(* PARAMETER BUS REGISTRATION                                                *)
(* ------------------------------------------------------------------------- *)
(* These usage statements hoist the Parameter Bus macros and their internal  *)
(* symbols into the GWPDeveloper context. This guarantees that all extension *)
(* subpackages (like GWPHydrodynamics) share the exact same variable spaces  *)
(* for pattern matching, completely avoiding cross-context evaluation traps. *)
(* ========================================================================= *)
GWPARG::usage = "GWPARG is the developer macro for the parameter sequence pattern.";
GWPVAL::usage = "GWPVAL is the developer macro for the parameter sequence values.";
RA::usage = IA::usage = RX::usage = RP::usage = RG::usage = IG::usage = "Parameter bus symbol.";
NORM::usage = HBAR::usage = MASS::usage = INIT::usage = "Parameter bus symbol.";
V0::usage = V1::usage = V2::usage = "Potential coefficient bus symbol.";


(* --- GWP Parameter Generation --- *)
GWPPARAM::usage = "GWPPARAM[alpha, x, p, gamma] returns a sequence of GWP parameters.\n" <>
  "GWPPARAM[alpha, x, p] assumes a default phase gamma.\n" <>
  "GWPPARAM[alpha, x] assumes default momentum p and phase gamma.\n" <>
  "GWPPARAM[alpha] assumes default position x, momentum p, and phase gamma.\n" <>
  "GWPPARAM[] assumes default GWP parameters.\n" <>
  "Note: Arguments accept complex-valued numbers, expressions, or tagged lists (see the documentation for GWP or Developer Reference Manual for exact syntax).";
  
(* --- GWP Parameter Extraction --- *)
GWPRA::usage = "GWPRA[param] extracts the real shape parameter.";
GWPIA::usage = "GWPIA[param] extracts the imaginary shape parameter.";
GWPRX::usage = "GWPRX[param] extracts the position center.";
GWPRP::usage = "GWPRP[param] extracts the momentum center.";
GWPRG::usage = "GWPRG[param] extracts the real phase parameter.";
GWPIG::usage = "GWPIG[param] extracts the imaginary phase parameter.";
GWPNORM::usage = "GWPNORM[param] extracts the normalization constant.";
GWPMASS::usage = "GWPMASS[param] extracts the mass.";
GWPHBAR::usage = "GWPHBAR[param] extracts the reduced Planck constant.";
GWPPECOEFF::usage = "GWPPECOEFF[param] extracts the external potential coefficients.";
GWPINPUT::usage = "GWPINPUT[param] extracts the input parameters.";
GWPINIT::usage = "GWPINIT[param] extracts the processed initial parameters.";

(* --- GWP Four-Eight-Six Parameter Engine --- *)
GWP486::usage = "GWP486 is the internal engine used by GWPPARAM to convert single-primed complex parameters into the double-primed real-parameter model.";

(* --- GWP Parameter Parsers Usage Statements --- *)
GWPSHAPE::usage = "GWPSHAPE[A1, HBAR, MASS] parses the user-provided wavepacket shape parameter A1 and translates it into the foundational real and imaginary width components {RA, IA}.\n" <>
  "A1 accepts multiple formats: a raw complex scalar (RA + I*IA), a spatial uncertainty and position-momentum covariance ({\"Covariance\", UX, COVXP}), or position-momentum uncertainties alongside a chirp direction sign ({\"Uncertainty\", UX, UP, chirpSign}).";

GWPMOMENTUM::usage = "GWPMOMENTUM[P1, MASS] parses the user-provided momentum parameter P1 and translates it into the foundational real and imaginary momentum components {RP1, IP1}.\n" <>
  "P1 accepts multiple formats: a raw complex scalar (RP + I*IP), or a list specifying an initial kinetic energy alongside a directional sign ({\"KineticEnergy\", Energy, Sign}).";

GWPPOSITION::usage = "GWPPOSITION[X1] parses the user-provided position parameter X1 and translates it into the foundational real and imaginary position components {RX, IX}.";

GWPPHASE::usage = "GWPPHASE[G1, HBAR, RA, RX, RP] parses the user-provided global phase parameter G1 and translates it into the real and imaginary phase components {RG, IG}.\n" <>
  "G1 accepts multiple formats: a raw complex scalar (RG + I*IG), a semiclassical initial action ({\"Action\", S, mu}), a phase-space displacement ({\"Displacement\", X0, P0}), a complex superposition coefficient ({\"Coefficient\", PhaseAngle, AmplitudeWeight}), or an energy eigenstate time evolution ({\"Evolution\", Energy, Time}).";

(* --- GWP Parameter Assumptions --- *)
GWPASSUMPTIONS::usage = "GWPASSUMPTIONS[param, opts] generates real-domain assumptions for the parameters and variables.";


(* ::Subsubsection::Closed:: *)
(*Potential Models*)


(* --- GWP Parameter Time Derivatives --- *)
GWPRXTD::usage = "GWPRXTD[param] computes the time derivative of the position center.";
GWPRPTD::usage = "GWPRPTD[param] computes the time derivative of the momentum center.";
GWPRATD::usage = "GWPRATD[param] computes the time derivative of the real shape parameter.";
GWPIATD::usage = "GWPIATD[param] computes the time derivative of the imaginary shape parameter.";
GWPRGTD::usage = "GWPRGTD[param] computes the time derivative of the real phase parameter.";
GWPIGTD::usage = "GWPIGTD[param] computes the time derivative of the imaginary phase parameter.";


(* --- GWP Potential Models --- *) 
FREE::usage = "FREE[t][param] evaluates the free particle parameters.";
HO::usage = "HO[t][param] evaluates the standard harmonic oscillator parameters.";
LINEAR::usage = "LINEAR[k][t][param] evaluates the linear potential parameters.";
HARMONIC::usage = "HARMONIC[omega][t][param] evaluates the harmonic oscillator parameters.";
PARABOLIC::usage = "PARABOLIC[omega][t][param] evaluates the parabolic barrier parameters.";
FHOLIN::usage = "FHOLIN[omega, A][t][param] evaluates the linear-driven harmonic oscillator parameters.";
FHORES::usage = "FHORES[omega, A][t][param] evaluates the resonant-driven harmonic oscillator parameters.";
FHONON::usage = "FHONON[omega, A, omega1][t][param] evaluates the non-resonant-driven harmonic oscillator parameters.";

(* --- GWP Potential Energy and Force Functions --- *)
GWPPEX::usage = "GWPPEX[x][param] evaluates the external potential energy.\n" <>
  "GWPPEX[n][x][param] evaluates the nth spatial derivative of the external potential energy.";

GWPFEX::usage = "GWPFEX[x][param] evaluates the external force.\n" <>
  "GWPFEX[n][x][param] evaluates the nth spatial derivative of the external force.";


(* ::Subsubsection::Closed:: *)
(*Wavefunctions*)


(* --- Recursion Relation for Wavefunctions and Densities --- *)
GWPHermiteEngine::usage = "GWPHermiteEngine[n, p1, coeff] generates the nth-order polynomial factor for the generalized Gaussian wavepacket spatial derivatives by implementing a three-term Hermite recurrence relation.";


(* --- x-Space Wavefunctions ---*)
GWPPSIX::usage = "GWPPSIX[x][param] evaluates the x-space wavefunction.\n" <>
  "GWPPSIX[n][x][param] evaluates the nth derivative of the x-space wavefunction.";

GWPCSIX::usage = "GWPCSIX[x][param] evaluates the complex conjugate x-space wavefunction.\n" <>
  "GWPCSIX[n][x][param] evaluates the nth derivative of the complex conjugate x-space wavefunction.";

GWPRSIX::usage = "GWPRSIX[x][param] evaluates the real part of the x-space wavefunction.";
GWPISIX::usage = "GWPISIX[x][param] evaluates the imaginary part of the x-space wavefunction.";

(* --- p-Space Wavefunctions ---*)
GWPPSIP::usage = "GWPPSIP[p][param] evaluates the p-space wavefunction.\n" <>
  "GWPPSIP[n][p][param] evaluates the nth derivative of the p-space wavefunction.";

GWPCSIP::usage = "GWPCSIP[p][param] evaluates the complex conjugate p-space wavefunction.\n" <>
  "GWPCSIP[n][p][param] evaluates the nth derivative of the complex conjugate p-space wavefunction.";

GWPRSIP::usage = "GWPRSIP[p][param] evaluates the real part of the p-space wavefunction.";
GWPISIP::usage = "GWPISIP[p][param] evaluates the imaginary part of the p-space wavefunction.";


(* ::Subsubsection::Closed:: *)
(*Probabilities*)


(* --- Probability Densities --- *)
GWPRHOX::usage = "GWPRHOX[x][param] evaluates the x-space probability density.\n" <>
  "GWPRHOX[n][x][param] evaluates the nth derivative of the x-space probability density.";

GWPRHOP::usage = "GWPRHOP[p][param] evaluates the p-space probability density.\n" <>
  "GWPRHOP[n][p][param] evaluates the nth derivative of the p-space probability density.";

GWPRHOE::usage = "GWPRHOE[e][param] evaluates the energy probability density.";

(* --- Cumulative Distribution Functions --- *)
GWPCX::usage = "GWPCX[x][param] evaluates the x-space cumulative distribution function.";
GWPCP::usage = "GWPCP[p][param] evaluates the p-space cumulative distribution function.";
GWPCE::usage = "GWPCE[e][param] evaluates the energy cumulative distribution function.";

(* --- Probabilities --- *)
GWPPROBX::usage = "GWPPROBX[xmin, xmax][param] calculates the probability of finding the particle in the x-space interval.";
GWPPROBP::usage = "GWPPROBP[pmin, pmax][param] calculates the probability of finding the particle in the p-space interval.";
GWPPROBE::usage = "GWPPROBE[emin, emax][param] calculates the probability of finding the particle in the energy interval.";


(* ::Subsubsection::Closed:: *)
(*ExpectationValues*)


(* --- x-Space Expectation Values --- *)
GWPEX::usage = "GWPEX[param] evaluates the x-space expectation value.\n" <>
  "GWPEX[n][param] evaluates the nth x-space moment.";

(* --- p-Space Expectation Values --- *)
GWPEP::usage = "GWPEP[param] evaluates the p-space expectation value.\n" <>
  "GWPEP[n][param] evaluates the nth p-space moment.";

(* --- Uncertainties --- *)
GWPUX::usage = "GWPUX[param] evaluates the x-space uncertainty.";
GWPUP::usage = "GWPUP[param] evaluates the p-space uncertainty.";

(* --- x-p Cross-Correlations --- *)
GWPEXP::usage = "GWPEXP[param] evaluates the x-p product expectation value.\n" <>
  "GWPEXP[m, n][param] evaluates the arbitrary cross-moment expectation value of x^m p^n.";

GWPEPX::usage = "GWPEPX[param] evaluates the p-x product expectation value.\n" <>
  "GWPEPX[m, n][param] evaluates the arbitrary cross-moment expectation value of p^m x^n.";

GWPCOVXP::usage = "GWPCOVXP[param] evaluates the x-p covariance.";
GWPCORXP::usage = "GWPCORXP[param] evaluates the x-p correlation.";

(* --- Force Expectation Values --- *)
GWPEF1::usage = "GWPEF1[param] evaluates the force expectation value.";
GWPEF2::usage = "GWPEF2[param] evaluates the squared force expectation value.";
GWPUF::usage = "GWPUF[param] evaluates the force uncertainty.";

(* --- Fisher Information --- *)
GWPEFIX::usage = "GWPEFIX[param] evaluates the x-space Fisher information.";
GWPEFIP::usage = "GWPEFIP[param] evaluates the p-space Fisher information.";


(* ::Subsubsection::Closed:: *)
(*Energies*)


(* --- Kinetic Energy Expectation Values --- *)
GWPEKE::usage = "GWPEKE[param] evaluates the kinetic energy expectation value.\n" <>
  "GWPEKE[n][param] evaluates the nth kinetic energy moment.";

(* --- Potential Energy Expectation Values --- *)
GWPEPE::usage = "GWPEPE[param] evaluates the potential energy expectation value.\n" <>
  "GWPEPE[n][param] evaluates the nth potential energy moment.";

(* --- Kinetic-Potential Energy Cross-Correlations --- *)
GWPEKEPE::usage = "GWPEKEPE[param] evaluates the kinetic-potential energy product expectation value.";
GWPEPEKE::usage = "GWPEPEKE[param] evaluates the potential-kinetic energy product expectation value.";
GWPCOVKEPE::usage = "GWPCOVKEPE[param] evaluates the kinetic-potential energy covariance.";
GWPCORKEPE::usage = "GWPCORKEPE[param] evaluates the kinetic-potential energy correlation.";

(* --- Total Energy Expectation Values --- *)
GWPETE::usage = "GWPETE[param] evaluates the total energy expectation value.\n" <>
  "GWPETE[n][param] evaluates the nth total energy moment (supported up to n=4).";
GWPETE1::usage = "GWPETE1[param] evaluates the total energy (Hamiltonian) expectation value.";
GWPETE2::usage = "GWPETE2[param] evaluates the squared total energy expectation value.";
GWPETE3::usage = "GWPETE3[param] evaluates the cubed total energy expectation value.";
GWPETE4::usage = "GWPETE3[param] evaluates the fourth-order total energy expectation value.";

(* --- Energy Uncertainty --- *)
GWPUKE::usage = "GWPUKE[param] evaluates the kinetic energy uncertainty.";
GWPUPE::usage = "GWPUPE[param] evaluates the potential energy uncertainty.";
GWPUTE::usage = "GWPUTE[param] evaluates the total energy uncertainty.";


(* ::Subsection::Closed:: *)
(*End*)


(* --- Close GWPDeveloper Package --- *)
EndPackage[]


(* ::Section::Closed:: *)
(*BeginPackage*)


(* ========================================================================= *)
(* PACKAGE     : GWPTools`GWPEngine`                                         *)
(* DESCRIPTION : The core mathematical kernel, parameter bus, and baseline   *)
(*               observables for the GWPTools framework.                     *)
(* ========================================================================= *)

BeginPackage["GWPTools`GWPEngine`"]

Begin["`Private`"]

(* Load the developer context strictly for internal compilation *)
Needs["GWPTools`GWPDeveloper`"];


(* ::Section::Closed:: *)
(*Parameters*)


(* ::Subsection::Closed:: *)
(*GWPARG/GWPVAL*)


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

GWPARG = Sequence[RA_, IA_, RX_, RP_, RG_, IG_, NORM_, HBAR_, MASS_, {V0_, V1_, V2_}, INIT_];
GWPVAL = Sequence[RA,  IA,  RX,  RP,  RG,  IG,  NORM,  HBAR,  MASS,  {V0,  V1,  V2},  INIT];


(* --- Helper Pattern for Strict Scalar/Symbol Enforcement --- *)
GWPScalarQ[val_] := FreeQ[val, List];


(* ::Subsection::Closed:: *)
(*GWPPARAM*)


(* --- Default Options --- *)
Options[GWPPARAM] = {"HBAR" -> 1, "MASS" -> 1};


(* --- Error Messages --- *)
GWPPARAM::posval = "The value of option `1` -> `2` must be strictly positive.";


(* --- Parameter Generator --- *)
GWPPARAM[
  AA : Except[_Rule | _RuleDelayed] : 1/4, 
  XX : Except[_Rule | _RuleDelayed] : 0, 
  PP : Except[_Rule | _RuleDelayed] : 0, 
  GG : Except[_Rule | _RuleDelayed] : 0, 
  opts : OptionsPattern[]
] := Module[{h, m, invalidOpts},
  
  (* Catch Unknown Options *)
  invalidOpts = FilterRules[{opts}, Except[Options[GWPPARAM]]];
  If[Length[invalidOpts] > 0,
    Message[General::optx, First[First[invalidOpts]], HoldForm[GWPPARAM]];
    Return[$Failed]
  ];

  (* Extract Option Values *)  
  h = OptionValue["HBAR"];
  m = OptionValue["MASS"];

(*    
  (* Enforce strictly positive physical constants (Safely ignores symbols) *)
  If[TrueQ[h <= 0], Message[GWPPARAM::posval, "HBAR", h]; Return[$Failed]];
  If[TrueQ[m <= 0], Message[GWPPARAM::posval, "MASS", m]; Return[$Failed]];
*)
 (* Enforce strictly positive physical constants and completely reject lists *)
  If[!GWPScalarQ[h] || TrueQ[h <= 0], Message[GWPPARAM::posval, "HBAR", h]; Return[$Failed]];
  If[!GWPScalarQ[m] || TrueQ[m <= 0], Message[GWPPARAM::posval, "MASS", m]; Return[$Failed]];

    (* Proceed to engine *)
  GWP486[AA, XX, PP, GG, h, m]
];


(* ::Subsection::Closed:: *)
(*GWP486*)


GWP486::unnorm = "The real shape parameter RA = `1` must be strictly positive.";
GWP486::complexia = "The calculated imaginary shape parameter IA = `1` must be strictly real. Check your uncertainty bounds.";


GWP486[A1_, X1_, P1_, G1_, HBAR_, MASS_] := Module[{
  RA1, IA1, RX1, IX1, RP1, IP1, RG1, IG1,
  RA2, IA2, RX2, RP2, RG2, IG2, NORM, PECOEFF, INIT, PARAM
},
  (* --- Complex Expand Input Parameters --- *)
  {RA1, IA1} = GWPSHAPE[A1, HBAR, MASS];
  {RX1, IX1} = GWPPOSITION[X1];
  {RP1, IP1} = GWPMOMENTUM[P1, MASS];
  
  (* Fail Fast before GWPPHASE if primary kinematics failed *)
  If[ContainsAny[{RA1, RX1, RP1}, {$Failed}], Return[$Failed]];  
  
  {RG1, IG1} = GWPPHASE[G1, HBAR, RA1, RX1, RP1];
  If[RG1 === $Failed, Return[$Failed]];

  (* --- Fail Fast if any parser returned $Failed --- *)
  If[ContainsAny[{RA1, RX1, RP1, RG1}, {$Failed}], Return[$Failed]];

  (* --- Physics Validation --- *)
  If[TrueQ[RA1 <= 0], Message[GWP486::unnorm, RA1]; Return[$Failed]];
  If[TrueQ[!Element[IA1, Reals]], Message[GWP486::complexia, IA1]; Return[$Failed]];
  
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
  Sequence @@ Simplify[{PARAM}, GWPASSUMPTIONS@PARAM]
];


(* ::Subsection::Closed:: *)
(*Parameter Parsers*)


(*
(* --- Error Messages --- *)
GWPSHAPE::badform = "The shape parameter format `1` is invalid. Provide a scalar, {\"Covariance\", UX, COVXP}, or {\"Uncertainty\", UX, UP, Sign}.";
GWPPOSITION::badform = "The position parameter format `1` is invalid. Provide a scalar or complex number.";
GWPMOMENTUM::badform = "The momentum parameter format `1` is invalid. Provide a scalar or {\"KineticEnergy\", E, Sign}.";
GWPPHASE::badform = "The phase parameter format `1` is invalid. See documentation for valid list formats.";

(* --- Shape Parser --- *)
GWPSHAPE[A1_, HBAR_, MASS_] := Replace[A1, {
  (* Spatial Uncertainty and x-p Covariance *)
  {"Covariance", ux_, covxp_}       :> {1 / (4 * ux^2), -covxp / (2 * HBAR * ux^2)},
  
  (* Spatial and Momentum Uncertainties with Chirp Direction (+1 or -1) *)
  {"Uncertainty", ux_, up_, chirp_} :> {1 / (4 * ux^2), Sign[chirp] * Sqrt[(up^2 / (4 * HBAR^2 * ux^2)) - 1 / (16 * ux^4)]},
  
  (* Restrict fallback to non-lists using Condition (/;) or PatternTest (?) *)
  alpha_?(!ListQ[#]&) :> ComplexExpand @ ReIm @ alpha,
  
  (* Catch everything else *)
  bad_ :> (Message[GWPSHAPE::badform, bad]; {$Failed, $Failed})
}]

(* --- Position Parser --- *)
GWPPOSITION[X1_] := Replace[X1, {
  (* Restrict fallback to non-lists *)
  x_?(!ListQ[#]&) :> ComplexExpand @ ReIm @ x,
  
  (* Catch invalid list formats *)
  bad_ :> (Message[GWPPOSITION::badform, bad]; {$Failed, $Failed})
}]

(* --- Momentum Parser --- *)
GWPMOMENTUM[P1_, MASS_] := Replace[P1, {
  (* Kinetic Energy with directional sign (+1 for right, -1 for left) *)
  {"KineticEnergy", ek_, sign_} :> {Sign[sign] * Sqrt[2 * MASS * ek], 0},
  
  (* Restrict fallback to non-lists using Condition (/;) or PatternTest (?) *)
  p_?(!ListQ[#]&) :> ComplexExpand @ ReIm @ p,
  
  (* Catch everything else *)
  bad_ :> (Message[GWPMOMENTUM::badform, bad]; {$Failed, $Failed})
}]

(* --- Phase Parser --- *)
GWPPHASE[G1_, HBAR_, RA_, RX_, RP_] := Replace[G1, {
  (* Semiclassical Action with explicit Maslov index *)
  {"Action", action_, mu_}       :> {action - HBAR * mu * Pi / 2, -(HBAR / 4) * Log[(2 * RA) / Pi]},
  
  (* Semiclassical Action (defaults to Maslov = 0) *)
  {"Action", action_}            :> {action, -(HBAR / 4) * Log[(2 * RA) / Pi]},
  
  (* Arbitrary Phase Space Displacement (Weyl Phase) *)
  {"Displacement", X0_, P0_}     :> {(RX - X0) * (RP - P0) / 2, -(HBAR / 4) * Log[(2 * RA) / Pi]},
  
  (* Complex Coefficient (Superposition) *)
  {"Coefficient", phi_, weight_} :> {HBAR * phi, -HBAR * Log[weight]},
  
  (* Energy Eigenstate Evolution *)
  {"Evolution", en_, t_}         :> {-en * t, 0},
  
  (* Restrict fallback to non-lists using Condition (/;) or PatternTest (?) *)
  gamma_?(!ListQ[#]&) :> ComplexExpand @ ReIm @ gamma,
  
  (* Catch everything else *)
  bad_ :> (Message[GWPPHASE::badform, bad]; {$Failed, $Failed})
}]
*)


(* ::Subsection::Closed:: *)
(*Parameter Parsers*)


(* --- Error Messages --- *)
GWPSHAPE::badform = "The shape parameter format `1` is invalid. Provide a scalar, {\"Covariance\", UX, COVXP}, or {\"Uncertainty\", UX, UP, Sign}.";
GWPPOSITION::badform = "The position parameter format `1` is invalid. Provide a scalar or complex number.";
GWPMOMENTUM::badform = "The momentum parameter format `1` is invalid. Provide a scalar or {\"KineticEnergy\", E, Sign}.";
GWPPHASE::badform = "The phase parameter format `1` is invalid. See documentation for valid list formats.";

(* --- Shape Parser --- *)
GWPSHAPE[A1_, HBAR_, MASS_] := Replace[A1, {
  (* Spatial Uncertainty and x-p Covariance *)
  {"Covariance", ux_?GWPScalarQ, covxp_?GWPScalarQ} :> 
    {1 / (4 * ux^2), -covxp / (2 * HBAR * ux^2)},
  
  (* Spatial and Momentum Uncertainties with Chirp Direction (+1 or -1) *)
  {"Uncertainty", ux_?GWPScalarQ, up_?GWPScalarQ, chirp_?GWPScalarQ} :> 
    {1 / (4 * ux^2), Sign[chirp] * Sqrt[(up^2 / (4 * HBAR^2 * ux^2)) - 1 / (16 * ux^4)]},
  
  (* Restrict fallback to strictly list-free scalar/symbolic expressions *)
  alpha_?GWPScalarQ :> ComplexExpand @ ReIm @ alpha,
  
  (* Catch everything else (including nested lists) *)
  bad_ :> (Message[GWPSHAPE::badform, bad]; {$Failed, $Failed})
}]

(* --- Position Parser --- *)
GWPPOSITION[X1_] := Replace[X1, {
  x_?GWPScalarQ :> ComplexExpand @ ReIm @ x,
  bad_ :> (Message[GWPPOSITION::badform, bad]; {$Failed, $Failed})
}]

(* --- Momentum Parser --- *)
GWPMOMENTUM[P1_, MASS_] := Replace[P1, {
  {"KineticEnergy", ek_?GWPScalarQ, sign_?GWPScalarQ} :> 
    {Sign[sign] * Sqrt[2 * MASS * ek], 0},
  
  p_?GWPScalarQ :> ComplexExpand @ ReIm @ p,
  bad_ :> (Message[GWPMOMENTUM::badform, bad]; {$Failed, $Failed})
}]

(* --- Phase Parser --- *)
GWPPHASE[G1_, HBAR_, RA_, RX_, RP_] := Replace[G1, {
  {"Action", action_?GWPScalarQ, mu_?GWPScalarQ} :> 
    {action - HBAR * mu * Pi / 2, -(HBAR / 4) * Log[(2 * RA) / Pi]},
    
  {"Action", action_?GWPScalarQ} :> 
    {action, -(HBAR / 4) * Log[(2 * RA) / Pi]},
    
  {"Displacement", X0_?GWPScalarQ, P0_?GWPScalarQ} :> 
    {(RX - X0) * (RP - P0) / 2, -(HBAR / 4) * Log[(2 * RA) / Pi]},
    
  {"Coefficient", phi_?GWPScalarQ, weight_?GWPScalarQ} :> 
    {HBAR * phi, -HBAR * Log[weight]},
    
  {"Evolution", en_?GWPScalarQ, t_?GWPScalarQ} :> 
    {-en * t, 0},
    
  gamma_?GWPScalarQ :> ComplexExpand @ ReIm @ gamma,
  bad_ :> (Message[GWPPHASE::badform, bad]; {$Failed, $Failed})
}]


(* ::Subsection::Closed:: *)
(*Parameter Extractors*)


(* --- GWP Parameter Extraction ---*)
GWPRA[GWPARG]=RA;
GWPIA[GWPARG]=IA;
GWPRX[GWPARG]=RX;
GWPRP[GWPARG]=RP;
GWPRG[GWPARG]=RG;
GWPIG[GWPARG]=IG;
GWPNORM[GWPARG]=NORM;
GWPMASS[GWPARG]=MASS;
GWPHBAR[GWPARG]=HBAR;
GWPPECOEFF[GWPARG]={V0,V1,V2};
GWPINPUT[GWPARG]=INIT;
GWPINIT[GWPARG]={RA,IA,RX,RP,RG,IG};


(* ::Subsection::Closed:: *)
(*GWPASSUMPTIONS*)


(* --- Default Options --- *)
Options[GWPASSUMPTIONS] = {
  "Position"         -> None, 
  "Momentum"         -> None, 
  "Cumulative"       -> None, 
  "Time"             -> None, 
  "Energy"           -> None, 
  "RP2Sign"          -> None,
  "IntegerVariables" -> None
};


(* --- Error Messages --- *)
GWPASSUMPTIONS::rp2conflict = "The requested RP2Sign (`1`) explicitly contradicts the evaluated effective momentum (RP2 = `2`).";


(* --- GWP Assumption Generator Engine --- *)
GWPASSUMPTIONS[GWPARG, opts : OptionsPattern[]] := Module[{
  RA1, IA1, RX1, IX1, RP1, IP1, RG1, IG1, 
  symbs, realSymbs, intSymbs, raSymbs, iaSqrts, shapeCondList, shapeCond,
  base, cond, extra, x, p, c, t, e, rp2sign, RP2val, requestedCond,
  intVars, invalidOpts
},

  (* Catch Unknown Options *)
  invalidOpts = FilterRules[{opts}, Except[Options[GWPASSUMPTIONS]]];
  If[Length[invalidOpts] > 0,
    Message[General::optx, First[First[invalidOpts]], HoldForm[GWPASSUMPTIONS]];
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
      Message[GWPASSUMPTIONS::rp2conflict, rp2sign, RP2val];
      Return[$Failed];
    ];
    
    cond = cond && requestedCond;
  ];
  
  (* Return perfectly merged assumption sequence *)
  base && FullSimplify[cond, Assumptions -> True] && extra
];


(* ::Subsection::Closed:: *)
(*GWP Time-Dependent Parameters*)


(* --- GWP Time-Dependent Parameters ---*)
GWPRATD[GWPARG]=4*HBAR/MASS*RA*IA;
GWPIATD[GWPARG]=-2*HBAR/MASS*(RA^2-IA^2)+V2/HBAR;
GWPRXTD[GWPARG]=RP/MASS;
GWPRPTD[GWPARG]=-(V1+2*V2*RX);
GWPRGTD[GWPARG]=RP^2/(2*MASS)-(V0+V1*RX+V2*RX^2)-HBAR^2/MASS*RA;
GWPIGTD[GWPARG]=-HBAR^2/MASS*IA


(* ::Section::Closed:: *)
(*Potential Models*)


(* ::Subsection::Closed:: *)
(*Named Potential Models*)


(* --- Named Systems ---*)
FREE[t_][GWPARG]=LINEAR[0][t][GWPVAL];
HO[t_][GWPARG]=HARMONIC[1][t][GWPVAL];


(* ::Subsection::Closed:: *)
(*Linear Potential*)


(* --- Note on Phase Evolution & 'LCT' Terms --- *)
(* For non-free potentials, the exact time-dependent phase relies on the     *)
(* classical action. The 'LCT' (Lagrangian Classical Term) functions compute *)
(* the exact time-integral of the classical Lagrangian along the center of   *)
(* the wavepacket's trajectory: Integral[ L(x(t), v(t)), dt ].               *)


LINEARFUN={LINEARRAT,LINEARIAT,LINEARRXT,LINEARRPT,LINEARRGT,LINEARIGT};
SetAttributes[LINEARFUN,Listable];
LINEAR[FK_:1][t_][GWPARG]=Sequence@@{Sequence@@Through[Through[LINEARFUN[t,FK]][GWPVAL]],NORM,HBAR,MASS,{0,FK,0},INIT};
LINEARRAT[t_,FK_][GWPARG]=(MASS^2*RA)/(MASS^2 - 4*HBAR*IA*MASS*t + 4*HBAR^2*(IA^2 + RA^2)*t^2);
LINEARIAT[t_,FK_][GWPARG]=(MASS*(IA*MASS - 2*HBAR*(IA^2 + RA^2)*t))/(MASS^2 - 4*HBAR*IA*MASS*t + 4*HBAR^2*(IA^2 + RA^2)*t^2);
LINEARRXT[t_,FK_][GWPARG]=RX + (RP*t)/MASS - (FK*t^2)/(2*MASS);
LINEARRPT[t_,FK_][GWPARG]=RP - FK*t;
LINEARLCT[t_,FK_][GWPARG]=(t*(3*RP^2 - 6*FK*RP*t + 2*FK*(-3*MASS*RX + FK*t^2)))/(6*MASS);
LINEARRGT[t_,FK_][GWPARG]=RG + LINEARLCT[t,FK][GWPVAL] - (HBAR*ArcTan[1 - (2*HBAR*IA*t)/MASS, (2*HBAR*RA*t)/MASS])/2;
(*LINEARIGT[t_,FK_][GWPARG]=IG + (HBAR*(-2*Log[MASS] + Log[4*HBAR^2*RA^2*t^2 + (MASS - 2*HBAR*IA*t)^2]))/4;*)
LINEARIGT[t_,FK_][GWPARG]=IG + (HBAR*Log[4*HBAR^2*RA^2*t^2/MASS^2 + (MASS - 2*HBAR*IA*t)^2/MASS^2])/4;


(* ::Subsection::Closed:: *)
(*Harmonic Oscillator Potential*)


HARMONICFUN={HARMONICRAT,HARMONICIAT,HARMONICRXT,HARMONICRPT,HARMONICRGT,HARMONICIGT};
SetAttributes[HARMONICFUN,Listable];
HARMONIC[OMEGA_:1][t_][GWPARG]=Sequence@@{Sequence@@Through[Through[HARMONICFUN[t,OMEGA]][GWPVAL]],NORM,HBAR,MASS,{0,0,MASS*OMEGA^2/2},INIT};
HARMONICRAT[t_,OMEGA_][GWPARG]=(MASS^2*OMEGA^2*RA)/(4*HBAR^2*(IA^2 + RA^2)*Sin[OMEGA*t]^2 + MASS*OMEGA*(MASS*OMEGA*Cos[OMEGA*t]^2 - 2*HBAR*IA*Sin[2*OMEGA*t]));
HARMONICIAT[t_,OMEGA_][GWPARG]=(MASS*OMEGA*(4*HBAR*IA*MASS*OMEGA*Cos[2*OMEGA*t] + (MASS^2*OMEGA^2 - 4*HBAR^2*(IA^2 + RA^2))*Sin[2*OMEGA*t]))/(4*(4*HBAR^3*(IA^2 + RA^2)*Sin[OMEGA*t]^2 + HBAR*MASS*OMEGA*(MASS*OMEGA*Cos[OMEGA*t]^2 - 2*HBAR*IA*Sin[2*OMEGA*t])));
HARMONICRXT[t_,OMEGA_][GWPARG]=RX*Cos[OMEGA*t] + (RP*Sin[OMEGA*t])/(MASS*OMEGA);
HARMONICRPT[t_,OMEGA_][GWPARG]=RP*Cos[OMEGA*t] - MASS*OMEGA*RX*Sin[OMEGA*t];
HARMONICLCT[t_,OMEGA_][GWPARG]=(Sin[OMEGA*t]*((RP^2/(MASS*OMEGA) - MASS*OMEGA*RX^2)*Cos[OMEGA*t] - 2*RP*RX*Sin[OMEGA*t]))/2;
HARMONICRGT[t_,OMEGA_][GWPARG]=RG+HARMONICLCT[t,OMEGA][GWPVAL]-1/2*(HBAR*ArcTan[(MASS*OMEGA*Cos[OMEGA*t])/HBAR - 2*IA*Sin[OMEGA*t], 2*RA*Sin[OMEGA*t]])+HBAR*Pi*Floor[(Pi - OMEGA*t)/(2*Pi)];
HARMONICIGT[t_,OMEGA_][GWPARG]=IG+(HBAR*Log[(4*HBAR^2*(RA^2*Sin[OMEGA*t]^2 + (-1/2*(MASS*OMEGA*Cos[OMEGA*t])/HBAR + IA*Sin[OMEGA*t])^2))/(MASS^2*OMEGA^2)])/4;


(* ::Subsection::Closed:: *)
(*Parabolic Potential*)


PARABOLICFUN={PARABOLICRAT,PARABOLICIAT,PARABOLICRXT,PARABOLICRPT,PARABOLICRGT,PARABOLICIGT};
SetAttributes[PARABOLICFUN,Listable];
PARABOLIC[OMEGA_:1][t_][GWPARG]=Sequence@@{Sequence@@Through[Through[PARABOLICFUN[t,OMEGA]][GWPVAL]],NORM,HBAR,MASS,{0,0,-MASS*OMEGA^2/2},INIT};
PARABOLICRAT[t_,OMEGA_][GWPARG]=(MASS^2*OMEGA^2*RA)/(4*HBAR^2*(IA^2 + RA^2)*Sinh[OMEGA*t]^2 + MASS*OMEGA*(MASS*OMEGA*Cosh[OMEGA*t]^2 - 2*HBAR*IA*Sinh[2*OMEGA*t]));
PARABOLICIAT[t_,OMEGA_][GWPARG]=(MASS*OMEGA*(4*HBAR*IA*MASS*OMEGA*Cosh[2*OMEGA*t] - (MASS^2*OMEGA^2 + 4*HBAR^2*(IA^2 + RA^2))*Sinh[2*OMEGA*t]))/(4*(4*HBAR^3*(IA^2 + RA^2)*Sinh[OMEGA*t]^2 + HBAR*MASS*OMEGA*(MASS*OMEGA*Cosh[OMEGA*t]^2 - 2*HBAR*IA*Sinh[2*OMEGA*t])));
PARABOLICRXT[t_,OMEGA_][GWPARG]=RX*Cosh[OMEGA*t] + (RP*Sinh[OMEGA*t])/(MASS*OMEGA);
PARABOLICRPT[t_,OMEGA_][GWPARG]=RP*Cosh[OMEGA*t] + MASS*OMEGA*RX*Sinh[OMEGA*t];
PARABOLICLCT[t_,OMEGA_][GWPARG]=RP*RX*Sinh[OMEGA*t]^2 + ((RP^2 + MASS^2*OMEGA^2*RX^2)*Sinh[2*OMEGA*t])/(4*MASS*OMEGA);
PARABOLICRGT[t_,OMEGA_][GWPARG] = RG + PARABOLICLCT[t,OMEGA][GWPVAL] + (HBAR*ArcTan[1/2*(MASS*OMEGA*Cosh[OMEGA*t])/HBAR - IA*Sinh[OMEGA*t], -RA*Sinh[OMEGA*t]])/2;
PARABOLICIGT[t_,OMEGA_][GWPARG]=IG+(HBAR*Log[(MASS^2*OMEGA^2 - 4*HBAR^2*(IA^2 + RA^2) + (MASS^2*OMEGA^2 + 4*HBAR^2*(IA^2 + RA^2))*Cosh[2*OMEGA*t] - 4*HBAR*IA*MASS*OMEGA*Sinh[2*OMEGA*t])/(2*MASS^2*OMEGA^2)])/4;


(* ::Subsection::Closed:: *)
(*Forced Harmonic Oscillator with Linear Driving*)


FHOLINFUN={FHOLINRAT,FHOLINIAT,FHOLINRXT,FHOLINRPT,FHOLINRGT,FHOLINIGT};
SetAttributes[FHOLINFUN,Listable];
FHOLIN[OMEGA_:1,FA_:1/10][t_][GWPARG]=Sequence@@{Sequence@@Through[Through[FHOLINFUN[t,OMEGA,FA]][GWPVAL]],NORM,HBAR,MASS,{0,-FA*t,MASS*OMEGA^2/2},INIT};
FHOLINRAT[t_,OMEGA_,FA_][GWPARG]=HARMONICRAT[t,OMEGA][GWPVAL];
FHOLINIAT[t_,OMEGA_,FA_][GWPARG]=HARMONICIAT[t,OMEGA][GWPVAL];
FHOLINRXT[t_,OMEGA_,FA_][GWPARG]=(FA*OMEGA*t + MASS*OMEGA^3*RX*Cos[OMEGA*t] + (-FA + OMEGA^2*RP)*Sin[OMEGA*t])/(MASS*OMEGA^3);
FHOLINRPT[t_,OMEGA_,FA_][GWPARG]=(FA + (-FA + OMEGA^2*RP)*Cos[OMEGA*t] - MASS*OMEGA^3*RX*Sin[OMEGA*t])/OMEGA^2;
FHOLINLCINT[t_,OMEGA_,FA_][GWPARG]=(2*FA*OMEGA*(FA*t + (FA*OMEGA^2*t^3)/3 + 2*MASS*OMEGA^2*RX*(-1 + Cos[OMEGA*t])) + 4*(FA - OMEGA^2*RP)*Sin[OMEGA*t]*(-FA + MASS*OMEGA^3*RX*Sin[OMEGA*t]) + ((FA - OMEGA^2*RP)^2 - MASS^2*OMEGA^6*RX^2)*Sin[2*OMEGA*t])/(4*MASS*OMEGA^5);
FHOLINRGT[t_,OMEGA_,FA_][GWPARG]=RG+FHOLINLCINT[t,OMEGA,FA][GWPVAL]-1/2*(HBAR*ArcTan[(MASS*OMEGA*Cos[OMEGA*t])/HBAR - 2*IA*Sin[OMEGA*t], 2*RA*Sin[OMEGA*t]])+HBAR*Pi*Floor[(Pi - OMEGA*t)/(2*Pi)];
FHOLINIGT[t_,OMEGA_,FA_][GWPARG]=HARMONICIGT[t,OMEGA][GWPVAL];


(* ::Subsection::Closed:: *)
(*Forced Harmonic Oscillator with Sinusoidal Resonant Driving*)


FHORESFUN={FHORESRAT,FHORESIAT,FHORESRXT,FHORESRPT,FHORESRGT,FHORESIGT};
SetAttributes[FHORESFUN,Listable];
FHORES[OMEGA_:1,FA_:1/10][t_][GWPARG]=Sequence@@{Sequence@@Through[Through[FHORESFUN[t,OMEGA,FA]][GWPVAL]],NORM,HBAR,MASS,{0,-FA*Sin[OMEGA*t],MASS*OMEGA^2/2},INIT};
FHORESRAT[t_,OMEGA_,FA_][GWPARG]=HARMONICRAT[t,OMEGA][GWPVAL];
FHORESIAT[t_,OMEGA_,FA_][GWPARG]=HARMONICIAT[t,OMEGA][GWPVAL];
FHORESRXT[t_,OMEGA_,FA_][GWPARG]=(OMEGA*(2*MASS*OMEGA*RX - FA*t)*Cos[OMEGA*t] + (FA + 2*OMEGA*RP)*Sin[OMEGA*t])/(2*MASS*OMEGA^2);
FHORESRPT[t_,OMEGA_,FA_][GWPARG]=RP*Cos[OMEGA*t] + ((-2*MASS*OMEGA*RX + FA*t)*Sin[OMEGA*t])/2;
FHORESLCT[t_,OMEGA_,FA_][GWPARG]=(-16*MASS*OMEGA^3*RP*RX + 2*FA*OMEGA*(3*FA + 4*OMEGA*RP)*t + 8*OMEGA^2*RP*(2*MASS*OMEGA*RX - FA*t)*Cos[2*OMEGA*t] + (8*OMEGA^2*RP^2 - 8*MASS^2*OMEGA^4*RX^2 + 8*FA*MASS*OMEGA^3*RX*t - FA^2*(3 + 2*OMEGA^2*t^2))*Sin[2*OMEGA*t])/(32*MASS*OMEGA^3);
FHORESRGT[t_,OMEGA_,FA_][GWPARG]=RG+FHORESLCT[t,OMEGA,FA][GWPVAL]-1/2*(HBAR*ArcTan[(MASS*OMEGA*Cos[OMEGA*t])/HBAR - 2*IA*Sin[OMEGA*t], 2*RA*Sin[OMEGA*t]])+HBAR*Pi*Floor[(Pi - OMEGA*t)/(2*Pi)];
FHORESIGT[t_,OMEGA_,FA_][GWPARG]=HARMONICIGT[t,OMEGA][GWPVAL];


(* ::Subsection::Closed:: *)
(*Forced Harmonic Oscillator with Sinusoidal Non-resonant Driving*)


FHONONFUN={FHONONRAT,FHONONIAT,FHONONRXT,FHONONRPT,FHONONRGT,FHONONIGT};
SetAttributes[FHONONFUN,Listable];
FHONON[OMEGA_:1,FA_:1/10,OMEGA1_:2][t_][GWPARG]=Sequence@@{Sequence@@Through[Through[FHONONFUN[t,OMEGA,FA,OMEGA1]][GWPVAL]],NORM,HBAR,MASS,{0,-FA*Sin[OMEGA1*t],MASS*OMEGA^2/2},INIT};
FHONONRAT[t_,OMEGA_,FA_,OMEGA1_][GWPARG]=HARMONICRAT[t,OMEGA][GWPVAL];
FHONONIAT[t_,OMEGA_,FA_,OMEGA1_][GWPARG]=HARMONICIAT[t,OMEGA][GWPVAL];
FHONONRXT[t_,OMEGA_,FA_,OMEGA1_][GWPARG]=(MASS*OMEGA*(OMEGA^2 - OMEGA1^2)*RX*Cos[OMEGA*t] - (FA*OMEGA1 - OMEGA^2*RP + OMEGA1^2*RP)*Sin[OMEGA*t] + FA*OMEGA*Sin[OMEGA1*t])/(MASS*OMEGA*(OMEGA^2 - OMEGA1^2));
FHONONRPT[t_,OMEGA_,FA_,OMEGA1_][GWPARG]=(-((FA*OMEGA1 + (-OMEGA^2 + OMEGA1^2)*RP)*Cos[OMEGA*t]) + FA*OMEGA1*Cos[OMEGA1*t] + MASS*OMEGA*(-OMEGA^2 + OMEGA1^2)*RX*Sin[OMEGA*t])/(OMEGA^2 - OMEGA1^2);
FHONONLCT[t_,OMEGA_,FA_,OMEGA1_][GWPARG]=(-2*OMEGA*(OMEGA - OMEGA1)*OMEGA1*(OMEGA + OMEGA1)*(2*MASS*(FA*OMEGA1 + (OMEGA - OMEGA1)*(OMEGA + OMEGA1)*RP)*RX - FA^2*t) + 4*MASS*OMEGA*(OMEGA - OMEGA1)*OMEGA1*(OMEGA + OMEGA1)*(OMEGA^2*RP - OMEGA1*(FA + OMEGA1*RP))*RX*Cos[2*OMEGA*t] + 8*FA*MASS*OMEGA*(OMEGA - OMEGA1)*OMEGA1^2*(OMEGA + OMEGA1)*RX*Cos[OMEGA*t]*Cos[OMEGA1*t] - 8*FA*OMEGA1^2*(-(OMEGA^2*RP) + OMEGA1*(FA + OMEGA1*RP))*Cos[OMEGA1*t]*Sin[OMEGA*t] + 2*OMEGA1*(FA*OMEGA1 + (OMEGA - OMEGA1)*(OMEGA + OMEGA1)*(-RP + MASS*OMEGA*RX))*(FA*OMEGA1 - (OMEGA - OMEGA1)*(OMEGA + OMEGA1)*(RP + MASS*OMEGA*RX))*Sin[2*OMEGA*t] - FA^2*OMEGA*(OMEGA^2 - 3*OMEGA1^2)*Sin[2*OMEGA1*t])/(8*MASS*OMEGA*OMEGA1*(OMEGA^2 - OMEGA1^2)^2);
FHONONRGT[t_,OMEGA_,FA_,OMEGA1_][GWPARG]=RG+FHONONLCT[t,OMEGA,FA,OMEGA1][GWPVAL]-1/2*(HBAR*ArcTan[(MASS*OMEGA*Cos[OMEGA*t])/HBAR - 2*IA*Sin[OMEGA*t], 2*RA*Sin[OMEGA*t]])+HBAR*Pi*Floor[(Pi - OMEGA*t)/(2*Pi)];
FHONONIGT[t_,OMEGA_,FA_,OMEGA1_][GWPARG]=HARMONICIGT[t,OMEGA][GWPVAL];


(* ::Subsection::Closed:: *)
(*External Potential and Force*)


(* --- x-Space External Potential Energy Field --- *)
GWPPEX[0][x_][GWPARG] := V0 + V1 * x + V2 * x^2;
GWPPEX[1][x_][GWPARG] := V1 + 2*V2*x;
GWPPEX[2][x_][GWPARG] := 2*V2;
GWPPEX[n_Integer][x_][GWPARG] /; n >= 3 := 0; 
(* Fallback: Route GWPPEX[x][...] to the 0th derivative *)
GWPPEX[x_][arg___] /; !MatchQ[Unevaluated[GWPPEX[x]], GWPPEX[_Integer]] := GWPPEX[0][x][arg];


(* --- x-Space External Force Field --- *)
GWPFEX[0][x_][GWPARG] := -V1 - 2 * V2 * x;
GWPFEX[1][x_][GWPARG] := -2 * V2;
GWPFEX[n_Integer][x_][GWPARG] /; n >= 2 := 0;
(* Fallback: Route GWPFEX[x][...] to the 0th derivative *)
GWPFEX[x_][arg___] /; !MatchQ[Unevaluated[GWPFEX[x]], GWPFEX[_Integer]] := GWPFEX[0][x][arg];


(* ::Section::Closed:: *)
(*Wavefunctions*)


(* --- Private Worker Function for Wavefunction Recursion --- *)
(* Implements the generalized three-term Hermite polynomial recurrence: *)
(* P_n(z) = p1 * P_{n-1}(z) - 2 * coeff * (n - 1) * P_{n-2}(z)          *)
GWPHermiteEngine[n_Integer, p1_, coeff_] := Module[{pPrev2, pPrev1, pCurr},
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
GWPPSIX[n_Integer][x_][GWPARG] := Module[{raia, p1, poly},
  raia = RA + I*IA;
  p1 = -2 * raia * (x - RX) + (I * RP) / HBAR;  
  (* Generate the polynomial using the worker engine *)
  poly = GWPHermiteEngine[n, p1, raia];
  poly * NORM * Exp[-(RA + I*IA)*(x - RX)^2 + (I/HBAR)*RP*(x - RX) + (I/HBAR)*(RG + I*IG)]
];
(* Fallback: Route GWPPSIX[x][...] to the 0th derivative *)
GWPPSIX[x_][arg___] /; !MatchQ[Unevaluated[GWPPSIX[x]], GWPPSIX[_Integer]] := GWPPSIX[0][x][arg];


(* --- x-space Complex Conjugate Wavefunction --- *)
GWPCSIX[n_Integer][x_][GWPARG] := Module[{raia, p1, poly},
  raia = RA - I*IA;
  p1 = -2 * raia * (x - RX) + (-I * RP) / HBAR; 
  poly = GWPHermiteEngine[n, p1, raia]; 
  poly * NORM * Exp[-(RA - I*IA)*(x - RX)^2 - (I/HBAR)*RP*(x - RX) - (I/HBAR)*(RG - I*IG)]
];
(* Fallback: Route GWPCSIX[x][...] to the 0th derivative *)
GWPCSIX[x_][arg___] /; !MatchQ[Unevaluated[GWPCSIX[x]], GWPCSIX[_Integer]] := GWPCSIX[0][x][arg];


(* --- x-Space Real and Imaginary Wavefunction Components --- *)
GWPRSIX[x_][GWPARG] = NORM * Exp[-(IG/HBAR) - RA*(RX - x)^2] * Cos[(RG - (RP + HBAR*IA*(RX - x))*(RX - x))/HBAR];
GWPISIX[x_][GWPARG] = NORM * Exp[-(IG/HBAR) - RA*(RX - x)^2] * Sin[(RG - (RP + HBAR*IA*(RX - x))*(RX - x))/HBAR];


(* --- p-Space Wavefunctions --- *)
GWPPSIP[n_Integer][p_][GWPARG] := Module[{a, b, p1, poly, shift, normP, phaseP},
  a = RA + I*IA;
  b = 1 / (4 * a * HBAR^2);
  shift = p - RP;
  p1 = -2 * b * shift - (I * RX) / HBAR;
  poly = GWPHermiteEngine[n, p1, b];
  normP = NORM / Sqrt[2 * HBAR * a];
  phaseP = Exp[-b * shift^2 - (I/HBAR) * RX * p + (I/HBAR) * (RG + I*IG)];     
  poly * normP * phaseP
];
(* Fallback: Route GWPPSIP[p][...] to the 0th derivative *)
GWPPSIP[p_][arg___] /; !MatchQ[Unevaluated[GWPPSIP[p]], GWPPSIP[_Integer]] := GWPPSIP[0][p][arg];


(* --- p-Space Complex Conjugate Wavefunction --- *)
GWPCSIP[n_Integer][p_][GWPARG] := Module[{a, b, p1, poly, shift, normP, phaseP},
  a = RA - I*IA;
  b = 1 / (4 * a * HBAR^2);
  shift = p - RP;
  p1 = -2 * b * shift - (-I * RX) / HBAR; 
  poly = GWPHermiteEngine[n, p1, b];
  normP = NORM / Sqrt[2 * HBAR * a];
  phaseP = Exp[-b * shift^2 - (-I/HBAR) * RX * p + (-I/HBAR) * (RG - I*IG)];   
  poly * normP * phaseP
];
(* Fallback: Route GWPCSIP[p][...] to the 0th derivative *)
GWPCSIP[p_][arg___] /; !MatchQ[Unevaluated[GWPCSIP[p]], GWPCSIP[_Integer]] := GWPCSIP[0][p][arg];


(* --- p-Space Real and Imaginary Wavefunction Components --- *)
GWPRSIP[p_][GWPARG] = (NORM * Exp[-IG/HBAR - (RA*(p - RP)^2)/(4*HBAR^2*(RA^2 + IA^2))] * Cos[RG/HBAR - (p*RX)/HBAR + (IA*(p - RP)^2)/(4*HBAR^2*(RA^2 + IA^2)) - 1/2*ArcTan[RA, IA]]) / (4*HBAR^2*(RA^2 + IA^2))^(1/4);
GWPISIP[p_][GWPARG] = (NORM * Exp[-IG/HBAR - (RA*(p - RP)^2)/(4*HBAR^2*(RA^2 + IA^2))] * Sin[RG/HBAR - (p*RX)/HBAR + (IA*(p - RP)^2)/(4*HBAR^2*(RA^2 + IA^2)) - 1/2*ArcTan[RA, IA]]) / (4*HBAR^2*(RA^2 + IA^2))^(1/4);


(* ::Section::Closed:: *)
(*Probabilities*)


(* --- x-Space Density --- *)
GWPRHOX[n_Integer][x_][GWPARG] := Module[{alpha, p1, shift, poly},
  alpha = 2 * RA;
  shift = x - RX;
  p1 = -2 * alpha * shift;  
  (* Generate the polynomial using the worker engine *)
  poly = GWPHermiteEngine[n, p1, alpha];  
  poly * (Sqrt[2/Pi] * Sqrt[RA]) * Exp[-2 * RA * (x - RX)^2]
];
(* Fallback: Route GWPRHOX[x][...] to the 0th derivative *)
GWPRHOX[x_][arg___] /; !MatchQ[Unevaluated[GWPRHOX[x]], GWPRHOX[_Integer]] := GWPRHOX[0][x][arg];


(* --- p-Space Density --- *)
GWPRHOP[n_Integer][p_][GWPARG] := Module[{beta, p1, shift, poly},
  beta = RA / (2 * HBAR^2 * (RA^2 + IA^2));
  shift = p - RP;
  p1 = -2 * beta * shift;  
  (* Generate the polynomial using the worker engine *)
  poly = GWPHermiteEngine[n, p1, beta];
  
  poly * Sqrt[RA / (2*Pi*HBAR^2*(RA^2 + IA^2))] * Exp[-beta * (p - RP)^2]
];
(* Fallback: Route GWPRHOP[p][...] to the 0th derivative *)
GWPRHOP[p_][arg___] /; !MatchQ[Unevaluated[GWPRHOP[p]], GWPRHOP[_Integer]] := GWPRHOP[0][p][arg];


(* --- Energy Density --- *)
GWPRHOE[EE_][GWPARG] = (Sqrt[MASS/EE] * (
  Sqrt[RA / (HBAR^2*(IA^2 + RA^2))] / (Exp[(RA*(-(Sqrt[2]*Sqrt[EE*MASS]) - RP)^2) / (2*HBAR^2*(IA^2 + RA^2))] * Sqrt[2*Pi]) + 
  Sqrt[RA / (HBAR^2*(IA^2 + RA^2))] / (Exp[(RA*(Sqrt[2]*Sqrt[EE*MASS] - RP)^2) / (2*HBAR^2*(IA^2 + RA^2))] * Sqrt[2*Pi])
)) / Sqrt[2];


(* --- Cumulative Distribution Functions --- *)
GWPCX[x_][GWPARG] = (1 + Erf[Sqrt[2 * RA] * (x - RX)]) / 2;

GWPCP[p_][GWPARG] = (1 + Erf[(p - RP) / (Sqrt[2] * HBAR * Sqrt[IA^2/RA + RA])]) / 2;

GWPCE[e_][GWPARG] := (
  Erf[(Sqrt[RA / (IA^2 + RA^2)] * (2*Sqrt[e*MASS] - Sqrt[2]*RP)) / (2*HBAR)] + 
  Erf[(Sqrt[RA / (IA^2 + RA^2)] * (2*Sqrt[e*MASS] + Sqrt[2]*RP)) / (2*HBAR)]
) / 2;



(* --- Interval Probabilities --- *)
GWPPROBX[mn_, mx_][GWPARG] = GWPCX[mx][GWPVAL] - GWPCX[mn][GWPVAL];
GWPPROBP[mn_, mx_][GWPARG] = GWPCP[mx][GWPVAL] - GWPCP[mn][GWPVAL];
GWPPROBE[mn_, mx_][GWPARG] = GWPCE[mx][GWPVAL] - GWPCE[mn][GWPVAL];


(* ::Section::Closed:: *)
(*ExpectationValues*)


(* --- Position Expectation Values (Arbitrary Order) --- *)
GWPEX[n_Integer][GWPARG] := Sum[
  Binomial[n, 2*k] * (2*k - 1)!! * (1/(4*RA))^k * RX^(n - 2*k), 
  {k, 0, Floor[n/2]}
];
(* Fallback: Route GWPEX[...] to the 1st moment *)
GWPEX[param___] /; !MatchQ[{param}, {_Integer}] := GWPEX[1][param];


(* --- Momentum Expectation Values (Arbitrary Order) --- *)
GWPEP[n_Integer][GWPARG] := Sum[
  Binomial[n, 2*k] * (2*k - 1)!! * (HBAR^2*(RA + (IA^2 / RA)))^k * RP^(n - 2*k), 
  {k, 0, Floor[n/2]}
];
(* Fallback: Route GWPEP[...] to the 1st moment *)
GWPEP[param___] /; !MatchQ[{param}, {_Integer}] := GWPEP[1][param];


(* --- Position-Momentum Uncertainty --- *)
GWPUX[GWPARG]  = 1/(2*Sqrt[RA]);
GWPUP[GWPARG]  = HBAR*Sqrt[RA + IA^2/RA];


(* --- Position-Mometum Product Expectation Values (Arbitrary Order) --- *)
With[{VAL = GWPVAL},
  
  (* Base Case: n=0 reduces strictly to a pure position moment *)
  GWPEXP[m_Integer /; m >= 0, 0][GWPARG] := GWPEX[m][VAL];

  (* Recursive Step for n > 0 *)
  GWPEXP[m_Integer /; m >= 0, n_Integer /; n > 0][GWPARG] := Module[{A, B},
      
    (* Exact algebraic mapping from the Parameter Bus *)
    A = 2 * I * HBAR * (RA + I * IA); 
    B = RP - A * RX;

    (* Forward Recursion (strictly decreases momentum power n) *)
    A * GWPEXP[m + 1, n - 1][VAL] + 
    B * GWPEXP[m, n - 1][VAL] - 
    If[n >= 2, I * HBAR * A * (n - 1) * GWPEXP[m, n - 2][VAL], 0]
  ];
];

(* Fallback: Route default calls to m=1, n=1 *)
GWPEXP[args___] /; !MatchQ[{args}, {_Integer, _Integer}] := GWPEXP[1, 1][args];


(* --- Mometum-Position Expectation Values (Arbitrary Orders) --- *)
With[{VAL = GWPVAL},
  
  (* Base Case: m=0 reduces strictly to a pure position moment *)
  GWPEPX[0, n_Integer /; n >= 0][GWPARG] := GWPEX[n][VAL];

  (* Recursive Step for m > 0 *)
  GWPEPX[m_Integer /; m > 0, n_Integer /; n >= 0][GWPARG] := Module[{As, Bs},
      
    (* Explicitly written conjugates of A and B using Parameter Bus symbols *)
    As = -2 * I * HBAR * (RA - I * IA); 
    Bs = RP - As * RX;

    (* Reverse Recursion (strictly decreases momentum power m) *)
    As * GWPEPX[m - 1, n + 1][VAL] + 
    Bs * GWPEPX[m - 1, n][VAL] + 
    If[m >= 2, I * HBAR * As * (m - 1) * GWPEPX[m - 2, n][VAL], 0]
  ];
];

(* Fallback: Route default calls to m=1, n=1 *)
GWPEPX[args___] /; !MatchQ[{args}, {_Integer, _Integer}] := GWPEPX[1, 1][args];


(* --- Position-Momentum Covariance --- *)
GWPCOVXP[GWPARG] = -1/2*(HBAR*IA)/RA;
GWPCORXP[GWPARG] = -(IA/Sqrt[IA^2 + RA^2]);


(* --- Force Expectation Values --- *)
GWPEF1[GWPARG] = -V1 - 2*RX*V2;
GWPEF2[GWPARG] = (V2^2 + RA*(V1 + 2*RX*V2)^2)/RA;
GWPUF[GWPARG]  = Abs[V2]/Sqrt[RA];


(* --- Fisher Information ---*)
GWPEFIX[GWPARG] = 4*RA;
GWPEFIP[GWPARG] = RA/(HBAR^2*(IA^2 + RA^2));


(* ::Section::Closed:: *)
(*Energies*)


(* --- Note on Analytical Derivations --- *)
(* The massive algebraic expressions for high-order moments, cross-terms,    *)
(* and squared expectations are exact analytical results.*)
(* They were derived offline via exact symbolic integration of the quantum   *)
(* mechanical operators over the underlying Gaussian probability densities.  *)


(* --- Kinetic Energy Expectation Values (arbitrary order) --- *)
With[{VAL = GWPVAL},
  GWPEKE[n_Integer /; n >= 0][GWPARG] := GWPEP[2 * n][VAL] / (2 * MASS)^n;
];

(* Fallback: Route default calls to the 1st moment *)
GWPEKE[args___] /; !MatchQ[{args}, {_Integer}] := GWPEKE[1][args];


(* --- Potential Energy Expectation Values (arbitrary order) --- *)
With[{VAL = GWPVAL},
  GWPEPE[n_Integer /; n >= 0][GWPARG] := Module[{moments},
    moments = Table[GWPEX[k][VAL], {k, 0, 2 * n}];
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
GWPEPE[args___] /; !MatchQ[{args}, {_Integer}] := GWPEPE[1][args];


(* --- Kinetic-Potential Energy Cross-Correlations --- *)
GWPEKEPE[GWPARG] = (-4*HBAR*(IA + I*RA)*RA*RP*(V1 + 2*RX*V2) + HBAR^2*(4*RA*(IA^2 + RA^2)*(V0 + RX*V1) + (IA + I*RA)*(3*IA + I*RA + 4*(IA - I*RA)*RA*RX^2)*V2) + RA*RP^2*(V2 + 4*RA*(V0 + RX*(V1 + RX*V2))))/(8*MASS*RA^2);
GWPEPEKE[GWPARG] = ((4*I)*HBAR*RA*(I*IA + RA)*RP*(V1 + 2*RX*V2) + HBAR^2*(4*RA*(IA^2 + RA^2)*(V0 + RX*V1) + (IA - I*RA)*(3*IA - I*RA + 4*(IA + I*RA)*RA*RX^2)*V2) + RA*RP^2*(V2 + 4*RA*(V0 + RX*(V1 + RX*V2))))/(8*MASS*RA^2);
GWPCOVKEPE[GWPARG] = (HBAR*(HBAR*IA^2*V2 - HBAR*RA^2*V2 - 2*IA*RA*RP*(V1 + 2*RX*V2)))/(4*MASS*RA^2);
GWPCORKEPE[GWPARG] /; (V1 == 0 && V2 == 0) := 0;
GWPCORKEPE[GWPARG] := (HBAR*(HBAR*IA^2*V2 - HBAR*RA^2*V2 - 2*IA*RA*RP*(V1 + 2*RX*V2))) / 
  (MASS*RA^2 * Sqrt[(HBAR^2*(IA^2 + RA^2)*(HBAR^2*(IA^2 + RA^2) + 2*RA*RP^2))/(MASS^2*RA^2)] * Sqrt[(V2^2 + 2*RA*(V1 + 2*RX*V2)^2)/RA^2]);


(* --- Kinetic-Potential Energy Cross-Correlations (Arbitrary Order) --- *)
With[{VAL = GWPVAL},
  GWPEKEPE[m_Integer /; m >= 0, n_Integer /; n >= 0][GWPARG] := Module[{moments},
    moments = Table[GWPEPX[2 * m, k][VAL], {k, 0, 2 * n}];
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

With[{VAL = GWPVAL},
  GWPEPEKE[m_Integer /; m >= 0, n_Integer /; n >= 0][GWPARG] := Module[{moments},
    moments = Table[GWPEXP[k, 2 * n][VAL], {k, 0, 2 * m}];
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
GWPETE::maxorder = "Analytically exact total energy moments are only supported up to n = 4. Requested order: `1`.";

With[{VAL = GWPVAL},
  GWPETE[n_Integer /; n >= 0][GWPARG] := Which[
    n == 0, 1,
    n == 1, GWPETE1[VAL],
    n == 2, GWPETE2[VAL],
    n == 3, GWPETE3[VAL],
    n == 4, GWPETE4[VAL],
    True,   Message[GWPETE::maxorder, n]; $Failed
  ];
];

(* Fallback: Route default calls to the 1st moment *)
GWPETE[args___] /; !MatchQ[{args}, {_Integer}] := GWPETE[1][args];


(* --- Total Energy Expectation Values --- *)
GWPETE1[GWPARG] = (HBAR^2*(IA^2/RA + RA) + RP^2)/(2*MASS) + V0 + RX*V1 + (1/(4*RA) + RX^2)*V2;
GWPETE2[GWPARG] = (12*HBAR^4*(IA^2 + RA^2)^2 + 3*MASS^2*V2^2 - 16*HBAR*IA*MASS*RA*RP*(V1 + 2*RX*V2) + 4*HBAR^2*(2*RA*(IA^2 + RA^2)*(3*RP^2 + 2*MASS*(V0 + RX*V1)) + MASS*(3*IA^2 - RA^2 + 4*RA*(IA^2 + RA^2)*RX^2)*V2) + 4*RA^2*(RP^2 + 2*MASS*(V0 + RX*(V1 + RX*V2)))^2 + 4*MASS*RA*(RP^2*V2 + MASS*(V1^2 + 6*RX*V1*V2 + 2*V2*(V0 + 3*RX^2*V2))))/(16*MASS^2*RA^2);
(* --- 3rd-Order Total Energy Moment (Semiclassical Skewness) --- *)
GWPETE3[GWPARG] = (120*HBAR^6*(IA^2 + RA^2)^3 + 15*MASS^3*V2^3 - 
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
GWPETE4[GWPARG] = (1680*HBAR^8*(IA^2 + RA^2)^4 + 105*MASS^4*V2^4 - 5760*HBAR^5*IA*MASS*RA*(IA^2 + RA^2)^2*RP*(V1 + 2*RX*V2) + 
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
GWPUKE[GWPARG]  = Sqrt[(HBAR^2*(IA^2 + RA^2)*(HBAR^2*(IA^2 + RA^2) + 2*RA*RP^2))/(MASS^2*RA^2)]/Sqrt[2];
GWPUPE[GWPARG]  = Sqrt[(V2^2 + 2*RA*(V1 + 2*RX*V2)^2)/RA^2]/(2*Sqrt[2]);
GWPUTE[GWPARG]  = Sqrt[(4*HBAR^4*(IA^2 + RA^2)^2 + 4*HBAR^2*(2*RA*(IA^2 + RA^2)*RP^2 + MASS*(IA - RA)*(IA + RA)*V2) - 8*HBAR*IA*MASS*RA*RP*(V1 + 2*RX*V2) + MASS^2*(V2^2 + 2*RA*(V1 + 2*RX*V2)^2))/(MASS^2*RA^2)]/(2*Sqrt[2]);


(* ::Section::Closed:: *)
(*GWPObject Registration*)


(* ::Subsection::Closed:: *)
(*Potential Model Resolution*)


(* --- Potential Model Resolution & Dispatch --- *)
(* This section defines the external potential energy models available to    *)
(* the GWPObject and dictates how user inputs are validated and routed.      *)
(*                                                                           *)
(* - $GWPPotentialModels     : A reference list of the raw internal          *)
(*                             signatures (e.g., "HO", "LINEAR[FK]").        *)
(* - $GWPPotentialNames      : An Association mapping human-readable strings *)
(*                             (e.g., "HarmonicOscillator") to their         *)
(*                             internal package counterparts.                *)
(* - $GWPPotentialSignatures : A strictly typed pattern registry             *)
(*                             (e.g., FREE | HO | LINEAR[_]) used by the     *)
(*                             Core Constructor to instantly validate inputs.*)
(*                                                                           *)
(* RESOLUTION FLOW:                                                          *)
(* When a user evaluates GWP["Potential" -> sys]:                            *)
(* 1. If sys is a known string name (e.g., "FreeParticle"), it maps directly *)
(*    to the underlying package function (e.g., FREE).                       *)
(* 2. If sys is a direct mathematical signature (e.g., "LINEAR[2]"), it      *)
(*    validates against the pattern registry and passes it directly to the   *)
(*    physics engine.                                                        *)


(* --- User-Facing Potential Templates (For Introspection) --- *)
$GWPPotentialModels = {
   "\"Free\"", 
   "\"HO\"", 
   "{\"Linear\", k}", 
   "{\"Harmonic\", omega}", 
   "{\"ParabolicBarrier\", omega}", 
   "{\"LinearForcedHO\", omega, A}", 
   "{\"ResonantForcedHO\", omega, A}", 
   "{\"NonResonantForcedHO\", omega, A, omega1}"
};

(* --- Named Potentials with Predefined Parameters --- *)
$GWPPotentialNames = <|
   "Free" -> FREE,
   "HO" -> HO
|>;

(* --- Parameterized Potential Heads --- *)
$GWPPotentialHeads = <|
   "Linear" -> LINEAR,
   "Harmonic" -> HARMONIC,
   "ParabolicBarrier" -> PARABOLIC,
   "LinearForcedHO" -> FHOLIN,
   "ResonantForcedHO" -> FHORES,
   "NonResonantForcedHO" -> FHONON
|>;

(* --- Internal Pattern Registry for Validation --- *)
$GWPPotentialSignatures = FREE | HO | LINEAR[_] | HARMONIC[_] | PARABOLIC[_] | FHOLIN[_, _] | FHORES[_, _] | FHONON[_, _, _];


(* ::Subsection::Closed:: *)
(*Property Resolution and Dispatch*)


$regStatic = Append[#, "StaticParameters"] & /@ {
  {"Normalization",         "NORM",        "Static", "Static"},
  {"ReducedPlanckConstant", "HBAR",        "Static", "Static"},
  {"Mass",                  "MASS",        "Static", "Static"},
  {"InputParameters",       "INPUT",       "Static", "Static"},
  {"InitialParameters",     "INIT",        "Static", "Static"},
  {"Assumptions",           "ASSUMPTIONS", "Static", "Static"}
};


$regDynamic = Append[#, "DynamicParameters"] & /@ {
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


$regWave = Append[#, "Wavefunctions"] & /@ {
  {"WavefunctionX",          "PSIX", "Recursive", "RecursiveSpatial"},
  {"ConjugateWavefunctionX", "CSIX", "Recursive", "RecursiveSpatial"},
  {"WavefunctionP",          "PSIP", "Recursive", "RecursiveSpatial"},
  {"ConjugateWavefunctionP", "CSIP", "Recursive", "RecursiveSpatial"},
  {"RealWavefunctionX",      "RSIX", "Field",     "Spatial"},
  {"ImaginaryWavefunctionX", "ISIX", "Field",     "Spatial"},
  {"RealWavefunctionP",      "RSIP", "Field",     "Spatial"},
  {"ImaginaryWavefunctionP", "ISIP", "Field",     "Spatial"}
};


$regProb = Append[#, "Probabilities"] & /@ {
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


$regExp = Append[#, "ExpectationValues"] & /@ {
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
  {"ForceUncertainty",                   "UF",    "Temporal",    None},
  
  {"FisherInformationX",                 "EFIX",  "Temporal",    "StaticValue"},
  {"FisherInformationP",                 "EFIP",  "Temporal",    "StaticValue"}
};


$regEng = Append[#, "Energies"] & /@ {
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
$EngineReg = Join[$regStatic, $regDynamic, $regWave, $regProb, $regExp, $regEng];
Clear[$regStatic, $regDynamic, $regWave, $regProb, $regExp, $regEng];



(* ::Subsection::Closed:: *)
(*Register Potentials and Properties *)


(* The Hook: Dynamically inject registries if GWPTools is active *)
If[TrueQ[GWPTools`Private`$DispatcherActive],
  
  GWPTools`Private`GWPRegisterPotentials[
    $GWPPotentialModels, 
    $GWPPotentialNames, 
    $GWPPotentialHeads,
    $GWPPotentialSignatures
  ];
  
  GWPTools`Private`GWPRegisterExtension[$EngineReg];
];


(* ::Section::Closed:: *)
(*End*)


(* --- End "GWPTools`GWPEngine`Private`" --- *)
End[];


(* Hide internal code for all Developer functions from the ? menu *)
SetAttributes[Evaluate[Names["GWPTools`GWPDeveloper`*"]], {ReadProtected}];


(* --- End "GWPTools`GWPEngine`" --- *)
EndPackage[];

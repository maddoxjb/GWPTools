(* ::Package:: *)

(* ::Title:: *)
(*GWPDeveloper Package*)


(* ::Section::Closed:: *)
(*BeginPackage*)


(* ========================================================================= *)
(* PACKAGE     : GWPTools`GWPDeveloper`                                      *)
(* VERSION     : 1.0.0                                                       *)
(* AUTHOR      : Jeremy B. Maddox                                            *)
(* COPYRIGHT   : (c) 2026 Jeremy B. Maddox                                   *)
(* LICENSE     : MIT License (See LICENSE file in root directory)            *)
(* REPOSITORY  : https://github.com/[your-username]/GWPTools                 *)
(* CITATION    : If you use this software, please cite the companion paper:  *)
(*               [Citation details to be added]                              *)
(* DESCRIPTION : Raw math engine and diagnostics for GWPTools.               *)
(* ========================================================================= *)


(* ========================================================================= *)
(* PACKAGE     : GWPTools`GWPDeveloper`                                      *)
(* DESCRIPTION : Core math engine and diagnostics for GWPTools.              *)
(* ========================================================================= *)


(* --- Define Context --- *)
BeginPackage["GWPTools`GWPDeveloper`"]


(* ::Section::Closed:: *)
(*Usage Statements*)


(* ::Subsection::Closed:: *)
(*About*)


(* --- Mathematical Conventions --- *)
(* 1. Fourier Transform : p-space is defined with the phase Exp[-I p x / HBAR] *)
(* 2. Wavefunction      : Psi(x) = R(x) Exp[I S(x) / HBAR]                     *)
(* 3. Phase Sign        : Time evolution follows Exp[-I E t / HBAR]            *)
(* 4. Normalization     : All densities integrate to 1 over (-inf, inf)        *)
(* 5. Parameter Bus     : All core physics functions internally bind to the    *)
(*                        strict 11-element evaluation sequence:               *)
(*               {RA, IA, RX, RP, RG, IG, NORM, HBAR, MASS, {V0, V1, V2}, INIT}*)

(* --- Namespace & Naming Legend --- *)
(* MANIFOLD SUFFIXES:                                                        *)
(*   X : Position space manifold               (e.g., PSIX, RHOX)            *)
(*   P : Momentum space manifold               (e.g., PSIP, RHOP)            *)
(*   C : Cumulative/Bohmian coordinate space   (e.g., XC, PC, RHOC)          *)
(*   E : Energy space manifold                 (e.g., RHOE, CE)              *)
(*                                                                           *)
(* PROPERTY PREFIXES:                                                        *)
(*   E   : Expectation values                  (e.g., EKE1, EPE1)            *)
(*   U   : Uncertainties                       (e.g., UX, UP, UKE)           *)
(*   COV : Covariance & Correlation statistics (e.g., COVXP, CORKEPE)        *)
(*   Q   : Quantum hydrodynamic terms          (e.g., QPX, QFX)              *)
(*                                                                           *)
(* HYDRODYNAMIC FIELDS & DENSITIES:                                          *)
(*   Fields    : V (Velocity), J (Current), A (Amplitude), S (Phase)         *)
(*   Densities : KE (Kinetic Energy), PE (Potential Energy), TED (Total)     *)
(*   Modifiers : I (Internal), C (Convective)  (e.g., IKEX, CPEP)            *)
(* ========================================================================= *)


(* ::Subsection::Closed:: *)
(*Parameters*)


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


(* ::Subsection::Closed:: *)
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


(* ::Subsection::Closed:: *)
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


(* ::Subsection::Closed:: *)
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


(* ::Subsection::Closed:: *)
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


(* ::Subsection::Closed:: *)
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

(* --- Hydrodynamic Expectation Values --- *)
GWPEIKE::usage = "GWPEIKE[param] evaluates the internal (quantum) kinetic energy expectation value.";
GWPECKE::usage = "GWPECKE[param] evaluates the convective (classical) kinetic energy expectation value.";
GWPEIPE::usage = "GWPEIPE[param] evaluates the internal potential energy expectation value.";
GWPECPE::usage = "GWPECPE[param] evaluates the convective potential energy expectation value.";


(* ::Subsection::Closed:: *)
(*HydrodynamicsX*)


(* --- x-Space Hydrodynamic Fields --- *)
GWPJX::usage = "GWPJX[x][param] evaluates the x-space probability current density.";
GWPAX::usage = "GWPAX[x][param] evaluates the x-space real-valued amplitude.";
GWPSX::usage = "GWPSX[x][param] evaluates the x-space real-valued phase function.";
GWPPX::usage = "GWPPX[x][param] evaluates the x-space momentum field.";
GWPVX::usage = "GWPVX[x][param] evaluates the x-space velocity flow field.";
GWPOVX::usage = "GWPOVX[x][param] evaluates the x-space osmotic velocity field.";
GWPQPX::usage = "GWPQPX[x][param] evaluates the x-space quantum potential.";
GWPQFX::usage = "GWPQFX[x][param] evaluates the x-space quantum force.";
GWPQSX::usage = "GWPQSX[x][param] evaluates the x-space quantum stress density.";

(* --- x-Space Information and Energy Densities --- *)
GWPFIX::usage = "GWPFIX[x][param] evaluates the x-space Fisher information density.";
GWPCKEX::usage = "GWPCKEX[x][param] evaluates the x-space convective kinetic energy density.";
GWPIKEX::usage = "GWPIKEX[x][param] evaluates the x-space internal kinetic energy density.";
GWPTKEX::usage = "GWPTKEX[x][param] evaluates the x-space total kinetic energy density.";
GWPTPEX::usage = "GWPTPEX[x][param] evaluates the x-space total potential energy density.";
GWPTEDX::usage = "GWPTEDX[x][param] evaluates the x-space total energy density.";


(* ::Subsection::Closed:: *)
(*HydrodynamicsP*)


(* --- p-Space Hydrodynamic Fields --- *)
GWPAP::usage = "GWPAP[p][param] evaluates the p-space real-valued amplitude.";
GWPSP::usage = "GWPSP[p][param] evaluates the p-space real-valued phase function.";
GWPXP::usage = "GWPXP[p][param] evaluates the p-space position field.";
GWPVP::usage = "GWPVP[p][param] evaluates the p-space force flow field.";
GWPOVP::usage = "GWPOVP[p][param] evaluates the p-space osmotic flow field.";
GWPJP::usage = "GWPJP[p][param] evaluates the p-space probability current density.";
GWPQPP::usage = "GWPQPP[p][param] evaluates the p-space internal potential.";
GWPQFP::usage = "GWPQFP[p][param] evaluates the p-space internal force.";
GWPQSP::usage = "GWPQSP[p][param] evaluates the p-space quantum stress density.";

(* --- p-Space Information and Energy Densities --- *)
GWPFIP::usage = "GWPFIP[p][param] evaluates the p-space Fisher information density.";
GWPCPEP::usage = "GWPCPEP[p][param] evaluates the p-space convective potential energy density.";
GWPIPEP::usage = "GWPIPEP[p][param] evaluates the p-space internal potential energy density.";
GWPTPEP::usage = "GWPTPEP[p][param] evaluates the p-space total potential energy density.";
GWPTKEP::usage = "GWPTKEP[p][param] evaluates the p-space total kinetic energy density.";
GWPTEDP::usage = "GWPTEDP[p][param] evaluates the p-space total energy density.";


(* ::Subsection::Closed:: *)
(*BohmianTrajectories*)


(* --- Recursion for XC Derivatives --- *)
GWPInverseGaussianEngine::usage = "GWPInverseGaussianEngine[n, u] generates the nth-order polynomial factor for the Bohmian cumulative coordinate mappings by implementing an iterative chain-rule recurrence over the inverse error function.";


(* --- Bohmian-Type Trajectory Fields --- *)
GWPXC::usage = "GWPXC[c][param] evaluates the C-space x-trajectory field.\n" <> 
  "GWPXC[n][c][param] evaluates the nth derivative of the C-space x-trajectory field.";

GWPPC::usage = "GWPPC[c][param] evaluates the C-space p-trajectory field.\n" <> 
  "GWPPC[n][c][param] evaluates the nth derivative of the C-space p-trajectory field.";
  
(* --- C-Space Hydrodynamics Fields --- *)
GWPRHOC::usage = "GWPRHOC[c][param] evaluates the C-space probability density.";
GWPJC::usage   = "GWPJC[c][param] evaluates the C-space probability current density.";
GWPAC::usage   = "GWPAC[c][param] evaluates the C-space amplitude.";
GWPSC::usage   = "GWPSC[c][param] evaluates the C-space phase.";
GWPVC::usage   = "GWPVC[c][param] evaluates the C-space velocity field.";
GWPOVC::usage  = "GWPOVC[c][param] evaluates the C-space osmotic velocity.";
GWPQSC::usage  = "GWPQSC[c][param] evaluates the C-space quantum stress.";
GWPQPC::usage  = "GWPQPC[c][param] evaluates the C-space quantum potential.";
GWPQFC::usage  = "GWPQFC[c][param] evaluates the C-space quantum force.";

(* --- C-Space External Fields --- *)
GWPPEC::usage = "GWPPEC[c][param] evaluates the C-space external potential.\n" <>
  "GWPPEC[n][c][param] evaluates the nth derivative of the C-space external potential.";

GWPFEC::usage = "GWPFEC[c][param] evaluates the C-space external force.\n" <>
  "GWPFEC[n][c][param] evaluates the nth derivative of the C-space external force.";
  
(* --- C-Space Information and Energy Densities --- *)
GWPFIC::usage  = "GWPFIC[c][param] evaluates the C-space Fisher information density.";
GWPCKEC::usage = "GWPCKEC[c][param] evaluates the C-space convective kinetic energy density.";
GWPIKEC::usage = "GWPIKEC[c][param] evaluates the C-space internal kinetic energy density.";
GWPTKEC::usage = "GWPTKEC[c][param] evaluates the C-space total kinetic energy density.";
GWPTPEC::usage = "GWPTPEC[c][param] evaluates the C-space total potential energy density.";
GWPTEDC::usage = "GWPTEDC[c][param] evaluates the C-space total energy density.";


(* ::Subsection::Closed:: *)
(*Utilities*)


(* --- Core Utilities --- *)
SequenceSimplify::usage = "SequenceSimplify[expr1, expr2, ...] applies Simplify to a sequence of expressions and returns the simplified Sequence.\n" <>
  "Accepts all standard options of Simplify (e.g., Assumptions, TimeConstraint).";

GWPUsageTable::usage = "GWPUsageTable[{sym1, sym2, ...}] generates a formatted Dataset displaying the names and usage strings for a list of symbols.";


(* --- Testing & Diagnostics --- *)
GWPTestReport::usage = "GWPTestReport[\"key1\", \"key2\", ...] runs test files whose names contain the specified strings.\n" <>
  "GWPTestReport[\"All\"] runs the entire testing suite.\n" <>
  "GWPTestReport[] returns a list of all available test files.";

GWPFormatReport::usage = "GWPFormatReport[report] formats a TestReportObject into a Dataset.\n" <>
  "GWPFormatReport[report, \"ReportFormat\" -> format] specifies the output format (e.g., \"Summary\", \"Detailed\").";

GWPCacheVerificationSuite::usage = "GWPCacheVerificationSuite[] runs the entire test suite and saves the merged TestReportObjects to a binary .mx file.\n" <>
  "GWPCacheVerificationSuite[\"Load\"] instantly loads the cached reports into the global variable GWPVerificationTests.";

GWPDiagnosticBench::usage = "GWPDiagnosticBench[sys, {arg}, {opt}] evaluates the structural integrity of the package and returns an interactive Dataset.\n" <>
  "GWPDiagnosticBench[sys, {arg}, {opt}, maxN] evaluates the recursive and moment properties up to the maxnth order.";


(* ::Section::Closed:: *)
(*Private*)


Begin["`Private`"]

(* Capture Package Directory (from your original code) *)
$PackageDirectory = Quiet[
  If[$InputFileName =!= "", 
    DirectoryName[$InputFileName, 2], 
    NotebookDirectory[]
  ]
];


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


(* ::Section::Closed:: *)
(*Parameters*)


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
  
  (* Enforce strictly positive physical constants (Safely ignores symbols) *)
  If[TrueQ[h <= 0], Message[GWPPARAM::posval, "HBAR", h]; Return[$Failed]];
  If[TrueQ[m <= 0], Message[GWPPARAM::posval, "MASS", m]; Return[$Failed]];

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
  SequenceSimplify[PARAM, Assumptions -> GWPASSUMPTIONS@PARAM]
];


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


(* ::Section::Closed:: *)
(*Potential Models*)


(* --- Note on Phase Evolution & 'LCT' Terms --- *)
(* For non-free potentials, the exact time-dependent phase relies on the     *)
(* classical action. The 'LCT' (Lagrangian Classical Term) functions compute *)
(* the exact time-integral of the classical Lagrangian along the center of   *)
(* the wavepacket's trajectory: Integral[ L(x(t), v(t)), dt ].               *)


(* ::Subsection::Closed:: *)
(*GWP Time-Dependent Parameters*)


(* --- GWP Time-Dependent Parameters ---*)
GWPRATD[GWPARG]=4*HBAR/MASS*RA*IA;
GWPIATD[GWPARG]=-2*HBAR/MASS*(RA^2-IA^2)+V2/HBAR;
GWPRXTD[GWPARG]=RP/MASS;
GWPRPTD[GWPARG]=-(V1+2*V2*RX);
GWPRGTD[GWPARG]=RP^2/(2*MASS)-(V0+V1*RX+V2*RX^2)-HBAR^2/MASS*RA;
GWPIGTD[GWPARG]=-HBAR^2/MASS*IA


(* ::Subsection::Closed:: *)
(*Named Potential Models*)


(* --- Named Systems ---*)
FREE[t_][GWPARG]=LINEAR[0][t][GWPVAL];
HO[t_][GWPARG]=HARMONIC[1][t][GWPVAL];


(* ::Subsection::Closed:: *)
(*Linear Potential*)


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
SetAttributes[FFHORESFUN,Listable];
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


(*
(* --- Phase Space & Density Matrices --- *)
GWPDMX[x_, y_][GWPARG] = Sqrt[2*RA / Pi] * Exp[-(RA + I*IA)*(x - RX)^2 - (RA - I*IA)*(y - RX)^2 + (I*RP*(x - y))/HBAR];
GWPWIG[x_, p_][GWPARG] = 1/(Pi*HBAR) * Exp[-((2*(RA^2 + IA^2)*(x - RX)^2)/RA) - ((p - RP)^2)/(2*HBAR^2*RA) - (2*IA*(x - RX)*(p - RP))/(HBAR*RA)];
*)


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
GWPEX[n_Integer][GWPARG] := Moment[NormalDistribution[RX, Sqrt[1/(4*RA)]], n];
(* Fallback: Route GWPEX[...] to the 1st moment *)
GWPEX[param___] /; !MatchQ[{param}, {_Integer}] := GWPEX[1][param];


(* --- Momentum Expectation Values (Arbitrary Order) --- *)
GWPEP[n_Integer][GWPARG] := Moment[NormalDistribution[RP, HBAR * Sqrt[RA + (IA^2 / RA)]], n];
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


(* ::Section:: *)
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
  GWPEPE[n_Integer /; n >= 0][GWPARG] := Module[{coeffs, moments},
    coeffs = CoefficientList[(V0 + V1 * x + V2 * x^2)^n, x];
    moments = Table[GWPEX[i][VAL], {i, 0, 2 * n}];
    coeffs . moments
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
  GWPEKEPE[m_Integer /; m >= 0, n_Integer /; n >= 0][GWPARG] := Module[{coeffs, moments},
    
    (* Natively pad the coefficient list to length 2n + 1 *)
    coeffs = CoefficientList[(V0 + V1 * x + V2 * x^2)^n, {x}, {2 * n + 1}];
    
    moments = Table[GWPEPX[2 * m, k][VAL], {k, 0, 2 * n}];
    (coeffs . moments) / (2 * MASS)^m
  ];
];

With[{VAL = GWPVAL},
  GWPEPEKE[m_Integer /; m >= 0, n_Integer /; n >= 0][GWPARG] := Module[{coeffs, moments},
    
    (* Natively pad the coefficient list to length 2m + 1 *)
    coeffs = CoefficientList[(V0 + V1 * x + V2 * x^2)^m, {x}, {2 * m + 1}];
    
    moments = Table[GWPEXP[k, 2 * n][VAL], {k, 0, 2 * m}];
    (coeffs . moments) / (2 * MASS)^n
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


(* --- Hydrodynamic Expectation Values --- *)
GWPEIKE[GWPARG] = (HBAR^2*RA)/(2*MASS);
GWPECKE[GWPARG] = (HBAR^2*IA^2 + RA*RP^2)/(2*MASS*RA);
GWPEIPE[GWPARG] = (RA*V2)/(4*(IA^2 + RA^2));
GWPECPE[GWPARG] = (4*RA^3*(V0 + RX*(V1 + RX*V2)) + IA^2*(V2 + 4*RA*(V0 + RX*(V1 + RX*V2))))/(4*RA*(IA^2 + RA^2));


(* ::Section::Closed:: *)
(*HydrodynamicsX*)


(* --- Amplitude, Phase, and Mappings --- *)
GWPAX[x_][GWPARG] = (2/Pi*RA)^(1/4)*Exp[-RA*(x-RX)^2];
GWPSX[x_][GWPARG] = -HBAR*IA*(x-RX)^2 + RP*(x-RX) + RG;
GWPPX[x_][GWPARG] = RP - 2*HBAR*IA*(x-RX);


(* --- Flow and Currents --- *)
GWPVX[x_][GWPARG]  = (RP - 2*HBAR*IA*(x-RX))/MASS;
GWPOVX[x_][GWPARG] = (-2*HBAR*RA*(-RX + x))/MASS;
GWPJX[x_][GWPARG]  = (2/Pi*RA)^(1/2)*Exp[-2*RA*(x-RX)^2]*(RP - 2*HBAR*IA*(x-RX))/MASS;


(* --- Potentials, Forces, and Stresses --- *)
GWPQPX[x_][GWPARG] = HBAR^2/MASS*RA*(1 - 2*RA*(x-RX)^2);
GWPQFX[x_][GWPARG] = 4*HBAR^2/MASS*RA^2*(x-RX);
GWPQSX[x_][GWPARG] = -((HBAR^2*Sqrt[2/Pi]*RA^(3/2))/(E^(2*RA*(RX - x)^2)*MASS));


(* --- Energy Density Decompositions --- *)
GWPIKEX[x_][GWPARG] = (2*HBAR^2*Sqrt[2/Pi]*RA^(5/2)*(RX - x)^2)/(E^(2*RA*(RX - x)^2)*MASS);
GWPCKEX[x_][GWPARG] = (Sqrt[RA]*(RP - 2*HBAR*IA*(-RX + x))^2)/(E^(2*RA*(-RX + x)^2)*MASS*Sqrt[2*Pi]);
GWPTPEX[x_][GWPARG] = (Sqrt[2/Pi]*Sqrt[RA]*(V0 + x*(V1 + V2*x)))/E^(2*RA*(RX - x)^2);
GWPTKEX[x_][GWPARG] = (Sqrt[RA]*(RP^2 + 4*HBAR*IA*RP*(RX - x) + 4*HBAR^2*(IA^2 + RA^2)*(RX - x)^2))/(E^(2*RA*(RX - x)^2)*MASS*Sqrt[2*Pi]);
GWPTEDX[x_][GWPARG] = (Sqrt[RA]*(RP^2 + 4*HBAR*IA*RP*(RX - x) + 4*HBAR^2*(IA^2 + RA^2)*(RX - x)^2 + 2*MASS*(V0 + x*(V1 + V2*x))))/(E^(2*RA*(RX - x)^2)*MASS*Sqrt[2*Pi]);


(* --- Fisher Information Density --- *)
GWPFIX[x_][GWPARG]  = (16*Sqrt[2/Pi]*RA^(5/2)*(RX - x)^2)/E^(2*RA*(RX - x)^2);


(* ::Section::Closed:: *)
(*HydrodynamicsP*)


(* --- Amplitude, Phase, and Mappings --- *)
GWPAP[p_][GWPARG] = (RA^(1/4)*Exp[-(RA*(p - RP)^2)/(4*HBAR^2*(RA^2 + IA^2))])/((2*Pi)^(1/4)*Sqrt[HBAR]*(RA^2 + IA^2)^(1/4));
GWPSP[p_][GWPARG] = RG - p*RX + (IA*(p - RP)^2)/(4*HBAR*(RA^2 + IA^2)) - (HBAR/2)*ArcTan[RA, IA];
GWPXP[p_][GWPARG] = RX - (IA*(p - RP))/(2*HBAR*(IA^2 + RA^2));


(* --- Flow and Currents --- *)
GWPVP[p_][GWPARG]  = -V1 - 2*V2*(RX - (IA*(p - RP))/(2*HBAR*(IA^2 + RA^2)));
GWPOVP[p_][GWPARG] = -((RA*(p - RP)*V2)/(HBAR*(IA^2 + RA^2)));
GWPJP[p_][GWPARG]  = (-V1 + (IA*(p - RP)*V2)/(HBAR*(IA^2 + RA^2)) - 2*RX*V2)/(E^((RA*(p - RP)^2)/(2*HBAR^2*(IA^2 + RA^2)))*Sqrt[2*Pi]*Sqrt[(HBAR^2*(IA^2 + RA^2))/RA]);


(* --- Potentials, Forces, and Stresses --- *)
GWPQPP[p_][GWPARG] = (RA*(2*HBAR^2*(IA^2 + RA^2) - RA*(p - RP)^2)*V2)/(4*HBAR^2*(IA^2 + RA^2)^2);
GWPQFP[p_][GWPARG] = (RA^2*(p - RP)*V2)/(2*HBAR^2*(IA^2 + RA^2)^2);
GWPQSP[p_][GWPARG] = -1/2*(RA^(3/2)*V2)/(E^((RA*(p - RP)^2)/(2*HBAR^2*(IA^2 + RA^2)))*HBAR*Sqrt[2*Pi]*(IA^2 + RA^2)^(3/2));


(* --- Energy Density Decompositions --- *)
GWPIPEP[p_][GWPARG] = ((RA/(IA^2 + RA^2))^(5/2)*(p - RP)^2*V2)/(4*E^((RA*(p - RP)^2)/(2*HBAR^2*(IA^2 + RA^2)))*HBAR^3*Sqrt[2*Pi]);
GWPCPEP[p_][GWPARG] = (V0 + ((IA*(-p + RP))/(2*HBAR*(IA^2 + RA^2)) + RX)*V1 + ((IA*(-p + RP))/(2*HBAR*(IA^2 + RA^2)) + RX)^2*V2)/(E^((RA*(p - RP)^2)/(2*HBAR^2*(IA^2 + RA^2)))*Sqrt[2*Pi]*Sqrt[(HBAR^2*(IA^2 + RA^2))/RA]);
GWPTKEP[p_][GWPARG] = (E^((-2*IG)/HBAR - (RA*(p - RP)^2)/(2*HBAR^2*(IA^2 + RA^2)))*p^2*Sqrt[RA])/ (2*HBAR*MASS*Sqrt[2*Pi]*Sqrt[IA^2 + RA^2]);
GWPTPEP[p_][GWPARG] = (Sqrt[RA]*((p - RP)^2*V2 - 2*HBAR*IA*(p - RP)*(V1 + 2*RX*V2) + 4*HBAR^2*(IA^2 + RA^2)*(V0 + RX*(V1 + RX*V2))))/(4*E^((RA*(p - RP)^2)/(2*HBAR^2*(IA^2 + RA^2)))*HBAR^3*Sqrt[2*Pi]*(IA^2 + RA^2)^(3/2));
GWPTEDP[p_][GWPARG] = ((2*p^2*Sqrt[RA/(IA^2 + RA^2)])/(E^((2*IG)/HBAR)*HBAR*MASS) + (Sqrt[RA]*((p - RP)^2*V2 - 2*HBAR*IA*(p - RP)*(V1 + 2*RX*V2) + 4*HBAR^2*(IA^2 + RA^2)*(V0 + RX*(V1 + RX*V2))))/(HBAR^3*(IA^2 + RA^2)^(3/2)))/(4*E^((RA*(p - RP)^2)/(2*HBAR^2*(IA^2 + RA^2)))*Sqrt[2*Pi]);


(* --- Fisher Information Density --- *)
GWPFIP[p_][GWPARG]  = ((RA/(IA^2 + RA^2))^(5/2)*(p - RP)^2)/(E^((RA*(p - RP)^2)/(2*HBAR^2*(IA^2 + RA^2)))*HBAR^5*Sqrt[2*Pi]);


(* ::Section::Closed:: *)
(*BohmianTrajectories*)


(* --- Private Worker Function for Inverse-Erf Trajectory Recursion --- *)
(* Implements the chain-rule recurrence for derivatives of the inverse  *)
(* error function mapping. Generates the polynomial factor iteratively. *)
GWPInverseGaussianEngine[n_Integer, u_] := Module[{pPrev, pCurr},
  pPrev = 1; 
  pCurr = pPrev;
  Do[
    pCurr = Expand[D[pPrev, u] + 2*(i - 1)*u*pPrev];
    pPrev = pCurr,
    {i, 2, n}
  ];
  pCurr
];


(* --- Position Manifold (Inverse Cumulative Mappings) --- *)
GWPXC[0][c_][GWPARG] := RX + (1 / Sqrt[2*RA]) * InverseErf[2*c - 1];

GWPXC[n_Integer /; n > 0][c_][GWPARG] := Module[{u, dudz, poly},
  u = InverseErf[2*c - 1];
  dudz = (Sqrt[Pi]/2) * Exp[u^2];
  (* Generate the Inverse-Gaussian polynomial *)
  poly = GWPInverseGaussianEngine[n, u]; 
  poly * (2^n / Sqrt[2*RA]) * (dudz^n)
];
(* Fallback: Route GWPXC[c][...] to the 0th derivative *)
GWPXC[c_][arg___] /; !MatchQ[Unevaluated[GWPXC[c]], GWPXC[_Integer]] := GWPXC[0][c][arg];


(* --- Momentum Manifold (Inverse Cumulative Mappings) --- *)
GWPPC[0][c_][GWPARG] := RP + HBAR * Sqrt[2] * Sqrt[IA^2/RA + RA] * InverseErf[2*c - 1];

GWPPC[n_Integer /; n > 0][c_][GWPARG] := Module[{u, dudz, coeffP, poly},
  u = InverseErf[2*c - 1];
  dudz = (Sqrt[Pi]/2) * Exp[u^2];
  coeffP = HBAR * Sqrt[2] * Sqrt[IA^2/RA + RA];
  (* Generate the Inverse-Gaussian polynomial *)
  poly = GWPInverseGaussianEngine[n, u];
  poly * (2^n * coeffP) * (dudz^n)
];
(* Fallback: Route GWPPC[c][...] to the 0th derivative *)
GWPPC[c_][arg___] /; !MatchQ[Unevaluated[GWPPC[c]], GWPPC[_Integer]] := GWPPC[0][c][arg];


(* --- C-Space Hydrodynamic Fields --- *)
GWPRHOC[c_][GWPARG] = Sqrt[2*RA/Pi] * Exp[-InverseErf[2*c - 1]^2];
GWPJC[c_][GWPARG]   = Sqrt[2*RA/Pi] * Exp[-InverseErf[2*c - 1]^2] * (RP - (2*HBAR*IA / Sqrt[2*RA]) * InverseErf[2*c - 1]) / MASS;
GWPAC[c_][GWPARG] = ((2/Pi)^(1/4)*RA^(1/4))/E^(InverseErf[-1 + 2*c]^2/2);
GWPSC[c_][GWPARG] = RG + (RP*InverseErf[-1 + 2*c])/(Sqrt[2]*Sqrt[RA]) - (HBAR*IA*InverseErf[-1 + 2*c]^2)/(2*RA);
GWPVC[c_][GWPARG]   = (RP - (2*HBAR*IA / Sqrt[2*RA]) * InverseErf[2*c - 1]) / MASS;
GWPOVC[c_][GWPARG] = -((Sqrt[2]*HBAR*Sqrt[RA]*InverseErf[-1 + 2*c])/MASS);
GWPQSC[c_][GWPARG] = -((HBAR^2*Sqrt[2/Pi]*RA^(3/2))/(E^InverseErf[-1 + 2*c]^2*MASS));
GWPQPC[c_][GWPARG]  = (RA*HBAR^2 * (1 - InverseErf[2*c - 1]^2)) / MASS;
GWPQFC[c_][GWPARG]  = ((2*RA)^(3/2) * HBAR^2 * InverseErf[2*c - 1]) / MASS;


(* --- External Potential in C-Space (Chain Rule: d^n/dc^n) --- *)
GWPPEC[0][c_][GWPARG] = GWPPEX[0][GWPXC[0][c][GWPVAL]][GWPVAL];

With[{VAL = GWPVAL},
  GWPPEC[n_Integer /; n > 0][c_][GWPARG] := Module[{xDerivs, x2Deriv},
    (* Generate a list of x(c) derivatives from k=0 to n *)
    xDerivs = Table[GWPXC[k][c][VAL], {k, 0, n}];  
    (* Apply the Leibniz rule for the x(c)^2 term *)
    x2Deriv = Sum[Binomial[n, k] * xDerivs[[k + 1]] * xDerivs[[n - k + 1]], {k, 0, n}];   
    (* Reconstruct the nth derivative of the potential *)
    {V0, V1, V2} . {0, xDerivs[[n + 1]], x2Deriv}
  ]
];

(* Fallback: Route GWPPEC[c][...] to the 0th derivative *)
GWPPEC[c_][arg___] /; !MatchQ[Unevaluated[GWPPEC[c]], GWPPEC[_Integer]] := GWPPEC[0][c][arg];


(* --- External Force in C-Space (Chain Rule: d^n/dc^n) --- *)
GWPFEC[0][c_][GWPARG] = GWPFEX[0][GWPXC[0][c][GWPVAL]][GWPVAL];

With[{VAL = GWPVAL},
  GWPFEC[n_Integer /; n > 0][c_][GWPARG] := {V0, V1, V2} . {0, 0, -2 * GWPXC[n][c][VAL]}
];

(* Fallback: Route GWPFEC[c][...] to the 0th derivative *)
GWPFEC[c_][arg___] /; !MatchQ[Unevaluated[GWPFEC[c]], GWPFEC[_Integer]] := GWPFEC[0][c][arg];


(* --- Information and Energy Densities --- *)
GWPFIC[c_][GWPARG] = (8*Sqrt[2/Pi]*RA^(3/2)*InverseErf[-1 + 2*c]^2)/E^InverseErf[-1 + 2*c]^2;
GWPCKEC[c_][GWPARG] = (Sqrt[RA]*(RP - (Sqrt[2]*HBAR*IA*InverseErf[-1 + 2*c])/Sqrt[RA])^2)/(E^InverseErf[-1 + 2*c]^2*MASS*Sqrt[2*Pi]);
GWPIKEC[c_][GWPARG] = (HBAR^2*Sqrt[2/Pi]*RA^(3/2)*InverseErf[-1 + 2*c]^2)/(E^InverseErf[-1 + 2*c]^2*MASS);
GWPTKEC[c_][GWPARG] = (RA*RP^2 - 2*Sqrt[2]*HBAR*IA*Sqrt[RA]*RP*InverseErf[-1 + 2*c] + 2*HBAR^2*(IA^2 + RA^2)*InverseErf[-1 + 2*c]^2)/(E^InverseErf[-1 + 2*c]^2*MASS*Sqrt[2*Pi]*Sqrt[RA]);
GWPTPEC[c_][GWPARG] = (2*RA*(V0 + RX*(V1 + RX*V2)) + Sqrt[2]*Sqrt[RA]*(V1 + 2*RX*V2)*InverseErf[-1 + 2*c] + V2*InverseErf[-1 + 2*c]^2)/(E^InverseErf[-1 + 2*c]^2*Sqrt[2*Pi]*Sqrt[RA]);
GWPTEDC[c_][GWPARG] = (RA*(RP^2 + 2*MASS*(V0 + RX*(V1 + RX*V2))) + Sqrt[2]*Sqrt[RA]*(-2*HBAR*IA*RP + MASS*(V1 + 2*RX*V2))*InverseErf[-1 + 2*c] + (2*HBAR^2*(IA^2 + RA^2) + MASS*V2)*InverseErf[-1 + 2*c]^2)/(E^InverseErf[-1 + 2*c]^2*MASS*Sqrt[2*Pi]*Sqrt[RA]);


(* ::Section::Closed:: *)
(*Utilities*)


(* ::Subsection::Closed:: *)
(* SequenceSimplify*)


(* --- Dynamically catches trailing options and passes them to Simplify --- *)
SequenceSimplify[args___, opts : OptionsPattern[Simplify]] := Sequence @@ Simplify[{args}, opts];


(* ::Subsection::Closed:: *)
(*GWPUsageTable*)


(* --- Usage Table Utility --- *)
Options[GWPUsageTable] = Options[Grid];

GWPUsageTable[symbs_List, opts : OptionsPattern[]] := 
  Module[{gridOpts, header, rows, maxDescWidth = 425}, 
   gridOpts = FilterRules[{opts}, Options[Grid]];
   header = {Text[Style["Signature", Bold, 14]], 
     Text[Style["Description", Bold, 14]]};
   rows = 
    Flatten[Map[
      Function[sym, 
       Module[{rawUsage, symName, match}, 
        rawUsage = Quiet[Information[sym, "Usage"]];
        symName = ToString[sym];
        If[StringQ[rawUsage], 
         Map[Function[line, 
           match = StringCases[line, 
             RegularExpression[
               "^(" <> symName <> "(?:\\[.*?\\])?)\\s+(.*)$"] -> {"$1", 
               "$2"}];
           
           If[Length[match] > 0,
            (* Found a match *)
            {Text[match[[1, 1]]], 
             Pane[Text[
               Style[StringReplace[StringTrim[match[[1, 2]]], 
                 StartOfString ~~ c_ :> ToUpperCase[c]], 
                TextAlignment -> Left, LineIndent -> 0]], 
              ImageSize -> {UpTo[maxDescWidth], Automatic}]}, 
            
            (* No match (continuation line) *)
            {Text[""], 
             Pane[Text[
               Style[StringReplace[StringTrim[line], 
                 StartOfString ~~ c_ :> ToUpperCase[c]], 
                TextAlignment -> Left, LineIndent -> 0]], 
              ImageSize -> {UpTo[maxDescWidth], Automatic}]}]], 
          StringSplit[rawUsage, "\n"]], 
         
         (* No usage string found *)
         {{Text[symName], 
           Text[Style["No usage string defined.", Gray, Italic]]}}]]],
       symbs], 1];
       
   Grid[Prepend[rows, header], Alignment -> {Left, Top}, 
    (* Let both columns size automatically to their contents *)
    ItemSize -> Automatic, Spacings -> {2, 1.5}, 
    Frame -> True, Dividers -> All, 
    Background -> {None, {1 -> GrayLevel[0.95]}}, 
    Sequence @@ gridOpts]];


(* ::Subsection::Closed:: *)
(*GWPCacheVerificationSuite*)


(* --- Cache Verification Suite --- *)
GWPCacheVerificationSuite["Load"] := Module[{cacheFile},
  cacheFile = FileNameJoin[{$PackageDirectory, "Tests", "GWPVerificationCache.mx"}];
  
  If[FileExistsQ[cacheFile],
    Global`GWPVerificationTests = Import[cacheFile];
    Print["Successfully loaded cached verification suite into global variable GWPVerificationTests."],
    Print["Cache file not found. Run GWPCacheVerificationSuite[] to generate it."]
  ];
];

GWPCacheVerificationSuite[] := Module[{availableTests, cacheFile, reports},
  Print["Clearing system cache and preparing tests..."];
  ClearSystemCache[];
  
  availableTests = GWPTestReport[];
  cacheFile = FileNameJoin[{$PackageDirectory, "Tests", "GWPVerificationCache.mx"}];
  
  Print["Executing full verification suite. This will take a few minutes..."];
  
  reports = AssociationMap[
    GWPTestReport[#, "MergeReports" -> True] &, 
    availableTests
  ];
  
  Export[cacheFile, reports];
  
  (* Automatically load it into the global namespace for immediate use *)
  Global`GWPVerificationTests = reports;
  
  Print["Caching complete. Results saved to: ", cacheFile];
];


(* ::Subsection::Closed:: *)
(*GWPTestReport*)


(* --- Test Runner Utility (Private Implementation) --- *)
Options[GWPTestReport] = Join[
  {
    "GWPTestDirectory" -> Automatic,
    "MergeReports" -> True (* True natively merges all results into a single TestReportObject *)
  },
  Options[TestReport]
];

GWPTestReport::nodir = "Test directory not found at `1`.";
GWPTestReport::nokeys = "No test files matched the keys: `1`.";

GWPTestReport[keys___String, opts:OptionsPattern[]] := Module[
  {testDir, allFiles, targetFiles, keyList, availableKeys, testOpts, merge},
  
  keyList = {keys};
  
  (* 1. Extract options *)
  testOpts = FilterRules[{opts}, Options[TestReport]];
  merge = OptionValue["MergeReports"];
  
  (* 2. Resolve the test directory *)
  testDir = Replace[
    OptionValue["GWPTestDirectory"], 
    Automatic :> FileNameJoin[{$PackageDirectory, "Tests"}]
  ];
  
  If[!DirectoryQ[testDir],
    Message[GWPTestReport::nodir, testDir];
    Return[$Failed];
  ];

  (* 3. Find all .wl test files and extract base names *)
  allFiles = FileNames["*.wl", testDir];
  availableKeys = FileBaseName /@ allFiles;
  
  (* 4. BEHAVIOR: No Keys Provided -> Return a list of available tests *)
  If[Length[keyList] === 0,
    Return[availableKeys];
  ];
  
  (* 5. BEHAVIOR: Keys Provided -> Filter files *)
  targetFiles = If[MemberQ[ToLowerCase /@ keyList, "all"],
    allFiles, 
    Select[allFiles, 
      Function[file, AnyTrue[keyList, StringContainsQ[FileNameTake[file], #, IgnoreCase -> True] &]]
    ]
  ];
  
  (* 6. Catch invalid keys *)
  If[Length[targetFiles] === 0,
    Message[GWPTestReport::nokeys, keyList];
    Return[Missing["NotAvailable"]];
  ];

  (* 7. Execute tests and return raw TestReportObject(s) *)
  If[TrueQ[merge],
    TestReport[targetFiles, Sequence @@ testOpts],
    Map[TestReport[#, Sequence @@ testOpts] &, targetFiles]
  ]
];


(* ::Subsection::Closed:: *)
(*GWPFormatReport*)


(* --- Test Report Formatting Utility --- *)
Options[GWPFormatReport] = Join[
  {
    "ReportFormat" -> "Summary"
  },
  Options[Dataset]
];

(* Overload 1: Handles a SINGLE TestReportObject *)
GWPFormatReport[report_TestReportObject, opts:OptionsPattern[]] := Module[{format, datasetOpts},
  
  format = OptionValue["ReportFormat"];
  
  (* Filter out only the options that belong to Dataset *)
  datasetOpts = FilterRules[{opts}, Options[Dataset]];
  
  (* Check if the user provided a custom list of properties *)
  If[ListQ[format],
    Return[
      Dataset[
        Association @ MapIndexed[First[#2] -> #[format] &, report["Results"]], 
        Sequence @@ datasetOpts
      ]
    ]
  ];
  
  (* Otherwise, use the predefined string formats *)
  Switch[format,
    "Summary",
    Dataset[
      report[{"Title", "CPUTimeUsed", "RuntimeFailures", "ReportSucceeded"}], 
      Sequence @@ datasetOpts
    ],
    
    "Detailed",
    Dataset[
      Association @ MapIndexed[
        First[#2] -> #[{"TestID", "CPUTimeUsed", "Outcome", "Input", "MetaInformation"}] &, 
        report["Results"]
      ], 
      Sequence @@ datasetOpts
    ],
    
    (* Fallback *)
    _,
    report
  ]
];

(* Overload 2: Handles a LIST of TestReportObjects (if MergeReports -> False was used) *)
GWPFormatReport[reports:{__TestReportObject}, opts:OptionsPattern[]] := 
  Map[GWPFormatReport[#, opts] &, reports];


(* ::Subsection::Closed:: *)
(*GWPDiagnosticBench*)


(* --- Interactive Diagnostic Bench --- *)
Options[GWPDiagnosticBench] = {"ShowOutput" -> False};

GWPDiagnosticBench[sys_, argList_List, optList_List, maxN_: 2, OptionsPattern[]] := Module[
  {OBJ, reg, results, showOut},
  
  showOut = OptionValue["ShowOutput"];
  
  (* Safely unpack the lists back into pure Sequences for internal use *)
  With[{arg = Sequence @@ argList, opt = Sequence @@ optList},
  
    (* 1. Initialize the Object and Registry *)
    OBJ = GWP[arg, opt, "Potential" -> sys];
    reg = GWPTools`Private`$GWPRegistry;
    
    (* 2. Iterate over the Registry *)
    results = Flatten @ Map[
      Function[{row},
        Module[{short, type, head, buildRow},
          short = row[[2]];
          type  = row[[3]];
          head  = ToExpression["GWP" <> short];
          
          (* Helper function to evaluate and build a single row *)
          buildRow[n_] := Module[{ed, status, msgText, lhs, rhs, isMatch},
            
            (* Use EvaluationData to sandbox the generation and comparison *)
            ed = EvaluationData[
              Switch[type,
                "Static", 
                rhs = head[GWPPARAM[arg, opt]];
                lhs = OBJ[short],
                
                "Temporal", 
                rhs = head[sys[Global`t][GWPPARAM[arg, opt]]];
                lhs = OBJ[short][Global`t],
                
                "Field", 
                rhs = head[Global`var][sys[Global`t][GWPPARAM[arg, opt]]];
                lhs = OBJ[short][Global`var, Global`t],
                
                "Bivariate", 
                rhs = head[Global`var1, Global`var2][sys[Global`t][GWPPARAM[arg, opt]]];
                lhs = OBJ[short][Global`var1, Global`var2, Global`t],
                
                "Moment", 
                rhs = head[n][sys[Global`t][GWPPARAM[arg, opt]]];
                lhs = OBJ[short, n][Global`t],
                
                "Recursive", 
                rhs = head[n][Global`var][sys[Global`t][GWPPARAM[arg, opt]]];
                lhs = OBJ[short, n][Global`var, Global`t],
                
                _, 
                rhs = Null;
                lhs = False
              ];
              
              lhs === rhs
            ];
            
            (* Parse the sandbox data *)
            msgText = StringJoin[Riffle[ed["MessagesText"], " | "]];
            isMatch = ed["Result"] === True;
            
            status = Which[
              isMatch && Length[ed["Messages"]] == 0, Style["Pass", Darker@Green, Bold],
              isMatch && Length[ed["Messages"]] > 0, Style["Pass (Msg)", Darker@Orange, Bold],
              True, Style["Fail", Darker@Red, Bold]
            ];
            
            (* Construct the Association for this specific order/property *)
            <|
              "Property" -> short,
              "Order"    -> If[n === None, "-", n],
              "Type"     -> type,
              "Status"   -> status,
              "Time (ms)"-> Round[1000 * ed["Timing"], 0.1],
              "Messages" -> If[msgText == "", "-", msgText],
              "Output"   -> If[showOut, Short[rhs, 3], Null]
            |>
          ];
          
          (* 3. Unroll Moments and Recursives into individual rows *)
          If[MemberQ[{"Moment", "Recursive"}, type],
            Table[buildRow[n], {n, 0, maxN}],
            {buildRow[None]}
          ]
        ]
      ],
      reg
    ];
    
    (* 4. Render the dataset, conditionally dropping the Output column if not requested *)
    Dataset[If[showOut, results, KeyDrop[results, "Output"]]]
  ]
];


(* ::Section::Closed:: *)
(*End*)


End[]


(* Hide internal code for all Developer functions from the ? menu *)
SetAttributes[Evaluate[Names["GWPTools`GWPDeveloper`*"]], {ReadProtected}];


EndPackage[]

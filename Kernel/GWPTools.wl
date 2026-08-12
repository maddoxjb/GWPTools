(* ::Package:: *)

(* ::Title:: *)
(*GWPTools*)


(* ::Section::Closed:: *)
(*About*)


(* --- PACKAGE: GWPTools (Core) --- *)
(* VERSION: 1.0.0                                                            *)
(* DESCRIPTION: Analytical framework for single Gaussian Wavepackets (GWPs). *)
(* Features dual-basis hydrodynamics (Madelung), energy density partitioning,*)
(* and exact Bohmian trajectories.     *)


(* --- Mathematical Conventions --- *)
(* 1. Fourier Transform: p-space is defined with the phase Exp[-I p x / HBAR]*)
(* 2. Wavefunction: Psi(x) = R(x) Exp[I S(x) / HBAR]                         *)
(* 3. Phase Sign: Time evolution follows Exp[-I E t / HBAR]                  *)
(* 4. Normalization: All densities integrate to 1 over the interval (-inf, inf)*)
(* 5. Parameter Bus: All functions internally rely on the exact 11-element sequence: *)
(* {RA, IA, RX, RP, RG, IG, NORM, HBAR, MASS, {V0, V1, V2}, INIT}         *)


(* --- Namespace & Naming Legend --- *)
(* MANIFOLD SUFFIXES:                                                        *)
(* X : Position space manifold (e.g., PSIX, RHOX)                            *)
(* P : Momentum space manifold (e.g., PSIP, RHOP)                            *)
(* C : Cumulative/Probability coordinate space (e.g., XC, PC, RHOC)          *)
(* E : Energy space manifold (e.g., RHOE, CE)                                *)
(* *)
(* PROPERTY PREFIXES & INFIXES:                                              *)
(* E : Expectation values (e.g., EKE1, EPE1)                                 *)
(* D : Spatial density decompositions (e.g., TEDX, CKEX)                     *)
(* *)
(* FLOW & MAPPINGS:                                                          *)
(* V : Denotes velocity/flow fields (e.g., VX = dx/dt, VP = dp/dt).          *)
(* Double suffixes denote cross-mappings (e.g., PPX = p(x), XPP = x(p)).     *)


(* ::Section::Closed:: *)
(*BeginPackage*)


BeginPackage["GWPTools`"]


(* Clears everything in the GWP public context *)
ClearAll[Evaluate[Context[] <> "*"]];


(* ::Section:: *)
(*Usage Declarations*)


(* ::Subsection::Closed:: *)
(*GWP Parameters*)


(* --- GWP Parameter Generation --- *)
GWPPARAM::usage = "GWPPARAM[] returns default GWP parameters.\n" <>
  "GWPPARAM[alpha] returns parameters with shape alpha.\n" <>
  "GWPPARAM[alpha, x] returns parameters with shape alpha and position center x.\n" <>
  "GWPPARAM[alpha, x, p] returns parameters with shape alpha, position center x, and momentum center p.\n" <>
  "GWPPARAM[alpha, x, p, gamma] returns a Sequence of GWP parameters.";


(* --- GWP Parameter Extraction --- *)
GWPRA::usage = "GWPRA[param] extracts the real part of the shape parameter (RA).";
GWPIA::usage = "GWPIA[param] extracts the imaginary part of the shape parameter (IA).";
GWPRX::usage = "GWPRX[param] extracts the position center (RX).";
GWPRP::usage = "GWPRP[param] extracts the momentum center (RP).";
GWPRG::usage = "GWPRG[param] extracts the real part of the phase parameter (RG).";
GWPIG::usage = "GWPIG[param] extracts the imaginary part of the phase parameter (IG).";
GWPNORM::usage = "GWPNORM[param] extracts the normalization constant.";
GWPMASS::usage = "GWPMASS[param] extracts the mass (MASS).";
GWPHBAR::usage = "GWPHBAR[param] extracts the reduced Planck constant (HBAR).";
GWPPECOEFF::usage = "GWPPECOEFF[param] extracts the external potential coefficients {V0, V1, V2}.";
GWPINIT::usage = "GWPINIT[param] extracts the raw initial input parameters.";


(* --- GWP Parameter Simplify and Integrate Assumptions ---*)
GWPASSUMPTIONS::usage = "GWPASSUMPTIONS[param] generates base real-domain assumptions for the parameters.\n" <>
  "GWPASSUMPTIONS[param, opts] includes domain constraints for variables like \"Position\" -> x.";


(* --- GWP Parameter Parsers --- *)
GWP486::usage = "GWP486 is the internal engine used by GWPPARAM to convert single-primed complex parameters into the double-primed real-parameter model.";

GWPSHAPE::usage = "GWPSHAPE[A1, HBAR, MASS] parses the user-provided wavepacket shape parameter A1 and translates it into the foundational real and imaginary width components {RA, IA}.\n" <>
  "A1 accepts multiple formats: a raw complex scalar (RA + I*IA), a list containing spatial uncertainty and position-momentum covariance ({UX, COVXP}), or a list containing position-momentum uncertainties alongside a chirp direction sign ({UX, UP, chirpSign}).";

GWPMOMENTUM::usage = "GWPMOMENTUM[P1, MASS] parses the user-provided momentum parameter P1 and translates it into the foundational real and imaginary momentum components {RP1, IP1}.\n" <>
  "P1 accepts multiple formats: a raw complex scalar (RP + I*IP), or a list specifying an initial kinetic energy alongside a directional sign ({\"KineticEnergy\", Energy, Sign}).";

GWPPHASE::usage = "GWPPHASE[G1, HBAR, RA, RX, RP] parses the user-provided global phase parameter G1 and translates it into the real and imaginary phase components {RG, IG}.\n" <>
  "G1 accepts multiple formats: a raw complex scalar (RG + I*IG), a semiclassical initial action ({\"Action\", S, mu}), a phase-space displacement ({\"Displacement\", X0, P0}), a complex superposition coefficient ({\"Coefficient\", PhaseAngle, AmplitudeWeight}), or an energy eigenstate time evolution ({\"Evolution\", Energy, Time}).";


(* ::Subsection::Closed:: *)
(*GWP Systems*)


(* --- GWP Parameter Time Derivatives --- *)
GWPRXTD::usage = "GWPRXTD[GWPARG] computes the analytical time derivative of the position center RX.";
GWPRPTD::usage = "GWPRPTD[GWPARG] computes the analytical time derivative of the momentum center RP.";
GWPRATD::usage = "GWPRATD[GWPARG] computes the analytical time derivative of the wavepacket width parameter RA.";
GWPIATD::usage = "GWPIATD[GWPARG] computes the analytical time derivative of the wavepacket chirp parameter IA.";
GWPRGTD::usage = "GWPRGTD[GWPARG] computes the analytical time derivative of the real global phase parameter RG.";
GWPIGTD::usage = "GWPIGTD[GWPARG] computes the analytical time derivative of the imaginary global phase parameter IG.";


(* --- GWP Named Systems Functions --- *) 
FREE::usage = "FREE[t][param] evaluates the time-evolved GWP parameter sequence for a free particle at time t.";
HO::usage = "HO[t][param] evaluates the time-evolved GWP parameter sequence at time t for a standard harmonic oscillator.";


(* --- GWP Systems Functions --- *) 
LINEAR::usage = "LINEAR[k][t][param] evaluates the time-evolved GWP parameter sequence at time t for a linear potential with force constant k.";
HARMONIC::usage = "HARMONIC[omega][t][param] evaluates the time-evolved GWP parameter sequence at time t for a harmonic oscillator with natural frequency omega.";
PARABOLIC::usage = "PARABOLIC[omega][t][param] evaluates the time-evolved GWP parameter sequence at time t for a parabolic barrier with characteristic frequency omega.";
FHOLIN::usage = "FHOLIN[omega, A][t][param] evaluates the time-evolved GWP parameter sequence at time t for a harmonic oscillator driven by a linear force with slope A.";
FHORES::usage = "FHORES[omega, A][t][param] evaluates the time-evolved GWP parameter sequence at time t for a harmonic oscillator driven by a resonant sinusoidal force with amplitude A.";
FHONON::usage = "FHONON[omega, A, omega1][t][param] evaluates the time-evolved GWP parameter sequence at time t for a harmonic oscillator driven by a non-resonant sinusoidal force with amplitude A and frequency omega1.";


(* --- GWP Potential Energy and Force Functions --- *)
GWPPEX::usage = "GWPPEX[x][param] evaluates the external potential energy function at position x for the given GWP parameters.\n" <>
  "GWPPEX[n][x][param] evaluates the n-th spatial derivative of the external potential.";

GWPFEX::usage = "GWPFEX[x][param] evaluates the external force at position x for the given GWP parameters.\n" <>
  "GWPFEX[n][x][param] evaluates the n-th spatial derivative of the external force.";


(* ::Subsection::Closed:: *)
(*GWP Wavefunctions*)


(* --- Position-Space Wavefunctions ---*)
GWPPSIX::usage = "GWPPSIX[x][param] evaluates the position-space wavefunction.\n" <>
  "GWPPSIX[x, n][param] evaluates the n-th spatial derivative of the position-space wavefunction.";

GWPCSIX::usage = "GWPCSIX[x][param] evaluates the complex conjugate position-space wavefunction.\n" <>
  "GWPCSIX[x, n][param] evaluates the n-th spatial derivative of the complex conjugate position-space wavefunction.";

GWPRSIX::usage = "GWPRSIX[x][param] evaluates the real part of the position-space wavefunction.";
GWPISIX::usage = "GWPISIX[x][param] evaluates the imaginary part of the position-space wavefunction.";


(* --- Momentum-Space Wavefunctions ---*)
GWPPSIP::usage = "GWPPSIP[p][param] evaluates the momentum-space wavefunction.\n" <>
  "GWPPSIP[p, n][param] evaluates the n-th derivative of the momentum-space wavefunction with respect to momentum p.";

GWPCSIP::usage = "GWPCSIP[p][param] evaluates the complex conjugate momentum-space wavefunction.\n" <>
  "GWPCSIP[p, n][param] evaluates the n-th derivative of the complex conjugate momentum-space wavefunction.";

GWPRSIP::usage = "GWPRSIP[p][param] evaluates the real part of the momentum-space wavefunction.";
GWPISIP::usage = "GWPISIP[p][param] evaluates the imaginary part of the momentum-space wavefunction.";


(* ::Subsection::Closed:: *)
(*GWP Densities*)


(* --- Densities --- *)
GWPRHOX::usage = "GWPRHOX[x][param] evaluates the position-space probability density.\n" <>
  "GWPRHOX[x, n][param] evaluates the n-th spatial derivative of the position-space probability density.";

GWPRHOP::usage = "GWPRHOP[p][param] evaluates the momentum-space probability density.\n" <>
  "GWPRHOP[p, n][param] evaluates the n-th derivative of the momentum-space probability density with respect to momentum p.";

GWPRHOE::usage = "GWPRHOE[e][param] evaluates the energy probability density.";

(* --- Phase Space & Density Matrices --- *)
GWPDMX::usage = "GWPDMX[x, y][param] evaluates the spatial density matrix in the position representation.";
GWPWIG::usage = "GWPWIG[x, p][param] evaluates the Wigner quasi-probability phase-space distribution.";


(* ::Subsection::Closed:: *)
(*GWP CDFs*)


(* --- Cumulative Distribution Functions *)
GWPCX::usage = "GWPCX[x][param] evaluates the cumulative distribution function of the GWP position density.";
GWPCP::usage = "GWPCP[p][param] evaluates the cumulative distribution function of the GWP momentum density.";
GWPCE::usage = "GWPCE[e][param] evaluates the cumulative distribution function of the GWP energy density.";


(* --- Probabilities ---*)
GWPPROBX::usage = "GWPPROBX[xmin, xmax][param] calculates the total probability of finding the particle within the position range [xmin, xmax].";
GWPPROBP::usage = "GWPPROBP[pmin, pmax][param] calculates the total probability of finding the particle within the momentum range [pmin, pmax].";
GWPPROBE::usage = "GWPPROBE[emin, emax][param] calculates the total probability of finding the particle within the energy range [emin, emax].";


(* ::Subsection::Closed:: *)
(*GWP Expectation Values*)


(* --- Position Expectation Values --- *)
GWPEX::usage = "GWPEX[param] evaluates the position expectation value for the given GWP parameters.\n" <>
  "GWPEX[n][param] evaluates the n-th position moment for the given GWP parameters.";
GWPEX1::usage = "GWPEX1[param] evaluates the position expectation value.";
GWPEX2::usage = "GWPEX2[param] evaluates the second position moment.";
GWPEX3::usage = "GWPEX3[param] evaluates the third position moment.";
GWPEX4::usage = "GWPEX4[param] evaluates the fourth position moment.";
GWPUX::usage = "GWPUX[param] evaluates the position uncertainty.";


(* --- Momentum Expectation Values --- *)
GWPEP::usage = "GWPEP[param] evaluates the momentum expectation value for the given GWP parameters.\n" <>
  "GWPEP[n][param] evaluates the n-th momentum moment for the given GWP parameters.";
GWPEP1::usage = "GWPEP1[param] evaluates the momentum expectation value.";
GWPEP2::usage = "GWPEP2[param] evaluates the second momentum moment.";
GWPEP3::usage = "GWPEP3[param] evaluates the third momentum moment.";
GWPEP4::usage = "GWPEP4[param] evaluates the fourth momentum moment.";
GWPUP::usage = "GWPUP[param] evaluates the momentum uncertainty.";


(* --- Position-Momentum Cross-Correlations --- *)
GWPEXP::usage = "GWPEXP[param] evaluates the expectation value of the position-momentum product operator.";
GWPEPX::usage = "GWPEPX[param] evaluates the expectation value of the momentum-position product operator.";
GWPCOVXP::usage = "GWPCOVXP[param] evaluates the position-momentum covariance.";
GWPCORXP::usage = "GWPCORXP[param] evaluates the position-momentum correlation.";


(* --- Kinetic Energy Expectation Values --- *)
GWPEKE1::usage = "GWPEKE1[param] evaluates the kinetic energy expectation value.";
GWPEKE2::usage = "GWPEKE2[param] evaluates the expectation value of the kinetic energy squared.";
GWPUKE::usage = "GWPUKE[param] evaluates the kinetic energy uncertainty.";


(* --- Potential Energy Expectation Values --- *)
GWPEPE1::usage = "GWPEPE1[param] evaluates the potential energy expectation value.";
GWPEPE2::usage = "GWPEPE2[param] evaluates the expectation value of the potential energy squared.";
GWPUPE::usage = "GWPUPE[param] evaluates the potential energy uncertainty.";


(* --- Force Expectation Values --- *)
GWPEF1::usage = "GWPEF1[param] evaluates the force expectation value.";
GWPEF2::usage = "GWPEF2[param] evaluates the expectation value of the force squared.";
GWPUF::usage = "GWPUF[param] evaluates the force uncertainty.";


(* --- Kinetic-Potential Energy Cross-Correlations --- *)
GWPEKEPE::usage = "GWPEKEPE[param] evaluates the kinetic-potential energy product expectation value.";
GWPEPEKE::usage = "GWPEPEKE[param] evaluates the potential-kinetic energy product expectation value.";
GWPCOVKEPE::usage = "GWPCOVKEPE[param] evaluates the kinetic-potential energy covariance.";
GWPCORKEPE::usage = "GWPCORKEPE[param] evaluates the kinetic-potential energy correlation.";


(* --- Total Energy Expectation Values --- *)
GWPETE1::usage = "GWPETE1[param] evaluates the total energy (Hamiltonian) expectation value.";
GWPETE2::usage = "GWPETE2[param] evaluates the expectation value of the total energy squared.";
GWPUTE::usage = "GWPUTE[param] evaluates the total energy uncertainty.";


(* --- Hydrodynamic Expectation Values --- *)
GWPEFIX::usage = "GWPEFIX[param] evaluates the position-space Fisher information.";
GWPEIKE::usage = "GWPEIKE[param] evaluates the internal (quantum) kinetic energy expectation value.";
GWPECKE::usage = "GWPECKE[param] evaluates the convective (classical) kinetic energy expectation value.";
GWPEFIP::usage = "GWPEFIP[param] evaluates the momentum-space Fisher information.";
GWPEIPE::usage = "GWPEIPE[param] evaluates the internal potential energy expectation value.";
GWPECPE::usage = "GWPECPE[param] evaluates the convective potential energy expectation value.";


(* ::Subsection::Closed:: *)
(*GWP Hydrodynamics*)


(* --- Position-Space Hydrodynamic Fields --- *)
GWPAX::usage = "GWPAX[x][param] evaluates the position-space real-valued amplitude.";
GWPSX::usage = "GWPSX[x][param] evaluates the position-space real-valued phase function.";
GWPPX::usage = "GWPPX[x][param] evaluates the position-space momentum field.";
GWPVX::usage = "GWPVX[x][param] evaluates the position-space velocity flow field.";
GWPOVX::usage = "GWPOVX[x][param] evaluates the position-space osmotic velocity field.";
GWPJX::usage = "GWPJX[x][param] evaluates the position-space probability current density.";
GWPQPX::usage = "GWPQPX[x][param] evaluates the position-space quantum potential.";
GWPQFX::usage = "GWPQFX[x][param] evaluates the position-space quantum force.";
GWPQSX::usage = "GWPQSX[x][param] evaluates the position-space quantum stress density.";
GWPFIX::usage = "GWPFIX[x][param] evaluates the position-space Fisher information density.";


(* --- Position-Space Energy Densities --- *)
GWPCKEX::usage = "GWPCKEX[x][param] evaluates the position-space convective kinetic energy density.";
GWPIKEX::usage = "GWPIKEX[x][param] evaluates the position-space internal kinetic energy density.";
GWPTKEX::usage = "GWPTKEX[x][param] evaluates the position-space total kinetic energy density.";
GWPTPEX::usage = "GWPTPEX[x][param] evaluates the position-space total potential energy density.";
GWPTEDX::usage = "GWPTEDX[x][param] evaluates the position-space total energy density.";


(* --- Momentum-Space Hydrodynamic Fields --- *)
GWPAP::usage = "GWPAP[p][param] evaluates the momentum-space real-valued amplitude.";
GWPSP::usage = "GWPSP[p][param] evaluates the momentum-space real-valued phase function.";
GWPXP::usage = "GWPXP[p][param] evaluates the momentum-space position field.";
GWPVP::usage = "GWPVP[p][param] evaluates the momentum-space force flow field.";
GWPOVP::usage = "GWPOVP[p][param] evaluates the momentum-space osmotic flow field.";
GWPJP::usage = "GWPJP[p][param] evaluates the momentum-space probability current density.";
GWPQPP::usage = "GWPQPP[p][param] evaluates the momentum-space internal potential.";
GWPQFP::usage = "GWPQFP[p][param] evaluates the momentum-space internal force.";
GWPQSP::usage = "GWPQSP[p][param] evaluates the momentum-space quantum stress density.";
GWPFIP::usage = "GWPFIP[p][param] evaluates the momentum-space Fisher information density.";


(* --- Momentum-Space Energy Densities --- *)
GWPCPEP::usage = "GWPCPEP[p][param] evaluates the momentum-space convective potential energy density.";
GWPIPEP::usage = "GWPIPEP[p][param] evaluates the momentum-space internal potential energy density.";
GWPTPEP::usage = "GWPTPEP[p][param] evaluates the momentum-space total potential energy density.";
GWPTKEP::usage = "GWPTKEP[p][param] evaluates the momentum-space total kinetic energy density.";
GWPTEDP::usage = "GWPTEDP[p][param] evaluates the momentum-space total energy density.";


(* ::Subsection::Closed:: *)
(*GWP Trajectories*)


(* --- Bohmian-Type Trajectory Fields --- *)
GWPXC::usage = "GWPXC[c][param] evaluates the C-space position trajectory field.\n" <> 
  "GWPXC[n][c][param] evaluates the n-th derivative of the position trajectory field with respect to the probability coordinate c.";

GWPPC::usage = "GWPPC[c][param] evaluates the C-space momentum trajectory field.\n" <> 
  "GWPPC[n][c][param] evaluates the n-th derivative of the momentum trajectory field with respect to the probability coordinate c.";

GWPVC::usage = "GWPVC[c][param] evaluates the C-space trajectory velocity field.";


(* --- C-Space Hydrodynamics Fields --- *)
GWPRHOC::usage = "GWPRHOC[c][param] evaluates the probability density in the C-space representation.";
GWPQPC::usage = "GWPQPC[c][param] evaluates the quantum potential in the C-space representation.";
GWPQFC::usage = "GWPQFC[c][param] evaluates the quantum force in the C-space representation.";


(* --- C-Space External Fields --- *)
GWPPEC::usage = "GWPPEC[c][param] evaluates the external potential in the C-space representation.\n" <>
  "GWPPEC[n][c][param] evaluates the n-th derivative of the external potential with respect to c.";

GWPFEC::usage = "GWPFEC[c][param] evaluates the external force in the C-space representation.\n" <>
  "GWPFEC[n][c][param] evaluates the n-th derivative of the external force with respect to c.";


(* ::Subsection::Closed:: *)
(*GWP and GWPObject*)


(* --- GWPObject Interface --- *)
GWP::usage = "GWP[args, opts] constructs a GWPObject representing a time-evolving Gaussian wavepacket.\n" <>
  "Accepts the same positional arguments as GWPPARAM. Options include \"SYSTEM\", \"HBAR\", and \"MASS\".";

GWPObject::usage = "GWPObject[...] is the central data structure for the GWPTools package.\n" <>
  "Evaluate obj[\"Properties\"] or obj[\"PropertyClasses\"] to view the available dynamical fields, expectation values, and their logical groupings.";


(* ::Subsection::Closed:: *)
(*GWP Utilities*)


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
  "GWPDiagnosticBench[sys, {arg}, {opt}, maxN] evaluates the recursive and moment properties up to the maxN-th order.";


(* ::Section::Closed:: *)
(*Private*)


Begin["`Private`"]


(* --- Package Environment Setup --- *)
(* Capture the installation directory of the package at load time. *)
(* The '2' tells it to step up one level from the 'Kernel' folder to the package root. *)
$PackageDirectory = Quiet[
  If[$InputFileName =!= "", 
    DirectoryName[$InputFileName, 2], 
    NotebookDirectory[]
  ]
];


(* --- Core Sequence Macros --- *)
(* These variables dynamically expand into the strict 11-element parameter bus. *)
(* Do not alter these unless expanding the global physical model (e.g., adding charge). *)
GWPARG = Sequence[RA_, IA_, RX_, RP_, RG_, IG_, NORM_, HBAR_, MASS_, {V0_, V1_, V2_}, INIT_];
GWPVAL = Sequence[RA,  IA,  RX,  RP,  RG,  IG,  NORM,  HBAR,  MASS,  {V0,  V1,  V2},  INIT];


(* ::Section::Closed:: *)
(*GWP Parameters*)


(* ::Subsection::Closed:: *)
(*GWPPARAM*)


(* --- Default Options --- *)
Options[GWPPARAM] = {"HBAR" -> 1, "MASS" -> 1};
(*
(* --- Parameter Generators --- *)
GWPPARAM[OptionsPattern[]]                     := GWP486[1/4, 0,  0,  0,  OptionValue@"HBAR", OptionValue@"MASS"];
GWPPARAM[AA_, OptionsPattern[]]                := GWP486[AA,  0,  0,  0,  OptionValue@"HBAR", OptionValue@"MASS"];
GWPPARAM[AA_, XX_, OptionsPattern[]]           := GWP486[AA,  XX, 0,  0,  OptionValue@"HBAR", OptionValue@"MASS"];
GWPPARAM[AA_, XX_, PP_, OptionsPattern[]]      := GWP486[AA,  XX, PP, 0,  OptionValue@"HBAR", OptionValue@"MASS"];
GWPPARAM[AA_, XX_, PP_, GG_, OptionsPattern[]] := GWP486[AA,  XX, PP, GG, OptionValue@"HBAR", OptionValue@"MASS"];
*)
(* --- Parameter Generator --- *)
GWPPARAM[
  AA : Except[_Rule | _RuleDelayed] : 1/4, 
  XX : Except[_Rule | _RuleDelayed] : 0, 
  PP : Except[_Rule | _RuleDelayed] : 0, 
  GG : Except[_Rule | _RuleDelayed] : 0, 
  opts : OptionsPattern[]
] := GWP486[AA, XX, PP, GG, OptionValue@"HBAR", OptionValue@"MASS"];


(* ::Subsection::Closed:: *)
(*GWP486*)


(* --- Four-Eight-Six Parameter Engine --- *)
GWP486[A1_, X1_, P1_, G1_, HBAR_, MASS_] := Module[{
  RA1, IA1, RX1, IX1, RP1, IP1, RG1, IG1,
  RA2, IA2, RX2, RP2, RG2, IG2, NORM, PECOEFF, INIT, PARAM
},
  (* --- Complex Expand Input Parameters --- *)
  {RA1, IA1} = GWPSHAPE[A1, HBAR, MASS];
  {RX1, IX1} = ComplexExpand @ ReIm @ X1;
  {RP1, IP1} = GWPMOMENTUM[P1, MASS];
  {RG1, IG1} = GWPPHASE[G1, HBAR, RA1, RX1, RP1];

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
(*GWPPARSE*)


(* --- Shape Parser --- *)
GWPSHAPE[A1_, HBAR_, MASS_] := Replace[A1, {
  (* Spatial uncertainty and position-momentum covariance *)
  {ux_, covxp_}      :> {1 / (4 * ux^2), -covxp / (2 * HBAR * ux^2)},
  
  (* Position and momentum uncertainties with chirp direction *)
  {ux_, up_, chirp_} :> {1 / (4 * ux^2), Sign[chirp] * Sqrt[(up^2 / (4 * HBAR^2 * ux^2)) - 1 / (16 * ux^4)]},
  
  (* Fallback for standard scalar or complex input (RA + I*IA) *)
  alpha_             :> ComplexExpand @ ReIm @ alpha
}]


(* --- Momentum Parser --- *)
GWPMOMENTUM[P1_, MASS_] := Replace[P1, {
  (* Kinetic Energy with directional sign (+1 for right, -1 for left) *)
  {"KineticEnergy", ek_, sign_} :> {Sign[sign] * Sqrt[2 * MASS * ek], 0},
  
  (* Fallback for standard scalar or complex input *)
  p_ :> ComplexExpand @ ReIm @ p
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
  
  (* Fallback for standard scalar or complex input (RG + I*IG) *)
  gamma_                         :> ComplexExpand @ ReIm[gamma]
}]


(* ::Subsection::Closed:: *)
(*GWPEXTRACT*)


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
GWPINIT[GWPARG]=INIT;


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
GWPASSUMPTIONS[GWPARG, OptionsPattern[]] := Module[{
  RA1, IA1, RX1, IX1, RP1, IP1, RG1, IG1, 
  symbs, realSymbs, intSymbs, raSymbs, iaSqrts, shapeCondList, shapeCond,
  base, cond, extra, x, p, c, t, e, rp2sign, RP2val, requestedCond,
  opts, intVars
},
  
  (* 1. Extract raw initial parameters from the bound INIT list *)
  {RA1, IA1, RX1, IX1, RP1, IP1, RG1, IG1} = INIT;

  (* 2. Extract atomic symbols for real-domain declarations *)
  symbs = Select[
    Union @ Cases[{INIT, HBAR, MASS, V0, V1, V2}, _Symbol, Infinity], 
    Context[#] =!= "System`" &
  ];

  (* 3. Extract integer options and filter generic symbols *)
  intVars   = OptionValue["IntegerVariables"];
  intSymbs  = If[intVars === None, {}, Flatten[{intVars}]];
  realSymbs = Complement[symbs, intSymbs];

  (* 4. Construct core real and integer domain assumptions *)
  base = True;
  If[Length[realSymbs] > 0, base = base && Element[Alternatives @@ realSymbs, Reals]];
  If[Length[intSymbs] > 0,  base = base && Element[Alternatives @@ intSymbs, Integers]];

  (* 5. Smart shape conditions (preventing And[] absorption) *)
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
  
  (* 6. Extract dynamic coordinate Options *)
  x       = OptionValue["Position"];
  p       = OptionValue["Momentum"];
  c       = OptionValue["Cumulative"];
  t       = OptionValue["Time"];
  e       = OptionValue["Energy"];
  rp2sign = OptionValue["RP2Sign"];

  (* 7. Build dynamic coordinate assumptions *)
  extra = True;
  If[x =!= None, extra = extra && Element[x, Reals]];
  If[p =!= None, extra = extra && Element[p, Reals]];
  If[t =!= None, extra = extra && Element[t, Reals]];
  If[c =!= None, extra = extra && Element[c, Reals] && 0 < c < 1];
  If[e =!= None, extra = extra && Element[e, Reals] && 0 < e];
  
  (* 8. Inject RP2 branch cut assumption *)
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
  
  (* 9. Return perfectly merged assumption sequence *)
  base && FullSimplify[cond, Assumptions -> True] && extra
];


(* ::Section::Closed:: *)
(*GWP Systems*)


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
(*Named systems*)


(* --- Named Systems ---*)
FREE[t_][GWPARG]=LINEAR[0][t][GWPVAL];
HO[t_][GWPARG]=HARMONIC[1][t][GWPVAL];


(* ::Subsection::Closed:: *)
(*Linear potential*)


LINEARFUN={LINEARRAT,LINEARIAT,LINEARRXT,LINEARRPT,LINEARRGT,LINEARIGT};
SetAttributes[LINEARFUN,Listable];
LINEAR[FK_:1][t_][GWPARG]=Sequence@@{Sequence@@Through[Through[LINEARFUN[t,FK]][GWPVAL]],NORM,HBAR,MASS,{0,FK,0},INIT};
LINEARRAT[t_,FK_][GWPARG]=(MASS^2*RA)/(MASS^2 - 4*HBAR*IA*MASS*t + 4*HBAR^2*(IA^2 + RA^2)*t^2);
LINEARIAT[t_,FK_][GWPARG]=(MASS*(IA*MASS - 2*HBAR*(IA^2 + RA^2)*t))/(MASS^2 - 4*HBAR*IA*MASS*t + 4*HBAR^2*(IA^2 + RA^2)*t^2);
LINEARRXT[t_,FK_][GWPARG]=RX + (RP*t)/MASS - (FK*t^2)/(2*MASS);
LINEARRPT[t_,FK_][GWPARG]=RP - FK*t;
LINEARLCT[t_,FK_][GWPARG]=(t*(3*RP^2 - 6*FK*RP*t + 2*FK*(-3*MASS*RX + FK*t^2)))/(6*MASS);
LINEARRGT[t_,FK_][GWPARG]=RG + LINEARLCT[t,FK][GWPVAL] - (HBAR*ArcTan[1 - (2*HBAR*IA*t)/MASS, (2*HBAR*RA*t)/MASS])/2;
LINEARIGT[t_,FK_][GWPARG]=IG + (HBAR*(-2*Log[MASS] + Log[4*HBAR^2*RA^2*t^2 + (MASS - 2*HBAR*IA*t)^2]))/4;


(* ::Subsection::Closed:: *)
(*Harmonic oscillator potential*)


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
(*Parabolic oscillator potential*)


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
(*Forced harmonic oscillator linear driving*)


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
(*Forced harmonic oscillator sinusoidal resonant driving*)


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
(*Forced harmonic oscillator sinusoidal non-resonant driving*)


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
(*Potential and Force*)


(* --- Potential Energy Field in X --- *)
GWPPEX[0][x_][GWPARG] := V0 + V1 * x + V2 * x^2;
GWPPEX[1][x_][GWPARG] := V1 + 2*V2*x;
GWPPEX[2][x_][GWPARG] := 2*V2;
GWPPEX[n_Integer][x_][GWPARG] /; n >= 3 := 0; 
(* Fallback: Route GWPPEX[x][...] to the 0th derivative *)
GWPPEX[x_][arg___] /; !MatchQ[Unevaluated[GWPPEX[x]], GWPPEX[_Integer]] := GWPPEX[0][x][arg];


(* --- Force Field in X --- *)
GWPFEX[0][x_][GWPARG] := -V1 - 2 * V2 * x;
GWPFEX[1][x_][GWPARG] := -2 * V2;
GWPFEX[n_Integer][x_][GWPARG] /; n >= 2 := 0;
(* Fallback: Route GWPFEX[x][...] to the 0th derivative *)
GWPFEX[x_][arg___] /; !MatchQ[Unevaluated[GWPFEX[x]], GWPFEX[_Integer]] := GWPFEX[0][x][arg];


(* ::Section::Closed:: *)
(*GWP Wavefunctions*)


(* --- Private Worker Function for Wavefunction Recursion --- *)
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


(* --- Position Representation Wavefunctions --- *)
GWPPSIX[n_Integer][x_][GWPARG] := Module[{raia, p1, poly},
  raia = RA + I*IA;
  p1 = -2 * raia * (x - RX) + (I * RP) / HBAR;  
  (* Generate the polynomial using the worker engine *)
  poly = GWPHermiteEngine[n, p1, raia];
  poly * NORM * Exp[-(RA + I*IA)*(x - RX)^2 + (I/HBAR)*RP*(x - RX) + (I/HBAR)*(RG + I*IG)]
];
(* Fallback: Route GWPPSIX[x][...] to the 0th derivative *)
GWPPSIX[x_][arg___] /; !MatchQ[Unevaluated[GWPPSIX[x]], GWPPSIX[_Integer]] := GWPPSIX[0][x][arg];


(* --- Position-Space Complex Conjugate Wavefunction --- *)
GWPCSIX[n_Integer][x_][GWPARG] := Module[{raia, p1, poly},
  raia = RA - I*IA;
  p1 = -2 * raia * (x - RX) + (-I * RP) / HBAR; 
  poly = GWPHermiteEngine[n, p1, raia]; 
  poly * NORM * Exp[-(RA - I*IA)*(x - RX)^2 - (I/HBAR)*RP*(x - RX) - (I/HBAR)*(RG - I*IG)]
];
(* Fallback: Route GWPCSIX[x][...] to the 0th derivative *)
GWPCSIX[x_][arg___] /; !MatchQ[Unevaluated[GWPCSIX[x]], GWPCSIX[_Integer]] := GWPCSIX[0][x][arg];


(* --- Real and Imaginary Wavefunction Components --- *)
GWPRSIX[x_][GWPARG] = NORM * Exp[-(IG/HBAR) - RA*(RX - x)^2] * Cos[(RG - (RP + HBAR*IA*(RX - x))*(RX - x))/HBAR];
GWPISIX[x_][GWPARG] = NORM * Exp[-(IG/HBAR) - RA*(RX - x)^2] * Sin[(RG - (RP + HBAR*IA*(RX - x))*(RX - x))/HBAR];


(* --- Momentum Representation Wavefunctions --- *)
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


(* --- Momentum-Space Complex Conjugate Wavefunction --- *)
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


(* --- Real and Imaginary Wavefunction Components --- *)
GWPRSIP[p_][GWPARG] = (NORM * Exp[-IG/HBAR - (RA*(p - RP)^2)/(4*HBAR^2*(RA^2 + IA^2))] * Cos[RG/HBAR - (p*RX)/HBAR + (IA*(p - RP)^2)/(4*HBAR^2*(RA^2 + IA^2)) - 1/2*ArcTan[RA, IA]]) / (4*HBAR^2*(RA^2 + IA^2))^(1/4);
GWPISIP[p_][GWPARG] = (NORM * Exp[-IG/HBAR - (RA*(p - RP)^2)/(4*HBAR^2*(RA^2 + IA^2))] * Sin[RG/HBAR - (p*RX)/HBAR + (IA*(p - RP)^2)/(4*HBAR^2*(RA^2 + IA^2)) - 1/2*ArcTan[RA, IA]]) / (4*HBAR^2*(RA^2 + IA^2))^(1/4);


(* ::Section::Closed:: *)
(*GWP Densities*)


(* --- Position Density --- *)
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


(* --- Momentum Density --- *)
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


(* --- Phase Space & Density Matrices --- *)
GWPDMX[x_, y_][GWPARG] = Sqrt[2*RA / Pi] * Exp[-(RA + I*IA)*(x - RX)^2 - (RA - I*IA)*(y - RX)^2 + (I*RP*(x - y))/HBAR];
GWPWIG[x_, p_][GWPARG] = 1/(Pi*HBAR) * Exp[-((2*(RA^2 + IA^2)*(x - RX)^2)/RA) - ((p - RP)^2)/(2*HBAR^2*RA) - (2*IA*(x - RX)*(p - RP))/(HBAR*RA)];


(* ::Section::Closed:: *)
(*GWP Probabilities*)


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
(*GWP Expectation values*)


(* --- Position Expectation Values (Arbitrary Order) --- *)
GWPEX[n_Integer][GWPARG] := Moment[NormalDistribution[RX, Sqrt[1/(4*RA)]], n];
(* Fallback: Route GWPEX[...] to the 1st moment *)
GWPEX[param___] /; !MatchQ[{param}, {_Integer}] := GWPEX[1][param];


(* --- Position Moments and Uncertainty (Legacy) --- *)
GWPEX1[GWPARG] = RX;
GWPEX2[GWPARG] = 1/(4*RA) + RX^2;
GWPEX3[GWPARG] = (3*RX)/(4*RA) + RX^3;
GWPEX4[GWPARG] = 3/(16*RA^2) + (3*RX^2)/(2*RA) + RX^4;
GWPUX[GWPARG]  = 1/(2*Sqrt[RA]);


(* --- Momentum Expectation Values (Arbitrary Order) --- *)
GWPEP[n_Integer][GWPARG] := Moment[NormalDistribution[RP, HBAR * Sqrt[RA + (IA^2 / RA)]], n];
(* Fallback: Route GWPEP[...] to the 1st moment *)
GWPEP[param___] /; !MatchQ[{param}, {_Integer}] := GWPEP[1][param];


(* --- Momentum Moments and Uncertainty (Legacy) --- *)
GWPEP1[GWPARG] = RP;
GWPEP2[GWPARG] = HBAR^2*(RA + IA^2/RA) + RP^2;
GWPEP3[GWPARG] = (3*HBAR^2*(IA^2 + RA^2)*RP)/RA + RP^3;
GWPEP4[GWPARG] = (3*HBAR^4*(IA^2 + RA^2)^2)/RA^2 + (6*HBAR^2*(IA^2 + RA^2)*RP^2)/RA + RP^4;
GWPUP[GWPARG]  = HBAR*Sqrt[RA + IA^2/RA];


(* --- Position-Momentum Products and Covariance --- *)
GWPEXP[GWPARG]   = -1/2*(HBAR*(IA - I*RA))/RA + RP*RX;
GWPEPX[GWPARG]   = -1/2*(HBAR*(IA + I*RA))/RA + RP*RX;
GWPCOVXP[GWPARG] = -1/2*(HBAR*IA)/RA;
GWPCORXP[GWPARG] = -(IA/Sqrt[IA^2 + RA^2]);


(* --- Kinetic Energy Expectation Values --- *)
GWPEKE1[GWPARG] = (HBAR^2*(IA^2/RA + RA) + RP^2)/(2*MASS);
GWPEKE2[GWPARG] = ((3*HBAR^4*(IA^2 + RA^2)^2)/RA^2 + (6*HBAR^2*(IA^2 + RA^2)*RP^2)/RA + RP^4)/(4*MASS^2);
GWPUKE[GWPARG]  = Sqrt[(HBAR^2*(IA^2 + RA^2)*(HBAR^2*(IA^2 + RA^2) + 2*RA*RP^2))/(MASS^2*RA^2)]/Sqrt[2];


(* --- Potential Energy Expectation Values --- *)
GWPEPE1[GWPARG] = V0 + V2/(4*RA) + RX*(V1 + RX*V2);
GWPEPE2[GWPARG] = (3*V2^2)/(16*RA^2) + (V0 + RX*(V1 + RX*V2))^2 + (V1^2 + 6*RX*V1*V2 + 2*V2*(V0 + 3*RX^2*V2))/(4*RA);
GWPUPE[GWPARG]  = Sqrt[(V2^2 + 2*RA*(V1 + 2*RX*V2)^2)/RA^2]/(2*Sqrt[2]);


(* --- Force Expectation Values --- *)
GWPEF1[GWPARG] = -V1 - 2*RX*V2;
GWPEF2[GWPARG] = (V2^2 + RA*(V1 + 2*RX*V2)^2)/RA;
GWPUF[GWPARG]  = Abs[V2]/Sqrt[RA];


(* --- Kinetic-Potential Energy Cross-Correlations --- *)
GWPEKEPE[GWPARG] = (-4*HBAR*(IA + I*RA)*RA*RP*(V1 + 2*RX*V2) + HBAR^2*(4*RA*(IA^2 + RA^2)*(V0 + RX*V1) + (IA + I*RA)*(3*IA + I*RA + 4*(IA - I*RA)*RA*RX^2)*V2) + RA*RP^2*(V2 + 4*RA*(V0 + RX*(V1 + RX*V2))))/(8*MASS*RA^2);
GWPEPEKE[GWPARG] = ((4*I)*HBAR*RA*(I*IA + RA)*RP*(V1 + 2*RX*V2) + HBAR^2*(4*RA*(IA^2 + RA^2)*(V0 + RX*V1) + (IA - I*RA)*(3*IA - I*RA + 4*(IA + I*RA)*RA*RX^2)*V2) + RA*RP^2*(V2 + 4*RA*(V0 + RX*(V1 + RX*V2))))/(8*MASS*RA^2);
GWPCOVKEPE[GWPARG] = (HBAR*(HBAR*IA^2*V2 - HBAR*RA^2*V2 - 2*IA*RA*RP*(V1 + 2*RX*V2)))/(4*MASS*RA^2);
(*
GWPCORKEPE[GWPARG] = Piecewise[{
    {0, V1 == 0 && V2 == 0}
  }, 
  (HBAR*(HBAR*IA^2*V2 - HBAR*RA^2*V2 - 2*IA*RA*RP*(V1 + 2*RX*V2))) / 
  (MASS*RA^2 * Sqrt[(HBAR^2*(IA^2 + RA^2)*(HBAR^2*(IA^2 + RA^2) + 2*RA*RP^2))/(MASS^2*RA^2)] * Sqrt[(V2^2 + 2*RA*(V1 + 2*RX*V2)^2)/RA^2])
];
*)
(* Correlation: Overloaded to prevent 0/0 Indeterminate for flat potentials *)
GWPCORKEPE[GWPARG] /; (V1 == 0 && V2 == 0) := 0;
GWPCORKEPE[GWPARG] := (HBAR*(HBAR*IA^2*V2 - HBAR*RA^2*V2 - 2*IA*RA*RP*(V1 + 2*RX*V2))) / 
  (MASS*RA^2 * Sqrt[(HBAR^2*(IA^2 + RA^2)*(HBAR^2*(IA^2 + RA^2) + 2*RA*RP^2))/(MASS^2*RA^2)] * Sqrt[(V2^2 + 2*RA*(V1 + 2*RX*V2)^2)/RA^2]);


(* --- Total Energy Expectation Values --- *)
GWPETE1[GWPARG] = (HBAR^2*(IA^2/RA + RA) + RP^2)/(2*MASS) + V0 + RX*V1 + (1/(4*RA) + RX^2)*V2;
GWPETE2[GWPARG] = (12*HBAR^4*(IA^2 + RA^2)^2 + 3*MASS^2*V2^2 - 16*HBAR*IA*MASS*RA*RP*(V1 + 2*RX*V2) + 4*HBAR^2*(2*RA*(IA^2 + RA^2)*(3*RP^2 + 2*MASS*(V0 + RX*V1)) + MASS*(3*IA^2 - RA^2 + 4*RA*(IA^2 + RA^2)*RX^2)*V2) + 4*RA^2*(RP^2 + 2*MASS*(V0 + RX*(V1 + RX*V2)))^2 + 4*MASS*RA*(RP^2*V2 + MASS*(V1^2 + 6*RX*V1*V2 + 2*V2*(V0 + 3*RX^2*V2))))/(16*MASS^2*RA^2);
GWPUTE[GWPARG]  = Sqrt[(4*HBAR^4*(IA^2 + RA^2)^2 + 4*HBAR^2*(2*RA*(IA^2 + RA^2)*RP^2 + MASS*(IA - RA)*(IA + RA)*V2) - 8*HBAR*IA*MASS*RA*RP*(V1 + 2*RX*V2) + MASS^2*(V2^2 + 2*RA*(V1 + 2*RX*V2)^2))/(MASS^2*RA^2)]/(2*Sqrt[2]);


(* --- Hydrodynamic Expectation Values --- *)
GWPEFIX[GWPARG] = 4*RA;
GWPEIKE[GWPARG] = (HBAR^2*RA)/(2*MASS);
GWPECKE[GWPARG] = (HBAR^2*IA^2 + RA*RP^2)/(2*MASS*RA);
GWPEFIP[GWPARG] = RA/(HBAR^2*(IA^2 + RA^2));
GWPEIPE[GWPARG] = (RA*V2)/(4*(IA^2 + RA^2));
GWPECPE[GWPARG] = (4*RA^3*(V0 + RX*(V1 + RX*V2)) + IA^2*(V2 + 4*RA*(V0 + RX*(V1 + RX*V2))))/(4*RA*(IA^2 + RA^2));


(* ::Section::Closed:: *)
(*GWP Hydrodynamics*)


(* ::Subsection::Closed:: *)
(*Position-Space Hydrodynamics*)


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


(* --- Information and Internal Energies --- *)
GWPFIX[x_][GWPARG]  = (16*Sqrt[2/Pi]*RA^(5/2)*(RX - x)^2)/E^(2*RA*(RX - x)^2);
GWPIKEX[x_][GWPARG] = (2*HBAR^2*Sqrt[2/Pi]*RA^(5/2)*(RX - x)^2)/(E^(2*RA*(RX - x)^2)*MASS);
GWPCKEX[x_][GWPARG] = (Sqrt[RA]*(RP - 2*HBAR*IA*(-RX + x))^2)/(E^(2*RA*(-RX + x)^2)*MASS*Sqrt[2*Pi]);


(* --- Total Energy Density Decompositions --- *)
GWPTPEX[x_][GWPARG] = (Sqrt[2/Pi]*Sqrt[RA]*(V0 + x*(V1 + V2*x)))/E^(2*RA*(RX - x)^2);
GWPTKEX[x_][GWPARG] = (Sqrt[RA]*(RP^2 + 4*HBAR*IA*RP*(RX - x) + 4*HBAR^2*(IA^2 + RA^2)*(RX - x)^2))/(E^(2*RA*(RX - x)^2)*MASS*Sqrt[2*Pi]);
GWPTEDX[x_][GWPARG] = (Sqrt[RA]*(RP^2 + 4*HBAR*IA*RP*(RX - x) + 4*HBAR^2*(IA^2 + RA^2)*(RX - x)^2 + 2*MASS*(V0 + x*(V1 + V2*x))))/(E^(2*RA*(RX - x)^2)*MASS*Sqrt[2*Pi]);


(* ::Subsection::Closed:: *)
(*Momentum-Space Hydrodynamics*)


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


(* --- Information and Internal Energies --- *)
GWPFIP[p_][GWPARG]  = ((RA/(IA^2 + RA^2))^(5/2)*(p - RP)^2)/(E^((RA*(p - RP)^2)/(2*HBAR^2*(IA^2 + RA^2)))*HBAR^5*Sqrt[2*Pi]);
GWPIPEP[p_][GWPARG] = ((RA/(IA^2 + RA^2))^(5/2)*(p - RP)^2*V2)/(4*E^((RA*(p - RP)^2)/(2*HBAR^2*(IA^2 + RA^2)))*HBAR^3*Sqrt[2*Pi]);


(* --- Total Energy Density Decompositions --- *)
GWPCPEP[p_][GWPARG] = (V0 + ((IA*(-p + RP))/(2*HBAR*(IA^2 + RA^2)) + RX)*V1 + ((IA*(-p + RP))/(2*HBAR*(IA^2 + RA^2)) + RX)^2*V2)/(E^((RA*(p - RP)^2)/(2*HBAR^2*(IA^2 + RA^2)))*Sqrt[2*Pi]*Sqrt[(HBAR^2*(IA^2 + RA^2))/RA]);
GWPTKEP[p_][GWPARG] = (E^((-2*IG)/HBAR - (RA*(p - RP)^2)/(2*HBAR^2*(IA^2 + RA^2)))*p^2*Sqrt[RA])/ (2*HBAR*MASS*Sqrt[2*Pi]*Sqrt[IA^2 + RA^2]);
GWPTPEP[p_][GWPARG] = (Sqrt[RA]*((p - RP)^2*V2 - 2*HBAR*IA*(p - RP)*(V1 + 2*RX*V2) + 4*HBAR^2*(IA^2 + RA^2)*(V0 + RX*(V1 + RX*V2))))/(4*E^((RA*(p - RP)^2)/(2*HBAR^2*(IA^2 + RA^2)))*HBAR^3*Sqrt[2*Pi]*(IA^2 + RA^2)^(3/2));
GWPTEDP[p_][GWPARG] = ((2*p^2*Sqrt[RA/(IA^2 + RA^2)])/(E^((2*IG)/HBAR)*HBAR*MASS) + (Sqrt[RA]*((p - RP)^2*V2 - 2*HBAR*IA*(p - RP)*(V1 + 2*RX*V2) + 4*HBAR^2*(IA^2 + RA^2)*(V0 + RX*(V1 + RX*V2))))/(HBAR^3*(IA^2 + RA^2)^(3/2)))/(4*E^((RA*(p - RP)^2)/(2*HBAR^2*(IA^2 + RA^2)))*Sqrt[2*Pi]);


(* ::Section::Closed:: *)
(*GWP BohmianTrajectories*)


(* --- Private Worker Function for Inverse-Erf Trajectory Recursion --- *)
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
GWPQPC[c_][GWPARG]  = (RA*HBAR^2 * (1 - InverseErf[2*c - 1]^2)) / MASS;
GWPQFC[c_][GWPARG]  = ((2*RA)^(3/2) * HBAR^2 * InverseErf[2*c - 1]) / MASS;
GWPVC[c_][GWPARG]   = (RP - (2*HBAR*IA / Sqrt[2*RA]) * InverseErf[2*c - 1]) / MASS;


(* --- External Potential in C-Space (Chain Rule: d^n/dc^n) --- *)
GWPPEC[0][c_][GWPARG] = GWPPEX[0][GWPXC[0][c][GWPVAL]][GWPVAL];

With[{VAL = GWPVAL},
  GWPPEC[n_Integer /; n > 0][c_][GWPARG] := Module[{xDerivs, x2Deriv},
    (* Generate a list of x(c) derivatives from k=0 to n *)
    xDerivs = Table[GWPXC[k][c][VAL], {k, 0, n}];  
    (* Apply the Leibniz rule for the x(c)^2 term *)
    x2Deriv = Sum[Binomial[n, k] * xDerivs[[k + 1]] * xDerivs[[n - k + 1]], {k, 0, n}];   
    (* Reconstruct the n-th derivative of the potential *)
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


(* ::Section::Closed:: *)
(*GWP User Interface*)


(* ::Subsection::Closed:: *)
(*Variables*)


(* --- System Discovery & Dispatch --- *)
$GWPNamedSystems = <|
   "FreeParticle" -> LINEAR[0],
   "HarmonicOscillator" -> HARMONIC[1],
   "LinearPotential" -> LINEAR[1]
|>;

$GWPSystemFunctions = {
   "FREE", 
   "HO", 
   "LINEAR[FK]", 
   "HARMONIC[OMEGA]", 
   "PARABOLIC[OMEGA]", 
   "FHOLIN[OMEGA, AK]", 
   "FHORES[OMEGA, AK]", 
   "FHONON[OMEGA, AK, OMEGA1]"
};


(* ::Subsection::Closed:: *)
(*Discoverability*)


GWP["NamedSystems"] := Sort[Keys[$GWPNamedSystems]];
GWP["SystemFunctions"] := $GWPSystemFunctions;
GWP["Systems"] := <|
   "NamedSystems" -> GWP["NamedSystems"],
   "SystemFunctions" -> GWP["SystemFunctions"]
|>;


(* --- Programmatic Package Documentation --- *)
GWP["About"] := Panel[
  TabView[{
    "Overview" -> Column[{
      Style["GWPTools (Core)", Bold, 16, Darker[Blue]],
      Style["Version 1.0.0", Italic, 12, Gray],
      Spacer[5],
      "Analytical framework for single Gaussian Wavepackets (GWPs).",
      "Features dual-basis hydrodynamics (Madelung), energy density partitioning,",
      "and exact Bohmian trajectories."
    }, Spacings -> 0.5],
    
    "Mathematical Conventions" -> Column[{
      "1. Fourier Transform: p-space is defined with the phase Exp[-I p x / HBAR]",
      "2. Wavefunction: \[Psi](x) = R(x) Exp[I S(x) / HBAR]",
      "3. Phase Sign: Time evolution follows Exp[-I E t / HBAR]",
      "4. Normalization: All densities integrate to 1 over the interval (-\[Infinity], \[Infinity])",
      "5. Parameter Bus: All functions internally rely on the exact 11-element sequence:",
      Spacer[2],
      Style["   {RA, IA, RX, RP, RG, IG, NORM, HBAR, MASS, {V0, V1, V2}, INIT}", Bold, Darker[Gray]]
    }, Spacings -> 0.8],
    
    "Namespace Legend" -> Grid[{
      {Style["Manifold Suffixes:", Bold, Darker[Blue]], SpanFromLeft},
      {"X", "Position space manifold (e.g., PSIX, RHOX)"},
      {"P", "Momentum space manifold (e.g., PSIP, RHOP)"},
      {"C", "Cumulative/Probability coordinate space (e.g., XC, PC, RHOC)"},
      {"E", "Energy space manifold (e.g., RHOE, CE)"},
      {"", ""},
      {Style["Property Prefixes & Infixes:", Bold, Darker[Blue]], SpanFromLeft},
      {"E", "Expectation values (e.g., EKE1, EPE1)"},
      {"D", "Spatial density decompositions (e.g., TEDX, CKEX)"},
      {"", ""},
      {Style["Flow & Cross-Mappings:", Bold, Darker[Blue]], SpanFromLeft},
      {"V", "Denotes velocity/flow fields (e.g., VX = dx/dt, VP = dp/dt)."},
      {"Double", "Cross-mappings (e.g., PPX = p(x), XPP = x(p))."}
    }, Alignment -> Left, Spacings -> {2, 0.8}]
  }],
  Style["GWPTools Package Information", Bold, 14],
  Background -> White,
  FrameMargins -> 15
];


(* ::Subsection::Closed:: *)
(*Constructor*)


(* --- Core GWPObject Constructor --- *)
Options[GWP] = {"SYSTEM" -> "FreeParticle", "HBAR" -> 1, "MASS" -> 1};

GWP[initialParams___ : Automatic, opts : OptionsPattern[]] := 
  Module[{params, rawSys, finalSys, h, m},
    h = OptionValue["HBAR"];
    m = OptionValue["MASS"];   
    params = If[{initialParams} === {Automatic} || {initialParams} === {}, 
       GWPPARAM["HBAR" -> h, "MASS" -> m], 
       GWPPARAM[initialParams, "HBAR" -> h, "MASS" -> m]
    ];
    rawSys = OptionValue["SYSTEM"];
    finalSys = Lookup[$GWPNamedSystems, rawSys, rawSys];
    
    GWPObject[<|
      "Parameters" -> params, 
      "System" -> finalSys, 
      "Created" -> Now
    |>]
];


(* ::Section::Closed:: *)
(*GWPObject Architecture*)


(* ::Subsection::Closed:: *)
(*$GWPRegistry*)


(* --- Master Registry: Property Resolution & Dispatch Mapping --- *)
(* This registry defines the properties accessible via the GWPObject.        *)
(* Each entry follows the format:                                            *)
(* {"LongName", "ShortKey", "DispatchType", "PhysicsClass}                 *)
(* - "LongName": The human-readable string used in gwp["LongName"].          *)
(* - "ShortKey": Maps to the underlying package function (e.g., "GWP" <> key)*)
(* - "DispatchType": Dictates how the Dispatcher formats the output function:*)
(* * Static    : f[params]             -> Returns evaluated value instantly  *)
(* * Temporal  : f[params]             -> Returns Function[t]                *)
(* * Field     : f[var][params]        -> Returns Function[{var, t}]         *)
(* * Recursive : f[n][var][params]     -> Returns Function[{var, t}]         *)
(* * Moment    : f[n][params]          -> Returns Function[t]                *)
(* * Bivariate : f[v1, v2][params]     -> Returns Function[{v1, v2, t}]      *)


(* ::Subsubsection::Closed:: *)
(*Static*)


$regStatic = {
   {"Normalization", "NORM", "Static", "StaticParameters"},
   {"PlanckConstant", "HBAR", "Static", "StaticParameters"},
   {"ParticleMass", "MASS", "Static", "StaticParameters"},
   {"InitialState", "INIT", "Static", "StaticParameters"},
   {"PotentialCoefficients", "PECOEFF", "Temporal", "DynamicParameters"},
   {"Assumptions", "ASSUMPTIONS", "Static", "StaticParameters"}
};


(* ::Subsubsection::Closed:: *)
(*Dynamic*)


$regDynamic = {
   {"RealShape", "RA", "Temporal", "DynamicParameters"},
   {"ImaginaryShape", "IA", "Temporal", "DynamicParameters"},
   {"PositionCenter", "RX", "Temporal", "DynamicParameters"},
   {"MomentumCenter", "RP", "Temporal", "DynamicParameters"},
   {"RealPhase", "RG", "Temporal", "DynamicParameters"},
   {"ImaginaryPhase", "IG", "Temporal", "DynamicParameters"},
   {"RealShapeTimeDerivative", "RATD", "Temporal", "DynamicParameters"},
   {"ImaginaryShapeTimeDerivative", "IATD", "Temporal", "DynamicParameters"},
   {"PositionCenterTimeDerivative", "RXTD", "Temporal", "DynamicParameters"},
   {"MomentumCenterTimeDerivative", "RPTD", "Temporal", "DynamicParameters"},
   {"RealPhaseTimeDerivative", "RGTD", "Temporal", "DynamicParameters"},
   {"ImaginaryPhaseTimeDerivative", "IGTD", "Temporal", "DynamicParameters"}
};


(* ::Subsubsection::Closed:: *)
(*Wavefunctions*)


$regWave = {
   {"WavefunctionX", "PSIX", "Recursive", "Wavefunctions"},
   {"ConjugateWavefunctionX", "CSIX", "Recursive", "Wavefunctions"},
   {"WavefunctionP", "PSIP", "Recursive", "Wavefunctions"},
   {"ConjugateWavefunctionP", "CSIP", "Recursive", "Wavefunctions"},
   {"RealWavefunctionX", "RSIX", "Field", "Wavefunctions"},
   {"ImaginaryWavefunctionX", "ISIX", "Field", "Wavefunctions"},
   {"RealWavefunctionP", "RSIP", "Field", "Wavefunctions"},
   {"ImaginaryWavefunctionP", "ISIP", "Field", "Wavefunctions"}
};


(* ::Subsubsection:: *)
(*Densities*)


$regDens = {
   {"DensityX", "RHOX", "Recursive", "Densities"},
   {"DensityP", "RHOP", "Recursive", "Densities"},
   {"EnergyDensity", "RHOE", "Field", "Densities"},
   {"DensityMatrixX", "DMX", "Bivariate", "Densities"},
   {"WignerDistribution", "WIG", "Bivariate", "Densities"}
};


(* ::Subsubsection::Closed:: *)
(*Probabilities*)


$regProb = {
   {"CumulativeDistributionX", "CX", "Field", "Probabilities"},
   {"CumulativeDistributionP", "CP", "Field", "Probabilities"},
   {"CumulativeDistributionE", "CE", "Field", "Probabilities"},
   {"ProbabilityX", "PROBX", "Bivariate", "Probabilities"},
   {"ProbabilityP", "PROBP", "Bivariate", "Probabilities"},
   {"ProbabilityE", "PROBE", "Bivariate", "Probabilities"}
};


(* ::Subsubsection::Closed:: *)
(*Expectation Values*)


$regExp = {
   {"ExpectationX", "EX", "Moment", "Expectations"},
   {"ExpectationP", "EP", "Moment", "Expectations"},
   {"PositionUncertainty", "UX", "Temporal", "Expectations"},
   {"MomentumUncertainty", "UP", "Temporal", "Expectations"},
   {"MeanPositionMomentumProduct", "EXP", "Temporal", "Expectations"}, 
   {"MeanMomentumPositionProduct", "EPX", "Temporal", "Expectations"}, 
   {"PositionMomentumCovariance", "COVXP", "Temporal", "Expectations"}, 
   {"PositionMomentumCorrelation", "CORXP", "Temporal", "Expectations"}
};


(* ::Subsubsection::Closed:: *)
(*Energies*)


$regEng = {
   {"MeanKineticEnergy", "EKE1", "Temporal", "Energies"},
   {"MeanSquareKineticEnergy", "EKE2", "Temporal", "Energies"},
   {"KineticEnergyUncertainty", "UKE", "Temporal", "Energies"},
   {"MeanPotentialEnergy", "EPE1", "Temporal", "Energies"},
   {"MeanSquarePotentialEnergy", "EPE2", "Temporal", "Energies"}, 
   {"PotentialEnergyUncertainty", "UPE", "Temporal", "Energies"},
   {"MeanTotalEnergy", "ETE1", "Temporal", "Energies"},
   {"MeanSquareTotalEnergy", "ETE2", "Temporal", "Energies"},
   {"TotalEnergyUncertainty", "UTE", "Temporal", "Energies"}, 
   {"MeanKineticPotentialProduct", "EKEPE", "Temporal", "Energies"}, 
   {"MeanPotentialKineticProduct", "EPEKE", "Temporal", "Energies"}, 
   {"KineticPotentialCovariance", "COVKEPE", "Temporal", "Energies"}, 
   {"KineticPotentialCorrelation", "CORKEPE", "Temporal", "Energies"}
};


(* ::Subsubsection::Closed:: *)
(*Hydrodynamic Expectation Values*)


$regHydroExp = {
   {"FisherInformationX", "EFIX", "Temporal", "HydrodynamicExpectations"},
   {"MeanInternalKineticEnergy", "EIKE", "Temporal", "HydrodynamicExpectations"},
   {"MeanConvectiveKineticEnergy", "ECKE", "Temporal", "HydrodynamicExpectations"},
   {"FisherInformationP", "EFIP", "Temporal", "HydrodynamicExpectations"},
   {"MeanInternalPotentialEnergy", "EIPE", "Temporal", "HydrodynamicExpectations"},
   {"MeanConvectivePotentialEnergy", "ECPE", "Temporal", "HydrodynamicExpectations"},
   {"MeanForce", "EF1", "Temporal", "ForceExpectations"},
   {"MeanSquareForce", "EF2", "Temporal", "ForceExpectations"},
   {"ForceUncertainty", "UF", "Temporal", "ForceExpectations"}
};


(* ::Subsubsection::Closed:: *)
(*Position-Space Hydrodynamic Fields*)


$regHydroX = {
   {"AmplitudeX", "AX", "Field", "HydrodynamicsX"},
   {"PhaseX", "SX", "Field", "HydrodynamicsX"},
   {"MomentumFieldX", "PX", "Field", "HydrodynamicsX"},
   {"VelocityX", "VX", "Field", "HydrodynamicsX"},
   {"OsmoticVelocityX", "OVX", "Field", "HydrodynamicsX"},
   {"CurrentX", "JX", "Field", "HydrodynamicsX"},
   {"QuantumPotentialX", "QPX", "Field", "HydrodynamicsX"},
   {"QuantumForceX", "QFX", "Field", "HydrodynamicsX"},
   {"QuantumStressX", "QSX", "Field", "HydrodynamicsX"},
   {"FisherInformationDensityX", "FIX", "Field", "HydrodynamicsX"},
   {"ConvectiveKineticDensityX", "CKEX", "Field", "HydrodynamicsX"},
   {"InternalKineticDensityX", "IKEX", "Field", "HydrodynamicsX"},
   {"TotalKineticDensityX", "TKEX", "Field", "HydrodynamicsX"},
   {"TotalPotentialDensityX", "TPEX", "Field", "HydrodynamicsX"},
   {"TotalEnergyDensityX", "TEDX", "Field", "HydrodynamicsX"}
};


(* ::Subsubsection::Closed:: *)
(*Momentum-Space Hydrodynamics Fields*)


$regHydroP = {
   {"AmplitudeP", "AP", "Field", "HydrodynamicsP"},
   {"PhaseP", "SP", "Field", "HydrodynamicsP"},
   {"PositionFieldP", "XP", "Field", "HydrodynamicsP"},
   {"ForceFlowP", "VP", "Field", "HydrodynamicsP"},
   {"OsmoticFlowP", "OVP", "Field", "HydrodynamicsP"},
   {"CurrentP", "JP", "Field", "HydrodynamicsP"},
   {"QuantumPotentialP", "QPP", "Field", "HydrodynamicsP"},
   {"QuantumForceP", "QFP", "Field", "HydrodynamicsP"},
   {"QuantumStressP", "QSP", "Field", "HydrodynamicsP"},
   {"FisherInformationDensityP", "FIP", "Field", "HydrodynamicsP"},
   {"ConvectivePotentialDensityP", "CPEP", "Field", "HydrodynamicsP"},
   {"InternalPotentialDensityP", "IPEP", "Field", "HydrodynamicsP"},
   {"TotalPotentialDensityP", "TPEP", "Field", "HydrodynamicsP"},
   {"TotalKineticDensityP", "TKEP", "Field", "HydrodynamicsP"},
   {"TotalEnergyDensityP", "TEDP", "Field", "HydrodynamicsP"}
};


(* ::Subsubsection::Closed:: *)
(*Bohmian Trajectories*)


$regTraj = {
   {"TrajectoryField", "XC", "Recursive", "BohmianTrajectories"},
   {"MomentumTrajectoryField", "PC", "Recursive", "BohmianTrajectories"},
   {"DensityC", "RHOC", "Field", "BohmianTrajectories"},
   {"VelocityC", "VC", "Field", "BohmianTrajectories"},
   {"QuantumPotentialC", "QPC", "Field", "BohmianTrajectories"},
   {"QuantumForceC", "QFC", "Field", "BohmianTrajectories"},
   {"ExternalPotentialX", "PEX", "Field", "BohmianTrajectories"},
   {"ExternalPotentialC", "PEC", "Field", "BohmianTrajectories"},
   {"ExternalForceX", "FEX", "Field", "BohmianTrajectories"},
   {"ExternalForceC", "FEC", "Field", "BohmianTrajectories"}
};


(* ::Subsubsection:: *)
(*Registry Assembly*)


$GWPRegistry = Join[
  $regStatic, $regDynamic, 
  $regWave, $regDens, 
  $regProb, $regExp, $regEng, 
  $regHydroExp, $regHydroX, $regHydroP, $regTraj
];

(* Clean up the builder variables to keep the Private namespace pristine *)
Clear[$regStatic, $regDynamic, $regWave, $regDens, $regProb, $regExp, $regEng, $regHydroExp, $regHydroX, $regHydroP, $regTraj];


(* ::Subsection::Closed:: *)
(*Map Builders*)


(* --- Map Builders & Type Verification --- *)
$GWPLongToShort = Association[#1 -> #2 & @@@ $GWPRegistry];
$GWPTypeMap = Association[#2 -> #3 & @@@ $GWPRegistry];

$GWPArchitectureClasses = GroupBy[$GWPRegistry, #[[3]] &, Map[#[[1]] &]];
$GWPPhysicsClasses = GroupBy[$GWPRegistry, #[[4]] &, Map[#[[1]] &]];
$GWPAllClasses = Join[$GWPArchitectureClasses, $GWPPhysicsClasses];

GWPTypeQ[key_, type_] := (Lookup[$GWPTypeMap, key, None] === type);


(* ::Subsection::Closed:: *)
(*Front-End Formatting*)


(* --- Object Formatting --- *)
$GWPLogo = Graphics[{
    Opacity[0.2], Blue, FilledCurve[BezierCurve[{{-1, 0}, {-0.5, 0}, {-0.2, 1}, {0, 1}, {0.2, 1}, {0.5, 0}, {1, 0}}]],
    Opacity[1], Thickness[0.08], Blue, Line[Table[{x, Exp[-4 x^2]}, {x, -1, 1, 0.05}]],
    Thickness[0.04], Darker[Cyan], Line[Table[{x, 0.2 Sin[15 x] Exp[-4 x^2] - 0.1}, {x, -0.8, 0.8, 0.02}]]
  }, ImageSize -> 32, PlotRange -> {{-1.1, 1.1}, {-0.3, 1.1}}];

GWPObject /: MakeBoxes[obj : GWPObject[data_], format_] := 
  BoxForm`ArrangeSummaryBox[
    "GWPObject", obj, $GWPLogo, 
    {"System: ", data["System"]}, 
    {{"Mass: ", data["Mass"]}, {"Hbar: ", data["Hbar"]}, {"Created: ", data["Created"]}}, 
    format
  ];


(* ::Subsection::Closed:: *)
(*GWPObject*)


(* --- Object Interface (Tier 1 & 2) --- *)
GWPObject[data_]["Properties"] := Sort[Join[Keys[data], Keys[$GWPLongToShort]]];
GWPObject[data_]["PropertyClasses"] := Sort[Keys[$GWPAllClasses]];

GWPObject[data_][prop_String] /; KeyExistsQ[data, prop] := data[prop];

GWPObject::invalidprop = "`1` is not a valid property, class, or data key. Try obj[\"Properties\"] or obj[\"PropertyClasses\"].";

GWPObject[data_][query_String, args___] := Module[{key},
  Which[
    (* 1. Is it a registered property? *)
    KeyExistsQ[$GWPLongToShort, query] || KeyExistsQ[$GWPTypeMap, query],
    key = Lookup[$GWPLongToShort, query, query];
    GWPPropertyDispatch[key, data, args],
    
    (* 2. Is it a property class? *)
    Length[{args}] == 0 && KeyExistsQ[$GWPAllClasses, query],
    Sort[$GWPAllClasses[query]],
    
    (* 3. Not found *)
    True,
    Message[GWPObject::invalidprop, query];
    $Failed
  ]
];


(* ::Subsection::Closed:: *)
(*Dispatch Engine*)


(* --- Signature Dispatching (Tier 3) --- *)
GWPPropertyDispatch[key_ /; GWPTypeQ[key, "Static"], data_, opts___] := 
  Symbol["GWP" <> key][data["Parameters"], opts];

GWPPropertyDispatch[key_ /; GWPTypeQ[key, "Recursive"], data_, n_Integer : 0] := 
  Function[{var, t}, Symbol["GWP" <> key][n][var][data["System"][t][data["Parameters"]]]];

GWPPropertyDispatch[key_ /; GWPTypeQ[key, "Moment"], data_, n_Integer : 1] := 
  Function[t, Symbol["GWP" <> key][n][data["System"][t][data["Parameters"]]]];

GWPPropertyDispatch[key_ /; GWPTypeQ[key, "Field"], data_] := 
  Function[{var, t}, Symbol["GWP" <> key][var][data["System"][t][data["Parameters"]]]];

GWPPropertyDispatch[key_ /; GWPTypeQ[key, "Bivariate"], data_] := 
  Function[{v1, v2, t}, Symbol["GWP" <> key][v1, v2][data["System"][t][data["Parameters"]]]];

GWPPropertyDispatch[key_ /; GWPTypeQ[key, "Temporal"], data_] := 
  Function[t, Symbol["GWP" <> key][data["System"][t][data["Parameters"]]]];


(* ::Section::Closed:: *)
(*Utilities*)


(* ::Subsection::Closed:: *)
(* SequenceSimplify*)


(* --- Dynamically catches trailing options and passes them to Simplify --- *)
SequenceSimplify[args___, opts : OptionsPattern[Simplify]] := Sequence @@ Simplify[{args}, opts];


(* ::Subsection::Closed:: *)
(*GWPUsageTable*)


(* --- Usage Table Utility --- *)
Options[GWPUsageTable] = Options[Dataset];

GWPUsageTable[symbs_List, opts:OptionsPattern[]] := Module[{datasetOpts},
  
  (* Safely extract Dataset options for perfect API symmetry *)
  datasetOpts = FilterRules[{opts}, Options[Dataset]];
  
  Dataset[
    Map[
      Function[sym,
        Module[{rawUsage},
          rawUsage = Quiet[Information[sym, "Usage"]];
          
          Association[
            "Name" -> ToString[sym],
            "Usage" -> If[StringQ[rawUsage],
              Pane[
                Column[StringSplit[rawUsage, "\n"], Alignment -> Left, Spacings -> 0.75],
                FrameMargins -> {{0, 0}, {10, 0}} (* {{left, right}, {bottom, top}} *)
              ],
              Style["No usage string defined.", Gray]
            ]
          ]
        ]
      ],
      symbs
    ],
    Sequence @@ datasetOpts,
    Alignment -> {Left, Top}, 
    ItemSize -> {Automatic, Automatic}
  ]
];


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
    OBJ = GWP[arg, opt, "SYSTEM" -> sys];
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


EndPackage[]

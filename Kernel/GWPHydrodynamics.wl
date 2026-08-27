(* ::Package:: *)

(* ::Title:: *)
(*GWPHydrodynamics Package*)


(* ::Section::Closed:: *)
(*GWPDeveloper Usage Registration*)


(* ::Subsection::Closed:: *)
(*BeginPackage*)


(* --- Open GWPDeveloper Package --- *)
BeginPackage["GWPTools`GWPDeveloper`"]


(* ::Subsection::Closed:: *)
(*Usage Statements*)


(* ::Subsubsection::Closed:: *)
(*Expectation Values*)


(* --- Hydrodynamic Expectation Values --- *)
GWPEIKE::usage = "GWPEIKE[param] evaluates the internal (quantum) kinetic energy expectation value.";
GWPECKE::usage = "GWPECKE[param] evaluates the convective (classical) kinetic energy expectation value.";
GWPEIPE::usage = "GWPEIPE[param] evaluates the internal potential energy expectation value.";
GWPECPE::usage = "GWPECPE[param] evaluates the convective potential energy expectation value.";


(* ::Subsubsection::Closed:: *)
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


(* ::Subsubsection::Closed:: *)
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


(* ::Subsubsection::Closed:: *)
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
(*End*)


(* --- Close GWPDeveloper Package --- *)
EndPackage[]
$ContextPath = DeleteCases[$ContextPath, "GWPTools`GWPDeveloper`"];


(* ::Section::Closed:: *)
(*BeginPackage*)


(* ========================================================================= *)
(* PACKAGE     : GWPTools`GWPHydrodynamics`                                  *)
(* DESCRIPTION : Quantum fluid dynamics, energy partitioning, and Bohmian    *)
(*               trajectories for the GWPTools framework.                    *)
(* ========================================================================= *)

(* IMPORTANT: Do NOT include a second-argument array here! *)
BeginPackage["GWPTools`GWPHydrodynamics`"]

Begin["`Private`"]

(* LOAD DEPENDENCIES INTERNALLY *)
(* These will be available for compilation, but automatically erased from *)
(* the user's $ContextPath when EndPackage[] is called at the bottom.   *)
Needs["GWPTools`GWPDeveloper`"];
Needs["GWPTools`GWPEngine`"];


(* ::Section::Closed:: *)
(*Expectation Values*)


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
(* Implements a pure algebraic coefficient recurrence to generate the   *)
(* nth-order polynomial factor without invoking calculus functions.     *)
GWPInverseGaussianEngine[n_Integer, uVal_] := Module[{coeffs, nextCoeffs, deg},
  (* Base case n=1: P_1 = 1 *)
  coeffs = {1};
  
  Do[
    deg = Length[coeffs] - 1;
    (* The next polynomial has degree deg + 1 *)
    nextCoeffs = ConstantArray[0, deg + 2];
    
    (* Apply the algebraic coefficient mapping *)
    Do[
      (* Derivative contribution: (k+1)*C_{i-1, k+1} *)
      If[k + 1 <= deg, 
        nextCoeffs[[k + 1]] += (k + 1) * coeffs[[k + 2]]
      ];
      (* Shift contribution: 2*(i-1)*C_{i-1, k-1} *)
      If[k - 1 >= 0,
        nextCoeffs[[k + 1]] += 2 * (i - 1) * coeffs[[k]]
      ];
    , {k, 0, deg + 1}];
    
    coeffs = nextCoeffs;
  , {i, 2, n}];
  
  (* Reconstruct polynomial using Horner's method for perfect listability *)
  Fold[(#1 * uVal + #2) &, 0, Reverse[coeffs]]
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
    
    (* Explicit algebraic summation guarantees perfect listability *)
    V1 * xDerivs[[n + 1]] + V2 * x2Deriv
  ]
];

(* Fallback: Route GWPPEC[c][...] to the 0th derivative *)
GWPPEC[c_][arg___] /; !MatchQ[Unevaluated[GWPPEC[c]], GWPPEC[_Integer]] := GWPPEC[0][c][arg];


(* --- External Force in C-Space (Chain Rule: d^n/dc^n) --- *)
GWPFEC[0][c_][GWPARG] = GWPFEX[0][GWPXC[0][c][GWPVAL]][GWPVAL];

With[{VAL = GWPVAL},
  GWPFEC[n_Integer /; n > 0][c_][GWPARG] := 
    (* Explicit algebraic multiplication guarantees perfect listability *)
    -2 * V2 * GWPXC[n][c][VAL]
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
(*GWPObject Registry*)


$regHydroExp = Append[#, "ExpectationValues"] & /@ {
  {"InternalKineticEnergyExpectation",     "EIKE", "Temporal", "StaticValue"},
  {"ConvectiveKineticEnergyExpectation",   "ECKE", "Temporal", "StaticValue"},
  {"InternalPotentialEnergyExpectation",   "EIPE", "Temporal", None},
  {"ConvectivePotentialEnergyExpectation", "ECPE", "Temporal", None}
};

$regHydroX = Append[#, "HydrodynamicsX"] & /@ {
  {"AmplitudeX",                "AX",   "Field",     "Spatial"},
  {"PhaseX",                    "SX",   "Field",     "Spatial"},
  {"MomentumFieldX",            "PX",   "Field",     "Spatial"},
  {"VelocityX",                 "VX",   "Field",     "Spatial"},
  {"OsmoticVelocityX",          "OVX",  "Field",     "Spatial"},
  {"CurrentX",                  "JX",   "Field",     "Spatial"},
  {"QuantumPotentialX",         "QPX",  "Field",     "Spatial"},
  {"QuantumForceX",             "QFX",  "Field",     "Spatial"},
  {"QuantumStressX",            "QSX",  "Field",     "Spatial"},
  {"FisherInformationDensityX", "FIX",  "Field",     "Spatial"},
  {"ConvectiveKineticDensityX", "CKEX", "Field",     "Spatial"},
  {"InternalKineticDensityX",   "IKEX", "Field",     "Spatial"},
  {"TotalKineticDensityX",      "TKEX", "Field",     "Spatial"},
  {"TotalPotentialDensityX",    "TPEX", "Field",     None},
  {"TotalEnergyDensityX",       "TEDX", "Field",     None}
};

$regHydroP = Append[#, "HydrodynamicsP"] & /@ {
  {"AmplitudeP",                  "AP",   "Field", "Spatial"},
  {"PhaseP",                      "SP",   "Field", "Spatial"},
  {"PositionFieldP",              "XP",   "Field", "Spatial"},
  {"ForceFlowP",                  "VP",   "Field", "Spatial"},
  {"OsmoticFlowP",                "OVP",  "Field", "Spatial"},
  {"CurrentP",                    "JP",   "Field", "Spatial"},
  {"QuantumPotentialP",           "QPP",  "Field", "Spatial"},
  {"QuantumForceP",               "QFP",  "Field", "Spatial"},
  {"QuantumStressP",              "QSP",  "Field", "Spatial"},
  {"FisherInformationDensityP",   "FIP",  "Field", "Spatial"},
  {"ConvectivePotentialDensityP", "CPEP", "Field", None},
  {"InternalPotentialDensityP",   "IPEP", "Field", None},
  {"TotalPotentialDensityP",      "TPEP", "Field", None},
  {"TotalKineticDensityP",        "TKEP", "Field", "Spatial"},
  {"TotalEnergyDensityP",         "TEDP", "Field", None}
};

$regTraj = Append[#, "BohmianTrajectories"] & /@ {
  {"TrajectoryField",             "XC",   "Recursive", "RecursiveSpatial"},
  {"MomentumTrajectoryField",     "PC",   "Recursive", "RecursiveSpatial"},
  {"AmplitudeC",                  "AC",   "Field",     "Spatial"},
  {"PhaseC",                      "SC",   "Field",     "Spatial"},
  {"DensityC",                    "RHOC", "Field",     "Spatial"},
  {"VelocityC",                   "VC",   "Field",     "Spatial"},
  {"OsmoticVelocityC",            "OVC",  "Field",     "Spatial"},
  {"CurrentC",                    "JC",   "Field",     "Spatial"},
  {"QuantumPotentialC",           "QPC",  "Field",     "Spatial"},
  {"QuantumForceC",               "QFC",  "Field",     "Spatial"},
  {"ExternalPotentialC",          "PEC",  "Recursive", None},   
  {"ExternalForceC",              "FEC",  "Recursive", None},   
  {"QuantumStressC",              "QSC",  "Field",     "Spatial"},
  {"FisherInformationDensityC",   "FIC",  "Field",     "Spatial"},
  {"ConvectiveKineticDensityC",   "CKEC", "Field",     "Spatial"},
  {"InternalKineticDensityC",     "IKEC", "Field",     "Spatial"},
  {"TotalKineticDensityC",        "TKEC", "Field",     "Spatial"},
  {"TotalPotentialDensityC",      "TPEC", "Field",     None},
  {"TotalEnergyDensityC",         "TEDC", "Field",     None}
};


(* Export the combined chunk to the package context so GWPTools can find it *)
GWPTools`GWPHydrodynamics`$GWPHydroRegistry = Join[$regHydroX, $regHydroP, $regTraj, $regHydroExp];

(* The Hook: Dynamically inject this registry into the Object *)
If[TrueQ[GWPTools`Private`$DispatcherActive],
  GWPTools`Private`GWPRegisterExtension[GWPTools`GWPHydrodynamics`$GWPHydroRegistry]
];


(* ::Section::Closed:: *)
(*End*)


(* --- End "GWPTools`GWPHydrodynamics`Private`" --- *)
End[];

(* Hide internal code from the ? menu *)
SetAttributes[Evaluate[Names["GWPTools`GWPHydrodynamics`*"]], {ReadProtected}];

(* --- End "GWPTools`GWPHydrodynammics`" --- *)
EndPackage[]

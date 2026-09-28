(* ::Package:: *)

(* ::Title:: *)
(*GWPHydrodynamics1D Package*)


(* ::Section:: *)
(*GWPDeveloper Usage Declarations*)


(* ::Subsection:: *)
(*BeginPackage*)


Needs["GWPTools`GWPDeveloper`"];
BeginPackage["GWPTools`GWPDeveloper`"]
If[TrueQ[Global`$GWPDebug], Print["[GWPHydrodynamics1D] BeginPackage GWPDeveloper"]];
Off[General::shdw];


(* ::Subsection::Closed:: *)
(*Usage Declarations*)


(* ::Subsubsection::Closed:: *)
(*Hydrodynamic Expectation Values*)


(* --- Expectation Values --- *)
GWP1DEIKE::usage = "GWP1DEIKE[param] evaluates the internal (quantum) kinetic energy expectation value.";
GWP1DECKE::usage = "GWP1DECKE[param] evaluates the convective (classical) kinetic energy expectation value.";
GWP1DEIPE::usage = "GWP1DEIPE[param] evaluates the internal potential energy expectation value.";
GWP1DECPE::usage = "GWP1DECPE[param] evaluates the convective potential energy expectation value.";


(* --- Fisher Information --- *)
GWP1DEFIX::usage = "GWP1DEFIX[param] evaluates the x-space Fisher information.";
GWP1DEFIP::usage = "GWP1DEFIP[param] evaluates the p-space Fisher information.";


(* ::Subsubsection::Closed:: *)
(*x-Space Hydrodynamic Fields*)


(* --- x-Space Hydrodynamic Fields --- *)
GWP1DJX::usage = "GWP1DJX[x][param] evaluates the x-space probability current density.";
GWP1DAX::usage = "GWP1DAX[x][param] evaluates the x-space real-valued amplitude.";
GWP1DSX::usage = "GWP1DSX[x][param] evaluates the x-space real-valued phase function.";
GWP1DPX::usage = "GWP1DPX[x][param] evaluates the x-space momentum field.";
GWP1DVX::usage = "GWP1DVX[x][param] evaluates the x-space velocity flow field.";
GWP1DOVX::usage = "GWP1DOVX[x][param] evaluates the x-space osmotic velocity field.";
GWP1DQPX::usage = "GWP1DQPX[x][param] evaluates the x-space quantum potential.";
GWP1DQFX::usage = "GWP1DQFX[x][param] evaluates the x-space quantum force.";
GWP1DQSX::usage = "GWP1DQSX[x][param] evaluates the x-space quantum stress density.";

(* --- x-Space Information and Energy Densities --- *)
GWP1DFIX::usage = "GWP1DFIX[x][param] evaluates the x-space Fisher information density.";
GWP1DCKEX::usage = "GWP1DCKEX[x][param] evaluates the x-space convective kinetic energy density.";
GWP1DIKEX::usage = "GWP1DIKEX[x][param] evaluates the x-space internal kinetic energy density.";
GWP1DTKEX::usage = "GWP1DTKEX[x][param] evaluates the x-space total kinetic energy density.";
GWP1DTPEX::usage = "GWP1DTPEX[x][param] evaluates the x-space total potential energy density.";
GWP1DTEDX::usage = "GWP1DTEDX[x][param] evaluates the x-space total energy density.";


(* ::Subsubsection::Closed:: *)
(*p-Space Hydrodynamic Fields*)


(* --- p-Space Hydrodynamic Fields --- *)
GWP1DAP::usage = "GWP1DAP[p][param] evaluates the p-space real-valued amplitude.";
GWP1DSP::usage = "GWP1DSP[p][param] evaluates the p-space real-valued phase function.";
GWP1DXP::usage = "GWP1DXP[p][param] evaluates the p-space position field.";
GWP1DVP::usage = "GWP1DVP[p][param] evaluates the p-space force flow field.";
GWP1DOVP::usage = "GWP1DOVP[p][param] evaluates the p-space osmotic flow field.";
GWP1DJP::usage = "GWP1DJP[p][param] evaluates the p-space probability current density.";
GWP1DQPP::usage = "GWP1DQPP[p][param] evaluates the p-space internal potential.";
GWP1DQFP::usage = "GWP1DQFP[p][param] evaluates the p-space internal force.";
GWP1DQSP::usage = "GWP1DQSP[p][param] evaluates the p-space quantum stress density.";

(* --- p-Space Information and Energy Densities --- *)
GWP1DFIP::usage = "GWP1DFIP[p][param] evaluates the p-space Fisher information density.";
GWP1DCPEP::usage = "GWP1DCPEP[p][param] evaluates the p-space convective potential energy density.";
GWP1DIPEP::usage = "GWP1DIPEP[p][param] evaluates the p-space internal potential energy density.";
GWP1DTPEP::usage = "GWP1DTPEP[p][param] evaluates the p-space total potential energy density.";
GWP1DTKEP::usage = "GWP1DTKEP[p][param] evaluates the p-space total kinetic energy density.";
GWP1DTEDP::usage = "GWP1DTEDP[p][param] evaluates the p-space total energy density.";


(* ::Subsubsection::Closed:: *)
(*Bohmian Trajectories*)


(* --- Bohmian Trajectories --- *)
GWP1DInverseGaussianEngine::usage = "GWP1DInverseGaussianEngine[n, u] generates the nth-order polynomial factor for the Bohmian cumulative coordinate mappings.";
GWP1DXC::usage = "GWP1DXC[c][param] evaluates the C-space x-trajectory field.";
GWP1DPC::usage = "GWP1DPC[c][param] evaluates the C-space p-trajectory field.";

(* --- C-Space Fields --- *)
GWP1DRHOC::usage = "GWP1DRHOC[c][param] evaluates the C-space probability density.";
GWP1DJC::usage   = "GWP1DJC[c][param] evaluates the C-space probability current density.";
GWP1DAC::usage   = "GWP1DAC[c][param] evaluates the C-space amplitude.";
GWP1DSC::usage   = "GWP1DSC[c][param] evaluates the C-space phase.";
GWP1DVC::usage   = "GWP1DVC[c][param] evaluates the C-space velocity field.";
GWP1DOVC::usage  = "GWP1DOVC[c][param] evaluates the C-space osmotic velocity.";
GWP1DQSC::usage  = "GWP1DQSC[c][param] evaluates the C-space quantum stress.";
GWP1DQPC::usage  = "GWP1DQPC[c][param] evaluates the C-space quantum potential.";
GWP1DQFC::usage  = "GWP1DQFC[c][param] evaluates the C-space quantum force.";
GWP1DPEC::usage  = "GWP1DPEC[c][param] evaluates the C-space external potential.";
GWP1DFEC::usage  = "GWP1DFEC[c][param] evaluates the C-space external force.";
GWP1DFIC::usage  = "GWP1DFIC[c][param] evaluates the C-space Fisher information density.";
GWP1DCKEC::usage = "GWP1DCKEC[c][param] evaluates the C-space convective kinetic energy density.";
GWP1DIKEC::usage = "GWP1DIKEC[c][param] evaluates the C-space internal kinetic energy density.";
GWP1DTKEC::usage = "GWP1DTKEC[c][param] evaluates the C-space total kinetic energy density.";
GWP1DTPEC::usage = "GWP1DTPEC[c][param] evaluates the C-space total potential energy density.";
GWP1DTEDC::usage = "GWP1DTEDC[c][param] evaluates the C-space total energy density.";


(* ::Subsection::Closed:: *)
(*End*)


Off[General::shdw];

If[TrueQ[Global`$GWPDebug], Print["[GWPHydrodynamics1D] EndPackage GWPDeveloper"]];

Quiet[EndPackage[], General::shdw]

(* Scrub the Developer context from the global path immediately *)
$ContextPath = DeleteCases[$ContextPath, "GWPTools`GWPDeveloper`"];


(* ::Section::Closed:: *)
(*BeginPackage*)


(* ========================================================================= *)
(* PACKAGE     : GWPTools`GWPHydrodynamics1D`                                *)
(* DESCRIPTION : 1D Quantum fluid dynamics, energy partitioning, and Bohmian *)
(*               trajectories for the GWPTools framework.                    *)
(* ========================================================================= *)
BeginPackage["GWPTools`GWPHydrodynamics1D`"]
If[TrueQ[Global`$GWPDebug], Print["[GWPHydrodynamics1D] BeginPackage"]];
Begin["`Private`"]
If[TrueQ[Global`$GWPDebug], Print["[GWPHydrodynamics1D] Begin Private"]];

Needs["GWPTools`GWPDeveloper`"];
Needs["GWPTools`GWPRegistry`"];
Needs["GWPTools`GWPEngine1D`"];


(* ::Section::Closed:: *)
(*Hydrodynamic Expectation Values*)


(* --- Expectation Values --- *)
GWP1DEIKE[GWP1DARG] = (HBAR^2*RA)/(2*MASS);
GWP1DECKE[GWP1DARG] = (HBAR^2*IA^2 + RA*RP^2)/(2*MASS*RA);
GWP1DEIPE[GWP1DARG] = (RA*V2)/(4*(IA^2 + RA^2));
GWP1DECPE[GWP1DARG] = (4*RA^3*(V0 + RX*(V1 + RX*V2)) + IA^2*(V2 + 4*RA*(V0 + RX*(V1 + RX*V2))))/(4*RA*(IA^2 + RA^2));


(* --- Fisher Information ---*)
GWP1DEFIX[GWP1DARG] = 4*RA;
GWP1DEFIP[GWP1DARG] = RA/(HBAR^2*(IA^2 + RA^2));


(* ::Section::Closed:: *)
(*x-Space Hydrodynamic Fields*)


(* --- x-Space Fields --- *)
GWP1DAX[x_][GWP1DARG] = (2/Pi*RA)^(1/4)*Exp[-RA*(x-RX)^2];
GWP1DSX[x_][GWP1DARG] = -HBAR*IA*(x-RX)^2 + RP*(x-RX) + RG;
GWP1DPX[x_][GWP1DARG] = RP - 2*HBAR*IA*(x-RX);
GWP1DVX[x_][GWP1DARG]  = (RP - 2*HBAR*IA*(x-RX))/MASS;
GWP1DOVX[x_][GWP1DARG] = (-2*HBAR*RA*(-RX + x))/MASS;
GWP1DJX[x_][GWP1DARG]  = (2/Pi*RA)^(1/2)*Exp[-2*RA*(x-RX)^2]*(RP - 2*HBAR*IA*(x-RX))/MASS;
GWP1DQPX[x_][GWP1DARG] = HBAR^2/MASS*RA*(1 - 2*RA*(x-RX)^2);
GWP1DQFX[x_][GWP1DARG] = 4*HBAR^2/MASS*RA^2*(x-RX);
GWP1DQSX[x_][GWP1DARG] = -((HBAR^2*Sqrt[2/Pi]*RA^(3/2))/(E^(2*RA*(RX - x)^2)*MASS));
GWP1DFIX[x_][GWP1DARG]  = (16*Sqrt[2/Pi]*RA^(5/2)*(RX - x)^2)/E^(2*RA*(RX - x)^2);

GWP1DIKEX[x_][GWP1DARG] = (2*HBAR^2*Sqrt[2/Pi]*RA^(5/2)*(RX - x)^2)/(E^(2*RA*(RX - x)^2)*MASS);
GWP1DCKEX[x_][GWP1DARG] = (Sqrt[RA]*(RP - 2*HBAR*IA*(-RX + x))^2)/(E^(2*RA*(-RX + x)^2)*MASS*Sqrt[2*Pi]);
GWP1DTPEX[x_][GWP1DARG] = (Sqrt[2/Pi]*Sqrt[RA]*(V0 + x*(V1 + V2*x)))/E^(2*RA*(RX - x)^2);
GWP1DTKEX[x_][GWP1DARG] = (Sqrt[RA]*(RP^2 + 4*HBAR*IA*RP*(RX - x) + 4*HBAR^2*(IA^2 + RA^2)*(RX - x)^2))/(E^(2*RA*(RX - x)^2)*MASS*Sqrt[2*Pi]);
GWP1DTEDX[x_][GWP1DARG] = (Sqrt[RA]*(RP^2 + 4*HBAR*IA*RP*(RX - x) + 4*HBAR^2*(IA^2 + RA^2)*(RX - x)^2 + 2*MASS*(V0 + x*(V1 + V2*x))))/(E^(2*RA*(RX - x)^2)*MASS*Sqrt[2*Pi]);


(* ::Section::Closed:: *)
(*p-Space Hydrodynamic Fields*)


(* --- p-Space Fields --- *)
GWP1DAP[p_][GWP1DARG] = (RA^(1/4)*Exp[-(RA*(p - RP)^2)/(4*HBAR^2*(RA^2 + IA^2))])/((2*Pi)^(1/4)*Sqrt[HBAR]*(RA^2 + IA^2)^(1/4));
GWP1DSP[p_][GWP1DARG] = RG - p*RX + (IA*(p - RP)^2)/(4*HBAR*(RA^2 + IA^2)) - (HBAR/2)*ArcTan[RA, IA];
GWP1DXP[p_][GWP1DARG] = RX - (IA*(p - RP))/(2*HBAR*(IA^2 + RA^2));

GWP1DVP[p_][GWP1DARG]  = -V1 - 2*V2*(RX - (IA*(p - RP))/(2*HBAR*(IA^2 + RA^2)));
GWP1DOVP[p_][GWP1DARG] = -((RA*(p - RP)*V2)/(HBAR*(IA^2 + RA^2)));
GWP1DJP[p_][GWP1DARG]  = (-V1 + (IA*(p - RP)*V2)/(HBAR*(IA^2 + RA^2)) - 2*RX*V2)/(E^((RA*(p - RP)^2)/(2*HBAR^2*(IA^2 + RA^2)))*Sqrt[2*Pi]*Sqrt[(HBAR^2*(IA^2 + RA^2))/RA]);
GWP1DQPP[p_][GWP1DARG] = (RA*(2*HBAR^2*(IA^2 + RA^2) - RA*(p - RP)^2)*V2)/(4*HBAR^2*(IA^2 + RA^2)^2);
GWP1DQFP[p_][GWP1DARG] = (RA^2*(p - RP)*V2)/(2*HBAR^2*(IA^2 + RA^2)^2);
GWP1DQSP[p_][GWP1DARG] = -1/2*(RA^(3/2)*V2)/(E^((RA*(p - RP)^2)/(2*HBAR^2*(IA^2 + RA^2)))*HBAR*Sqrt[2*Pi]*(IA^2 + RA^2)^(3/2));
GWP1DFIP[p_][GWP1DARG]  = ((RA/(IA^2 + RA^2))^(5/2)*(p - RP)^2)/(E^((RA*(p - RP)^2)/(2*HBAR^2*(IA^2 + RA^2)))*HBAR^5*Sqrt[2*Pi]);

GWP1DIPEP[p_][GWP1DARG] = ((RA/(IA^2 + RA^2))^(5/2)*(p - RP)^2*V2)/(4*E^((RA*(p - RP)^2)/(2*HBAR^2*(IA^2 + RA^2)))*HBAR^3*Sqrt[2*Pi]);
GWP1DCPEP[p_][GWP1DARG] = (V0 + ((IA*(-p + RP))/(2*HBAR*(IA^2 + RA^2)) + RX)*V1 + ((IA*(-p + RP))/(2*HBAR*(IA^2 + RA^2)) + RX)^2*V2)/(E^((RA*(p - RP)^2)/(2*HBAR^2*(IA^2 + RA^2)))*Sqrt[2*Pi]*Sqrt[(HBAR^2*(IA^2 + RA^2))/RA]);
GWP1DTKEP[p_][GWP1DARG] = (E^((-2*IG)/HBAR - (RA*(p - RP)^2)/(2*HBAR^2*(IA^2 + RA^2)))*p^2*Sqrt[RA])/ (2*HBAR*MASS*Sqrt[2*Pi]*Sqrt[IA^2 + RA^2]);
GWP1DTPEP[p_][GWP1DARG] = (Sqrt[RA]*((p - RP)^2*V2 - 2*HBAR*IA*(p - RP)*(V1 + 2*RX*V2) + 4*HBAR^2*(IA^2 + RA^2)*(V0 + RX*(V1 + RX*V2))))/(4*E^((RA*(p - RP)^2)/(2*HBAR^2*(IA^2 + RA^2)))*HBAR^3*Sqrt[2*Pi]*(IA^2 + RA^2)^(3/2));
GWP1DTEDP[p_][GWP1DARG] = ((2*p^2*Sqrt[RA/(IA^2 + RA^2)])/(E^((2*IG)/HBAR)*HBAR*MASS) + (Sqrt[RA]*((p - RP)^2*V2 - 2*HBAR*IA*(p - RP)*(V1 + 2*RX*V2) + 4*HBAR^2*(IA^2 + RA^2)*(V0 + RX*(V1 + RX*V2))))/(HBAR^3*(IA^2 + RA^2)^(3/2)))/(4*E^((RA*(p - RP)^2)/(2*HBAR^2*(IA^2 + RA^2)))*Sqrt[2*Pi]);


(* ::Section::Closed:: *)
(*Bohmian Trajectories*)


(* --- Inverse Gaussian Recurrence --- *)
GWP1DInverseGaussianEngine[n_Integer, uVal_] := Module[{coeffs, nextCoeffs, deg},
  coeffs = {1};
  Do[
    deg = Length[coeffs] - 1;
    nextCoeffs = ConstantArray[0, deg + 2];
    Do[
      If[k + 1 <= deg, nextCoeffs[[k + 1]] += (k + 1) * coeffs[[k + 2]]];
      If[k - 1 >= 0, nextCoeffs[[k + 1]] += 2 * (i - 1) * coeffs[[k]]];
    , {k, 0, deg + 1}];
    coeffs = nextCoeffs;
  , {i, 2, n}];
  Fold[(#1 * uVal + #2) &, 0, Reverse[coeffs]]
];

(* --- C-Space Trajectories --- *)
GWP1DXC[0][c_][GWP1DARG] := RX + (1 / Sqrt[2*RA]) * InverseErf[2*c - 1];
GWP1DXC[n_Integer /; n > 0][c_][GWP1DARG] := Module[{u, dudz, poly},
  u = InverseErf[2*c - 1];
  dudz = (Sqrt[Pi]/2) * Exp[u^2];
  poly = GWP1DInverseGaussianEngine[n, u]; 
  poly * (2^n / Sqrt[2*RA]) * (dudz^n)
];
GWP1DXC[c_][arg___] /; !MatchQ[Unevaluated[GWP1DXC[c]], GWP1DXC[_Integer]] := GWP1DXC[0][c][arg];

GWP1DPC[0][c_][GWP1DARG] := RP + HBAR * Sqrt[2] * Sqrt[IA^2/RA + RA] * InverseErf[2*c - 1];
GWP1DPC[n_Integer /; n > 0][c_][GWP1DARG] := Module[{u, dudz, coeffP, poly},
  u = InverseErf[2*c - 1];
  dudz = (Sqrt[Pi]/2) * Exp[u^2];
  coeffP = HBAR * Sqrt[2] * Sqrt[IA^2/RA + RA];
  poly = GWP1DInverseGaussianEngine[n, u];
  poly * (2^n * coeffP) * (dudz^n)
];
GWP1DPC[c_][arg___] /; !MatchQ[Unevaluated[GWP1DPC[c]], GWP1DPC[_Integer]] := GWP1DPC[0][c][arg];



(* --- C-Space Hydrodynamic Fields --- *)
GWP1DRHOC[c_][GWP1DARG] = Sqrt[2*RA/Pi] * Exp[-InverseErf[2*c - 1]^2];
GWP1DJC[c_][GWP1DARG]   = Sqrt[2*RA/Pi] * Exp[-InverseErf[2*c - 1]^2] * (RP - (2*HBAR*IA / Sqrt[2*RA]) * InverseErf[2*c - 1]) / MASS;
GWP1DAC[c_][GWP1DARG] = ((2/Pi)^(1/4)*RA^(1/4))/E^(InverseErf[-1 + 2*c]^2/2);
GWP1DSC[c_][GWP1DARG] = RG + (RP*InverseErf[-1 + 2*c])/(Sqrt[2]*Sqrt[RA]) - (HBAR*IA*InverseErf[-1 + 2*c]^2)/(2*RA);
GWP1DVC[c_][GWP1DARG]   = (RP - (2*HBAR*IA / Sqrt[2*RA]) * InverseErf[2*c - 1]) / MASS;
GWP1DOVC[c_][GWP1DARG] = -((Sqrt[2]*HBAR*Sqrt[RA]*InverseErf[-1 + 2*c])/MASS);
GWP1DQSC[c_][GWP1DARG] = -((HBAR^2*Sqrt[2/Pi]*RA^(3/2))/(E^InverseErf[-1 + 2*c]^2*MASS));
GWP1DQPC[c_][GWP1DARG]  = (RA*HBAR^2 * (1 - InverseErf[2*c - 1]^2)) / MASS;
GWP1DQFC[c_][GWP1DARG]  = ((2*RA)^(3/2) * HBAR^2 * InverseErf[2*c - 1]) / MASS;
GWP1DFIC[c_][GWP1DARG] = (8*Sqrt[2/Pi]*RA^(3/2)*InverseErf[-1 + 2*c]^2)/E^InverseErf[-1 + 2*c]^2;

GWP1DPEC[0][c_][GWP1DARG] = GWP1DPEX[0][GWP1DXC[0][c][GWP1DVAL]][GWP1DVAL];
With[{VAL = GWP1DVAL},
  GWP1DPEC[n_Integer /; n > 0][c_][GWP1DARG] := Module[{xDerivs, x2Deriv},
    xDerivs = Table[GWP1DXC[k][c][VAL], {k, 0, n}];  
    x2Deriv = Sum[Binomial[n, k] * xDerivs[[k + 1]] * xDerivs[[n - k + 1]], {k, 0, n}];   
    V1 * xDerivs[[n + 1]] + V2 * x2Deriv
  ]
];
GWP1DPEC[c_][arg___] /; !MatchQ[Unevaluated[GWP1DPEC[c]], GWP1DPEC[_Integer]] := GWP1DPEC[0][c][arg];

GWP1DFEC[0][c_][GWP1DARG] = GWP1DFEX[0][GWP1DXC[0][c][GWP1DVAL]][GWP1DVAL];
With[{VAL = GWP1DVAL},
  GWP1DFEC[n_Integer /; n > 0][c_][GWP1DARG] := -2 * V2 * GWP1DXC[n][c][VAL]
];
GWP1DFEC[c_][arg___] /; !MatchQ[Unevaluated[GWP1DFEC[c]], GWP1DFEC[_Integer]] := GWP1DFEC[0][c][arg];

GWP1DCKEC[c_][GWP1DARG] = (Sqrt[RA]*(RP - (Sqrt[2]*HBAR*IA*InverseErf[-1 + 2*c])/Sqrt[RA])^2)/(E^InverseErf[-1 + 2*c]^2*MASS*Sqrt[2*Pi]);
GWP1DIKEC[c_][GWP1DARG] = (HBAR^2*Sqrt[2/Pi]*RA^(3/2)*InverseErf[-1 + 2*c]^2)/(E^InverseErf[-1 + 2*c]^2*MASS);
GWP1DTKEC[c_][GWP1DARG] = (RA*RP^2 - 2*Sqrt[2]*HBAR*IA*Sqrt[RA]*RP*InverseErf[-1 + 2*c] + 2*HBAR^2*(IA^2 + RA^2)*InverseErf[-1 + 2*c]^2)/(E^InverseErf[-1 + 2*c]^2*MASS*Sqrt[2*Pi]*Sqrt[RA]);
GWP1DTPEC[c_][GWP1DARG] = (2*RA*(V0 + RX*(V1 + RX*V2)) + Sqrt[2]*Sqrt[RA]*(V1 + 2*RX*V2)*InverseErf[-1 + 2*c] + V2*InverseErf[-1 + 2*c]^2)/(E^InverseErf[-1 + 2*c]^2*Sqrt[2*Pi]*Sqrt[RA]);
GWP1DTEDC[c_][GWP1DARG] = (RA*(RP^2 + 2*MASS*(V0 + RX*(V1 + RX*V2))) + Sqrt[2]*Sqrt[RA]*(-2*HBAR*IA*RP + MASS*(V1 + 2*RX*V2))*InverseErf[-1 + 2*c] + (2*HBAR^2*(IA^2 + RA^2) + MASS*V2)*InverseErf[-1 + 2*c]^2)/(E^InverseErf[-1 + 2*c]^2*MASS*Sqrt[2*Pi]*Sqrt[RA]);


(* ::Section::Closed:: *)
(*GWPObject Registration*)


(* --- GWPObject Registry (1D Hydrodynamics) --- *)
$regHydroExp1D = Join[#, {"ExpectationValues", "1D"}] & /@ {
  {"InternalKineticEnergyExpectation",     "EIKE", "Temporal", "StaticValue"},
  {"ConvectiveKineticEnergyExpectation",   "ECKE", "Temporal", "StaticValue"},
  {"InternalPotentialEnergyExpectation",   "EIPE", "Temporal", None},
  {"ConvectivePotentialEnergyExpectation", "ECPE", "Temporal", None},
  {"FisherInformationX",                   "EFIX", "Temporal", "StaticValue"},
  {"FisherInformationP",                   "EFIP", "Temporal", "StaticValue"}
};

$regHydroX1D = Join[#, {"HydrodynamicsX", "1D"}] & /@ {
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

$regHydroP1D = Join[#, {"HydrodynamicsP", "1D"}] & /@ {
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

$regTraj1D = Join[#, {"BohmianTrajectories", "1D"}] & /@ {
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

GWPTools`GWPRegistry`GWPRegisterExtension[Join[$regHydroExp1D, $regHydroX1D, $regHydroP1D, $regTraj1D]];


(* ::Section::Closed:: *)
(*End*)


(* --- End "GWPTools`GWPHydrodynammics1D`Private`" --- *)

If[TrueQ[Global`$GWPDebug], Print["[GWPHydrodynamics1D] End Private"]];
End[]

(* Hide internal code for all Developer functions from the ? menu *)
SetAttributes[Evaluate[Names["GWPTools`GWPHydrodynamics1D`*"]], {ReadProtected}];

(* --- End "GWPTools`GWPHydrodynamics1D`" --- *)
If[TrueQ[Global`$GWPDebug], Print["[GWPHydrodynamics1D] EndPackage"]];
EndPackage[]

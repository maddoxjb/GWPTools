# GWPTools

> **Notice:** Active development for **GWPTools** has moved to the **MaddoxScience** organization. For the latest releases, paclet builds, and active codebase, please visit:
> 
> 👉 **[github.com/MaddoxScience/GWPTools](https://github.com/MaddoxScience/GWPTools)**

---

## Overview

**GWPTools** is an extensible symbolic-numeric Wolfram Language framework designed for exact time-dependent Gaussian Wave Packet (GWP) dynamics. It provides a high-level, object-oriented interface for simulating wavepacket propagation, hydrodynamics, phase-space dynamics, and structured ensemble generation across 1D and multi-dimensional systems.

This repository represents the initial code state and historical provenance for the software submitted to *Computer Physics Communications* (CPC).

---

## Key Features

* **Master Object Interface:** Unified constructor (`GWP`) and wavepacket container (`GWPObject`) for defining and manipulating quantum states.
* **Exact Math Engines:** High-performance, exact symbolic/numeric propagation engines including `GWPEngine1D`, `GWPEngine2D`, `GWPEngineSS1D`, `GWPEngineMC1D`, and `GWPEngineRDM1D`.
* **Hydrodynamics & Phase Space:** Integrated tools for calculating Bohmian trajectories, quantum potential, density fields, and phase-space representation functions.
* **Ensemble Generation:** Automated sampling tools (`GWPEnsemble`) for coordinate, momentum, and phase-space grid generation.
* **Encapsulated Developer API:** Advanced developer mode (`GWPDeveloper`) providing direct access to low-level parameter transformation functions and numerical backend routines.

---

## Academic Citation & CPC Paper

If you use **GWPTools** in your research, please cite the framework paper submitted to *Computer Physics Communications*:

```bibtex
@article{Maddox2026GWPTools,
  title   = {GWPTools: An Extensible Symbolic-Numeric Framework for Exact Time-Dependent Gaussian Wave Packet Dynamics},
  author  = {Maddox, Jeremy B. and Giliani, Ismail and Heck, Carter M. and Mattingly, Connor S.},
  journal = {Computer Physics Communications},
  note    = {Submitted / In Review},
  year    = {2026}
}

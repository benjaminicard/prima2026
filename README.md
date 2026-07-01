# Formalizing the Moral Evaluation of Speech Acts: Truthfulness, Lies and Ethical Dilemmas

This repository accompanies our paper submission to **PRIMA 2026** ([conference website](https://www.prima2026.org)).

It provides a Python-driven implementation of an Answer Set Programming (ASP) framework (via **Clingo** and **Clyngor**) to model and evaluate speech acts in high-stakes ethical scenarios. Using Sartre’s *The Wall* (1939) as a running case, the framework integrates major moral theories—**deontologism**, **principialism** (v1 and v2), and **consequentialism** (two utility variants)—to assess the permissibility of speech acts based on (i) the speaker’s honesty/dishonesty, (ii) the objective truth-value of the utterance, (iii) moral motives, and (iv) outcomes for third parties.

## Table of Contents
- [Overview](#overview)
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Interpreting the Output](#interpreting-the-output)
- [Code Structure](#code-structure)

## Overview

Ethical dilemmas extend beyond physical actions to **verbal** actions—lying, truth-telling, withholding information. Our ASP framework formalizes these as actions with intentions, truth conditions, and consequences, then evaluates them under different moral theories.

**Case study — Sartre’s *The Wall*.** Pablo Ibbieta is interrogated about Ramon Gris’s location. He lies twice: the first lie inadvertently protects Ramon; the second, **a truthful utterance spoken as a lie**, leads to Ramon’s death. The contrast illustrates how **intentions**, **truthfulness**, and **consequences** interact—ideal for a computational ethics analysis.

## Features

- **ASP modeling with Clingo/Clyngor.** Core logic encoded as ASP rules; Python orchestrates solving and presentation.  
- **Multiple moral theories.**
  - **Deontologism:** maxims (e.g., do-not-lie; do-not-enable-murder) and violations.
  - **Principialism v1:** principled exceptions anchored in duties.
  - **Principialism v2 (counterfactual):** compares alternatives via counterfactual structure.
  - **Consequentialism (two variants):** permissibility by comparing (expected / realized) utilities.
- **Speech-act taxonomy.** Distinguishes **objective truth / falsehood** from **honest / dishonest** intentions (e.g., *objective lie*, *erroneous truth*, *erroneous lie*).  
- **Scenario control.** Three predefined situations (`s1–s3`) capturing variations in beliefs about location, hostility, and credibility.  
- **Pretty output.** Helper functions render per-theory permissibility tables for each scenario.

## Installation

### Prerequisites
- Python **3.8+**
- A working Clingo (comes via `clyngor-with-clingo`, or install system-wide)
  - macOS (Homebrew): `brew install clingo`
  - Ubuntu/Debian: `sudo apt-get install clingo`

### Install via pip
```bash
python -m pip install --upgrade pip
python -m pip install clingo
python -m pip install clyngor-with-clingo
```

> **Note:** If running outside notebooks, ignore any notebook “bang” lines (e.g., `!pip install ...`).

## Usage

### Option A — Run as a script
```bash
python aamas2026_asp.py
```

### Option B — Jupyter / Colab
Open the file in a notebook cell and run. The inline Markdown tables will render in the notebook.

### Selecting a scenario
Inside `aamas2026_asp.py`, scenarios are toggled in the ASP **`program1`** string:
```prolog
% Current and potential situations
situation(s1).   % <- active by default
%situation(s2).
%situation(s3).
```
Uncomment the one you want (only one `situation/1` should be active at a time), then rerun.

## Interpreting the Output

The solver enumerates answer sets and then prints a **per-scenario table** with, for each candidate act (e.g., `tell(p, at(r, cemetery), f)`; `silence(...)`):

- Whether it is **permissible/impermissible** under:  
  **Deontologism**, **Principialism v1**, **Principialism v2**, **Consequentialism 1** (e.g., immediate/expected utility), **Consequentialism 2** (e.g., cumulative/realized utility).
- The **rule/exceptions** that justify the status (for deontological/principialist cases).
- The **utility comparison** that justifies the status (for consequentialist cases).

This lets you contrast, for example, how a **truthful utterance intended as a lie** might be impermissible deontologically yet optimal under a consequentialist variant, or permissible in **principialism v2** once counterfactuals are taken into account.

## Code Structure

- **`aamas2026_asp.py`** — Single self-contained script that:
  - Declares the **ASP programs** (scenario facts; honesty/truth predicates; action consequences; maxims/principles; utility aggregation; counterfactual comparison).
  - Runs the solver and prints structured results.

### Key Helpers (Python)
- `answer_set_to_facts(answer)`: normalize one answer set into a Python fact list.  
- `get_all_facts(answers)`: collect/merge facts for reporting.  
- `get_pred(all_facts, scenario)`: filter facts for a chosen `s1|s2|s3`.  
- `get_act(facts)`: enumerate candidate actions/decisions.  
- `get_perm(facts, act)`: compute per-theory permissibility for a given action.  
- `show_scenario(all_facts, scenario)`: render a Markdown table summarizing the scenario’s actions and permissibility across theories.

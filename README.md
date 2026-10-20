# Parallel MAC with Arithmetic Pipelining

## Overview

This project implements a fully parallel Multiply-Accumulate (MAC) unit with a local register file for storing weight coefficients. It explores both non-pipelined and three-stage pipelined arithmetic implementations using SystemVerilog.

The design uses signed 8-bit input data and weight coefficients, with a sequence length of 9.

## Features

- Fully parallel MAC architecture.
- Local register file for weight storage.
- Signed 8-bit inputs and weight coefficients.
- Sequence length of 9.
- Separate weight-loading and computation phases.
- Non-pipelined and three-stage pipelined implementations.
- Dedicated testbenches for both implementations.
- Simulation waveform analysis using Cadence Xcelium.

## Architecture

The intended multiply-accumulate operation is:

\[
Y = \sum_{i=0}^{8} x_i w_i
\]

where:

- \(x_i\) represents a signed 8-bit input sample.
- \(w_i\) represents its corresponding signed 8-bit weight.
- \(Y\) represents the accumulated output.

### Non-Pipelined Implementation

The arithmetic computation is performed without the three-stage pipeline used in the pipelined implementation.

**RTL:** `mac_par_comb.sv`

**Testbench:** `tb_mac_par_comb.sv`

### Three-Stage Pipelined Implementation

The arithmetic computation is divided into three pipeline stages to explore the timing and latency characteristics of a pipelined datapath.

**RTL:** `mac_par_pipe.sv`

**Testbench:** `tb_mac_par_pipe.sv`

## Repository Structure

```text
parallel-mac-pipelined/
├── mac_par_comb.sv
├── mac_par_pipe.sv
├── tb_mac_par_comb.sv
├── tb_mac_par_pipe.sv
└── README.md
```

## Simulation

The designs can be compiled and simulated using Cadence Xcelium.

Run the commands below from the directory containing the four SystemVerilog files.

### 1. Non-Pipelined MAC

```bash
xrun -64bit -sv -access +rwc \
  mac_par_comb.sv \
  tb_mac_par_comb.sv \
  -l mac_par_comb.log
```

### 2. Three-Stage Pipelined MAC

```bash
xrun -64bit -sv -access +rwc \
  mac_par_pipe.sv \
  tb_mac_par_pipe.sv \
  -l mac_par_pipe.log
```

Each command compiles the corresponding RTL and testbench, runs the simulation, and saves the simulator output to a log file.

## Simulation Results

Simulation waveforms can be inspected to examine the signal activity and output timing of each implementation.

### Non-Pipelined Waveform

<img width="940" height="425" alt="image" src="https://github.com/user-attachments/assets/120add29-d27a-4abf-9adb-33b68576590c" />

### Three-Stage Pipelined Waveform

<img width="940" height="412" alt="image" src="https://github.com/user-attachments/assets/811229ba-4b16-4f71-8784-040fb5399cd1" />

The waveforms should be used alongside the testbench output to inspect functional behavior and, for the pipelined design, pipeline latency.

## Verification

The two testbenches provide separate simulation environments for the non-pipelined and pipelined designs.

Verification should cover:

- Weight-loading behavior.
- Computation phase.
- Accumulated output.
- Pipeline timing and latency, where applicable.
- Testbench pass/fail results.

## Technologies

- SystemVerilog
- RTL Design
- Parallel Arithmetic
- Arithmetic Pipelining
- Cadence Xcelium
- Functional Simulation


# Round-Robin Arbiter — RTL & Verification

A 4-requester synchronous round-robin arbiter implemented in SystemVerilog, with a self-checking verification environment.

This project is being developed incrementally as part of an FPGA/RTL portfolio, with verification methodology added progressively.

## Current Status

**Initial implementation completed**

* Round-robin arbitration for 4 requesters
* Pointer-based circular priority
* One-hot grant generation
* Reset and pointer update logic
* Directed verification
* Self-checking testbench
* Reference model
* Randomized verification
* Functional request-pattern coverage

### Verification Results

* **100 randomized tests**
* **16/16 possible request patterns covered**
* **0 observed mismatches**
* Simulation completed successfully through `$finish`

## Design Overview

The arbiter accepts four request signals and grants access to at most one requester per cycle.

The arbitration search begins from the current pointer and proceeds circularly:

```text
Pointer = 0 → 0 → 1 → 2 → 3
Pointer = 1 → 1 → 2 → 3 → 0
Pointer = 2 → 2 → 3 → 0 → 1
Pointer = 3 → 3 → 0 → 1 → 2
```

When a requester is granted, the pointer advances to the requester immediately following the winner.

If no requester is active, the pointer remains unchanged.

## Repository Structure

```text
round-robin-arbiter/
│
├── rtl/
│   └── round_robin_arbiter.sv
│
├── tb/
│   └── tb.sv
│
├── README.md
└── .gitignore
```

## Verification Approach

The testbench uses a reference model to independently calculate the expected grant.

```text
Request
   │
   ├──────────────► DUT ──────────────► Grant
   │
   └──────────────► Reference Model ──► Expected Grant
                                      │
                                      ▼
                                   Compare
```

The verification process currently includes:

1. Directed test cases
2. Self-checking comparisons
3. Reference-model-based checking
4. Randomized request generation
5. Functional coverage of all 16 possible request patterns

## Tools

* SystemVerilog
* AMD Vivado
* Vivado Simulator

## Roadmap

The project will be extended incrementally with:

* Stronger randomized verification
* Intentional DUT bug injection
* SystemVerilog Assertions (SVA)
* Formal verification
* Additional corner-case properties
* Final verification and documentation

> Formal verification is **not yet implemented** in the current version.

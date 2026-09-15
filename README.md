# Round-Robin Arbiter — RTL & Verification

A 4-requester synchronous round-robin arbiter implemented in SystemVerilog, with a self-checking simulation environment, SystemVerilog Assertions (SVA), and formal verification.

This project is being developed incrementally as part of an FPGA/RTL portfolio, with verification methodology added progressively.

## Current Status

**RTL design, simulation, SVA verification, formal verification, synthesis, static timing analysis, and power estimation completed**

* Round-robin arbitration for 4 requesters
* Pointer-based circular priority
* One-hot grant generation
* Reset and pointer update logic
* Directed verification
* Self-checking testbench
* Reference model
* Randomized verification
* Functional request-pattern coverage
* Grant-state coverage
* Pointer-state coverage
* SystemVerilog Assertions (SVA)
* Intentional DUT bug injection
* Formal verification using SymbiYosys
* Formal behavioral property checking
* FPGA synthesis
* Static timing analysis
* Resource utilization analysis
* Vivado power estimation

### Verification Results

* **100 randomized tests**
* **16/16 possible request patterns covered**
* **4/4 grant states covered**
* **4/4 pointer states covered**
* **0 observed mismatches with the correct DUT**
* **SVA assertions passed with the correct DUT**
* **Formal assertions passed**
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
├── assertions/
│   └── arbiter_assertions.sv
│
├── constraints/
│   └── round_robin_arbiter.xdc
│
├── formal/
│   ├── arbiter.sby
│   ├── formal_assertions.sv
│   └── formal_tb.sv
│
├── rtl/
│   └── round_robin_arbiter.sv
│
├── testbench/
│   └── tb.sv
│
├── .gitignore
└── README.md
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

The verification process includes:

1. Directed test cases
2. Self-checking comparisons
3. Reference-model-based checking
4. Randomized request generation
5. Functional coverage of all 16 possible request patterns
6. Grant-state coverage
7. Pointer-state coverage
8. SystemVerilog Assertions
9. Intentional bug injection
10. Formal verification

## SystemVerilog Assertions

SVA properties are used during RTL simulation to continuously check important design invariants.

### Grant Validity

The grant must always be either zero or one-hot:

```systemverilog
assert property (
    @(posedge clk)
    disable iff (rst)
    $onehot0(grant)
);
```

This ensures that the arbiter never produces a multi-hot grant.

Valid grant values are:

```text
0000
0001
0010
0100
1000
```

### Request-to-Grant Relationship

Whenever at least one requester is active, exactly one requester must be granted:

```systemverilog
assert property (
    @(posedge clk)
    disable iff (rst)
    (request != 4'b0000) |-> $onehot(grant)
);
```

### Pointer Transition

The pointer advances to the requester immediately following the winner.

The expected transitions are:

```text
Previous Grant       Next Pointer
-------------        ------------
0001                 01
0010                 10
0100                 11
1000                 00
```

The pointer behavior was also tested through intentional bug injection and reference-model-based verification.

## Formal Verification

Formal verification was performed using **SymbiYosys** with the **Z3 SMT solver**.

The formal environment consists of:

```text
RTL DUT
   │
   ▼
Formal Testbench
   │
   ├── Reset assumptions
   │
   ▼
Formal Assertions
   │
   ▼
SymbiYosys
   │
   ▼
Z3
```

The formal testbench explicitly handles the initial reset cycle and tracks when `$past()` becomes valid.

### Formally Verified Properties

The following properties were successfully proven:

#### 1. Grant is one-hot or zero

```systemverilog
assert ($onehot0(grant));
```

#### 2. A non-empty request set produces exactly one grant

```systemverilog
if (request != 4'b0000)
    assert ($onehot(grant));
```

#### 3. Grant is always a subset of the request

```systemverilog
assert ((grant & ~request) == 4'b0000);
```

#### 4. Round-robin rotation

The formal environment verifies the circular priority transitions:

```text
0 → 1
1 → 2
2 → 3
3 → 0
```

when the next requester is active.

The formal harness uses an explicit reset assumption and a validity flag to ensure that temporal checks using `$past()` are only evaluated after a valid previous cycle exists.

These properties are checked exhaustively over the formal state space rather than relying on a finite set of simulation test vectors.

## Intentional Bug Injection

The verification environment was tested by deliberately introducing bugs into the DUT.

### Grant Logic Bug

The grant output was temporarily forced to a multi-hot value:

```systemverilog
grant = 4'b0011;
```

The SVA `$onehot0(grant)` property correctly detected the violation.

### Pointer Wrap-Around Bug

The correct wrap-around logic:

```systemverilog
if (actual_requester == 3)
    next_pointer = 0;
```

was temporarily changed to:

```systemverilog
if (actual_requester == 3)
    next_pointer = 3;
```

The reference model detected the resulting functional mismatches.

The verification flow therefore uses multiple complementary techniques:

```text
Reference Model
      +
Randomized Simulation
      +
Functional Coverage
      +
SVA
      +
Formal Verification
```

## Synthesis, Timing & Power Results

Implementation and static timing analysis were performed for the target device:

```text
Device: xc7a12ticsg325-1L
Clock constraint: 10.000 ns (100 MHz)
```

### Resource Utilization

| Resource | Used | Available | Utilization |
|---|---:|---:|---:|
| LUT | 7 | 8,000 | 0.09% |
| FF | 2 | 16,000 | 0.01% |
| I/O | 10 | 150 | 6.67% |

### Static Timing Analysis

| Metric | Result |
|---|---:|
| WNS | 7.805 ns |
| TNS | 0.000 ns |
| WHS | 0.467 ns |
| THS | 0.000 ns |
| Failing setup endpoints | 0 |
| Failing hold endpoints | 0 |
| Worst setup path delay | 2.195 ns |
| Approx. Fmax from worst setup path | 455.6 MHz |

Vivado reported that all user-specified timing constraints were met.

The approximately 455.6 MHz figure is derived from the reported worst setup path delay and should be interpreted as an STA-based estimate, not a measured hardware operating frequency.

### Power Estimate

Vivado reported the following estimated on-chip power:

| Power | Result |
|---|---:|
| Total On-Chip Power | 0.061 W |
| Dynamic Power | 0.002 W |
| Static Power | 0.059 W |

These are Vivado power estimates, not measurements from physical hardware.

## Verification Flow

```text
RTL Design
    ↓
Directed Testing
    ↓
Self-Checking Testbench
    ↓
Reference Model
    ↓
Randomized Testing
    ↓
Functional Coverage
    ↓
SystemVerilog Assertions
    ↓
Intentional Bug Injection
    ↓
Formal Verification
    ↓
Synthesis
    ↓
Static Timing Analysis
    ↓
Power Estimation
```

## Tools

* SystemVerilog
* AMD Vivado
* Vivado Simulator
* SymbiYosys
* Yosys
* Z3 SMT Solver

## Roadmap

Possible future improvements:

* Additional temporal assertions
* More corner-case properties
* Parameterize the number of requesters
* Expand randomized verification
* Explore alternative arbiter architectures

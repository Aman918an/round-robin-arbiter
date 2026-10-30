# Round-Robin Arbiter --- RTL, Verification & ASIC Implementation

A 4-requester synchronous round-robin arbiter implemented in
SystemVerilog, with a self-checking simulation environment,
SystemVerilog Assertions (SVA), formal verification, FPGA implementation
analysis, and an ASIC RTL-to-GDS flow.

This project is developed incrementally to explore the digital design
process from RTL development and functional verification through
synthesis and physical implementation.

## Current Status

**Completed: RTL design, simulation, SVA verification, formal
verification, FPGA synthesis and analysis, and ASIC RTL-to-GDS
implementation.**

-   Round-robin arbitration for 4 requesters
-   Pointer-based circular priority
-   One-hot grant generation
-   Reset and pointer update logic
-   Directed verification
-   Self-checking testbench
-   Reference model
-   Randomized verification
-   Functional request-pattern coverage
-   Grant-state coverage
-   Pointer-state coverage
-   SystemVerilog Assertions (SVA)
-   Intentional DUT bug injection
-   Formal verification using SymbiYosys
-   FPGA synthesis, static timing analysis and resource utilization
    analysis
-   Vivado power estimation
-   ASIC synthesis using OpenROAD Flow Scripts
-   Floorplanning and power distribution network generation
-   Global and detailed placement
-   Clock tree synthesis
-   Global and detailed routing
-   Final GDS generation

## Design Overview

The arbiter accepts four request signals and grants access to at most
one requester per cycle.

The arbitration search begins from the current pointer and proceeds
circularly:

``` text
Pointer = 0 → 0 → 1 → 2 → 3
Pointer = 1 → 1 → 2 → 3 → 0
Pointer = 2 → 2 → 3 → 0 → 1
Pointer = 3 → 3 → 0 → 1 → 2
```

When a requester is granted, the pointer advances to the requester
immediately following the winner.

If no requester is active, the pointer remains unchanged.

## Repository Structure

``` text
round-robin-arbiter/
│
├── assertions/
│   └── arbiter_assertions.sv
│
├── constraints/
│   └── round_robin_arbiter.xdc
│
├── docs/
│   ├── architecture.md
│   ├── rtl_to_gds.md
│   └── pdn_investigation.md
│
├── formal/
│   ├── arbiter.sby
│   ├── formal_assertions.sv
│   └── formal_tb.sv
│
├── physical_design/
│   ├── config.mk
│   └── pdn/
│
├── reports/
│   ├── synthesis/
│   ├── timing/
│   └── physical_design/
│
├── results/
│   └── screenshots/
│       ├── 01_floorplan.png
│       ├── 02_placement.png
│       ├── 03_clock_tree.png
│       ├── 04_global_routing.png
│       └── 05_final_layout.png
│
├── rtl/
│   └── round_robin_arbiter.sv
│
├── testbench/
│   └── tb.sv
│
├── .gitignore
├── LICENSE
└── README.md
```

## Verification Approach

The testbench uses a reference model to independently calculate the
expected grant.

``` text
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

1.  Directed test cases
2.  Self-checking comparisons
3.  Reference-model-based checking
4.  Randomized request generation
5.  Functional coverage of all 16 possible request patterns
6.  Grant-state coverage
7.  Pointer-state coverage
8.  SystemVerilog Assertions
9.  Intentional bug injection
10. Formal verification

### Verification Results

-   **100 randomized tests**
-   **16/16 possible request patterns covered**
-   **4/4 grant states covered**
-   **4/4 pointer states covered**
-   **0 observed mismatches with the correct DUT**
-   **SVA assertions passed with the correct DUT**
-   **Formal assertions passed**
-   Simulation completed successfully through `$finish`

## SystemVerilog Assertions

SVA properties are used during RTL simulation to continuously check
important design invariants.

### Grant Validity

The grant must always be either zero or one-hot:

``` systemverilog
assert property (
    @(posedge clk)
    disable iff (rst)
    $onehot0(grant)
);
```

This ensures that the arbiter never produces a multi-hot grant.

Valid grant values are:

``` text
0000
0001
0010
0100
1000
```

### Request-to-Grant Relationship

Whenever at least one requester is active, exactly one requester must be
granted:

``` systemverilog
assert property (
    @(posedge clk)
    disable iff (rst)
    (request != 4'b0000) |-> $onehot(grant)
);
```

### Pointer Transition

The pointer advances to the requester immediately following the winner.

The expected transitions are:

``` text
Previous Grant       Next Pointer
-------------        ------------
0001                 01
0010                 10
0100                 11
1000                 00
```

The pointer behavior was also tested through intentional bug injection
and reference-model-based verification.

## Formal Verification

Formal verification was performed using **SymbiYosys** with the **Z3 SMT
solver**.

The formal environment consists of:

``` text
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

The formal testbench explicitly handles the initial reset cycle and
tracks when `$past()` becomes valid.

### Formally Verified Properties

The following properties were successfully proven:

#### 1. Grant is one-hot or zero

``` systemverilog
assert ($onehot0(grant));
```

#### 2. A non-empty request set produces exactly one grant

``` systemverilog
if (request != 4'b0000)
    assert ($onehot(grant));
```

#### 3. Grant is always a subset of the request

``` systemverilog
assert ((grant & ~request) == 4'b0000);
```

#### 4. Round-robin rotation

The formal environment verifies the circular priority transitions:

``` text
0 → 1
1 → 2
2 → 3
3 → 0
```

when the next requester is active.

The formal harness uses an explicit reset assumption and a validity flag
to ensure that temporal checks using `$past()` are only evaluated after
a valid previous cycle exists.

These properties are checked exhaustively over the formal state space
rather than relying on a finite set of simulation test vectors.

## Intentional Bug Injection

The verification environment was tested by deliberately introducing bugs
into the DUT.

### Grant Logic Bug

The grant output was temporarily forced to a multi-hot value:

``` systemverilog
grant = 4'b0011;
```

The SVA `$onehot0(grant)` property correctly detected the violation.

### Pointer Wrap-Around Bug

The correct wrap-around logic:

``` systemverilog
if (actual_requester == 3)
    next_pointer = 0;
```

was temporarily changed to:

``` systemverilog
if (actual_requester == 3)
    next_pointer = 3;
```

The reference model detected the resulting functional mismatches.

The verification flow therefore uses multiple complementary techniques:

``` text
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

## FPGA Synthesis, Timing & Power Results

Implementation and static timing analysis were performed for the target
device:

``` text
Device: xc7a12ticsg325-1L
Clock constraint: 10.000 ns (100 MHz)
```

### Resource Utilization

  Resource     Used   Available   Utilization
  ---------- ------ ----------- -------------
  LUT             7       8,000         0.09%
  FF              2      16,000         0.01%
  I/O            10         150         6.67%

### Static Timing Analysis

  Metric                                    Result
  ------------------------------------ -----------
  WNS                                     7.805 ns
  TNS                                     0.000 ns
  WHS                                     0.467 ns
  THS                                     0.000 ns
  Failing setup endpoints                        0
  Failing hold endpoints                         0
  Worst setup path delay                  2.195 ns
  Approx. Fmax from worst setup path     455.6 MHz

Vivado reported that all user-specified timing constraints were met.

The approximately 455.6 MHz figure is derived from the reported worst
setup path delay and should be interpreted as an STA-based estimate, not
a measured hardware operating frequency.

### FPGA Power Estimate

  Power                    Result
  --------------------- ---------
  Total On-Chip Power     0.061 W
  Dynamic Power           0.002 W
  Static Power            0.059 W

These are Vivado power estimates, not measurements from physical
hardware.

## ASIC Implementation --- RTL to GDS

The RTL was taken through an ASIC implementation flow using **OpenROAD
Flow Scripts** and the **Nangate45** standard-cell platform.

The implementation flow covered:

``` text
RTL
 ↓
Synthesis
 ↓
Floorplanning
 ↓
Power Distribution Network
 ↓
Global Placement
 ↓
Detailed Placement
 ↓
Clock Tree Synthesis
 ↓
Global Routing
 ↓
Detailed Routing
 ↓
Metal Fill
 ↓
Final GDS Generation
```

### Physical Design Stages

The following stages were inspected using OpenROAD:

1.  Floorplan
2.  Placement
3.  Clock tree synthesis
4.  Global routing
5.  Final layout

Add the corresponding OpenROAD GUI screenshots to this section when they
are available in the repository. The existing repository structure is
intentionally retained; screenshot files are not represented as new
tracked folders here.

### ASIC Implementation Results

  Metric                              Result
  ----------------------------- ------------
  Platform                         Nangate45
  Synthesis cell area             125.02 µm²
  Final design area                  139 µm²
  Standard-cell count                     95
  Reported final utilization             67%
  Worst setup slack                 +9.53 ns
  Hold slack                        +0.14 ns
  Setup violations                         0
  Hold violations                          0
  Detailed routing violations              0
  Estimated total power              69.6 µW

Additional physical design information:

-   Core dimensions: approximately 14.82 × 14.00 µm
-   Die dimensions: approximately 17.06 × 17.06 µm
-   Final GDS generated successfully.

The timing and power values are implementation-tool estimates under the
configured flow and constraints. They are not measured silicon
characteristics. The reported clock-period estimate should not be
treated as a validated operating frequency without further timing and
corner analysis.

### Power Distribution Network Investigation

The initial PDN configuration explored metal1, metal4 and metal7 power
distribution.

During investigation, metal7 geometry was not generated in the arbiter's
floorplan database. Experiments included changing the metal7 stripe
pitch and comparing the configuration with the Nangate45 GCD reference
design.

The final documented arbiter configuration uses metal1 and metal4 power
distribution. The reason metal7 geometry was absent remains unresolved;
the small floorplan may be a contributing factor, but this was not
established as the root cause.

The current result should not be interpreted as proof of power
integrity. IR-drop and current-density analysis would be needed to
assess that.

## Verification Flow

``` text
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
FPGA Synthesis and Analysis
```

## RTL-to-GDS Flow

``` text
RTL
    ↓
OpenROAD Flow Scripts
    ↓
Synthesis
    ↓
Floorplanning and PDN
    ↓
Placement
    ↓
Clock Tree Synthesis
    ↓
Global and Detailed Routing
    ↓
Final GDS
```

## Tools

-   SystemVerilog
-   AMD Vivado
-   Vivado Simulator
-   SymbiYosys
-   Yosys
-   Z3 SMT Solver
-   OpenROAD
-   OpenROAD Flow Scripts
-   Nangate45 standard-cell platform

## Roadmap

Possible future improvements:

-   Additional temporal assertions
-   More corner-case properties
-   Parameterize the number of requesters
-   Expand randomized verification
-   Explore alternative arbiter architectures
-   Investigate PDN behaviour and perform power-integrity analysis
-   Explore physical-design optimization and PPA trade-offs

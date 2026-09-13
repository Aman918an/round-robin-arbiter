# Round-Robin Arbiter — RTL & Verification

A 4-requester synchronous round-robin arbiter implemented in SystemVerilog, with a self-checking verification environment.

This project is being developed incrementally as part of an FPGA/RTL portfolio, with verification methodology added progressively.

## Current Status

**SVA verification completed**

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

### Verification Results

* **100 randomized tests**
* **16/16 possible request patterns covered**
* **4/4 grant states covered**
* **4/4 pointer states covered**
* **0 observed mismatches with the correct DUT**
* **SVA assertions passed with the correct DUT**
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
├── assertions/
│   └── arbiter_assertions.sv
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
6. Grant-state coverage
7. Pointer-state coverage
8. SystemVerilog Assertions (SVA)

## SystemVerilog Assertions

SVA properties are maintained separately from the DUT in the `assertions/` directory.

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

This verifies that an active request set results in exactly one granted requester.

### Pointer Transition

The pointer must advance to the requester immediately following the previous winner.

```text
Previous Grant       Current Pointer
-------------        --------------
0001                 01
0010                 10
0100                 11
1000                 00
```

The transition is checked using `$past()`.

For example:

```systemverilog
assert property (
    @(posedge clk)
    disable iff (rst)
    $past(grant) == 4'b0001 |-> pointer == 2'b01
);
```

The wrap-around case is explicitly verified:

```systemverilog
assert property (
    @(posedge clk)
    disable iff (rst)
    $past(grant) == 4'b1000 |-> pointer == 2'b00
);
```

### Reset-Aware Assertions

Assertions are disabled while reset is active using:

```systemverilog
disable iff (rst)
```

This prevents normal functional properties from being evaluated during reset.

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

The SVA pointer-transition property also detected the incorrect state transition:

```text
Previous grant = 1000
Expected pointer = 00
Actual pointer   = 11
```

This demonstrated that the reference model and SVA provide complementary verification mechanisms.

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
```

## Tools

* SystemVerilog
* AMD Vivado
* Vivado Simulator

## Roadmap

The project will be extended incrementally with:

* Additional temporal assertions
* Corner-case properties
* Formal verification using SymbiYosys
* Formal counterexample analysis
* Synthesis and static timing analysis
* Final verification and documentation

> Formal verification is **not yet implemented** in the current version.

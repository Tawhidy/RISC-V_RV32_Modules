# 32-bit ALU — SystemVerilog

A 32-bit Arithmetic Logic Unit written in SystemVerilog, built from scratch on top of a structural ripple-carry adder. Supports 10 RISC-V–aligned operations with full status flag output. Simulated with Verilator and waveforms viewed in GTKWave.

This is a foundational component of an ongoing RV32I soft-core CPU project.

---

## Specs

| Parameter        | Value                              |
|------------------|------------------------------------|
| Data width       | 32-bit                             |
| Opcode width     | 4-bit                              |
| Operations       | 10                                 |
| Status flags     | `zero`, `carry_out`, `overflow`, `negative` |
| Adder type       | Ripple-carry (structural, gate-level) |
| Opcode encoding  | RISC-V `funct3` + `funct7[5]` aligned |
| HDL              | SystemVerilog                      |
| Simulator        | Verilator (via WSL)                |
| Waveform viewer  | GTKWave                            |

---

## File Structure

```
.
├── Full_Adder.sv        # 1-bit full adder (structural)
├── Full_Adder_32bit.sv  # 32-bit ripple-carry adder (generate block)
├── ALU_32bit.sv         # Top-level ALU module
├── ALU_tb.sv            # Self-checking testbench with VCD dump
└── alu_waves.vcd        # Simulation waveform output
```

---

## Operations

The opcode encoding mirrors the RISC-V ISA — `opcode[2:0]` maps to `funct3`, `opcode[3]` maps to `funct7[5]`. If you're building a RISC-V datapath, the ALU control unit plugs straight in.

| Operation | Opcode   | Description                        |
|-----------|----------|------------------------------------|
| ADD       | `4'b0000`| A + B (with carry-in)              |
| SUB       | `4'b1000`| A − B (2's complement via ~B + 1)  |
| AND       | `4'b0111`| Bitwise AND                        |
| OR        | `4'b0110`| Bitwise OR                         |
| XOR       | `4'b0100`| Bitwise XOR                        |
| SLL       | `4'b0001`| Shift left logical (by B[4:0])     |
| SRL       | `4'b0101`| Shift right logical (by B[4:0])    |
| SRA       | `4'b1101`| Shift right arithmetic (by B[4:0]) |
| SLT       | `4'b0010`| Set if A < B (signed)              |
| SLTU      | `4'b0011`| Set if A < B (unsigned)            |

### Status Flags

| Flag        | Condition                                         |
|-------------|---------------------------------------------------|
| `zero`      | Result is all zeros                               |
| `carry_out` | Carry out of bit 31 (ADD/SUB only)                |
| `overflow`  | Signed overflow detected (ADD/SUB only)           |
| `negative`  | MSB of result is 1                                |

---

## Simulation (Verilator + WSL)

### Prerequisites

```bash
sudo apt update
sudo apt install verilator gtkwave
```

### Compile and run

```bash
verilator --binary --sv -j 0 --trace \
  Full_Adder.sv Full_Adder_32bit.sv ALU_32bit.sv ALU_tb.sv \
  --top-module ALU_tb -o alu_sim

./obj_dir/alu_sim
```

### View waveforms

```bash
gtkwave alu_waves.vcd
```

Load all signals from the `ALU_tb` scope, then add `A`, `B`, `opcode`, `result`, and the four flag signals to the wave viewer.

---

## Tested Operations

The testbench runs through the following cases and prints results to stdout:

```
--- STARTING ALU STRESS TEST ---
ADD (0000): 15 + 10 = 25
SUB (1000): 25 - 10 = 15
AND (0111): 1100 & 1010 = 1000
OR  (0110): 1100 | 1010 = 1110
XOR (0100): 1100 ^ 1010 = 0110
SLL (0001): 15 << 2 = 60
SLT (0010): -5 < 10 = 1 (1 means True)
ZERO TEST : 42 - 42 = 0 | Zero Flag: 1
--- TEST COMPLETE ---
```

---
## Waveforms

![ALU Simulation Waveforms](https://github.com/Tawhidy/RISC-V_RV32_Modules/blob/main/docs/ALU_optest1.png)

## Instantiation

Drop this into your own design. All four source files are required.

```systemverilog
ALU_32bit u_alu (
    .A         (operand_a),    // [31:0] First operand
    .B         (operand_b),    // [31:0] Second operand
    .opcode    (alu_ctrl),     // [3:0]  Operation select
    .carry_in  (cin),          // Carry-in (tie to 1 for clean SUB)
    .result    (alu_result),   // [31:0] Output
    .zero      (flag_zero),    // Result == 0
    .carry_out (flag_carry),   // Carry out of MSB
    .overflow  (flag_overflow),// Signed overflow
    .negative  (flag_negative) // Result is negative
);
```

> **Note on SUB:** The ALU computes subtraction as `A + (~B) + carry_in`. For a clean 2's complement subtraction, drive `carry_in = 1`. If you're building an ALU control unit, handle this at the control layer.

---

## Roadmap

This ALU is destined to be the execute stage of a 5-stage pipelined RV32I SoC, targeting tapeout on the SKY130 process via Tiny Tapeout.

- [ ] Integrate into single-cycle RV32I datapath (M2)
- [ ] Full simulation and verification with assembly programs (M3)
- [ ] Pipeline (IF/ID/EX/MEM/WB) with hazard handling
- [ ] Physical design with OpenLane → SKY130

---

## Author

**Tawhid Alam** — Industrial Engineering student @ IUT, Bangladesh.
Building CPUs because the world deserves better

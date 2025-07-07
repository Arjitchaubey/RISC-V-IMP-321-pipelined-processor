RISC-V 5-Stage Pipelined Processor

1. Overview

I have implemented a 5-stage pipelined RISC-V processor in Verilog. I have designed individual modules for hazard detection and control, data forwarding. The processor supports R, I, S, B, U and J type instructions. The processor is modular, fully synthesizable, and ready for simulation or FPGA deployment. I have loaded an external program using a program.hex file.
along with modeling a testbench to simulate the data flow in my processor.

2. Pipeline Architecture Stages:

    - IF (Instruction Fetch): Fetches instructions from memory.

    - ID (Instruction Decode): Decodes instructions, reads registers, and generates control signals.

    - EX (Execute): Performs ALU operations, computes branch targets, and resolves hazards.

    - MEM (Memory Access): Handles data memory read/write.

    - WB (Write Back): Writes results back to the register file.

    - Hazard detection and forwarding units ensure correct operation and high throughput.

    - IF, ID, EX, MEM, WB stages are implemented with pipeline registers to temporarily hold the values of each stage.


3. Module Descriptions
   - Top Module: RISC_V_PROCESSOR
     Integrates all pipeline stages, registers, hazard/forwarding units, and exposes debug outputs (PC, instruction, ALU result, register values, memory data).

    - Program Counter: pc
      Maintains the current instruction address, supports stalling and resets.

    - Instruction Memory: instruction_memory
      Synchronous, word-aligned instruction memory. Loads instructions from program.hex at startup.

    - IF/ID Pipeline Register: if_id_pipeline
      Buffers PC and instruction between the IF and ID stages. Supports stall and flush.

    - Instruction Decoder: instruction_decoder
      Parses instructions, extracts register addresses, and generates all control signals for the pipeline.

    - Register File: reg_file
      Implements 32 general-purpose registers. Supports dual read and single write per cycle. Register x0 is hardwired to zero.

    - Sign Extend: sign_extend
      Extracts and sign-extends immediate values for all RISC-V instruction types.

    - ID/EX Pipeline Register: id_ex_pipeline
      Transfers decoded data and control signals from ID to EX. Supports stall and flush.

    - ALU: alu
      Performs all arithmetic, logic, shift, and comparison operations as required by the instruction set.

    - Forwarding Unit: forwarding_unit
      Detects data hazards and generates control signals to forward results from later pipeline stages to the ALU.

    - EX/MEM Pipeline Register: ex_mem_pipeline
      Buffers ALU result, store data, and control signals between EX and MEM.

    - Memory Bank: memory_bank
      Implements 4KB of data memory with byte, half-word, and word access support.

    - MEM/WB Pipeline Register: pipeline_mem_wb
      Buffers results and control signals between MEM and WB.

    - Hazard Unit: hazard_unit
      Detects data and control hazards, generates stall and flush signals, and ensures correct pipeline operation.

    - Test Bench: riscv_processor_tb
      Drives the processor, provides clock/reset, prints pipeline state, and displays final register/memory contents.

4. How to Build, Simulate, and Run
Clone or Download the Repository

```bash
git clone https://github.com/Arjitchaubey/RISC-V-IMP-321-pipelined-processor.git
cd RISC-V-IMP-321-pipelined-processor
```

I have synthesized and implemented my processor using a Kintex 7 FPGA in vivado

My program.hex file consists of the following instructions
```text
00500093  // ADDI x1, x0, 5
00A00113  // ADDI x2, x0, 10
002081B3  // ADD  x3, x1, x2
00302023  // SW   x3, 0(x0)
00002203  // LW   x4, 0(x0)
0000006F  // J    0 (infinite loop or halt)
```

The Utilization, Power and Timing reports and reference screenshots are placed in the respective synthesis and implementation folders/files

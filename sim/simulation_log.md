```bash
The simulation log results have been displayed below.

The results are in a tabular format and all the control signals are updating as expected.

The registers are written with the expected values and the data memory at the address at the
end of simulation is 15 as expected.

The registers [31 : 5] are filled with NOP values (as expected).
```

start_gui

open_project C:/Users/arjit/pipelined_riscv/pipelined_riscv.xpr

INFO: [filemgmt 56-3] Default IP Output Path : Could not find the directory 'C:/Users/arjit/pipelined_riscv/pipelined_riscv.gen/sources_1'.

Scanning sources...

Finished scanning sources

open_project: Time (s): cpu = 00:00:12 ; elapsed = 00:00:06 . Memory (MB): peak = 1193.066 ; gain = 74.059

update_compile_order -fileset sources_1

launch_simulation

Time resolution is 1 ps

source riscv_processor_tb.tcl

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Time | IF_PC    | ID_Instr | ID_RS1 | ID_RS2 | ID_RD | EX_ALU_Op1 | EX_ALU_Op2 | EX_ALU_Control | EX_ALU_Result | EX_Store_Data | MEM_Read_Data | WB_Write_Data | MEM_MemWrite | WB_RegWrite | 
-----|----------|----------|--------|--------|-------|------------|------------|----------------|---------------|---------------|---------------|---------------|--------------|-------------|
  32 | 00000008 | 00500093 |      0 |      5 |     1 | 00xxxxxxxx | 00xxxxxxxx | 00000000000000 | 00000xxxxxxxx | 00000xxxxxxxx | 0000000000000 | 0000000000000 | 000000000000 | 00000000000 
  35 | 0000000c | 00a00113 |      0 |     10 |     2 | 0000000000 | 0000000005 | 00000000000000 | 0000000000005 | 0000000000000 | 0000000000000 | 0000000000000 | 000000000000 | 00000000000 
  45 | 00000010 | 002081b3 |      1 |      2 |     3 | 0000000000 | 000000000a | 00000000000000 | 000000000000a | 0000000000000 | 0000000000000 | 00000xxxxxxxx | 000000000000 | 00000000000 
  55 | 00000014 | 00302023 |      0 |      3 |     0 | 0000000005 | 000000000a | 00000000000000 | 000000000000f | 000000000000a | 0000000000000 | 0000000000005 | 000000000000 | 00000000001 
  65 | 00000018 | 00002203 |      0 |      0 |     4 | 0000000000 | 0000000000 | 00000000000000 | 0000000000000 | 000000000000f | 0000000000000 | 000000000000a | 000000000000 | 00000000001 
  75 | 0000001c | 0000006f |      0 |      0 |     0 | 0000000000 | 0000000000 | 00000000000000 | 0000000000000 | 0000000000000 | 0000000000000 | 000000000000f | 000000000001 | 00000000001 
  85 | 00000020 | xxxxxxxx | x | x | x | 0000000000 | 0000000000 | 00000000000000 | 0000000000000 | 0000000000000 | 0000000000000 | 0000000000000 | 000000000000 | 00000000000 
  95 | 00000018 | 00000013 |      0 |      0 |     0 | 0000000000 | 0000000000 | 00000000000000 | 0000000000000 | 0000000000000 | 0000000000000 | 0000000000000 | 000000000000 | 00000000001 
 105 | 0000001c | xxxxxxxx | x | x | x | 0000000000 | 0000000000 | 00000000000000 | 0000000000000 | 0000000000000 | 0000000000000 | 0000000000000 | 000000000000 | 00000000000 
 115 | 00000020 | xxxxxxxx | x | x | x | 00xxxxxxxx | 00xxxxxxxx | 00000000000000 | 00000xxxxxxxx | 00000xxxxxxxx | 0000000000000 | 0000000000000 | 000000000000 | 00000000000 
 125 | 00000024 | xxxxxxxx | x | x | x | 00xxxxxxxx | 00xxxxxxxx | 00000000000000 | 00000xxxxxxxx | 00000xxxxxxxx | 0000000000000 | 0000000000000 | 000000000000 | 00000000001 
 135 | 00000028 | xxxxxxxx | x | x | x | 00xxxxxxxx | 00xxxxxxxx | 00000000000000 | 00000xxxxxxxx | 00000xxxxxxxx | 0000000000000 | 00000xxxxxxxx | 000000000000 | 00000000000 
 145 | 0000002c | xxxxxxxx | x | x | x | 00xxxxxxxx | 00xxxxxxxx | 00000000000000 | 00000xxxxxxxx | 00000xxxxxxxx | 0000000000000 | 00000xxxxxxxx | 000000000000 | 00000000000 
 155 | 00000030 | xxxxxxxx | x | x | x | 00xxxxxxxx | 00xxxxxxxx | 00000000000000 | 00000xxxxxxxx | 00000xxxxxxxx | 0000000000000 | 00000xxxxxxxx | 000000000000 | 00000000000 
 165 | 00000034 | xxxxxxxx | x | x | x | 00xxxxxxxx | 00xxxxxxxx | 00000000000000 | 00000xxxxxxxx | 00000xxxxxxxx | 0000000000000 | 00000xxxxxxxx | 000000000000 | 00000000000 
 175 | 00000038 | xxxxxxxx | x | x | x | 00xxxxxxxx | 00xxxxxxxx | 00000000000000 | 00000xxxxxxxx | 00000xxxxxxxx | 0000000000000 | 00000xxxxxxxx | 000000000000 | 00000000000 
 185 | 0000003c | xxxxxxxx | x | x | x | 00xxxxxxxx | 00xxxxxxxx | 00000000000000 | 00000xxxxxxxx | 00000xxxxxxxx | 0000000000000 | 00000xxxxxxxx | 000000000000 | 00000000000 
 195 | 00000040 | xxxxxxxx | x | x | x | 00xxxxxxxx | 00xxxxxxxx | 00000000000000 | 00000xxxxxxxx | 00000xxxxxxxx | 0000000000000 | 00000xxxxxxxx | 000000000000 | 00000000000 
 205 | 00000044 | xxxxxxxx | x | x | x | 00xxxxxxxx | 00xxxxxxxx | 00000000000000 | 00000xxxxxxxx | 00000xxxxxxxx | 0000000000000 | 00000xxxxxxxx | 000000000000 | 00000000000 
 215 | 00000048 | xxxxxxxx | x | x | x | 00xxxxxxxx | 00xxxxxxxx | 00000000000000 | 00000xxxxxxxx | 00000xxxxxxxx | 0000000000000 | 00000xxxxxxxx | 000000000000 | 00000000000 
 225 | 0000004c | xxxxxxxx | x | x | x | 00xxxxxxxx | 00xxxxxxxx | 00000000000000 | 00000xxxxxxxx | 00000xxxxxxxx | 0000000000000 | 00000xxxxxxxx | 000000000000 | 00000000000 
 235 | 00000050 | xxxxxxxx | x | x | x | 00xxxxxxxx | 00xxxxxxxx | 00000000000000 | 00000xxxxxxxx | 00000xxxxxxxx | 0000000000000 | 00000xxxxxxxx | 000000000000 | 00000000000 
 245 | 00000054 | xxxxxxxx | x | x | x | 00xxxxxxxx | 00xxxxxxxx | 00000000000000 | 00000xxxxxxxx | 00000xxxxxxxx | 0000000000000 | 00000xxxxxxxx | 000000000000 | 00000000000 
 255 | 00000058 | xxxxxxxx | x | x | x | 00xxxxxxxx | 00xxxxxxxx | 00000000000000 | 00000xxxxxxxx | 00000xxxxxxxx | 0000000000000 | 00000xxxxxxxx | 000000000000 | 00000000000 
 265 | 0000005c | xxxxxxxx | x | x | x | 00xxxxxxxx | 00xxxxxxxx | 00000000000000 | 00000xxxxxxxx | 00000xxxxxxxx | 0000000000000 | 00000xxxxxxxx | 000000000000 | 00000000000 
 275 | 00000060 | xxxxxxxx | x | x | x | 00xxxxxxxx | 00xxxxxxxx | 00000000000000 | 00000xxxxxxxx | 00000xxxxxxxx | 0000000000000 | 00000xxxxxxxx | 000000000000 | 00000000000 
 285 | 00000064 | xxxxxxxx | x | x | x | 00xxxxxxxx | 00xxxxxxxx | 00000000000000 | 00000xxxxxxxx | 00000xxxxxxxx | 0000000000000 | 00000xxxxxxxx | 000000000000 | 00000000000 
 295 | 00000068 | xxxxxxxx | x | x | x | 00xxxxxxxx | 00xxxxxxxx | 00000000000000 | 00000xxxxxxxx | 00000xxxxxxxx | 0000000000000 | 00000xxxxxxxx | 000000000000 | 00000000000 
 305 | 0000006c | xxxxxxxx | x | x | x | 00xxxxxxxx | 00xxxxxxxx | 00000000000000 | 00000xxxxxxxx | 00000xxxxxxxx | 0000000000000 | 00000xxxxxxxx | 000000000000 | 00000000000 
 315 | 00000070 | xxxxxxxx | x | x | x | 00xxxxxxxx | 00xxxxxxxx | 00000000000000 | 00000xxxxxxxx | 00000xxxxxxxx | 0000000000000 | 00000xxxxxxxx | 000000000000 | 00000000000 
 325 | 00000074 | xxxxxxxx | x | x | x | 00xxxxxxxx | 00xxxxxxxx | 00000000000000 | 00000xxxxxxxx | 00000xxxxxxxx | 0000000000000 | 00000xxxxxxxx | 000000000000 | 00000000000 
 335 | 00000078 | xxxxxxxx | x | x | x | 00xxxxxxxx | 00xxxxxxxx | 00000000000000 | 00000xxxxxxxx | 00000xxxxxxxx | 0000000000000 | 00000xxxxxxxx | 000000000000 | 00000000000 
 345 | 0000007c | xxxxxxxx | x | x | x | 00xxxxxxxx | 00xxxxxxxx | 00000000000000 | 00000xxxxxxxx | 00000xxxxxxxx | 0000000000000 | 00000xxxxxxxx | 000000000000 | 00000000000 
 355 | 00000080 | xxxxxxxx | x | x | x | 00xxxxxxxx | 00xxxxxxxx | 00000000000000 | 00000xxxxxxxx | 00000xxxxxxxx | 0000000000000 | 00000xxxxxxxx | 000000000000 | 00000000000 
 365 | 00000084 | xxxxxxxx | x | x | x | 00xxxxxxxx | 00xxxxxxxx | 00000000000000 | 00000xxxxxxxx | 00000xxxxxxxx | 0000000000000 | 00000xxxxxxxx | 000000000000 | 00000000000 
 375 | 00000088 | xxxxxxxx | x | x | x | 00xxxxxxxx | 00xxxxxxxx | 00000000000000 | 00000xxxxxxxx | 00000xxxxxxxx | 0000000000000 | 00000xxxxxxxx | 000000000000 | 00000000000 
 385 | 0000008c | xxxxxxxx | x | x | x | 00xxxxxxxx | 00xxxxxxxx | 00000000000000 | 00000xxxxxxxx | 00000xxxxxxxx | 0000000000000 | 00000xxxxxxxx | 000000000000 | 00000000000 
 395 | 00000090 | xxxxxxxx | x | x | x | 00xxxxxxxx | 00xxxxxxxx | 00000000000000 | 00000xxxxxxxx | 00000xxxxxxxx | 0000000000000 | 00000xxxxxxxx | 000000000000 | 00000000000 
 405 | 00000094 | xxxxxxxx | x | x | x | 00xxxxxxxx | 00xxxxxxxx | 00000000000000 | 00000xxxxxxxx | 00000xxxxxxxx | 0000000000000 | 00000xxxxxxxx | 000000000000 | 00000000000 
 415 | 00000098 | xxxxxxxx | x | x | x | 00xxxxxxxx | 00xxxxxxxx | 00000000000000 | 00000xxxxxxxx | 00000xxxxxxxx | 0000000000000 | 00000xxxxxxxx | 000000000000 | 00000000000 
 425 | 0000009c | xxxxxxxx | x | x | x | 00xxxxxxxx | 00xxxxxxxx | 00000000000000 | 00000xxxxxxxx | 00000xxxxxxxx | 0000000000000 | 00000xxxxxxxx | 000000000000 | 00000000000 
 435 | 000000a0 | xxxxxxxx | x | x | x | 00xxxxxxxx | 00xxxxxxxx | 00000000000000 | 00000xxxxxxxx | 00000xxxxxxxx | 0000000000000 | 00000xxxxxxxx | 000000000000 | 00000000000 
 445 | 000000a4 | xxxxxxxx | x | x | x | 00xxxxxxxx | 00xxxxxxxx | 00000000000000 | 00000xxxxxxxx | 00000xxxxxxxx | 0000000000000 | 00000xxxxxxxx | 000000000000 | 00000000000 
 455 | 000000a8 | xxxxxxxx | x | x | x | 00xxxxxxxx | 00xxxxxxxx | 00000000000000 | 00000xxxxxxxx | 00000xxxxxxxx | 0000000000000 | 00000xxxxxxxx | 000000000000 | 00000000000 
 465 | 000000ac | xxxxxxxx | x | x | x | 00xxxxxxxx | 00xxxxxxxx | 00000000000000 | 00000xxxxxxxx | 00000xxxxxxxx | 0000000000000 | 00000xxxxxxxx | 000000000000 | 00000000000 
 475 | 000000b0 | xxxxxxxx | x | x | x | 00xxxxxxxx | 00xxxxxxxx | 00000000000000 | 00000xxxxxxxx | 00000xxxxxxxx | 0000000000000 | 00000xxxxxxxx | 000000000000 | 00000000000 
 485 | 000000b4 | xxxxxxxx | x | x | x | 00xxxxxxxx | 00xxxxxxxx | 00000000000000 | 00000xxxxxxxx | 00000xxxxxxxx | 0000000000000 | 00000xxxxxxxx | 000000000000 | 00000000000 
 495 | 000000b8 | xxxxxxxx | x | x | x | 00xxxxxxxx | 00xxxxxxxx | 00000000000000 | 00000xxxxxxxx | 00000xxxxxxxx | 0000000000000 | 00000xxxxxxxx | 000000000000 | 00000000000 
 505 | 000000bc | xxxxxxxx | x | x | x | 00xxxxxxxx | 00xxxxxxxx | 00000000000000 | 00000xxxxxxxx | 00000xxxxxxxx | 0000000000000 | 00000xxxxxxxx | 000000000000 | 00000000000 
 515 | 000000c0 | xxxxxxxx | x | x | x | 00xxxxxxxx | 00xxxxxxxx | 00000000000000 | 00000xxxxxxxx | 00000xxxxxxxx | 0000000000000 | 00000xxxxxxxx | 000000000000 | 00000000000 
 525 | 000000c4 | xxxxxxxx | x | x | x | 00xxxxxxxx | 00xxxxxxxx | 00000000000000 | 00000xxxxxxxx | 00000xxxxxxxx | 0000000000000 | 00000xxxxxxxx | 000000000000 | 00000000000 
 535 | 000000c8 | xxxxxxxx | x | x | x | 00xxxxxxxx | 00xxxxxxxx | 00000000000000 | 00000xxxxxxxx | 00000xxxxxxxx | 0000000000000 | 00000xxxxxxxx | 000000000000 | 00000000000 
 545 | 000000cc | xxxxxxxx | x | x | x | 00xxxxxxxx | 00xxxxxxxx | 00000000000000 | 00000xxxxxxxx | 00000xxxxxxxx | 0000000000000 | 00000xxxxxxxx | 000000000000 | 00000000000 
 555 | 000000d0 | xxxxxxxx | x | x | x | 00xxxxxxxx | 00xxxxxxxx | 00000000000000 | 00000xxxxxxxx | 00000xxxxxxxx | 0000000000000 | 00000xxxxxxxx | 000000000000 | 00000000000 
 565 | 000000d4 | xxxxxxxx | x | x | x | 00xxxxxxxx | 00xxxxxxxx | 00000000000000 | 00000xxxxxxxx | 00000xxxxxxxx | 0000000000000 | 00000xxxxxxxx | 000000000000 | 00000000000 
 575 | 000000d8 | xxxxxxxx | x | x | x | 00xxxxxxxx | 00xxxxxxxx | 00000000000000 | 00000xxxxxxxx | 00000xxxxxxxx | 0000000000000 | 00000xxxxxxxx | 000000000000 | 00000000000 
 585 | 000000dc | xxxxxxxx | x | x | x | 00xxxxxxxx | 00xxxxxxxx | 00000000000000 | 00000xxxxxxxx | 00000xxxxxxxx | 0000000000000 | 00000xxxxxxxx | 000000000000 | 00000000000 
 595 | 000000e0 | xxxxxxxx | x | x | x | 00xxxxxxxx | 00xxxxxxxx | 00000000000000 | 00000xxxxxxxx | 00000xxxxxxxx | 0000000000000 | 00000xxxxxxxx | 000000000000 | 00000000000 
 605 | 000000e4 | xxxxxxxx | x | x | x | 00xxxxxxxx | 00xxxxxxxx | 00000000000000 | 00000xxxxxxxx | 00000xxxxxxxx | 0000000000000 | 00000xxxxxxxx | 000000000000 | 00000000000 
 615 | 000000e8 | xxxxxxxx | x | x | x | 00xxxxxxxx | 00xxxxxxxx | 00000000000000 | 00000xxxxxxxx | 00000xxxxxxxx | 0000000000000 | 00000xxxxxxxx | 000000000000 | 00000000000 
 625 | 000000ec | xxxxxxxx | x | x | x | 00xxxxxxxx | 00xxxxxxxx | 00000000000000 | 00000xxxxxxxx | 00000xxxxxxxx | 0000000000000 | 00000xxxxxxxx | 000000000000 | 00000000000 
 635 | 000000f0 | xxxxxxxx | x | x | x | 00xxxxxxxx | 00xxxxxxxx | 00000000000000 | 00000xxxxxxxx | 00000xxxxxxxx | 0000000000000 | 00000xxxxxxxx | 000000000000 | 00000000000 
 645 | 000000f4 | xxxxxxxx | x | x | x | 00xxxxxxxx | 00xxxxxxxx | 00000000000000 | 00000xxxxxxxx | 00000xxxxxxxx | 0000000000000 | 00000xxxxxxxx | 000000000000 | 00000000000 
 655 | 000000f8 | xxxxxxxx | x | x | x | 00xxxxxxxx | 00xxxxxxxx | 00000000000000 | 00000xxxxxxxx | 00000xxxxxxxx | 0000000000000 | 00000xxxxxxxx | 000000000000 | 00000000000 
 665 | 000000fc | xxxxxxxx | x | x | x | 00xxxxxxxx | 00xxxxxxxx | 00000000000000 | 00000xxxxxxxx | 00000xxxxxxxx | 0000000000000 | 00000xxxxxxxx | 000000000000 | 00000000000 
 675 | 00000100 | xxxxxxxx | x | x | x | 00xxxxxxxx | 00xxxxxxxx | 00000000000000 | 00000xxxxxxxx | 00000xxxxxxxx | 0000000000000 | 00000xxxxxxxx | 000000000000 | 00000000000 
 685 | 00000104 | xxxxxxxx | x | x | x | 00xxxxxxxx | 00xxxxxxxx | 00000000000000 | 00000xxxxxxxx | 00000xxxxxxxx | 0000000000000 | 00000xxxxxxxx | 000000000000 | 00000000000 
 695 | 00000108 | xxxxxxxx | x | x | x | 00xxxxxxxx | 00xxxxxxxx | 00000000000000 | 00000xxxxxxxx | 00000xxxxxxxx | 0000000000000 | 00000xxxxxxxx | 000000000000 | 00000000000 
 705 | 0000010c | xxxxxxxx | x | x | x | 00xxxxxxxx | 00xxxxxxxx | 00000000000000 | 00000xxxxxxxx | 00000xxxxxxxx | 0000000000000 | 00000xxxxxxxx | 000000000000 | 00000000000 
 715 | 00000110 | xxxxxxxx | x | x | x | 00xxxxxxxx | 00xxxxxxxx | 00000000000000 | 00000xxxxxxxx | 00000xxxxxxxx | 0000000000000 | 00000xxxxxxxx | 000000000000 | 00000000000 
 725 | 00000114 | xxxxxxxx | x | x | x | 00xxxxxxxx | 00xxxxxxxx | 00000000000000 | 00000xxxxxxxx | 00000xxxxxxxx | 0000000000000 | 00000xxxxxxxx | 000000000000 | 00000000000 

--------------------------------------------------------------------------------

Final Register File State (Time: 732)

  x0: 00000000
  
  x1: 00000005
  
  x2: 0000000a
  
  x3: 0000000f
  
  x4: 00000000
  
  x5: 00000000
  
  x6: 00000000
  
  x7: 00000000
  
  x8: 00000000
  
  x9: 00000000
  
  x10: 00000000
  
  x11: 00000000
  
  x12: 00000000
  
  x13: 00000000
  
  x14: 00000000
  
  x15: 00000000
  
  x16: 00000000
  
  x17: 00000000
  
  x18: 00000000
  
  x19: 00000000
  
  x20: 00000000
  
  x21: 00000000
  
  x22: 00000000
  
  x23: 00000000
  
  x24: 00000000
  
  x25: 00000000
  
  x26: 00000000
  
  x27: 00000000
  
  x28: 00000000
  
  x29: 00000000
  
  x30: 00000000
  
  x31: 00000000
  
--------------------------------------------------------------------------------

Data Memory Content at Address 0 (Time: 732)

  Mem[0x00]: 0000000f
  
--------------------------------------------------------------------------------

$finish called at time : 732 ns : File "C:/Users/arjit/pipelined_riscv/pipelined_riscv.srcs/sim_1/new/risc_v_tb.v" Line 115

xsim: Time (s): cpu = 00:00:08 ; elapsed = 00:00:07 . Memory (MB): peak = 1225.844 ; gain = 0.000

launch_simulation: Time (s): cpu = 00:00:10 ; elapsed = 00:00:15 . Memory (MB): peak = 1225.844 ; gain = 0.000

```
---------------------------------------------------------------------------------
Starting RTL Elaboration : Time (s): cpu = 00:00:07 ; elapsed = 00:00:08 . Memory (MB): peak = 1023.441 ; gain = 469.523
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
Finished RTL Elaboration : Time (s): cpu = 00:00:09 ; elapsed = 00:00:11 . Memory (MB): peak = 1142.785 ; gain = 588.867
---------------------------------------------------------------------------------
Finished Handling Custom Attributes : Time (s): cpu = 00:00:09 ; elapsed = 00:00:11 . Memory (MB): peak = 1142.785 ; gain = 588.867
Finished RTL Optimization Phase 1 : Time (s): cpu = 00:00:09 ; elapsed = 00:00:11 . Memory (MB): peak = 1142.785 ; gain = 588.867
Netlist sorting complete. Time (s): cpu = 00:00:00 ; elapsed = 00:00:00.052 . Memory (MB): peak = 1142.785 ; gain = 0.000
Netlist sorting complete. Time (s): cpu = 00:00:00 ; elapsed = 00:00:00 . Memory (MB): peak = 1230.289 ; gain = 0.000
Constraint Validation Runtime : Time (s): cpu = 00:00:00 ; elapsed = 00:00:00.043 . Memory (MB): peak = 1230.289 ; gain = 0.000
Finished Constraint Validation : Time (s): cpu = 00:00:21 ; elapsed = 00:00:24 . Memory (MB): peak = 1230.289 ; gain = 676.371
Finished Loading Part and Timing Information : Time (s): cpu = 00:00:21 ; elapsed = 00:00:24 . Memory (MB): peak = 1230.289 ; gain = 676.371
Finished applying 'set_property' XDC Constraints : Time (s): cpu = 00:00:21 ; elapsed = 00:00:24 . Memory (MB): peak = 1230.289 ; gain = 676.371
Finished RTL Optimization Phase 2 : Time (s): cpu = 00:00:23 ; elapsed = 00:00:26 . Memory (MB): peak = 1230.289 ; gain = 676.371
Finished Cross Boundary and Area Optimization : Time (s): cpu = 00:00:41 ; elapsed = 00:00:45 . Memory (MB): peak = 1247.594 ; gain = 693.676
---------------------------------------------------------------------------------
Start ROM, RAM, DSP, Shift Register and Retiming Reporting
---------------------------------------------------------------------------------

Block RAM: Preliminary Mapping Report (see note below)
+-----------------+------------------+------------------------+---+---+------------------------+---+---+------------------+--------+--------+
|Module Name      | RTL Object       | PORT A (Depth x Width) | W | R | PORT B (Depth x Width) | W | R | Ports driving FF | RAMB18 | RAMB36 | 
+-----------------+------------------+------------------------+---+---+------------------------+---+---+------------------+--------+--------+
|RISC_V_PROCESSOR | data_mem/mem_reg | 1 K x 32(READ_FIRST)   | W |   | 1 K x 32(WRITE_FIRST)  |   | R | Port A and B     | 0      | 1      | 
+-----------------+------------------+------------------------+---+---+------------------------+---+---+------------------+--------+--------+

Note: The table above is a preliminary report that shows the Block RAMs at the current stage of the synthesis flow. Some Block RAMs may be reimplemented as non Block RAM primitives later in the synthesis flow. Multiple instantiated Block RAMs are reported only once. 
---------------------------------------------------------------------------------
Finished ROM, RAM, DSP, Shift Register and Retiming Reporting
---------------------------------------------------------------------------------
Finished Applying XDC Timing Constraints : Time (s): cpu = 00:00:49 ; elapsed = 00:00:54 . Memory (MB): peak = 1345.703 ; gain = 791.785
Finished Timing Optimization : Time (s): cpu = 00:00:54 ; elapsed = 00:00:59 . Memory (MB): peak = 1424.613 ; gain = 870.695
Finished Technology Mapping : Time (s): cpu = 00:00:56 ; elapsed = 00:01:01 . Memory (MB): peak = 1424.613 ; gain = 870.695
Finished IO Insertion : Time (s): cpu = 00:01:03 ; elapsed = 00:01:09 . Memory (MB): peak = 1583.234 ; gain = 1029.316
Finished Renaming Generated Instances : Time (s): cpu = 00:01:03 ; elapsed = 00:01:09 . Memory (MB): peak = 1583.234 ; gain = 1029.316
Finished Rebuilding User Hierarchy : Time (s): cpu = 00:01:03 ; elapsed = 00:01:09 . Memory (MB): peak = 1583.234 ; gain = 1029.316
Finished Renaming Generated Ports : Time (s): cpu = 00:01:03 ; elapsed = 00:01:09 . Memory (MB): peak = 1583.234 ; gain = 1029.316
Finished Handling Custom Attributes : Time (s): cpu = 00:01:03 ; elapsed = 00:01:09 . Memory (MB): peak = 1587.258 ; gain = 1033.340
Finished Renaming Generated Nets : Time (s): cpu = 00:01:03 ; elapsed = 00:01:09 . Memory (MB): peak = 1587.258 ; gain = 1033.340

Report Cell Usage: 
+------+---------+------+
|      |Cell     |Count |
+------+---------+------+
|1     |BUFG     |     1|
|2     |CARRY4   |    28|
|3     |LUT1     |     3|
|4     |LUT2     |    85|
|5     |LUT3     |    76|
|6     |LUT4     |    58|
|7     |LUT5     |    69|
|8     |LUT6     |   470|
|9     |MUXF7    |    64|
|10    |MUXF8    |    32|
|11    |RAMB36E1 |     1|
|12    |FDRE     |  1548|
|13    |IBUF     |     3|
|14    |OBUF     |    48|
+------+---------+------+
Finished Writing Synthesis Report : Time (s): cpu = 00:01:03 ; elapsed = 00:01:09 . Memory (MB): peak = 1587.258 ; gain = 1033.340
Netlist sorting complete. Time (s): cpu = 00:00:00 ; elapsed = 00:00:00.048 . Memory (MB): peak = 1596.430 ; gain = 0.000
Netlist sorting complete. Time (s): cpu = 00:00:00 ; elapsed = 00:00:00 . Memory (MB): peak = 1600.082 ; gain = 0.000
synth_design: Time (s): cpu = 00:01:09 ; elapsed = 00:01:19 . Memory (MB): peak = 1600.082 ; gain = 1230.066
Write ShapeDB Complete: Time (s): cpu = 00:00:00 ; elapsed = 00:00:00.006 . Memory (MB): peak = 1600.082 ; gain = 0.000
```

```
Copyright 1986-2022 Xilinx, Inc. All Rights Reserved. Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
---------------------------------------------------------------------------------------------------------------------------------------------
| Tool Version : Vivado v.2024.2 (win64) Build 5239630 Fri Nov 08 22:35:27 MST 2024
| Date         : Tue Jul  8 02:58:33 2025
| Host         : Aj_lappy running 64-bit major release  (build 9200)
| Command      : report_utilization -file RISC_V_PROCESSOR_utilization_synth.rpt -pb RISC_V_PROCESSOR_utilization_synth.pb
| Design       : RISC_V_PROCESSOR
| Device       : xc7k70tfbg484-1
| Speed File   : -1
| Design State : Synthesized
---------------------------------------------------------------------------------------------------------------------------------------------

Utilization Design Information

Table of Contents
-----------------
1. Slice Logic
1.1 Summary of Registers by Type
2. Memory
3. DSP
4. IO and GT Specific
5. Clocking
6. Specific Feature
7. Primitives
8. Black Boxes
9. Instantiated Netlists

1. Slice Logic
--------------

+-------------------------+------+-------+------------+-----------+-------+
|        Site Type        | Used | Fixed | Prohibited | Available | Util% |
+-------------------------+------+-------+------------+-----------+-------+
| Slice LUTs*             |  694 |     0 |          0 |     41000 |  1.69 |
|   LUT as Logic          |  694 |     0 |          0 |     41000 |  1.69 |
|   LUT as Memory         |    0 |     0 |          0 |     13400 |  0.00 |
| Slice Registers         | 1548 |     0 |          0 |     82000 |  1.89 |
|   Register as Flip Flop | 1548 |     0 |          0 |     82000 |  1.89 |
|   Register as Latch     |    0 |     0 |          0 |     82000 |  0.00 |
| F7 Muxes                |   64 |     0 |          0 |     20500 |  0.31 |
| F8 Muxes                |   32 |     0 |          0 |     10250 |  0.31 |
+-------------------------+------+-------+------------+-----------+-------+
* Warning! The Final LUT count, after physical optimizations and full implementation, is typically lower. Run opt_design after synthesis, if not already completed, for a more realistic count.
Warning! LUT value is adjusted to account for LUT combining.
Warning! For any ECO changes, please run place_design if there are unplaced instances


1.1 Summary of Registers by Type
--------------------------------

+-------+--------------+-------------+--------------+
| Total | Clock Enable | Synchronous | Asynchronous |
+-------+--------------+-------------+--------------+
| 0     |            _ |           - |            - |
| 0     |            _ |           - |          Set |
| 0     |            _ |           - |        Reset |
| 0     |            _ |         Set |            - |
| 0     |            _ |       Reset |            - |
| 0     |          Yes |           - |            - |
| 0     |          Yes |           - |          Set |
| 0     |          Yes |           - |        Reset |
| 0     |          Yes |         Set |            - |
| 1548  |          Yes |       Reset |            - |
+-------+--------------+-------------+--------------+


2. Memory
---------

+-------------------+------+-------+------------+-----------+-------+
|     Site Type     | Used | Fixed | Prohibited | Available | Util% |
+-------------------+------+-------+------------+-----------+-------+
| Block RAM Tile    |    1 |     0 |          0 |       135 |  0.74 |
|   RAMB36/FIFO*    |    1 |     0 |          0 |       135 |  0.74 |
|     RAMB36E1 only |    1 |       |            |           |       |
|   RAMB18          |    0 |     0 |          0 |       270 |  0.00 |
+-------------------+------+-------+------------+-----------+-------+
* Note: Each Block RAM Tile only has one FIFO logic available and therefore can accommodate only one FIFO36E1 or one FIFO18E1. However, if a FIFO18E1 occupies a Block RAM Tile, that tile can still accommodate a RAMB18E1


3. DSP
------

+-----------+------+-------+------------+-----------+-------+
| Site Type | Used | Fixed | Prohibited | Available | Util% |
+-----------+------+-------+------------+-----------+-------+
| DSPs      |    0 |     0 |          0 |       240 |  0.00 |
+-----------+------+-------+------------+-----------+-------+


4. IO and GT Specific
---------------------

+-----------------------------+------+-------+------------+-----------+-------+
|          Site Type          | Used | Fixed | Prohibited | Available | Util% |
+-----------------------------+------+-------+------------+-----------+-------+
| Bonded IOB                  |   51 |     0 |          0 |       285 | 17.89 |
| Bonded IPADs                |    0 |     0 |          0 |        14 |  0.00 |
| Bonded OPADs                |    0 |     0 |          0 |         8 |  0.00 |
| PHY_CONTROL                 |    0 |     0 |          0 |         6 |  0.00 |
| PHASER_REF                  |    0 |     0 |          0 |         6 |  0.00 |
| OUT_FIFO                    |    0 |     0 |          0 |        24 |  0.00 |
| IN_FIFO                     |    0 |     0 |          0 |        24 |  0.00 |
| IDELAYCTRL                  |    0 |     0 |          0 |         6 |  0.00 |
| IBUFDS                      |    0 |     0 |          0 |       275 |  0.00 |
| GTXE2_COMMON                |    0 |     0 |          0 |         1 |  0.00 |
| GTXE2_CHANNEL               |    0 |     0 |          0 |         4 |  0.00 |
| PHASER_OUT/PHASER_OUT_PHY   |    0 |     0 |          0 |        24 |  0.00 |
| PHASER_IN/PHASER_IN_PHY     |    0 |     0 |          0 |        24 |  0.00 |
| IDELAYE2/IDELAYE2_FINEDELAY |    0 |     0 |          0 |       300 |  0.00 |
| ODELAYE2/ODELAYE2_FINEDELAY |    0 |     0 |          0 |       100 |  0.00 |
| IBUFDS_GTE2                 |    0 |     0 |          0 |         2 |  0.00 |
| ILOGIC                      |    0 |     0 |          0 |       285 |  0.00 |
| OLOGIC                      |    0 |     0 |          0 |       285 |  0.00 |
+-----------------------------+------+-------+------------+-----------+-------+


5. Clocking
-----------

+------------+------+-------+------------+-----------+-------+
|  Site Type | Used | Fixed | Prohibited | Available | Util% |
+------------+------+-------+------------+-----------+-------+
| BUFGCTRL   |    1 |     0 |          0 |        32 |  3.13 |
| BUFIO      |    0 |     0 |          0 |        24 |  0.00 |
| MMCME2_ADV |    0 |     0 |          0 |         6 |  0.00 |
| PLLE2_ADV  |    0 |     0 |          0 |         6 |  0.00 |
| BUFMRCE    |    0 |     0 |          0 |        12 |  0.00 |
| BUFHCE     |    0 |     0 |          0 |        96 |  0.00 |
| BUFR       |    0 |     0 |          0 |        24 |  0.00 |
+------------+------+-------+------------+-----------+-------+


6. Specific Feature
-------------------

+-------------+------+-------+------------+-----------+-------+
|  Site Type  | Used | Fixed | Prohibited | Available | Util% |
+-------------+------+-------+------------+-----------+-------+
| BSCANE2     |    0 |     0 |          0 |         4 |  0.00 |
| CAPTUREE2   |    0 |     0 |          0 |         1 |  0.00 |
| DNA_PORT    |    0 |     0 |          0 |         1 |  0.00 |
| EFUSE_USR   |    0 |     0 |          0 |         1 |  0.00 |
| FRAME_ECCE2 |    0 |     0 |          0 |         1 |  0.00 |
| ICAPE2      |    0 |     0 |          0 |         2 |  0.00 |
| PCIE_2_1    |    0 |     0 |          0 |         1 |  0.00 |
| STARTUPE2   |    0 |     0 |          0 |         1 |  0.00 |
| XADC        |    0 |     0 |          0 |         1 |  0.00 |
+-------------+------+-------+------------+-----------+-------+


7. Primitives
-------------

+----------+------+---------------------+
| Ref Name | Used | Functional Category |
+----------+------+---------------------+
| FDRE     | 1548 |        Flop & Latch |
| LUT6     |  470 |                 LUT |
| LUT2     |   85 |                 LUT |
| LUT3     |   76 |                 LUT |
| LUT5     |   69 |                 LUT |
| MUXF7    |   64 |               MuxFx |
| LUT4     |   58 |                 LUT |
| OBUF     |   48 |                  IO |
| MUXF8    |   32 |               MuxFx |
| CARRY4   |   28 |          CarryLogic |
| LUT1     |    3 |                 LUT |
| IBUF     |    3 |                  IO |
| RAMB36E1 |    1 |        Block Memory |
| BUFG     |    1 |               Clock |
+----------+------+---------------------+


8. Black Boxes
--------------

+----------+------+
| Ref Name | Used |
+----------+------+


9. Instantiated Netlists
------------------------

+----------+------+
| Ref Name | Used |
+----------+------+
```



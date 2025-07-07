`timescale 1ns / 1ps

// Module: riscv_processor_tb (Test Bench)
module riscv_processor_tb;

    // Clock and Reset signals
    reg clk;
    reg rst;

    // Instantiate the RISC-V Processor
    RISC_V_PROCESSOR dut (
        .clk(clk),
        .rst(rst)
    );
    integer r; // Loop variable for displaying register file
    // Clock generation: 10ns period (5ns high, 5ns low)
    initial begin
        clk = 1'b0; // Initial clock state
        forever #5 clk = ~clk; // Toggle clock every 5 time units
    end

    // Test sequence
    initial begin
        // Apply asynchronous active-low reset
        rst = 1'b0; // Assert reset
        #10;        // Hold reset for 10ns (2 clock half-cycles)
        rst = 1'b1; // Release reset
        #10;        // Allow one full clock cycle for reset to propagate and pipeline to clear

        // ====================================================================
        // Monitor Setup for Table-like Output
        //
        // This $monitor statement will print a new line whenever any of the
        // monitored signals change. The signals are chosen to represent key
        // values from each pipeline stage at the current simulation time.
        // Note that at any given time, these signals belong to different
        // instructions in the pipeline.
        // ====================================================================

        // Print header for the table
        $display("-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------");
        $display("Time | IF_PC    | ID_Instr | ID_RS1 | ID_RS2 | ID_RD | EX_ALU_Op1 | EX_ALU_Op2 | EX_ALU_Control | EX_ALU_Result | EX_Store_Data | MEM_Read_Data | WB_Write_Data | MEM_MemWrite | WB_RegWrite | Hazard_PC_En | Hazard_IF_ID_En | Hazard_IF_ID_Flush | Hazard_ID_EX_Flush | Hazard_Branch_Taken | Hazard_Branch_Resolved");
        $display("-----|----------|----------|--------|--------|-------|------------|------------|----------------|---------------|---------------|---------------|---------------|--------------|-------------|--------------|-----------------|--------------------|--------------------|---------------------|----------------------");

        // The $monitor statement
        $monitor("%4d | %8h | %8h | %6d | %6d | %5d | %10h | %10h | %14b | %13h | %13h | %13h | %13h | %12b | %11b | %12b | %15b | %18b | %18b | %19b | %20b",
                 $time,
                 dut.if_pc,                                 // PC of instruction currently being fetched (IF Stage)
                 dut.id_instruction,                        // Instruction currently in ID stage
                 dut.id_rs1_addr,                           // RS1 address of instruction in ID stage
                 dut.id_rs2_addr,                           // RS2 address of instruction in ID stage
                 dut.id_rd_addr,                            // RD address of instruction in ID stage
                 dut.ex_alu_op1,                            // ALU Operand 1 for instruction in EX stage
                 dut.ex_alu_op2,                            // ALU Operand 2 for instruction in EX stage
                 dut.ex_alu_control,                        // ALU Control for instruction in EX stage
                 dut.ex_alu_result,                         // ALU Result for instruction in EX stage
                 dut.ex_rs2_data_for_store,                 // Data to be stored for instruction in EX stage
                 dut.mem_data_mem_read_data,                // Data read from memory for instruction in MEM stage
                 dut.wb_write_data,                         // Final data to be written to RegFile for instruction in WB stage
                 dut.mem_mem_write,                         // Memory Write Enable for instruction in MEM stage
                 dut.wb_reg_write_en,                       // Register Write Enable for instruction in WB stage
                 dut.hazard_detection.pc_write_en,          // PC Write Enable from Hazard Unit
                 dut.hazard_detection.if_id_enable,         // IF/ID Enable from Hazard Unit
                 dut.hazard_detection.if_id_flush,          // IF/ID Flush from Hazard Unit
                 dut.hazard_detection.id_ex_flush,          // ID/EX Flush from Hazard Unit
                 dut.hazard_detection.ex_branch_taken,      // Branch Taken from Hazard Unit
                 dut.hazard_detection.ex_branch_resolved    // Branch Resolved from Hazard Unit
                );

        // The program has 6 instructions, plus pipeline fill/drain.
        // We'll run for 50 cycles (500ns) to observe full pipeline behavior.
        #700; // Run for 700ns (70 clock cycles)


        // Display final register file state
        $display("\n--------------------------------------------------------------------------------");
        $display("Final Register File State (Time: %0d)", $time);
        for (r = 0; r < 32; r = r + 1) begin
            $display("  x%0d: %h", r, dut.rf.registers[r]);
        end
        $display("--------------------------------------------------------------------------------");

        // Display final data memory content at address 0
        $display("Data Memory Content at Address 0 (Time: %0d)", $time);
        $display("  Mem[0x00]: %h", dut.data_mem.mem[0]);
        $display("--------------------------------------------------------------------------------");

        $finish; // End simulation
    end

endmodule

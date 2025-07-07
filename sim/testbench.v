`timescale 1ns / 1ps

// Module: riscv_processor_tb (Test Bench)
module riscv_processor_tb;

    // Clock and Reset signals
    reg clk;
    reg rst;
    reg output_en;
    wire [7:0] pc_out;   //Current program counter
    wire [7:0] instr_out;        //current instruction in ID stage
    wire [7:0] alu_out;          //ALU result in the EX stage
    wire [7:0] reg_x1;           //Register X1 (for debug)
    wire [7:0] reg_x2;           //Register x2 (for debug)
    wire [7:0] mem_data_out;     //Data memory output (read data)
  
    

    // Instantiate the RISC-V Processor
    RISC_V_PROCESSOR dut (
        .clk(clk),
        .rst(rst),
        .output_en(output_en),
        .pc_out(pc_out),
        .instr_out(instr_out),
        .alu_out(alu_out),
        .reg_x1(reg_x1),
        .reg_x2(reg_x2),
        .mem_data_out(mem_data_out)
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
        output_en = 1'b0;
        #12;
        output_en = 1'b1;       //Assert the output enable line for output display

        // ====================================================================
        // Monitor Setup for Table-like Output
     
        // Print header for the table
        $display("-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------");
        $display("Time | IF_PC    | ID_Instr | ID_RS1 | ID_RS2 | ID_RD | EX_ALU_Op1 | EX_ALU_Op2 | EX_ALU_Control | EX_ALU_Result | EX_Store_Data | MEM_Read_Data | WB_Write_Data | MEM_MemWrite | WB_RegWrite | ");
        $display("-----|----------|----------|--------|--------|-------|------------|------------|----------------|---------------|---------------|---------------|---------------|--------------|-------------|");

        // The $monitor statement
        $monitor("%4d | %8h | %8h | %6d | %6d | %5d | %10h | %10h | %14b | %13h | %13h | %13h | %13h | %12b | %11b",
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
                );

        // The program has 6 instructions, plus pipeline fill/drain.
        // We'll run for 70 cycles (700ns) to observe full pipeline behavior.
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

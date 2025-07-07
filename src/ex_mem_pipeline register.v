`timescale 1ns / 1ps

// EX-MEM Pipeline Register
// Transfers ALU result, RS2 data (for stores), PC+4 (for JAL/JALR), destination register
// address, and memory control signals from EX stage to MEM stage.
module ex_mem_pipeline(
    input clk,            // Clock
    input rst,            // Reset
    input flush,          // Flush signal
    input enable,         // Enable signal

    // Inputs from the EX stage
    input [31:0] ex_pc_plus_4,    // PC+4 (for JAL/JALR)
    input [31:0] ex_rs2_data,     // Data for memory write (store instructions)
    input [4:0] ex_rd_addr,       // Destination register address
    input [31:0] ex_alu_result,   // ALU result
    input [2:0] ex_func3,         // Added: func3 from EX stage (passed through to MEM)

    // Control signals from the EX stage
    input ex_reg_write_en,        // Register write enable
    input ex_mem_read,            // Memory read enable
    input ex_mem_write,           // Memory write enable
    input [3:0] ex_byte_en,       // Byte enable for memory access
    input [1:0] ex_mem_to_reg_sel,      // Select data for writeback
    input ex_jump_en,             // Propagate jump enable
    input ex_jalr_en,             // Propagate JALR enable

    // Outputs are the registered versions of all the input signals
    output reg [31:0] mem_pc_plus_4,      // Registered PC+4
    output reg [31:0] mem_alu_result,     // Registered ALU result
    output reg [31:0] mem_rs2_data,       // Registered RS2 data
    output reg [4:0] mem_rd_addr,         // Registered destination register address
    output reg [2:0] mem_func3,           // Added: func3 in MEM stage
    output reg mem_reg_write_en,          // Registered register write enable
    output reg mem_mem_read,              // Registered memory read enable
    output reg mem_mem_write,             // Registered memory write enable
    output reg [3:0] mem_byte_en,         // Registered byte enable
    output reg [1:0] mem_mem_to_reg_sel,  // Registered select data for writeback
    output reg mem_jump_en,               // Registered jump enable
    output reg mem_jalr_en                // Registered JALR enable
);
    always @ (posedge clk) begin
        if (!rst) begin
            // Reset all outputs to default/zero
            mem_alu_result     <= 32'b0;
            mem_rs2_data       <= 32'b0;
            mem_pc_plus_4      <= 32'b0;
            mem_rd_addr        <= 5'b0;
            mem_func3          <= 3'b0; // Reset func3
            mem_reg_write_en   <= 1'b0;
            mem_mem_read       <= 1'b0;
            mem_mem_write      <= 1'b0;
            mem_byte_en        <= 4'b0;
            mem_mem_to_reg_sel <= 2'b00;
            mem_jump_en        <= 1'b0; // Reset jump enable
            mem_jalr_en        <= 1'b0; // Reset JALR enable
        end else if (flush) begin
            // Flush: Clear control signals, zero out data
            mem_reg_write_en   <= 1'b0;
            mem_mem_read       <= 1'b0;
            mem_mem_write      <= 1'b0;
            mem_byte_en        <= 4'b0;
            mem_mem_to_reg_sel <= 2'b00;
            mem_jump_en        <= 1'b0; // Clear jump enable
            mem_jalr_en        <= 1'b0; // Clear JALR enable

            mem_alu_result     <= 32'b0;
            mem_rs2_data       <= 32'b0;
            mem_pc_plus_4      <= 32'b0;
            mem_rd_addr        <= 5'b0;
            mem_func3          <= 3'b0; // Clear func3
        end else if (enable) begin
            // Load new values from EX stage if enabled (pipeline register logic implies this for previous stage enable)
            mem_alu_result     <= ex_alu_result;
            mem_rs2_data       <= ex_rs2_data;
            mem_pc_plus_4      <= ex_pc_plus_4;
            mem_rd_addr        <= ex_rd_addr;
            mem_func3          <= ex_func3; // Pass func3 to MEM stage

            mem_reg_write_en   <= ex_reg_write_en;
            mem_mem_read       <= ex_mem_read;
            mem_mem_write      <= ex_mem_write;
            mem_byte_en        <= ex_byte_en;
            mem_mem_to_reg_sel <= ex_mem_to_reg_sel;
            mem_jump_en        <= ex_jump_en; // Propagate jump enable
            mem_jalr_en        <= ex_jalr_en; // Propagate JALR enable
        end
    end

endmodule

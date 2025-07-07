`timescale 1ns / 1ps

// MEM-WB Pipeline Register
// Transfers ALU result, memory read data, PC+4, destination register address,
// and write-back control signals from MEM stage to WB stage.
module pipeline_mem_wb(
    input clk,            // Clock
    input rst,            // Reset
    input flush,          // Flush signal
    input enable,         // Enable signal

    // Input signals from MEM stage
    input [31:0] mem_alu_result,         // ALU result from MEM stage
    input [31:0] mem_pc_plus_4,          // PC+4 from MEM stage
    input [4:0] mem_rd_addr,             // Destination register address from MEM stage
    input [31:0] mem_data_mem_read_data, // Data read from memory
    input [2:0] mem_func3,               // Added: func3 from MEM stage (passed through to WB)


    // Control signals from the MEM stage
    input mem_reg_write_en,              // Register write enable
    input [1:0] mem_mem_to_reg_sel,      // Select data for writeback
    input mem_jump_en,                   // Propagate jump enable
    input mem_jalr_en,                   // Propagate JALR enable

    // Outputs are the registered versions of all the input signals
    output reg [31:0] wb_alu_result,          // Registered ALU result
    output reg [31:0] wb_pc_plus_4,           // Registered PC+4
    output reg [4:0] wb_rd_addr,              // Registered destination register address
    output reg [31:0] wb_data_mem_read_data,  // Registered memory read data
    output reg [2:0] wb_func3,                // Added: func3 in WB stage
    output reg wb_reg_write_en,              // Registered register write enable
    output reg [1:0] wb_mem_to_reg_sel,      // Registered select data for writeback
    output reg wb_jump_en,                   // Registered jump enable
    output reg wb_jalr_en                    // Registered JALR enable
);

    always @(posedge clk) begin
        if (!rst) begin
            // Reset all outputs to default/zero
            wb_alu_result         <= 32'b0;
            wb_data_mem_read_data <= 32'b0;
            wb_pc_plus_4          <= 32'b0;
            wb_rd_addr            <= 5'b0;
            wb_func3              <= 3'b0; // Reset func3
            wb_reg_write_en       <= 1'b0;
            wb_mem_to_reg_sel     <= 2'b00;
            wb_jump_en            <= 1'b0; // Reset jump enable
            wb_jalr_en            <= 1'b0; // Reset JALR enable
        end else if (flush) begin
            // Flush: Set control signals to NOP equivalent, clear data
            wb_reg_write_en       <= 1'b0; // This is crucial for flushing an instruction
            wb_mem_to_reg_sel     <= 2'b00;
            wb_jump_en            <= 1'b0; // Clear jump enable
            wb_jalr_en            <= 1'b0; // Clear JALR enable

            wb_alu_result         <= 32'b0;
            wb_data_mem_read_data <= 32'b0;
            wb_pc_plus_4          <= 32'b0;
            wb_rd_addr            <= 5'b0;
            wb_func3              <= 3'b0; // Clear func3
        end else if (enable) begin
            // Load new values from MEM stage if enabled
            wb_alu_result         <= mem_alu_result;
            wb_data_mem_read_data <= mem_data_mem_read_data;
            wb_pc_plus_4          <= mem_pc_plus_4;
            wb_rd_addr            <= mem_rd_addr;
            wb_func3              <= mem_func3; // Pass func3 to WB stage

            wb_reg_write_en       <= mem_reg_write_en;
            wb_mem_to_reg_sel     <= mem_mem_to_reg_sel;
            wb_jump_en            <= mem_jump_en; // Propagate jump enable
            wb_jalr_en            <= mem_jalr_en; // Propagate JALR enable
        end
    end

endmodule

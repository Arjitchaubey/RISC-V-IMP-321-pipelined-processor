`timescale 1ns / 1ps

// Register File Unit Logic
    // This module implements the 32-entry RISC-V register file. It supports
    // synchronous writes and combinational reads. Register x0 (address 0) is
    // hardwired to zero.
    module reg_file(
        input clk,               // Clock signal for synchronous writes
        input rst,               // Synchronous reset signal
        input reg_write_en,      // Enable signal for writing to a register
        input [4:0] rs1_addr,    // Address for read port 1
        input [4:0] rs2_addr,    // Address for read port 2
        input [4:0] rd_addr,     // Address for write port
        input [31:0] rd_write_data, // Data to be written to the register
    
        output [31:0] rs1_data,  // Data read from rs1_addr
        output [31:0] rs2_data   // Data read from rs2_addr
    );
        reg [31:0] registers [0:31]; // 32 general-purpose 32-bit registers
    
        integer i;
        // Initialize all registers to zero at the start of simulation
        initial begin
            for (i = 0; i < 32; i = i + 1) begin
                registers[i] <= 32'b0;
            end
        end
    
        // Write logic: Synchronous on positive clock edge, asynchronous reset
        always @(posedge clk) begin
            if (!rst) begin
                // On reset, clear all registers
                for (i = 0; i < 32; i = i + 1) begin
                    registers[i] <= 32'b0;
                end
            end else if (reg_write_en && rd_addr != 32'b0) begin
                registers[rd_addr] = rd_write_data;
                
                end
            end
    
        // Read logic: Combinational. If rs1_addr or rs2_addr is 0, output 0.
        assign rs1_data = (rs1_addr == 5'b00000) ? 32'b0 : registers[rs1_addr];
        assign rs2_data = (rs2_addr == 5'b00000) ? 32'b0 : registers[rs2_addr];
    
    endmodule

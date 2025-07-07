`timescale 1ns / 1ps

// PROGRAM COUNTER LOGIC
// This module manages the Program Counter (PC), which holds the address of the
// instruction to be fetched next. It supports synchronous updates and reset.
module pc(
    input clk,          // Clock signal for synchronous updates
    input rst,          // Synchronus reset signal (active low)
    input [31:0] next_pc,  // The next PC value to be loaded
    input pc_write_en,  // When logic 0, it allows the Program Counter to retain its value (stall) for pipeline hazard control
    output [31:0] current_pc // The program counter outputs the current program's count
);
    reg [31:0] pc_value;    // Internal register to hold the PC value

    // Synchronous update of the PC logic on the posiive edge of clk
    always @(posedge clk) begin
        if(!rst) begin
            pc_value <= 32'h00000000; // Low reset logic: PC reset to address 0
        end else if (pc_write_en) begin
            pc_value <= next_pc; // Update PC with the next PC value if enabled
        end
    end

    assign current_pc = pc_value; // Combinational assignment of pc_value to the current_pc

endmodule

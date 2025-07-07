`timescale 1ns / 1ps

// Generic Pipeline Register Module
// This module provides a basic D-flip-flop with enable and asynchronous reset,
// and a synchronous flush to insert NOPs.
module pipeline_register #(
    parameter DATA_WIDTH = 32 // Parameter for data width
) (
    input clk,          // Clock signal
    input rst,          // Synchronous reset signal (active low)
    input flush,        // Synchronous flush signal (active high)
    input enable,       // Register enable signal (active high)
    input [DATA_WIDTH-1:0] in_data, // Input data
    output reg [DATA_WIDTH-1:0] out_data   // Registered output data
);

    always @(posedge clk) begin
        if (!rst) begin //active-low reset
            out_data <= {DATA_WIDTH{1'b0}}; // Reset to all zeros
        end else if (flush) begin // Synchronous flush (insert NOP)
            out_data <= {DATA_WIDTH{1'b0}}; // NOP instruction (all zeros)
        end else if (enable) begin // Load new data when enabled
            out_data <= in_data;
        end
    end

endmodule



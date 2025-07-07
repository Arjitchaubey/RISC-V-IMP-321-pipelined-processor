// IF-ID Pipeline Register
// Transfers PC, PC+4, and the fetched instruction from IF stage to ID stage.
module if_id_pipeline (
    input clk,               // Clock
    input rst,               // Reset
    input flush,             // Flush signal (for branches/jumps)
    input enable,            // Enable signal (for stalls)
    input [31:0] if_pc,         // PC of fetched instruction
    input [31:0] if_pc_plus_4,  // PC + 4 of the fetched instruction
    input [31:0] if_instruction, // The instruction fetched in the IF stage

    output reg [31:0] id_pc,          // PC of decoded instruction
    output reg [31:0] id_pc_plus_4,   // PC+4 of decoded instruction
    output reg [31:0] id_instruction  // Decoded instruction
);
    // NOP instruction (ADDI x0, x0, 0)
    parameter NOP_INSTRUCTION = 32'h00000013;

    always @ (posedge clk) begin
        if(!rst) begin
            id_pc          <= 32'b0;
            id_pc_plus_4   <= 32'b0;
            id_instruction <= 32'b0; // Default to NOP instruction or all zeros
        end else if(flush) begin
            id_pc          <= 32'b0;
            id_pc_plus_4   <= 32'b0;
            id_instruction <= NOP_INSTRUCTION; // Flush: insert NOP for branch/jump misprediction
        end else if (enable) begin
            id_pc          <= if_pc;
            id_pc_plus_4   <= if_pc_plus_4;
            id_instruction <= if_instruction;
        end
    end

endmodule

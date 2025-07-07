// INSTRUCTION MEMORY (Synthesizable Version)
// This module infers a synchronous read-only memory for instructions.
// Memory contents are loaded from an external file during synthesis or FPGA configuration.

module instruction_memory(
    input clk,                  // Clock signal for synchronous read
    input [31:0] address,       // 32-bit instruction address
    output reg [31:0] instruction // 32-bit instruction read from memory
);

    parameter MEM_SIZE = 1024; // 1KB memory (1024 bytes) -> 256 words
    reg [31:0] imem [0:(MEM_SIZE/4)-1]; // Word-addressable instruction memory

    // Synthesis/FPGA tools will use the following line to initialize memory from a file.
    // The file "program.mem" should be in the same directory as your project.
    initial $readmemh("program.hex", imem);

    always @(posedge clk) begin
        instruction <= imem[address[31:2]]; // Word-aligned access
    end

endmodule

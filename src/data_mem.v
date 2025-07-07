`timescale 1ns / 1ps

// Memory Bank Module
// Simulates a data memory unit with byte-level access control.
module memory_bank (
    input clk,          // Clock signal
    input rst,          // Reset signal
    input read_en,      // Read enable
    input write_en,     // Write enable
    input [31:0] address,   // 32-bit byte address
    input [31:0] write_data, // 32-bit data to write
    input [3:0]  byte_enable, // Byte enable for partial word writes (4'b1111 for full word)
    output reg [31:0] read_data    // 32-bit data read from memory
);

    // Memory declaration: 2^10 words (4KB)
    // Each word is 32 bits (4 bytes)
    reg [31:0] mem [0:1023]; // 1024 words * 4 bytes/word = 4096 bytes (4KB)

    // Initialize memory on reset or at the start of simulation (optional, for testbench)
    integer i;
    initial begin
        for (i = 0; i < 1024; i = i + 1) begin
            mem[i] = 32'b0; // Initialize all memory locations to 0
        end
        // For testing the LW instruction, let's pre-load a value at address 0x00
        // This corresponds to word address 0x00 / 4 = 0
        mem[0] = 32'h0000000F; // Example value: 15
    end

    // Read operation
    always @(posedge clk) begin
        if (rst) begin
            read_data <= 32'b0;
        end else if (read_en) begin
            // Address is byte-aligned, but memory is word-aligned.
            // Divide by 4 to get the word address.
            // Ensure address is word-aligned for full word reads.
            read_data <= mem[address[31:2]]; // Read the entire word
        end else begin
            read_data <= 32'b0; // Default to 0 when not reading
        end
    end

    // Write operation
    always @(posedge clk) begin
        if (!rst && write_en) begin
            // Address is byte-aligned, but memory is word-aligned.
            // Divide by 4 to get the word address.
            // Use byte_enable for partial word writes.
            case(byte_enable)
                4'b1111: begin // Word write (SW)
                    mem[address[31:2]] <= write_data;
                end
                4'b0001: begin // Byte write (SB) - to byte 0
                    mem[address[31:2]][7:0] <= write_data[7:0];
                end
                4'b0010: begin // Byte write (SB) - to byte 1
                    mem[address[31:2]][15:8] <= write_data[7:0];
                end
                4'b0100: begin // Byte write (SB) - to byte 2
                    mem[address[31:2]][23:16] <= write_data[7:0];
                end
                4'b1000: begin // Byte write (SB) - to byte 3
                    mem[address[31:2]][31:24] <= write_data[7:0];
                end
                4'b0011: begin // Half-word write (SH) - to bytes 0-1
                    mem[address[31:2]][15:0] <= write_data[15:0];
                end
                4'b1100: begin // Half-word write (SH) - to bytes 2-3
                    mem[address[31:2]][31:16] <= write_data[15:0];
                end
                default: begin
                    // No operation for unsupported byte enables or partial word writes
                    // This could indicate an error or an unsupported access type.
                end
            endcase
        end
    end

endmodule

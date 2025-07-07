`timescale 1ns / 1ps

// Sign Extend Module
// Extends various immediate formats (I, S, B, U, J) to 32 bits.
module sign_extend (
    input [31:0] instruction,    // Full instruction to extract immediate from
    input [2:0]  ins_type_sel,   // Instruction type select from instruction_decoder
                                 // 0: I-type (LOAD, OP-IMM, JALR)
                                 // 1: S-type (STORE)
                                 // 2: B-type (BRANCH)
                                 // 3: U-type (LUI, AUIPC)
                                 // 4: J-type (JAL)
    output reg [31:0] extended_immediate // 32-bit sign-extended immediate
);

    // Internal wires for extracting immediate fields
    wire [11:0] i_imm; // I-type immediate
    wire [11:0] s_imm; // S-type immediate
    wire [12:0] b_imm; // B-type immediate (13-bit value, but constructed from parts)
    wire [19:0] u_imm; // U-type immediate
    wire [20:0] j_imm; // J-type immediate (21-bit value, but constructed from parts)

    // Extracting immediate fields based on RISC-V ISA
    // I-type: imm[11:0] = inst[31:20]
    assign i_imm = instruction[31:20];

    // S-type: imm[11:5] = inst[31:25], imm[4:0] = inst[11:7]
    assign s_imm = {instruction[31:25], instruction[11:7]};

    // B-type: imm[12] = inst[31], imm[10:5] = inst[30:25], imm[4:1] = inst[11:8], imm[0] = inst[7]
    // The B-type immediate is constructed as: {imm[12], imm[10:5], imm[4:1], imm[11]} << 1
    // The spec uses: imm[12|10:5|4:1|11]
    assign b_imm = {instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0}; // Shifted left by 1 implicitly

    // U-type: imm[31:12] = inst[31:12], imm[11:0] = 12'b0
    assign u_imm = instruction[31:12];

    // J-type: imm[20] = inst[31], imm[10:1] = inst[30:21], imm[11] = inst[20], imm[19:12] = inst[19:12]
    // The J-type immediate is constructed as: {imm[20], imm[10:1], imm[11], imm[19:12]} << 1
    // The spec uses: imm[20|10:1|11|19:12]
    assign j_imm = {instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0}; // Shifted left by 1 implicitly


    always @(*) begin
        case(ins_type_sel)
            3'b000: begin // I-type (LOAD, OP-IMM, JALR)
                extended_immediate = {{20{i_imm[11]}}, i_imm}; // Sign-extend 12-bit immediate
            end
            3'b001: begin // S-type (STORE)
                extended_immediate = {{20{s_imm[11]}}, s_imm}; // Sign-extend 12-bit immediate
            end
            3'b010: begin // B-type (BRANCH)
                extended_immediate = {{19{b_imm[12]}}, b_imm}; // Sign-extend 13-bit immediate
            end
            3'b011: begin // U-type (LUI, AUIPC)
                extended_immediate = {u_imm, 12'b0}; // U-type immediate is already 20 bits, lower 12 bits are zero
            end
            3'b100: begin // J-type (JAL)
                extended_immediate = {{11{j_imm[20]}}, j_imm}; // Sign-extend 21-bit immediate
            end
            default: begin
                extended_immediate = 32'b0; // Default to zero for undefined types
            end
        endcase
    end

endmodule

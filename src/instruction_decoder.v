`timescale 1ns / 1ps

// Instruction Decoder Module
// Decodes the instruction and generates control signals and immediate values.
// This module supports R, I, S, B, U, J type instructions.
module instruction_decoder (
    input [31:0] instruction,   // 32-bit instruction from IF/ID register

    output [4:0] rs1_addr,      // Read register 1 address
    output [4:0] rs2_addr,      // Read register 2 address
    output [4:0] rd_addr,       // Write register address
    output [2:0] id_func3,      // func3 field (for ALU and Branch)

    // Control signals for ID/EX pipeline register
    output reg id_ex_reg_write_en,  // Register write enable
    output reg [2:0] id_ex_imm_type_sel, // Immediate type select (0: I, 1: S, 2: B, 3: U, 4: J)
    output reg id_ex_alu_src_sel,   // ALU Operand 2 select (0: RS2 data, 1: Immediate)
    output reg [3:0] id_ex_alu_control, // ALU operation control
    output reg id_ex_mem_read_en,   // Memory read enable
    output reg id_ex_mem_write_en,  // Memory write enable
    output reg [3:0] id_ex_byte_en, // Byte enable for memory access (4'b1111 for word, etc.)
    output reg [1:0] id_ex_mem_to_reg_sel, // Select data for writeback (00: ALU result, 01: Memory data, 11: pc+4)
    output reg id_ex_branch_en,     // Is this a branch instruction?
    output reg id_ex_jump_en,       // Is this a JAL instruction? (for PC update and flush)
    output reg id_ex_jalr_en,       // Is this a JALR instruction? (for PC update and flush)
    output reg id_ex_auipc_op       // Is this an AUIPC instruction?
);

    // Extract fields from instruction
    wire [6:0] opcode = instruction[6:0];
    wire [4:0] rs1    = instruction[19:15];
    wire [4:0] rs2    = instruction[24:20];
    wire [4:0] rd     = instruction[11:7];
    wire [2:0] func3  = instruction[14:12];
    wire [6:0] func7  = instruction[31:25];

    // Assign output addresses directly
    assign rs1_addr = rs1;
    assign rs2_addr = rs2;
    assign rd_addr  = rd;
    assign id_func3 = func3; // Pass func3 to EX stage for branch condition evaluation

    // Control signal generation logic
    always @(*) begin
        // Default values for all control signals (NOP state)
        id_ex_reg_write_en   = 1'b0;
        id_ex_imm_type_sel   = 3'b000; // Default to I-type (or 0 for unused)
        id_ex_alu_src_sel    = 1'b0;   // Default to RS2 data
        id_ex_alu_control    = 4'b0000; // Default to ADD (or NOP equivalent)
        id_ex_mem_read_en    = 1'b0;
        id_ex_mem_write_en   = 1'b0;
        id_ex_byte_en        = 4'b0000; // No byte enable
        id_ex_mem_to_reg_sel = 2'b00;   // Default to ALU result
        id_ex_branch_en      = 1'b0;
        id_ex_jump_en        = 1'b0;
        id_ex_jalr_en        = 1'b0;
        id_ex_auipc_op       = 1'b0;

        case(opcode)
            // R-Type Instructions (ADD, SUB, SLL, SLT, SLTU, XOR, SRL, SRA, OR, AND)
            7'b0110011: begin // OP (R-type)
                id_ex_reg_write_en   = 1'b1;
                id_ex_alu_src_sel    = 1'b0; // ALU Op2 is RS2 data
                id_ex_mem_to_reg_sel = 2'b00; // Write back ALU result

                case(func3)
                    3'b000: id_ex_alu_control = (func7 == 7'b0000000) ? 4'b0000 : 4'b0001; // ADD / SUB
                    3'b001: id_ex_alu_control = 4'b0010; // SLL
                    3'b010: id_ex_alu_control = 4'b0011; // SLT
                    3'b011: id_ex_alu_control = 4'b0100; // SLTU
                    3'b100: id_ex_alu_control = 4'b0101; // XOR
                    3'b101: id_ex_alu_control = (func7 == 7'b0000000) ? 4'b0110 : 4'b0111; // SRL / SRA
                    3'b110: id_ex_alu_control = 4'b1000; // OR
                    3'b111: id_ex_alu_control = 4'b1001; // AND
                    default: id_ex_alu_control = 4'b0000; // Default to ADD (or illegal)
                endcase
            end

            // I-Type Instructions (ADDI, SLTI, SLTIU, XORI, ORI, ANDI, SLLI, SRLI, SRAI, LW, JALR)
            7'b0010011: begin // OP-IMM (I-type Arithmetic/Logical)
                id_ex_reg_write_en   = 1'b1;
                id_ex_imm_type_sel   = 3'b000; // I-type immediate
                id_ex_alu_src_sel    = 1'b1;   // ALU Op2 is immediate data
                id_ex_mem_to_reg_sel = 2'b00; // Write back ALU result

                case(func3)
                    3'b000: id_ex_alu_control = 4'b0000; // ADDI
                    3'b010: id_ex_alu_control = 4'b0011; // SLTI
                    3'b011: id_ex_alu_control = 4'b0100; // SLTIU
                    3'b100: id_ex_alu_control = 4'b0101; // XORI
                    3'b110: id_ex_alu_control = 4'b1000; // ORI
                    3'b111: id_ex_alu_control = 4'b1001; // ANDI
                    3'b001: id_ex_alu_control = 4'b0010; // SLLI (func7 must be 0)
                    3'b101: id_ex_alu_control = (func7 == 7'b0000000) ? 4'b0110 : 4'b0111; // SRLI / SRAI
                    default: id_ex_alu_control = 4'b0000; // Default ADDI (or illegal)
                endcase
            end

            7'b0000011: begin // LOAD (I-type)
                id_ex_reg_write_en   = 1'b1;
                id_ex_imm_type_sel   = 3'b000; // I-type immediate
                id_ex_alu_src_sel    = 1'b1;   // ALU Op2 is immediate for address calculation
                id_ex_alu_control    = 4'b0000; // ADD for address calculation
                id_ex_mem_read_en    = 1'b1;
                id_ex_mem_to_reg_sel = 2'b01;   // Write back memory data
                id_ex_byte_en        = (func3 == 3'b000) ? 4'b0001 : // LB
                                       (func3 == 3'b001) ? 4'b0011 : // LH
                                       (func3 == 3'b010) ? 4'b1111 : // LW
                                       (func3 == 3'b100) ? 4'b0001 : // LBU
                                       (func3 == 3'b101) ? 4'b0011 : 4'b1111; // LHU / Default LW
            end

            7'b1100111: begin // JALR (I-type)
                id_ex_reg_write_en   = 1'b1;
                id_ex_imm_type_sel   = 3'b000; // I-type immediate
                id_ex_alu_src_sel    = 1'b1;   // ALU Op2 is immediate for address calculation
                id_ex_alu_control    = 4'b0000; // ADD for address calculation (RS1 + Imm)
                id_ex_mem_to_reg_sel = 2'b11;   // Write back PC+4
                id_ex_jalr_en        = 1'b1;   // Enable JALR specific logic
            end

            // S-Type Instructions (SW, SH, SB)
            7'b0100011: begin // STORE (S-type)
                id_ex_imm_type_sel = 3'b001; // S-type immediate
                id_ex_alu_src_sel  = 1'b1;   // ALU Op2 is immediate for address calculation
                id_ex_alu_control  = 4'b0000; // ADD for address calculation
                id_ex_mem_write_en = 1'b1;
                id_ex_byte_en      = (func3 == 3'b000) ? 4'b0001 : // SB
                                     (func3 == 3'b001) ? 4'b0011 : // SH
                                     (func3 == 3'b010) ? 4'b1111 : 4'b1111; // SW / Default SW
            end

            // B-Type Instructions (BEQ, BNE, BLT, BGE, BLTU, BGEU)
            7'b1100011: begin // BRANCH (B-type)
                id_ex_imm_type_sel = 3'b010; // B-type immediate
                id_ex_alu_src_sel  = 1'b0;   // ALU Op2 is RS2 data for comparison
                id_ex_alu_control  = 4'b0000; // ADD for comparison (RS1 - RS2)
                id_ex_branch_en    = 1'b1;   // Enable branch specific logic
            end

            // U-Type Instructions (LUI, AUIPC)
            7'b0110111: begin // LUI (U-type)
                id_ex_reg_write_en   = 1'b1;
                id_ex_imm_type_sel   = 3'b011; // U-type immediate
                id_ex_alu_src_sel    = 1'b1;   // ALU Op2 is immediate
                id_ex_alu_control    = 4'b1010; // LUI specific ALU control (shift immediate left by 12)
                id_ex_mem_to_reg_sel = 2'b00;   // Write back ALU result
            end

            7'b0010111: begin // AUIPC (U-type)
                id_ex_reg_write_en   = 1'b1;
                id_ex_imm_type_sel   = 3'b011; // U-type immediate
                id_ex_alu_src_sel    = 1'b1;   // ALU Op2 is immediate
                id_ex_alu_control    = 4'b0000; // ADD for PC + immediate
                id_ex_mem_to_reg_sel = 2'b00;   // Write back ALU result
                id_ex_auipc_op       = 1'b1;   // Signal AUIPC operation
            end

            // J-Type Instruction (JAL)
            7'b1101111: begin // JAL (J-type)
                id_ex_reg_write_en   = 1'b1;
                id_ex_imm_type_sel   = 3'b100; // J-type immediate
                id_ex_alu_src_sel    = 1'b1;   // ALU Op2 is immediate (for target calculation, though not strictly ALU)
                id_ex_alu_control    = 4'b0000; // Dummy ADD (or NOP) if ALU not used for target
                id_ex_mem_to_reg_sel = 2'b11;   // Write back PC+4
                id_ex_jump_en        = 1'b1;   // Enable JAL specific logic
            end

            default: begin
                // Handle unsupported/illegal opcodes - default to NOP behavior
                id_ex_reg_write_en   = 1'b0;
                id_ex_imm_type_sel   = 3'b000;
                id_ex_alu_src_sel    = 1'b0;
                id_ex_alu_control    = 4'b0000;
                id_ex_mem_read_en    = 1'b0;
                id_ex_mem_write_en   = 1'b0;
                id_ex_byte_en        = 4'b0000;
                id_ex_mem_to_reg_sel = 2'b00;
                id_ex_branch_en      = 1'b0;
                id_ex_jump_en        = 1'b0;
                id_ex_jalr_en        = 1'b0;
                id_ex_auipc_op       = 1'b0;
            end
        endcase
    end

endmodule

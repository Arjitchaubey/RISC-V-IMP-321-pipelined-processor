`timescale 1ns / 1ps

// ALU Module
// Performs arithmetic and logical operations based on alu_control signal.
module alu (
    input [31:0] alu_op1,     // First operand
    input [31:0] alu_op2,     // Second operand
    input [3:0]  alu_control, // ALU operation control signal
    output reg [31:0] alu_result,  // Result of ALU operation
    output reg zero_flag      // Zero flag (1 if result is 0, 0 otherwise)
);

    // ALU control codes (example mapping, adjust as per your instruction_decoder)
    // 4'b0000: ADD (R-type, I-type ADDI, LOAD, STORE, JALR, AUIPC)
    // 4'b0001: SUB (R-type SUB)
    // 4'b0010: SLL (R-type SLL, I-type SLLI)
    // 4'b0011: SLT (R-type SLT, I-type SLTI) - Signed Less Than
    // 4'b0100: SLTU (R-type SLTU, I-type SLTIU) - Unsigned Less Than
    // 4'b0101: XOR (R-type XOR, I-type XORI)
    // 4'b0110: SRL (R-type SRL, I-type SRLI)
    // 4'b0111: SRA (R-type SRA, I-type SRAI)
    // 4'b1000: OR (R-type OR, I-type ORI)
    // 4'b1001: AND (R-type AND, I-type ANDI)
    // 4'b1010: LUI (U-type LUI - special case for shifting immediate)

    always @(*) begin
        alu_result = 32'b0; // Default result
        zero_flag = 1'b0;   // Default zero flag

        case(alu_control)
            4'b0000: alu_result = alu_op1 + alu_op2; // ADD
            4'b0001: alu_result = alu_op1 - alu_op2; // SUB
            4'b0010: alu_result = alu_op1 << alu_op2[4:0]; // SLL (shift amount is 5 bits)
            4'b0011: alu_result = ($signed(alu_op1) < $signed(alu_op2)) ? 32'd1 : 32'd0; // SLT (Signed Less Than)
            4'b0100: alu_result = (alu_op1 < alu_op2) ? 32'd1 : 32'd0; // SLTU (Unsigned Less Than)
            4'b0101: alu_result = alu_op1 ^ alu_op2; // XOR
            4'b0110: alu_result = alu_op1 >> alu_op2[4:0]; // SRL (Logical Right Shift)
            4'b0111: alu_result = $signed(alu_op1) >>> alu_op2[4:0]; // SRA (Arithmetic Right Shift)
            4'b1000: alu_result = alu_op1 | alu_op2; // OR
            4'b1001: alu_result = alu_op1 & alu_op2; // AND
            4'b1010: alu_result = alu_op2 << 12; // LUI: Immediate is already upper 20 bits, shift left by 12
                                                 // alu_op2 will contain the U-type immediate (instruction[31:12])
            default: alu_result = 32'b0; // Should not happen with valid control signals
        endcase

        // Set zero flag
        if (alu_result == 32'b0) begin
            zero_flag = 1'b1;
        end else begin
            zero_flag = 1'b0;
        end
    end

endmodule

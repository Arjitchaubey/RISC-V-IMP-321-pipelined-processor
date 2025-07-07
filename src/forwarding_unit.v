`timescale 1ns / 1ps

// Forwarding Unit (for data hazard control)
// Detects data dependencies between instructions in EX and MEM stages and
// provides control signals to muxes at the ALU input to forward data.
module forwarding_unit(
    // Inputs from the ID/EX pipeline register (current instruction's source operands)
    input [4:0] id_ex_rs1_addr,
    input [4:0] id_ex_rs2_addr,

    // Inputs from the EX/MEM pipeline register (result from instruction in EX stage)
    input [4:0] ex_mem_rd_addr,
    input ex_mem_reg_write_en, // Is data being written to a register in EX/MEM stage?

    // Inputs from the MEM/WB pipeline register (result from instruction in MEM stage)
    input [4:0] mem_wb_rd_addr,
    input mem_wb_reg_write_en, // Is data being written to a register in MEM/WB stage?

    // Outputs for the forwarding units of the ALUs triggered by MUXes
    // 00 - No forwarding (data comes from register file)
    // 01 - Forward from ex_mem pipeline stage (ALU result)
    // 10 - Forward from mem_wb pipeline stage (ALU result or memory read data)
    output reg [1:0] fwd_alu_op1, // Forwarding control for ALU operand 1 (rs1)
    output reg [1:0] fwd_alu_op2  // Forwarding control for ALU operand 2 (rs2)
);

    // Logic for forwarding to ALU operand 1 (rs1)
    always @(*) begin
        fwd_alu_op1 = 2'b00; // Default: no forwarding for ALU Op1

        // Priority 1: EX/MEM stage (ALU result)
        // Check if EX/MEM instruction writes to a register (and not x0) AND its destination
        // matches the current instruction's rs1.
        if (ex_mem_reg_write_en && (ex_mem_rd_addr != 5'b0) && (ex_mem_rd_addr == id_ex_rs1_addr)) begin
            fwd_alu_op1 = 2'b01; // Forward from EX/MEM stage
        end

        // Priority 2: MEM/WB stage (ALU result or Memory read data)
        // Check if MEM/WB instruction writes to a register (and not x0) AND its destination
        // matches the current instruction's rs1. This only happens IF the EX/MEM stage
        // doesn't have the required data (higher priority).
        if ((mem_wb_reg_write_en && (mem_wb_rd_addr != 5'b0) && mem_wb_rd_addr == id_ex_rs1_addr)) begin
            if (! (ex_mem_reg_write_en && (ex_mem_rd_addr != 5'b0) && ex_mem_rd_addr == id_ex_rs1_addr) ) begin
                fwd_alu_op1 = 2'b10; // Forward from MEM/WB stage
            end
        end
    end

    // Logic for forwarding to ALU operand 2 (rs2)
    always @(*) begin
        fwd_alu_op2 = 2'b00; // Default: no forwarding for ALU Op2

        // Priority 1: EX/MEM stage (ALU result)
        if (ex_mem_reg_write_en && (ex_mem_rd_addr != 5'b0) && (ex_mem_rd_addr == id_ex_rs2_addr)) begin
            fwd_alu_op2 = 2'b01; // Forward from EX/MEM stage
        end

        // Priority 2: MEM/WB stage (ALU result or Memory read data)
        if ((mem_wb_reg_write_en && (mem_wb_rd_addr != 5'b0) && mem_wb_rd_addr == id_ex_rs2_addr)) begin
            if (! (ex_mem_reg_write_en && (ex_mem_rd_addr != 5'b0) && ex_mem_rd_addr == id_ex_rs2_addr) ) begin
                fwd_alu_op2 = 2'b10; // Forward from MEM/WB stage
            end
        end
    end

endmodule

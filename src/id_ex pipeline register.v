`timescale 1ns / 1ps

// ID/EX Pipeline Register
// Transfers data and control signals from Instruction Decode stage to Execute stage.
module id_ex_pipeline (
    input clk,
    input rst,
    input flush,    // Flush from hazard unit (for control hazards)
    input enable,   // Enable from hazard unit (for data hazards/stalls)

    // Inputs from ID stage
    input [31:0] id_pc,
    input [31:0] id_pc_plus_4,
    input [31:0] id_rs1_data,
    input [31:0] id_rs2_data,
    input [4:0]  id_rs1_addr,
    input [4:0]  id_rs2_addr,
    input [4:0]  id_rd_addr,
    input [2:0]  id_func3,
    input [31:0] id_extended_immediate,

    // Control signals from Instruction Decoder
    input        id_reg_write_en,
    input        id_alu_src_sel,
    input [3:0]  id_alu_control,
    input        id_mem_read,
    input        id_mem_write,
    input [3:0]  id_byte_en,
    input [1:0]  id_mem_to_reg_sel,
    input        id_branch_en,
    input        id_jump_en,
    input        id_jalr_en,
    input        id_auipc_op,

    // Outputs to EX stage
    output reg [31:0] ex_pc,
    output reg [31:0] ex_pc_plus_4,
    output reg [31:0] ex_rs1_data,
    output reg [31:0] ex_rs2_data,
    output reg [4:0]  ex_rs1_addr,
    output reg [4:0]  ex_rs2_addr,
    output reg [4:0]  ex_rd_addr,
    output reg [2:0]  ex_func3,
    output reg [31:0] ex_extended_immediate,

    // Control signals to EX stage
    output reg ex_reg_write_en,
    output reg ex_alu_src_sel,
    output reg [3:0]  ex_alu_control,
    output reg ex_mem_read,
    output reg ex_mem_write,
    output reg [3:0]  ex_byte_en,
    output reg [1:0]  ex_mem_to_reg_sel,
    output reg ex_branch_en,
    output reg ex_jump_en,
    output reg ex_jalr_en,
    output reg ex_auipc_op
);

    always @(posedge clk) begin
        if (!rst) begin
            // Reset all outputs to 0
            ex_pc                 <= 32'b0;
            ex_pc_plus_4          <= 32'b0;
            ex_rs1_data           <= 32'b0;
            ex_rs2_data           <= 32'b0;
            ex_rs1_addr           <= 5'b0;
            ex_rs2_addr           <= 5'b0;
            ex_rd_addr            <= 5'b0;
            ex_func3              <= 3'b0;
            ex_extended_immediate <= 32'b0;

            ex_reg_write_en       <= 1'b0;
            ex_alu_src_sel        <= 1'b0;
            ex_alu_control        <= 4'b0;
            ex_mem_read           <= 1'b0;
            ex_mem_write          <= 1'b0;
            ex_byte_en            <= 4'b0;
            ex_mem_to_reg_sel     <= 2'b00;
            ex_branch_en          <= 1'b0;
            ex_jump_en            <= 1'b0;
            ex_jalr_en            <= 1'b0;
            ex_auipc_op           <= 1'b0;
        end else if (flush) begin
            // Flush: Insert NOP (all control signals to 0, data to 0)
            ex_pc                 <= 32'b0; // NOP
            ex_pc_plus_4          <= 32'b0; // NOP
            ex_rs1_data           <= 32'b0; // NOP
            ex_rs2_data           <= 32'b0; // NOP
            ex_rs1_addr           <= 5'b0;  // NOP
            ex_rs2_addr           <= 5'b0;  // NOP
            ex_rd_addr            <= 5'b0;  // NOP
            ex_func3              <= 3'b0;  // NOP
            ex_extended_immediate <= 32'b0; // NOP

            ex_reg_write_en       <= 1'b0; // NOP
            ex_alu_src_sel        <= 1'b0; // NOP
            ex_alu_control        <= 4'b0; // NOP
            ex_mem_read           <= 1'b0; // NOP
            ex_mem_write          <= 1'b0; // NOP
            ex_byte_en            <= 4'b0; // NOP
            ex_mem_to_reg_sel     <= 2'b00; // NOP
            ex_branch_en          <= 1'b0; // NOP
            ex_jump_en            <= 1'b0; // NOP
            ex_jalr_en            <= 1'b0; // NOP
            ex_auipc_op           <= 1'b0; // NOP
        end else if (enable) begin
            // Load new data from ID stage
            ex_pc                 <= id_pc;
            ex_pc_plus_4          <= id_pc_plus_4;
            ex_rs1_data           <= id_rs1_data;
            ex_rs2_data           <= id_rs2_data;
            ex_rs1_addr           <= id_rs1_addr;
            ex_rs2_addr           <= id_rs2_addr;
            ex_rd_addr            <= id_rd_addr;
            ex_func3              <= id_func3;
            ex_extended_immediate <= id_extended_immediate;

            ex_reg_write_en       <= id_reg_write_en;
            ex_alu_src_sel        <= id_alu_src_sel;
            ex_alu_control        <= id_alu_control;
            ex_mem_read           <= id_mem_read;
            ex_mem_write          <= id_mem_write;
            ex_byte_en            <= id_byte_en;
            ex_mem_to_reg_sel     <= id_mem_to_reg_sel;
            ex_branch_en          <= id_branch_en;
            ex_jump_en            <= id_jump_en;
            ex_jalr_en            <= id_jalr_en;
            ex_auipc_op           <= id_auipc_op;
        end
    end

endmodule

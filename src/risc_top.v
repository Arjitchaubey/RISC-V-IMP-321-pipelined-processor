`timescale 1ns / 1ps

// The top level module for RISC V processor
// This module integrates all the pipeline stages and control units to form
// a complete 5-stage pipelined RISC-V CPU.
module RISC_V_PROCESSOR (
    input clk, // Main clock signal
    input rst,  // Asynchronous reset signal (active low)
    input output_en,           //output enable signal
    output reg [7:0] pc_out,   //Current program counter
    output reg[7:0] instr_out,        //current instruction in ID stage
    output reg[7:0] alu_out,          //ALU result in the EX stage
    output reg[7:0] reg_x1,           //Register X1 (for debug)
    output reg[7:0] reg_x2,           //Register x2 (for debug)
    output reg[7:0] mem_data_out     //Data memory output (read data)
    );

    // ===============================================
    // DECLARATION OF INTERNAL WIRES FOR PIPELINE COMMUNICATIONS
    // ===============================================

    // IF (Instruction Fetch) Stage Declarations
    wire [31:0] if_pc;                   // Current PC value from PC module
    wire [31:0] if_next_pc;              // Next PC value to feed back to PC module (target of branch/jump or PC+4)
    wire [31:0] if_pc_plus_4;            // Sequential next PC (current_pc + 4)
    wire [31:0] if_instruction;          // Instruction fetched from instruction memory
    wire        pc_write_en;             // PC write enable from hazard unit

    // ID (Instruction Decode) Stage Declarations
    wire [31:0] id_pc;                   // PC from IF/ID register
    wire [31:0] id_pc_plus_4;            // PC+4 from IF/ID register
    wire [31:0] id_instruction;          // Instruction from IF/ID register

    wire [4:0] id_rs1_addr;              // RS1 address from instruction decoder
    wire [4:0] id_rs2_addr;              // RS2 address from instruction decoder
    wire [4:0] id_rd_addr;               // RD address from instruction decoder
    wire [2:0] id_func3;                 // func3 from instruction decoder

    wire [31:0] id_rs1_data;             // Data read from RS1 in register file
    wire [31:0] id_rs2_data;             // Data read from RS2 in register file
    wire [31:0] id_extended_immediate;   // Sign-extended immediate value

    wire        id_ex_reg_write_en_ctrl;      // Control signal from instruction decoder
    wire [2:0]  id_ex_imm_type_sel_ctrl;      // Control signal from instruction decoder
    wire        id_ex_alu_src_sel_ctrl;       // Control signal from instruction decoder
    wire [3:0]  id_ex_alu_control_ctrl;       // Control signal from instruction decoder
    wire        id_ex_mem_read_en_ctrl;       // Control signal from instruction decoder
    wire        id_ex_mem_write_en_ctrl;      // Control signal from instruction decoder
    wire [3:0]  id_ex_byte_en_ctrl;           // Control signal from instruction decoder
    wire [1:0]  id_ex_mem_to_reg_sel_ctrl;    // Control signal from instruction decoder
    wire        id_ex_branch_en_ctrl;         // Control signal from instruction decoder
    wire        id_ex_jump_en_ctrl;           // Control signal from instruction decoder
    wire        id_ex_jalr_en_ctrl;           // Control signal from instruction decoder
    wire        id_ex_auipc_op_ctrl;          // Control signal from instruction decoder

    wire        if_id_enable;            // Enable for IF/ID register (from hazard unit)
    wire        if_id_flush;             // Flush for IF/ID register (from hazard unit)
    wire        id_ex_flush_from_hazard; // Output from hazard unit for ID/EX flush


    // EX (Execute) Stage Declarations
    wire [31:0] ex_pc;                   // PC from ID/EX register (for AUIPC)
    wire [31:0] ex_pc_plus_4;            // PC+4 from ID/EX register (for JAL/JALR)
    wire [31:0] ex_rs1_data;             // Raw RS1 data from ID/EX register (before forwarding MUX)
    wire [31:0] ex_rs2_data;             // Raw RS2 data from ID/EX register (before forwarding MUX)
    wire [4:0]  ex_rs1_addr;             // RS1 address from ID/EX register (for forwarding unit)
    wire [4:0]  ex_rs2_addr;             // RS2 address from ID/EX register (for forwarding unit)
    wire [4:0]  ex_rd_addr;              // RD address from ID/EX register
    wire [2:0]  ex_func3;                // func3 from ID/EX register
    wire [31:0] ex_extended_immediate;   // Immediate from ID/EX register

    wire        ex_reg_write_en;         // Control signal from ID/EX register
    wire        ex_alu_src_sel;          // Control signal from ID/EX register
    wire [3:0]  ex_alu_control;          // Control signal from ID/EX register
    wire        ex_mem_read;             // Control signal from ID/EX register
    wire        ex_mem_write;            // Control signal from ID/EX register
    wire [3:0]  ex_byte_en;              // Control signal from ID/EX register
    wire [1:0]  ex_mem_to_reg_sel;       // Control signal from ID/EX register
    wire        ex_branch_en;            // Control signal from ID/EX register (for hazard unit)
    wire        ex_jump_en;              // Control signal from ID/EX register (for hazard unit)
    wire        ex_jalr_en;              // Control signal from ID/EX register (for hazard unit)
    wire        ex_auipc_op;             // Control signal from ID/EX register

    reg [31:0] ex_alu_op1;               // Final ALU Op1 after forwarding/selection
    reg [31:0] ex_alu_op2;               // Final ALU Op2 after forwarding/selection
    wire [31:0] ex_alu_result;           // ALU result
    wire        ex_zero_flag;            // ALU zero flag

    wire [1:0]  fwd_alu_op1;             // Forwarding decision for ALU Op1
    wire [1:0]  fwd_alu_op2;             // Forwarding decision for ALU Op2

    // Wire for the forwarded RS2 data specifically for stores
    reg [31:0] ex_rs2_data_for_store;

    reg         ex_branch_resolved;      // Branch resolution signal (from EX, based on ALU zero_flag)
    reg         ex_branch_taken;         // Branch taken signal (from EX, based on branch condition and zero_flag)

    // MEM (Memory Access) Stage Declarations
    wire [31:0] mem_pc_plus_4;           // PC+4 from EX/MEM register
    wire [31:0] mem_alu_result;          // ALU result from EX/MEM register
    wire [31:0] mem_rs2_data;            // RS2 data from EX/MEM register (for stores)
    wire [4:0]  mem_rd_addr;             // RD address from EX/MEM register
    wire [2:0]  mem_func3;               // func3 from EX/MEM register
    wire [31:0] mem_data_mem_read_data;  // Data read from data memory
    wire        mem_jump_en;             // Propagated jump enable
    wire        mem_jalr_en;             // Propagated JALR enable

    wire        mem_reg_write_en;        // Control signal from EX/MEM register
    wire        mem_mem_read;            // Control signal from EX/MEM register
    wire        mem_mem_write;           // Control signal from EX/MEM register
    wire [3:0]  mem_byte_en;             // Control signal from EX/MEM register
    wire [1:0]  mem_mem_to_reg_sel;      // Control signal from EX/MEM register

    // WB (Write Back) Stage Declarations
    wire [31:0] wb_alu_result;           // ALU result from MEM/WB register
    wire [31:0] wb_pc_plus_4;            // PC+4 from MEM/WB register
    wire [4:0]  wb_rd_addr;              // RD address from MEM/WB register
    wire [2:0]  wb_func3;                // func3 from MEM/WB register
    wire [31:0] wb_data_mem_read_data;   // Data read from memory in MEM/WB register
    wire        wb_jump_en;              // Propagated jump enable
    wire        wb_jalr_en;              // Propagated JALR enable

    wire        wb_reg_write_en;         // Control signal from MEM/WB register
    wire [1:0]  wb_mem_to_reg_sel;       // Control signal from MEM/WB register

    wire [31:0] wb_write_data;           // Final data to be written to register file

    // ===============================================
    // INSTANTIATION OF MODULES
    // ===============================================

    // 1. IF Stage: Program Counter and Instruction Memory
    pc program_counter (
        .clk(clk),
        .rst(rst),
        .next_pc(if_next_pc),
        .pc_write_en(pc_write_en),
        .current_pc(if_pc)
    );

    // Calculate PC + 4 for sequential instruction fetching
    assign if_pc_plus_4 = if_pc + 32'd4;

    instruction_memory imem (
        .clk(clk),
        .address(if_pc),
        .instruction(if_instruction)
    );

    // PC MUX for selecting next PC (PC+4, branch target, JAL target, JALR target)
    // This MUX is placed here to select the next PC value to be loaded into the PC register.
    // Branch/Jump targets are calculated in the EX stage and forwarded back.
    // Priority: JAL/JALR > Taken Branch > PC+4
    wire [31:0] ex_jal_target;
    wire [31:0] ex_branch_target;
    wire [31:0] ex_jalr_target;

    // Use ex_jump_en and ex_jalr_en for PC redirection (registered from ID/EX)
    assign if_next_pc =
        (ex_jump_en) ? ex_jal_target : // JAL (highest priority)
        (ex_jalr_en) ? ex_jalr_target : // JALR
        (ex_branch_en && ex_branch_taken && ex_branch_resolved) ? ex_branch_target : // Taken Branch
        if_pc_plus_4; // Default sequential PC+4

    // IF/ID Pipeline Register
    if_id_pipeline if_id_reg (
        .clk(clk),
        .rst(rst),
        .flush(if_id_flush),
        .enable(if_id_enable),
        .if_pc(if_pc),
        .if_pc_plus_4(if_pc_plus_4),
        .if_instruction(if_instruction),
        .id_pc(id_pc),
        .id_pc_plus_4(id_pc_plus_4),
        .id_instruction(id_instruction)
    );

    // 2. ID Stage: Instruction Decoder, Register File, Sign Extend
    instruction_decoder decoder (
        .instruction(id_instruction),
        .rs1_addr(id_rs1_addr),
        .rs2_addr(id_rs2_addr),
        .rd_addr(id_rd_addr),
        .id_func3(id_func3),
        .id_ex_reg_write_en(id_ex_reg_write_en_ctrl),
        .id_ex_imm_type_sel(id_ex_imm_type_sel_ctrl),
        .id_ex_alu_src_sel(id_ex_alu_src_sel_ctrl),
        .id_ex_alu_control(id_ex_alu_control_ctrl),
        .id_ex_mem_read_en(id_ex_mem_read_en_ctrl),
        .id_ex_mem_write_en(id_ex_mem_write_en_ctrl),
        .id_ex_byte_en(id_ex_byte_en_ctrl),
        .id_ex_mem_to_reg_sel(id_ex_mem_to_reg_sel_ctrl),
        .id_ex_branch_en(id_ex_branch_en_ctrl),
        .id_ex_jump_en(id_ex_jump_en_ctrl),
        .id_ex_jalr_en(id_ex_jalr_en_ctrl),
        .id_ex_auipc_op(id_ex_auipc_op_ctrl)
    );

    reg_file rf (
        .clk(clk),
        .rst(rst),
        .reg_write_en(wb_reg_write_en), // Write enable from WB stage
        .rs1_addr(id_rs1_addr),         // Read addresses from ID stage
        .rs2_addr(id_rs2_addr),
        .rd_addr(wb_rd_addr),           // Destination address from WB stage
        .rd_write_data(wb_write_data),  // Write data from WB stage
        .rs1_data(id_rs1_data),         // Data for ID stage
        .rs2_data(id_rs2_data)          // Data for ID stage
    );

    sign_extend se (
        .instruction(id_instruction),
        .ins_type_sel(id_ex_imm_type_sel_ctrl), // Use imm_type_sel from decoder
        .extended_immediate(id_extended_immediate)
    );

    // ID/EX Pipeline Register
    id_ex_pipeline id_ex_reg (
        .clk(clk),
        .rst(rst),
        .flush(id_ex_flush_from_hazard), // Use output from hazard unit
        .enable(if_id_enable), // Use if_id_enable to control this register's update for stalling
        .id_pc(id_pc),
        .id_pc_plus_4(id_pc_plus_4),
        .id_rs1_data(id_rs1_data),
        .id_rs2_data(id_rs2_data),
        .id_rs1_addr(id_rs1_addr),       // Pass source addresses
        .id_rs2_addr(id_rs2_addr),       // Pass source addresses
        .id_rd_addr(id_rd_addr),
        .id_func3(id_func3),
        .id_extended_immediate(id_extended_immediate),
        .id_reg_write_en(id_ex_reg_write_en_ctrl),
        .id_alu_src_sel(id_ex_alu_src_sel_ctrl),
        .id_alu_control(id_ex_alu_control_ctrl),
        .id_mem_read(id_ex_mem_read_en_ctrl),
        .id_mem_write(id_ex_mem_write_en_ctrl),
        .id_byte_en(id_ex_byte_en_ctrl),
        .id_mem_to_reg_sel(id_ex_mem_to_reg_sel_ctrl),
        .id_branch_en(id_ex_branch_en_ctrl),
        .id_jump_en(id_ex_jump_en_ctrl),
        .id_jalr_en(id_ex_jalr_en_ctrl),
        .id_auipc_op(id_ex_auipc_op_ctrl),
        .ex_pc(ex_pc),
        .ex_pc_plus_4(ex_pc_plus_4),
        .ex_rs1_data(ex_rs1_data),
        .ex_rs2_data(ex_rs2_data),
        .ex_rs1_addr(ex_rs1_addr),
        .ex_rs2_addr(ex_rs2_addr),
        .ex_rd_addr(ex_rd_addr),
        .ex_func3(ex_func3),
        .ex_extended_immediate(ex_extended_immediate),
        .ex_reg_write_en(ex_reg_write_en),
        .ex_alu_src_sel(ex_alu_src_sel),
        .ex_alu_control(ex_alu_control),
        .ex_mem_read(ex_mem_read),
        .ex_mem_write(ex_mem_write),
        .ex_byte_en(ex_byte_en),
        .ex_mem_to_reg_sel(ex_mem_to_reg_sel),
        .ex_branch_en(ex_branch_en),
        .ex_jump_en(ex_jump_en),
        .ex_jalr_en(ex_jalr_en),
        .ex_auipc_op(ex_auipc_op)
    );

    // 3. EX Stage: ALU and Forwarding Unit
    forwarding_unit fwd_unit (
        .id_ex_rs1_addr(ex_rs1_addr), // Use RS1 address from ID/EX register
        .id_ex_rs2_addr(ex_rs2_addr), // Use RS2 address from ID/EX register
        .ex_mem_rd_addr(mem_rd_addr),
        .ex_mem_reg_write_en(mem_reg_write_en),
        .mem_wb_rd_addr(wb_rd_addr),
        .mem_wb_reg_write_en(wb_reg_write_en),
        .fwd_alu_op1(fwd_alu_op1),
        .fwd_alu_op2(fwd_alu_op2)
    );

    // MUX for ALU operand 1 (RS1 data or forwarded data or PC for AUIPC)
    always @(*) begin
        if (ex_auipc_op) begin // AUIPC uses PC as Op1
            ex_alu_op1 = ex_pc;
        end else begin // Regular instruction
            case(fwd_alu_op1)
                2'b00: ex_alu_op1 = ex_rs1_data; // No forwarding, use raw value from ID/EX register (reg file read)
                2'b01: ex_alu_op1 = mem_alu_result;  // Forward from EX/MEM stage
                2'b10: ex_alu_op1 = (wb_mem_to_reg_sel==2'b01) ? wb_data_mem_read_data : wb_alu_result; // Forward from MEM/WB
                default: ex_alu_op1 = ex_rs1_data; // Default to raw read if fwd_alu_op1 is 'x' or 'z'
            endcase
        end
    end


    // MUX for ALU operand 2 (RS2 data, immediate, or forwarded data)
    always @(*) begin
        if (ex_alu_src_sel) begin // Immediate value as Op2
            ex_alu_op2 = ex_extended_immediate;
        end else begin // RS2 data as Op2
            case(fwd_alu_op2)
                2'b00: ex_alu_op2 = ex_rs2_data; // No forwarding, use raw value from ID/EX register (reg file read)
                2'b01: ex_alu_op2 = mem_alu_result;  // Forward from EX/MEM stage
                2'b10: ex_alu_op2 = (wb_mem_to_reg_sel==2'b01) ? wb_data_mem_read_data : wb_alu_result; // Forward from MEM/WB
                default: ex_alu_op2 = ex_rs2_data; // Default to raw read if fwd_alu_op2 is 'x' or 'z'
            endcase
        end
    end

    // MUX for RS2 data for store operations (needs forwarding)
    always @(*) begin
        case(fwd_alu_op2) // Re-use fwd_alu_op2 for simplicity, assuming RS2 data forwarding is same as ALU Op2
            2'b00: ex_rs2_data_for_store = ex_rs2_data; // No forwarding, use raw value from ID/EX register (reg file read)
            2'b01: ex_rs2_data_for_store = mem_alu_result;  // Forward from EX/MEM stage
            2'b10: ex_rs2_data_for_store = (wb_mem_to_reg_sel==2'b01) ? wb_data_mem_read_data : wb_alu_result; // Forward from MEM/WB
            default: ex_rs2_data_for_store = ex_rs2_data; // Default to raw read if fwd_alu_op2 is 'x' or 'z'
        endcase
    end


    alu execute_alu (
        .alu_op1(ex_alu_op1),
        .alu_op2(ex_alu_op2),
        .alu_control(ex_alu_control),
        .alu_result(ex_alu_result),
        .zero_flag(ex_zero_flag)
    );

    // Branch Resolution Logic (in EX stage)
    // For BEQ, BNE: Check ALU zero_flag.
    // For BLT, BGE, BLTU, BGEU: Check ALU result for SLT/SLTU.
    always @(*) begin
        ex_branch_resolved = 1'b0; // Default: not resolved
        ex_branch_taken = 1'b0;    // Default: not taken

        if (ex_branch_en) begin // If it's a branch instruction
            ex_branch_resolved = 1'b1; // Branch is resolved in EX stage

            case(ex_func3) // Use func3 to precisely determine branch condition
                3'b000: ex_branch_taken = ex_zero_flag;       // BEQ (rs1 == rs2)
                3'b001: ex_branch_taken = !ex_zero_flag;      // BNE (rs1 != rs2)
                3'b100: ex_branch_taken = (ex_alu_result == 32'd1); // BLT (rs1 < rs2 signed)
                3'b101: ex_branch_taken = (ex_alu_result == 32'd0); // BGE (rs1 >= rs2 signed: ! (rs1 < rs2))
                3'b110: ex_branch_taken = (ex_alu_result == 32'd1); // BLTU (rs1 < rs2 unsigned)
                3'b111: ex_branch_taken = (ex_alu_result == 32'd0); // BGEU (rs1 >= rs2 unsigned: ! (rs1 < rs2))
                default: ex_branch_taken = 1'b0; // Should not happen for valid branch instructions
            endcase
        end
    end

    // Calculate branch target address (PC + immediate)
    assign ex_branch_target = ex_pc + ex_extended_immediate;

    // Calculate JAL target address (PC + immediate)
    assign ex_jal_target = ex_pc + ex_extended_immediate;

    // Calculate JALR target address ((RS1 + immediate) & ~1)
    assign ex_jalr_target = (ex_alu_op1 + ex_extended_immediate) & 32'hFFFFFFFE; // Use forwarded ALU_Op1 for JALR base address


    // EX/MEM Pipeline Register
    ex_mem_pipeline ex_mem_reg (
        .clk(clk),
        .rst(rst),
        .flush(id_ex_flush_from_hazard), // Use flush from hazard unit
        .enable(1'b1), // always enable
        .ex_pc_plus_4(ex_pc_plus_4),
        .ex_rs2_data(ex_rs2_data_for_store), // Use the dedicated forwarded RS2 data for stores
        .ex_rd_addr(ex_rd_addr),
        .ex_alu_result(ex_alu_result),
        .ex_func3(ex_func3),
        .ex_reg_write_en(ex_reg_write_en),
        .ex_mem_read(ex_mem_read),
        .ex_mem_write(ex_mem_write),
        .ex_byte_en(ex_byte_en),
        .ex_mem_to_reg_sel(ex_mem_to_reg_sel),
        .ex_jump_en(ex_jump_en),
        .ex_jalr_en(ex_jalr_en),
        .mem_pc_plus_4(mem_pc_plus_4),
        .mem_alu_result(mem_alu_result),
        .mem_rs2_data(mem_rs2_data),
        .mem_rd_addr(mem_rd_addr),
        .mem_func3(mem_func3),
        .mem_reg_write_en(mem_reg_write_en),
        .mem_mem_read(mem_mem_read),
        .mem_mem_write(mem_mem_write),
        .mem_byte_en(mem_byte_en),
        .mem_mem_to_reg_sel(mem_mem_to_reg_sel),
        .mem_jump_en(mem_jump_en),
        .mem_jalr_en(mem_jalr_en)
    );

    // 4. MEM Stage: Data Memory
    memory_bank data_mem (
        .clk(clk),
        .rst(rst),
        .read_en(mem_mem_read),
        .write_en(mem_mem_write),
        .address(mem_alu_result), // ALU result is the memory address
        .write_data(mem_rs2_data), // RS2 data is the write data for stores
        .byte_enable(mem_byte_en),
        .read_data(mem_data_mem_read_data)
    );

    // MEM/WB Pipeline Register
    pipeline_mem_wb mem_wb_reg (
        .clk(clk),
        .rst(rst),
        .flush(1'b0), // No flush needed here, NOPs propagate from earlier stages
        .enable(1'b1), // always enable
        .mem_alu_result(mem_alu_result),
        .mem_pc_plus_4(mem_pc_plus_4),
        .mem_rd_addr(mem_rd_addr),
        .mem_data_mem_read_data(mem_data_mem_read_data),
        .mem_func3(mem_func3),
        .mem_reg_write_en(mem_reg_write_en),
        .mem_mem_to_reg_sel(mem_mem_to_reg_sel),
        .mem_jump_en(mem_jump_en),
        .mem_jalr_en(mem_jalr_en),
        .wb_alu_result(wb_alu_result),
        .wb_pc_plus_4(wb_pc_plus_4),
        .wb_rd_addr(wb_rd_addr),
        .wb_data_mem_read_data(wb_data_mem_read_data),
        .wb_func3(wb_func3),
        .wb_reg_write_en(wb_reg_write_en),
        .wb_mem_to_reg_sel(wb_mem_to_reg_sel),
        .wb_jump_en(wb_jump_en),
        .wb_jalr_en(wb_jalr_en)
    );

    // 5. WB (Write Back) Stage: Write data back to Register File
    // MUX for selecting data to write back to the register file
    assign wb_write_data =
        (wb_mem_to_reg_sel == 2'b01) ? wb_data_mem_read_data :          // Priority 1: Data from memory (for Load instructions)
        ((wb_jump_en || wb_jalr_en) && wb_reg_write_en && wb_mem_to_reg_sel == 2'b11) ? wb_pc_plus_4 : // Priority 2: PC+4 for JAL/JALR (if writing to register)
        wb_alu_result;                                          // Default: ALU result (for R-type, I-type arithmetic, LUI, AUIPC)
 
    // Hazard Unit
    hazard_unit hazard_detection (
        .if_id_rs1_addr(id_rs1_addr),
        .if_id_rs2_addr(id_rs2_addr),
        .id_ex_rd_addr(ex_rd_addr),
        .id_ex_mem_read_en(ex_mem_read),
        .id_ex_reg_write_en(ex_reg_write_en),
        .ex_branch_en(ex_branch_en), // Pass the REGISTERED ex_branch_en
        .ex_jump_en(ex_jump_en),     // Pass the REGISTERED ex_jump_en
        .ex_jalr_en(ex_jalr_en),     // Pass the REGISTERED ex_jalr_en
        .ex_branch_resolved(ex_branch_resolved),
        .ex_branch_taken(ex_branch_taken),
        .pc_write_en(pc_write_en),
        .if_id_enable(if_id_enable),
        .if_id_flush(if_id_flush),
        .id_ex_flush(id_ex_flush_from_hazard)
        );
//output statements
always @ (posedge clk) begin
    if(!rst) begin
        pc_out <= 8'b0;
        instr_out <= 8'b0;
        alu_out <= 8'b0;
        mem_data_out <= 8'b0;
        reg_x1 <= 8'b0;
        reg_x2 <= 8'b0;
    end else if (output_en) begin 
        pc_out <=             if_pc[7:0];                  //Current pc from IF stage
        instr_out <=          id_instruction[7:0];         //current instruction from ID stage
        alu_out <=            ex_alu_result[7:0];          //ALU result form EX stage
        mem_data_out <=       mem_data_mem_read_data[7:0]; //data memory from mem stage
        reg_x1 <= rf.registers[1][7:0];                    //register for debugging
        reg_x2 <= rf.registers[2][7:0];                   //register for debugging
    end
end

endmodule

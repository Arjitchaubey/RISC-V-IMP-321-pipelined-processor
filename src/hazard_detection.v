`timescale 1ns / 1ps

// Hazard Unit Module
// Detects data and control hazards and generates stall/flush signals.
module hazard_unit (
    input [4:0] if_id_rs1_addr,    // RS1 address from IF/ID stage
    input [4:0] if_id_rs2_addr,    // RS2 address from ID/ID stage
    input [4:0] id_ex_rd_addr,     // RD address from ID/EX stage
    input       id_ex_mem_read_en, // Memory read enable from ID/EX stage (for load-use hazard)
    input       id_ex_reg_write_en, // Reg write enable from ID/EX stage (for forwarding and load-use)

    // These inputs are the REGISTERED versions from the ID/EX pipeline register.
    // Control hazard detection happens when the branch/jump instruction is in EX.
    input       ex_branch_en,      // Branch enable from ID/EX pipeline register
    input       ex_jump_en,        // JAL enable from ID/EX pipeline register
    input       ex_jalr_en,        // JALR enable from ID/EX pipeline register

    input       ex_branch_resolved, // Branch resolved in EX stage (from ALU)
    input       ex_branch_taken,    // Branch taken in EX stage (from ALU)

    output wire pc_write_en,        // PC write enable
    output wire if_id_enable,       // IF/ID pipeline register enable
    output wire if_id_flush,        // IF/ID pipeline register flush
    output wire id_ex_flush         // ID/EX pipeline register flush
);

    // Internal signals for hazard detection
    wire load_use_hazard;
    wire control_hazard_jump;
    wire control_hazard_branch_taken;

    // Use internal 'reg' type variables for procedural assignment within the always block
    // These 'reg's will infer combinational logic because they are in an always @(*) block
    reg r_pc_write_en;
    reg r_if_id_enable;
    reg r_if_id_flush;
    reg r_id_ex_flush;

    // Load-Use Hazard Detection
    // Occurs when an instruction in ID stage needs a register written by a LOAD in EX stage.
    // This requires a 1-cycle stall.
    assign load_use_hazard = (id_ex_mem_read_en && id_ex_reg_write_en &&
                              (id_ex_rd_addr != 5'b00000) && // Don't stall on writes to x0
                              ((id_ex_rd_addr == if_id_rs1_addr) || (id_ex_rd_addr == if_id_rs2_addr)));

    // Control Hazard Detection for JAL/JALR
    // JAL and JALR are unconditional jumps. They cause a 2-cycle bubble (flush IF/ID and ID/EX).
    // The decision is made when the instruction is in EX.
    assign control_hazard_jump = ex_jump_en || ex_jalr_en;

    // Control Hazard Detection for Branches
    // Branches cause a 2-cycle bubble (flush IF/ID and ID/EX) if they are taken.
    // The decision is made when the instruction is in EX.
    assign control_hazard_branch_taken = ex_branch_en && ex_branch_taken && ex_branch_resolved;


    always @(*) begin // This is a combinational always block
        // Default values (no hazard, pipeline runs normally)
        r_pc_write_en    = 1'b1; // Assign to internal reg
        r_if_id_enable   = 1'b1; // Assign to internal reg
        r_if_id_flush    = 1'b0; // Assign to internal reg
        r_id_ex_flush    = 1'b0; // Assign to internal reg

        if (load_use_hazard) begin
            // Stall for load-use hazard
            r_pc_write_en    = 1'b0; // Assign to internal reg
            r_if_id_enable   = 1'b0; // Assign to internal reg
            r_if_id_flush    = 1'b0; // No flush during stall
            r_id_ex_flush    = 1'b0; // No flush during stall (ID/EX will hold the stalled instruction, effectively inserting a NOP in EX)
        end else if (control_hazard_jump) begin
            // Flush for JAL/JALR (unconditional jumps)
            r_pc_write_en    = 1'b1; // PC will be updated to jump target
            r_if_id_enable   = 1'b1; // IF/ID register updates with the new target instruction
            r_if_id_flush    = 1'b1; // Flush IF/ID to insert NOP (for the instruction after the jump)
            r_id_ex_flush    = 1'b1; // Flush ID/EX to insert NOP (for the instruction after the jump)
        end else if (control_hazard_branch_taken) begin
            // Flush for taken branches
            r_pc_write_en    = 1'b1; // PC will be updated to branch target
            r_if_id_enable   = 1'b1; // IF/ID register updates with the new target instruction
            r_if_id_flush    = 1'b1; // Flush IF/ID to insert NOP
            r_id_ex_flush    = 1'b1; // Flush ID/EX to insert NOP
        end
    end

    // Connect the internal 'reg' variables to the 'wire' outputs
    assign pc_write_en  = r_pc_write_en;
    assign if_id_enable = r_if_id_enable;
    assign if_id_flush  = r_if_id_flush;
    assign id_ex_flush  = r_id_ex_flush;

endmodule

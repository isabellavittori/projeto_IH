`timescale 1ns / 1ps
//(ImmGen) has a 32-bit instruction as input that selects
//a 12-bit field for load, store, and branch if equal that is
//sign-extended into a 64-bit result appearing on the
//output

module imm_Gen ( //extendendo o sinal de 32-bit
    input  logic [31:0] inst_code,
    output logic [31:0] Imm_out
);


  always_comb
    case (inst_code[6:0])
      7'b0000011:  /*I-type load part*/
      Imm_out = {inst_code[31] ? 20'hFFFFF : 20'b0, inst_code[31:20]};

      7'b0010011:  /*I-type part*/
      Imm_out = {inst_code[31] ? 20'hFFFFF : 20'b0, inst_code[31:20]};

      7'b0110111: /*U-type part*/
      Imm_out = {inst_code[31:12], 12'b0};

      7'b0100011:  /*S-type*/
      Imm_out = {inst_code[31] ? 20'hFFFFF : 20'b0, inst_code[31:25], inst_code[11:7]};

      7'b1100011:  /*B-type*/
      Imm_out = {
        inst_code[31] ? 19'h7FFFF : 19'b0,
        inst_code[31],
        inst_code[7],
        inst_code[30:25],
        inst_code[11:8],
        1'b0
      };

      7'b1101111:  //JAL
      Imm_out = {
        inst_code[31] ? 11'h7FFFF : 11'b0,
        inst_code[31],
        inst_code[19:12],
        inst_code[20],
        inst_code[30:21],
        1'b0
      };

      7'b1100111: //JALR
      Imm_out = {inst_code[31] ? 19'hFFFFF : 19'b0, inst_code[31:20], 1'b0};

      default: Imm_out = {32'b0};

    endcase

endmodule

//The immediate generation logic must choose between sign-
//extending a 12-bit field in instruction bits 31:20 for load
//instructions, bits 31:25 and 11:7 for store instructions, or bits 31, 7,
//30:25, and 11:8 for the conditional branch. Since the input is all 32
//bits of the instruction, it can use the opcode bits of the instruction
//to select the proper field. RISC-V opcode bit 6 happens to be 0 for
//data transfer instructions and 1 for conditional branches, and RISC-
//V opcode bit 5 happens to be 0 for load instructions and 1 for store
//instructions. Thus, bits 5 and 6 can control a 3:1 multiplexor inside
//the immediate generation logic that selects the appropriate 12-bit
//field for load, store, and conditional branch instructions.


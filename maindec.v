module maindec (
    op,
    memToReg,
    memWrite,
    branch,
    aluSrc,
    regDst,
    regWrite,
    jump,
    aluOp
);
  input [5:0] op;
  output memToReg, memWrite, branch, aluSrc, regDst, regWrite, jump;
  output [1:0] aluOp;

  reg [8:0] controls;
  assign {regWrite, regDst, aluSrc, branch, memWrite, memToReg, jump, aluOp} = controls;

  always @(op) begin
    case (op)
      6'b000000: controls <= 9'b110000010;  // R-type
      6'b100011: controls <= 9'b101001000;  // lw
      6'b101011: controls <= 9'b001010000;  // sw
      6'b000100: controls <= 9'b000100001;  // beq
      6'b001000: controls <= 9'b101000000;  // addi
      6'b000010: controls <= 9'b000000100;  // j
      default:   controls <= 9'bxxxxxxxxx;  // illegal op
    endcase
  end
endmodule

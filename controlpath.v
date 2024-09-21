module controlpath (
    op,
    funct,
    zero,
    memToReg,
    memWrite,
    pcSrc,
    aluSrc,
    regDst,
    regWrite,
    jump,
    aluControl
);
  input [5:0] op, funct;
  input zero;
  output memToReg, memWrite, pcSrc, aluSrc, regDst, regWrite, jump;
  output [2:0] aluControl;

  wire [1:0] aluOp;
  wire branch;

  maindec md (
      .op(op),
      .memToReg(memToReg),
      .memWrite(memWrite),
      .branch(branch),
      .aluSrc(aluSrc),
      .regDst(regDst),
      .regWrite(regWrite),
      .jump(jump),
      .aluOp(aluOp)
  );
  aludec ad (
      .funct(funct),
      .aluOp(aluOp),
      .aluControl(aluControl)
  );
  assign pcSrc = branch & zero;
endmodule

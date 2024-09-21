module mips (
    clk,
    rst,
    pc,
    instr,
    memWrite,
    aluOut,
    writeData,
    readData
);
  input clk, rst;
  output memWrite;
  input [31:0] instr, readData;
  output [31:0] pc, aluOut, writeData;

  wire memToReg, aluSrc, regDst, regWrite, jump, pcSrc, zero;
  wire [2:0] aluControl;

  controlpath cp (
      .op(instr[31:26]),
      .funct(instr[5:0]),
      .zero(zero),
      .memToReg(memToReg),
      .memWrite(memWrite),
      .pcSrc(pcSrc),
      .aluSrc(aluSrc),
      .regDst(regDst),
      .regWrite(regWrite),
      .jump(jump),
      .aluControl(aluControl)
  );
  datapath dp (
      .clk(clk),
      .rst(rst),
      .memToReg(memToReg),
      .pcSrc(pcSrc),
      .aluSrc(aluSrc),
      .regDst(regDst),
      .regWrite(regWrite),
      .jump(jump),
      .aluControl(aluControl),
      .zero(zero),
      .pc(pc),
      .instr(instr),
      .aluOut(aluOut),
      .writeData(writeData),
      .readData(readData)
  );
endmodule

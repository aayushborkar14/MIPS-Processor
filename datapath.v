module datapath (
    clk,
    rst,
    memToReg,
    pcSrc,
    aluSrc,
    regDst,
    regWrite,
    jump,
    aluControl,
    zero,
    pc,
    instr,
    aluOut,
    writeData,
    readData
);
  input clk, rst, memToReg, pcSrc, aluSrc, regDst, regWrite, jump;
  input [2:0] aluControl;
  output zero;
  output [31:0] pc, aluOut, writeData;
  input [31:0] instr, readData;

  wire [4:0] writeReg;
  wire [31:0] pcNext, pcNextBr, pcPlus4, pcBranch;
  wire [31:0] signImm, signImmShifted;
  wire [31:0] srcA, srcB, result;

  // next pc logic
  flopr #(32) pcReg (
      .clk(clk),
      .rst(rst),
      .d  (pcNext),
      .q  (pc)
  );
  adder pcAdder (
      .a(pc),
      .b(32'd4),
      .y(pcPlus4)
  );
  sl2 immShift (
      .a(signImm),
      .y(signImmShifted)
  );
  adder pcAdd2 (
      .a(pcPlus4),
      .b(signImmShifted),
      .y(pcBranch)
  );
  mux2 #(32) pcMux (
      .d0(pcNextBr),
      .d1({pcPlus4[31:28], instr[25:0], 2'b00}),
      .s (jump),
      .y (pcNext)
  );
  mux2 #(32) pcBrMux (
      .d0(pcPlus4),
      .d1(pcBranch),
      .s (pcSrc),
      .y (pcNextBr)
  );

  // register file logic
  regfile rf (
      .clk(clk),
      .we3(regWrite),
      .ra1(instr[25:21]),
      .ra2(instr[20:16]),
      .wa3(writeReg),
      .wd3(result),
      .rd1(srcA),
      .rd2(writeData)
  );
  mux2 #(5) wrMux (
      .d0(instr[20:16]),
      .d1(instr[15:11]),
      .s (regDst),
      .y (writeReg)
  );
  mux2 #(32) resMux (
      .d0(aluOut),
      .d1(readData),
      .s (memToReg),
      .y (result)
  );
  signExt se (
      .a(instr[15:0]),
      .y(signImm)
  );

  // alu logic
  mux2 #(32) srcBMux (
      .d0(writeData),
      .d1(signImm),
      .s (aluSrc),
      .y (srcB)
  );
  alu alu (
      .srcA(srcA),
      .srcB(srcB),
      .aluControl(aluControl),
      .aluOut(aluOut),
      .zero(zero)
  );
endmodule

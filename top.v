module top (
    clk,
    rst,
    writeData,
    dataAddr,
    memWrite
);
  input clk, rst;
  output [31:0] writeData, dataAddr;
  output memWrite;

  wire [31:0] pc, instr, readData;

  mips mips (
      .clk(clk),
      .rst(rst),
      .pc(pc),
      .instr(instr),
      .memWrite(memWrite),
      .aluOut(dataAddr),
      .writeData(writeData),
      .readData(readData)
  );
  imem imem (
      .a (pc[7:2]),
      .rd(instr)
  );
  dmem dmem (
      .clk(clk),
      .we (memWrite),
      .a  (dataAddr),
      .wd (writeData),
      .rd (readData)
  );
endmodule

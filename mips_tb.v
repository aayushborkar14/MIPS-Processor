module mips_tb ();
  reg clk, rst;
  wire [31:0] writeData, dataAddr;
  wire memWrite;

  top dut (
      .clk(clk),
      .rst(rst),
      .writeData(writeData),
      .dataAddr(dataAddr),
      .memWrite(memWrite)
  );

  initial begin
    $dumpfile("mips_tb.vcd");
    $dumpvars(0, mips_tb);
    $display("dataAddr writeData memWrite");
    $monitor("%d %d %d", dataAddr, writeData, memWrite);
    rst <= 1;
    clk <= 0;
    #22 rst <= 0;
  end

  always #5 clk = ~clk;

  always @(negedge clk) begin
    if (memWrite) begin
      if (dataAddr == 84 && writeData == 7) begin
        $display("Test passed!");
        $finish;
      end else if (dataAddr != 80) begin
        $display("Test failed!");
        $finish;
      end
    end
  end
endmodule

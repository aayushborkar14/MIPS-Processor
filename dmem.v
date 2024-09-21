module dmem (
    clk,
    we,
    a,
    wd,
    rd
);
  input clk, we;
  input [31:0] a, wd;
  output [31:0] rd;

  reg [31:0] mem[0:63];
  assign rd = mem[a[31:2]];

  always @(posedge clk) begin
    if (we) mem[a[31:2]] <= wd;
  end
endmodule

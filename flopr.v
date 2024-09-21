module flopr #(
    parameter WIDTH = 8
) (
    clk,
    rst,
    d,
    q
);
  input clk, rst;
  input [WIDTH-1:0] d;
  output reg [WIDTH-1:0] q;

  always @(posedge clk or posedge rst) begin
    if (rst) q <= 0;
    else q <= d;
  end
endmodule

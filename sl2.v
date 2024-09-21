module sl2 (
    a,
    y
);
  input [31:0] a;
  output [31:0] y;
  assign y = {a[29:0], 2'b00};
endmodule

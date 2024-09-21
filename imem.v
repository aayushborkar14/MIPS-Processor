module imem (
    a,
    rd
);
  input [5:0] a;
  output [31:0] rd;

  reg [31:0] mem[0:17];

  initial begin
    $readmemh("memfile.dat", mem);
  end

  assign rd = mem[a];
endmodule

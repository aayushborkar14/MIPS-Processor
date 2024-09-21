module alu (
    srcA,
    srcB,
    aluControl,
    aluOut,
    zero
);
  input [31:0] srcA, srcB;
  input [2:0] aluControl;
  output reg [31:0] aluOut;
  output wire zero;

  assign zero = (aluOut == 0) ? 1 : 0;

  always @(aluControl or srcA or srcB) begin
    case (aluControl)
      3'b010:  aluOut <= srcA + srcB;  // add
      3'b110:  aluOut <= srcA - srcB;  // sub
      3'b000:  aluOut <= srcA & srcB;  // and
      3'b001:  aluOut <= srcA | srcB;  // or
      3'b111:  aluOut <= srcA < srcB ? 1 : 0;  // slt
      default: aluOut <= 32'bxxxxxxxx;  // illegal aluControl
    endcase
  end
endmodule

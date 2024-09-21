module aludec (
    funct,
    aluOp,
    aluControl
);
  input [5:0] funct;
  input [1:0] aluOp;
  output reg [2:0] aluControl;

  always @(aluOp or funct) begin
    case (aluOp)
      2'b00: aluControl <= 3'b010;  // add (for lw/sw/addi)
      2'b01: aluControl <= 3'b110;  // sub (for beq)
      default:
      case (funct)  // R-type instruction
        6'b100000: aluControl <= 3'b010;  // add
        6'b100010: aluControl <= 3'b110;  // sub
        6'b100100: aluControl <= 3'b000;  // and
        6'b100101: aluControl <= 3'b001;  // or
        6'b101010: aluControl <= 3'b111;  // slt
        default:   aluControl <= 3'bxxx;  // illegal funct
      endcase
    endcase
  end
endmodule

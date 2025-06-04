module alu(input [31:0] a, b,
           input [3:0] op,
           output reg [31:0] result);

always @(*) begin
    case(op)
        4'b0000: result <= a & b;
        4'b0001: result <= a | b;
        4'b0010: result <= a + b;
        4'b0110: result <= a - b;
        4'b0111: result <= a < b? 1:0;
        4'b1100: result <= ~(a|b);
        4'b1101: result <= a << b;
        default:
        result <= 0;
    endcase
end

endmodule
module alu_control (
    input wire [1:0] alu_op,
    input wire [5:0] funct,
    output reg [3:0] op
);
    always @(*) begin
        if(alu_op===2'b00) begin
            op <= 4'b0010;
        end
        else if(alu_op===2'b01) begin
            op <= 4'b0110;
        end
        else begin
            case (funct)
                6'b000_000: op <= 4'b1101; //sll
                6'b100_000: op <= 4'b0010; //add
                6'b100_010: op <= 4'b0110; //sub
                6'b101_010: op <= 4'b0111; //slt
                6'b100_100: op <= 4'b0000; //and
                6'b100_101: op <= 4'b0001; //or
                6'b100_111: op <= 4'b1100; //nor
                default: 
                op <= 4'bxxxx;
            endcase
        end
    end
endmodule
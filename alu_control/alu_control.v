module alu_control (
    input wire [1:0] alu_op,
    input wire [5:0] funct,
    output reg [3:0] op
);
    always @(*) begin
        if(~|alu_op) begin
            op <= 4'b0010;
        end
        else if(~alu_op[0]) begin
            op <= 4'b0110;
        end
        else begin
            case (funct[3:0])
                4'b0000: op <= 4'b0010;
                4'b0010: op <= 4'b0110;
                4'b0100: op <= 4'b0000;
                4'b1010: op <= 4'b0111;  
                default: 
                op <= 4'bzzzz;
            endcase
        end
    end
endmodule
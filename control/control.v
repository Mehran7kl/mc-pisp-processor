
// Here there are two approachs: Either we have instuctins and sub states associated with them or we have states sub-instuctions under them.
// We apply the second approach.
module control (
    input clk,
    input wire [5:0] opcode,
    output reg RegDst, ALUSrcA, MemtoReg, RegWrite, MemRead, MemWrite, Branch, PCWrite, IorD, IRWrite,
    output reg [1:0] ALUOp, ALUSrcB, PCSource
);
localparam [2:0] 
    S_IFETCH = 3'b000,
    S_ID =     3'b001,
    S_EX_R =   3'b010,
    S_WB_R =   3'b011,
    S_EX_B =   3'b100,
    S_EX_I =   3'b101;

    reg [2:0] s = 2'b00,ns;
    
    always @(posedge clk ) begin
        s <= ns;
    end
    always @(*) begin
        //ns <= s;
        case (s)
            S_IFETCH: ns = S_ID;
            S_ID: begin
                case (opcode)
                    6'b000000: ns <= S_EX_R;
                    6'b000100: ns <= S_EX_B;
                    6'b001000: ns <= S_EX_I;
                    default: ns <= S_IFETCH;
                endcase
            end
            S_EX_R: ns = S_WB_R;
            S_EX_I: ns = S_WB_R;
            default: ns <= S_IFETCH;
        endcase
    end

    always @(*) begin
        // default values.
        MemRead  = 1'b0;
        MemWrite = 1'b0;
        IorD     = 1'b0;
        IRWrite  = 1'b0;
        RegDst   = 1'b0; 
        RegWrite = 1'b0; 
        MemtoReg = 1'b0;

        ALUSrcA = 1'b0;
        ALUSrcB = 2'b00;
        ALUOp   = 2'b00;

        PCWrite = 1'b0;
        Branch  = 1'b0;
        PCSource= 2'b00;

        case (s)
            S_IFETCH: begin
                MemRead = 1'b1;
                IorD = 1'b0;
                ALUSrcA = 1'b0;
                ALUSrcB = 2'b01;
                ALUOp = 2'b00;
                PCWrite = 1'b1;
                PCSource = 1'b0;
                IRWrite = 1'b1;
            end
            S_ID: begin
                ALUSrcA = 1'b0;
                ALUSrcB = 2'b11; //aluout= imm32<<2 + pc
                ALUOp = 2'b00;
            end
            S_EX_R: begin
                ALUSrcA = 1'b1;
                ALUSrcB = 2'b00;
                ALUOp = 2'b10;
            end
            S_EX_I: begin
                ALUSrcA = 1'b1;
                ALUSrcB = 2'b10;
                ALUOp = 2'b00;
            end
            S_WB_R: begin
                RegDst = 1'b1;
                RegWrite = 1'b1;
                MemtoReg = 1'b0;
            end
            S_EX_B: begin
                ALUSrcA = 1'b1;
                ALUSrcB = 2'b00;
                ALUOp = 2'b01;
                Branch = 1'b1;
                PCSource = 2'b01;
            end
            default: ;
        endcase
    end
    
endmodule
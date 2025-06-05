
// Here there are two approachs: Either we have instuctins and sub states associated with them or we have states sub-instuctions under them.
// We apply the second approach.
module control (
    input clk,
    input wire [5:0] opcode,
    output reg RegDst, ALUSrcA, MemtoReg, RegWrite, MemRead, MemWrite, Branch, PCWrite, IorD, IRWrite, Cond, // 0 means zero condition, 1 otherwise
    output reg [1:0] ALUOp, ALUSrcB, PCSource
);
localparam [3:0] 
    S_IFETCH = 4'b0000,
    S_ID =     4'b0001,
    S_EX_R =   4'b0010,
    S_WB_R =   4'b0011,
    S_EX_B =   4'b0100,
    S_EX_I =   4'b0101,
    S_WB_D =   4'b0110,
    S_DFETCH = 4'b0111,
    S_MDRTOR = 4'b1000;

    reg [3:0] s = 2'b00, ns;
    
    always @(posedge clk ) begin
        s <= ns;
    end
    always @(*) begin
        //ns <= s;
        case (s)
            S_IFETCH: ns = S_ID;
            S_ID: begin
                case (opcode)
                    6'b000000: ns <= S_EX_R; // R-type
                    6'b000100: ns <= S_EX_B; // beq
                    6'b000101: ns <= S_EX_B; // bne
                    6'b001000: ns <= S_EX_I; // addi
                    6'b100011: ns <= S_EX_I; // lw
                    6'b101011: ns <= S_EX_I; // sw
                    default: ns <= S_IFETCH; // jump ...
                endcase
            end
            S_EX_R: begin
                ns = S_WB_R;
            end 
            S_EX_I:  begin
                ns = S_WB_R;
                if(opcode===6'b100011) ns = S_DFETCH;
                if(opcode===6'b101011) ns = S_WB_D;
            end 
            S_DFETCH: ns <= S_MDRTOR;
            
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
        Cond    = 1'b0;
        PCSource= 2'b00;

        case (s)
            S_IFETCH: begin
                // load to ir
                MemRead = 1'b1;
                IorD = 1'b0;
                // increment pc 
                ALUSrcA = 1'b0;
                ALUSrcB = 2'b01;
                ALUOp = 2'b00;
                PCWrite = 1'b1;
                PCSource = 1'b0;
                IRWrite = 1'b1;
            end
            S_ID: begin
                if(opcode[5:1]===5'b00010) // beq & bne
                begin
                    ALUSrcA = 1'b0;
                    ALUSrcB = 2'b11; //aluout= imm32<<2 + pc
                    ALUOp = 2'b00;        
                end
                if (opcode[5:1]===6'b00001) begin // jump & jal
                    PCSource = 2'b10;
                    PCWrite  = 1'b1;
                    // if(opcode[0]) link cant be executed because rd is not determined by control unit.
                    // so implenting this requires a significant change to the processor unit 
                end
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
                RegDst = ~opcode[3]; // for addi support
                RegWrite = 1'b1;
                MemtoReg = 1'b0;
            end
            S_EX_B: begin
                ALUSrcA = 1'b1;
                ALUSrcB = 2'b00;
                ALUOp = 2'b01;
                Branch = 1'b1;
                Cond   = opcode[0]; // beq vs bne
                PCSource = 2'b01;
            end
            S_WB_D: begin
                IorD = 1'b1;
                MemWrite = 1'b1;
            end
            S_DFETCH: begin
                IorD = 1'b1; MemRead = 1'b1;
            end
            S_MDRTOR: begin
                MemtoReg= 1'b1;
                RegWrite= 1'b1;
            end 
            default: ;
        endcase
    end
    
endmodule
module processor (
  input clk
);
    
    
    reg [31:0] ins = 0; //ir
    wire [4:0] rs1 = ins[25:21];
    wire [4:0] rs2 = ins[20:16];
    wire [4:0] rd;    
    wire RegDst, ALUSrcA, MemtoReg, RegWrite, MemRead, MemWrite, Branch, PCWrite, IRWrite, IorD;
    wire [1:0] ALUOp, ALUSrcB, PCSource;
    control cu (.clk(clk), .opcode(ins[31:26]), .RegDst(RegDst), .ALUSrcA(ALUSrcA), .ALUSrcB(ALUSrcB), .MemtoReg(MemtoReg), .RegWrite(RegWrite), .MemRead(MemRead), .MemWrite(MemWrite), .Branch(Branch), .IorD(IorD), .PCWrite(PCWrite), .IRWrite(IRWrite), .PCSource(PCSource), .ALUOp(ALUOp));
    
    assign rd = RegDst? ins[15:11] : ins[20:16];


    wire [31:0] rdata1,rdata2,wdata;
    reg_file regs(.clk(clk), .w(RegWrite),.rs1(rs1), .rs2(rs2), .rd(rd), .wdata(wdata), .rdata1(rdata1), .rdata2(rdata2));
    reg [31:0] regA = 0, regB = 0;
    
    wire [31:0] imm32;
    sign_extend se(.in(ins[15:0]),.out(imm32));
    
    wire [31:0] bdis; //branch displacement
    alu ba_shift(.a(imm32), .b(2), .op(4'b1101), .result(bdis));


    wire [3:0] op;
    alu_control aluc(.alu_op(ALUOp), .funct(ins[5:0]), .op(op));
    
    reg [31:0] pc=0;
    wire [31:0] alu_result;
    reg [31:0] alu_reg = 0;
    alu main_alu(.a(ALUSrcA ? regA : pc), .b( ALUSrcB[1] ? (ALUSrcB[0] ? bdis : imm32) : (ALUSrcB[0] ? 4 : regB)), .op(op), .result(alu_result));
    wire zero = ~| alu_result;
    
    wire [31:0] mem_data, addr;
    data_mem dmem (.clk(clk), .r(MemRead), .w(MemWrite), .addr(addr), .wdata(rdata2), .rdata(mem_data));

    
    wire [31:0] next_pc;
    assign addr = IorD ? alu_reg: pc; 
    reg [31:0] mdr;
    always @(posedge clk ) begin
      mdr <= mem_data;
      if (IRWrite) ins <= mem_data;
      if (PCWrite|(Branch&zero)) pc <= next_pc;
    end

    wire [31:0] jtarget; 
    alu ja_shift(.a(ins[25:0]), .b(2), .op(4'b1101), .result(jtarget[27:0]));
    assign jtarget[31:28] = pc[31:28];
    assign next_pc = PCSource[1]? (PCSource[0] ? 0 : jtarget) : (PCSource[0] ? alu_reg : alu_result);

endmodule
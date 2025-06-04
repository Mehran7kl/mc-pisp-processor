module processor (
  input clk
);
    reg [31:0] pc=0;
    wire [31:0] ins;
    wire RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, Jump;
    wire [1:0] alu_op;
    ins_mem imem (pc, ins);
    control cu (.opcode(ins[31:26]), .RegDst(RegDst), .ALUSrc(ALUSrc), .MemtoReg(MemtoReg), .RegWrite(RegWrite), .MemRead(MemRead), .MemWrite(MemWrite), .Branch(Branch),.Jump(Jump), .alu_op(alu_op));
    
    wire [4:0] rs1 = ins[25:21];
    wire [4:0] rs2 = ins[20:16];
    wire [4:0] rd = RegDst? ins[15:11] : ins[20:16];
    wire [31:0] rdata1,rdata2,wdata;
    reg_file regs(.clk(clk), .w(RegWrite),.rs1(rs1), .rs2(rs2), .rd(rd), .wdata(wdata), .rdata1(rdata1), .rdata2(rdata2));
    wire [31:0] imm32;
    sign_extend se(.in(ins[15:0]),.out(imm32));
    wire [3:0] op;
    alu_control aluc(.alu_op(alu_op), .funct(ins[5:0]), .op(op));
    wire [31:0] alu_result;
    alu main_alu(.a(rdata1), .b(ALUSrc?imm32:rdata2), .op(op), .result(alu_result));
    wire zero = ~| alu_result;
    wire [31:0] mem_data;
    data_mem dmem (.clk(clk), .r(MemRead), .w(MemWrite), .addr(alu_result), .wdata(rdata2), .rdata(mem_data));
    assign wdata = MemtoReg? mem_data:alu_result;
    wire [31:0] incpc; //increemnted pc = pc+4;
    alu pc_adder(.a(pc), .b(4), .op(4'b0010), .result(incpc));

    wire [31:0] jtarget; 
    alu ja_shift(.a(ins[25:0]), .b(2), .op(4'b1101), .result(jtarget[27:0]));
    assign jtarget[31:28] = incpc[31:28];

    wire [31:0] bdis; //branch displacement
    alu ba_shift(.a(imm32), .b(2), .op(4'b1101), .result(bdis));
    wire [31:0] btarget; //branch target
    alu br_adder(.a(incpc), .b(bdis), .op(4'b0010), .result(btarget));
    
    wire [31:0] target =  Jump? jtarget : (zero&Branch ? btarget : incpc);

    always @(posedge clk ) begin
        pc <= target;
    end
endmodule
module reg_file (
    input wire clk, w,
    input wire [4:0] rs1, rs2, rd,
    input wire [31:0] wdata,
    output wire [31:0] rdata1, rdata2
);
    reg [31:0] regs[0:31];
    initial regs[0] = 0;
    assign rdata1 = regs[rs1];
    assign rdata2 = regs[rs2];
    always @(posedge clk ) begin
        if(w) 
            regs[rd] <= wdata;
    end
endmodule
module reg_file (
    input wire clk, w, reset,
    input wire [4:0] rs1, rs2, rd,
    input wire [31:0] wdata,
    output wire [31:0] rdata1, rdata2
);
    reg [31:0] regs[0:31];
    
    assign rdata1 = regs[rs1];
    assign rdata2 = regs[rs2];
    always @(reset) begin
        if(reset) 
        for (integer i = 0; i<32; i= i +1) begin
            regs[i] = 0;
        end
    end
    always @(posedge clk ) begin
        if(w) 
            regs[rd] <= wdata;
    end
endmodule
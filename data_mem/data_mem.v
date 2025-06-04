module data_mem (
    input wire clk,
    input wire r, w,
    input wire [31:0] addr, wdata,
    output wire [31:0] rdata
);

    reg [31:0] mem [0:1023];

    assign rdata = (r && !w) ? mem[addr[11:2]] : 32'b0;

    always @(posedge clk) begin
        if (w && !r)
            mem[addr[11:2]] <= wdata;
    end

endmodule
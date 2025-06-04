`timescale 1ns / 1ns

module alu_tb;

reg [31:0] a, b;
reg [3:0] op;
wire [31:0] result;

alu uut(.a(a), .b(b), .op(op), .result(result));

initial begin
    $dumpfile("wave.vcd");   // Output waveform file
    $dumpvars(0, alu_tb);    // Dump all variables in the testbench
    $monitor("op = %b, result = %d",op,result);
    a = 6; b = 2;
    $display("a = %d, b = %d",a,b);
    op = 4'b0000; #10;
    op = 4'b0001; #10;
    op = 4'b0010; #10;
    op = 4'b0110; #10;

    $finish;
end

endmodule

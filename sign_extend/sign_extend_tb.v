`timescale 1ns / 1ns

module sign_extend_tb;
    reg signed [15:0] in;
    wire signed [31:0] out;
    sign_extend se (in,out);
    initial begin
        $dumpfile("wave.vcd");   // Output waveform file
        $dumpvars(0, sign_extend_tb);    // Dump all variables in the testbench
        $monitor("in = %d, out = %d",in,out);
        in = 2; #2;
        in = -2; #2;
        
        $finish;
    end
endmodule
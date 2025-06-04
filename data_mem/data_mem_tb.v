`timescale 1ps/1ps

module data_mem_tb;
    reg [31:0] addr ,wdata;
    wire [31:0 ] rdata;
    reg r,w,clk = 0;
    data_mem mem (clk,r,w,addr, wdata, rdata);
    always #1 clk = ~clk;
    initial begin
        $dumpfile("wave.vcd");   // Output waveform file
        $dumpvars(0, data_mem_tb);    // Dump all variables in the testbench
        $monitor("t = %d; r = %d, w = %d, addr = %d, rdata = %d, wdata = %d",$time,r , w ,addr, rdata ,wdata);
        addr = 2; r = 0 ; w = 1; wdata = 9; #2;
        addr = 2; r = 1 ; w = 0; 
        #5 $finish;
    end
endmodule
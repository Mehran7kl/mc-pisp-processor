`timescale 1ns/1ps
module reg_file_tb;
    
    reg clk = 0, w;
    reg [4:0] rs1 =0, rs2 =0, rd;
    reg [31:0] wdata;
    wire [31:0] rdata1, rdata2;
    reg_file file (clk,w,rs1,rs2,rd,wdata,rdata1,rdata2);
    always #1 clk = ~clk;
    initial begin
        $dumpfile("wave.vcd");   // Output waveform file
        $dumpvars(0, reg_file_tb);    // Dump all variables in the testbench
        $monitor("t = %d; rs1 = %d, rs2 = %d, rdata1 = %d, rdata2 = %d; rd = %d, w = %d, wdata = %d ",$time,rs1 , rs2 , rdata1, rdata2, rd ,w , wdata);
        #2;
        rd = 0; w =1; wdata = 12; #2; 
        rd = 1; w =1; wdata = 14; #2; w= 0;
        rs1 = 0; rs2 = 1; #2;

        #5 $finish;
        
    end
endmodule
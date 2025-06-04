`timescale 1ps/1ps

module processor_tb;
    reg clk = 0;
    processor mips(clk);
    always #2 clk = ~clk;
    initial begin
        $dumpfile("wave.vcd");   // Output waveform file
        $dumpvars(0, processor_tb);    // Dump all variables in the testbench
        
        mips.dmem.mem[0]= 32'h20080000;
        mips.dmem.mem[1]= 32'h21080001;
        mips.dmem.mem[2]= 32'h1108FFFE;
        
        #2;
        #100 $finish;

    end
endmodule
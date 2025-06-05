`timescale 1ps/1ps

module processor_tb;
    reg clk = 0 ,reset = 0;
    processor mips(clk,reset);
    always #2 clk = ~clk;
    initial begin
        $dumpfile("wave.vcd");   // Output waveform file
        $dumpvars(0, processor_tb);    // Dump all variables in the testbench
        
        reset = 1;
        #1;
        reset = 0;
                 
        
        // mips.dmem.mem[0]= 32'h20080000;
        // mips.dmem.mem[1]= 32'h21080001;
        // mips.dmem.mem[2]= 32'h1108FFFE;
        // reset = 1;
        // #1;
        // reset = 0;
        // #200;
        // $display("t0 = %d", mips.regs.regs[8]);
        
        mips.dmem.mem[0]  = 32'h201D03E8;  // addi $sp, $zero, 1000
        mips.dmem.mem[1]  = 32'h20080005;  // addi $t0, $zero, 5
        mips.dmem.mem[2]  = 32'h20090007;  // addi $t1, $zero, 7 
        mips.dmem.mem[3]  = 32'h0109702A;  // slt  $t6, $t0, $t1
        mips.dmem.mem[4]  = 32'h11C00008;  // beq  $t6, $zero, else_branch
        mips.dmem.mem[5]  = 32'h01095020;  // add  $t2, $t0, $t1    
        mips.dmem.mem[6]  = 32'h01095824;  // and  $t3, $t0, $t1
        mips.dmem.mem[7]  = 32'h01097825;  // or   $t7, $t0, $t1
        mips.dmem.mem[8]  = 32'h01E06027;  // nor  $t4, $t7, $zero      
        mips.dmem.mem[9]  = 32'hAFAA0000;  // sw   $t2, 0($sp)  
        mips.dmem.mem[10] = 32'hAFAB0004;  // sw   $t3, 4($sp)  
        mips.dmem.mem[11] = 32'hAFAC0008;  // sw   $t4, 8($sp)
        mips.dmem.mem[12] = 32'h0800000F;  // j    0F  
        mips.dmem.mem[13] = 32'h01096822;  // sw   $t5, 12($sp)
        mips.dmem.mem[14] = 32'hAFAD000C;  // sub  $t5, $t0, $t1 
        mips.dmem.mem[15] = 32'h8FB00000;  // lw   $s0, 0($sp)
        mips.dmem.mem[16] = 32'h8FB10004;  // lw   $s1, 4($sp)
        mips.dmem.mem[17] = 32'h16110002;  // bne  $s0, $s1, +2
        mips.dmem.mem[18] = 32'h20120001;  // addi $s2, $zero, 1
        mips.dmem.mem[19] = 32'h08000015;  // j    0x15 =21
        mips.dmem.mem[20] = 32'h20120002;  // addi $s2, $zero, 2
        #300;

        $display("t0 = %d", mips.regs.regs[8]);
        $display("t1 = %d", mips.regs.regs[9]);
        $display("t2 = %d", mips.regs.regs[10]);
        $display("t3 = %d", mips.regs.regs[11]);
        $display("t4 = %d", mips.regs.regs[12]);
        $display("t5 = %d", mips.regs.regs[13]);
        $display("t6 = %d", mips.regs.regs[14]);
        $display("t7 = %d", mips.regs.regs[15]);
        $display("s0 = %d", mips.regs.regs[16]);
        $display("s1 = %d", mips.regs.regs[17]);
        $display("s2 = %d", mips.regs.regs[18]);
        $display("[1000] = %d", mips.dmem.mem[250]);
        $display("[1004] = %d", mips.dmem.mem[251]);
        $display("[1004] = %d", mips.dmem.mem[252]);
        $finish;

    end
endmodule
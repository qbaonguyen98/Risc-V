`timescale 1ps/1ps 
module testbench();
    reg clk,rst;
    map map(rst, clk);

    initial begin
        rst = 0;
        clk = 0;
    end

    always begin
            #500 clk = !clk;
    end
endmodule


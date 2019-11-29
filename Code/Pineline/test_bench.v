`timescale 1ps/1ps 
module testbench();
    reg clk,rst;
    map_Pineline map_Pineline(rst, clk);

    initial begin
        rst = 0;
        clk = 0;
    end

    always begin
            #200 clk = !clk;
    end
endmodule


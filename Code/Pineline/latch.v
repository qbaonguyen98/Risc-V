module latch (clk, data_in, data_out);           // transfer stages base on clock

    input clk;
    input [31:0] data_in;

    output reg [31:0] data_out;

    always@ (posedge clk) begin
        data_out <= data_in;
    end

endmodule 
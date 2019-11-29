module p_latch (clk, enable, data_in, data_out);    // pulse_enable_latch

    input clk, enable;
    input [31:0] data_in;
    
    output reg [31:0] data_out;

    always@ (posedge clk) begin
        if (enable)     data_out <= data_in;
        else            data_out <= 32'bxxxxxxxxxxxxxxxxxxxxxxxxx0000000;
    end

endmodule
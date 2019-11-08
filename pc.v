// timescale ?
module pc(clk, rst, pc_in, pc_out);
    parameter PC_WIDTH_LENGTH = 32;
    
    input clk, rst;
    input [PC_WIDTH_LENGTH-1:0] pc_in;

    output reg [PC_WIDTH_LENGTH-1:0] pc_out;

    initial pc_out = 32'b00000000_00000000_00000000_00000000;

    always@ (posedge clk) begin
    if (rst==1)
        pc_out <= 32'b00000000_00000000_00000000_00000000;
    else 
        pc_out <= pc_in;    
endmodule
module plus4(pc_out, pc_plus4_out);
    parameter PC_WIDTH_LENGTH = 32;
    
    input [PC_WIDTH_LENGTH-1:0] pc_out;

    output reg [PC_WIDTH_LENGTH-1:0] pc_plus4_out;

    always@ (pc_out)
        pc_plus4_out = pc_out + 4;
endmodule
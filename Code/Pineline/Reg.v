module Reg(clk, RegWEn, inst_X, inst_W, DataD, DataA, DataB);
    input clk, RegWEn;
    input [31:0] inst_X, inst_W; 
    input [31:0] DataD;   // DataD = wb: data ghi nguoc
    
    output [31:0] DataA, DataB;

    integer k;
    reg [31:0] data [0:31];     // 2-dimens array: 32 thanh ghi, 1 thanh ghi 32 bit
    wire [4:0] AddrA, AddrB, AddrD;

    assign AddrD = inst_W[11:7];      // rd

    assign AddrA = inst_X[19:15];     // rs1
    assign AddrB = inst_X[24:20];     // rs2

    assign DataA = |AddrA ? data[AddrA] : 0;        // |x nghia la lay cac bit trong x OR lai voi nhau --> r0 luon = 0 
    assign DataB = |AddrB ? data[AddrB] : 0;

    initial begin
        for(k=0; k<32; k=k+1)   data[k] = 32'b0;
    end

    // always@ (posedge clk) begin
    always@ (*) begin
        data[0] <= 32'b0;            //  r0 luon = 0
        if (RegWEn)
            data[AddrD] <= DataD;    // ghi ket qua vao rd
    end
endmodule
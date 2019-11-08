module Reg(clk, RegWEn, inst, DataD, DataA, DataB);
    input clk, RegWEn;
    input [31:0] inst, DataD;   // DataD = wb: data ghi nguoc
    
    output [31:0] DataA, DataB;

    integer k;
    reg [31:0] data [0:31];     // 2-dimens array: 32 thanh ghi, 1 thanh ghi 32 bit
    wire [4:0] AddrA, AddrB, AddrD;

    assign AddrD = inst[11:7];      // rd
    assign AddrA = inst[19:15];     // rs1
    assign AddrB = inst[24:20];     // rs2

    assign DataA = |AddrA ? data[AddrA] : 0;        // |x nghia la lay cac bit trong x OR lai voi nhau
    assign DataB = |AddrB ? data[AddrB] : 0;

    initial begin
        for(k=0; k<32; k=k+1)   data[k] = 32'b0;
    end

    always@ (posedge clk) begin
        data[0] <= 32'b0;            //  r0 luon = 0
        if (RegWEn)
            data[AddrD] <= DataD;    // cho phep ghi ket qua vao rd
    end
endmodule
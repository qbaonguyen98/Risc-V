module DMEM(clk, Addr, DataW, MemRW, DataR));
    parameter	MEM_WIDTH_LENGTH = 32;          
    parameter	MEM_DEPTH = 1<<18;  
    reg		[MEM_WIDTH_LENGTH-1:0] IMEM[0:MEM_DEPTH-1]; 

    input clk, MemRW;           
    input [MEM_WIDTH_LENGTH:0] Addr, DataW;

    output reg [MEM_WIDTH_LENGTH:0] DataR;

    wire [17:0] pWord;
    wire [1:0] pByte;

    assign pWord = Addr[19:2];
    assign pByte = Addr[1:0];

    always@ (posedge clk) begin
        if (MemRW == 0) begin   // read
            if (pByte == 2'b00) begin
                DataR <= DMEM[pWord];
            end
            else begin
                DataR <= 'hz;
            end
        end
        else begin              // write
            DataR <= 'hz;
            if (pByte == 2'b00) begin
                DMEM[pWord] <= DataW;
            end
        end
    end
endmodule
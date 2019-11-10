`timescale 1ps/1ps
module DMEM(clk, Addr, DataW, MemRW, WSel, RSel, DataR);
    parameter	MEM_WIDTH_LENGTH = 32;          
    parameter	MEM_DEPTH = 1<<18;  
    reg		[MEM_WIDTH_LENGTH-1:0] DMEM[0:MEM_DEPTH-1]; 

    input clk, MemRW;         
    input [1:0] WSel;
    input [2:0] RSel;  
    input [MEM_WIDTH_LENGTH-1:0] Addr, DataW;

    output reg [MEM_WIDTH_LENGTH-1:0] DataR;

    wire [17:0] pWord;
    wire [1:0] pByte;
    wire [MEM_WIDTH_LENGTH-1:0] tempR, tempW;

    assign pWord = Addr[19:2];
    assign pByte = Addr[1:0];
    assign tempR = DMEM[pWord];
    assign tempW = DMEM[pWord];

    always@ (posedge clk) begin
    #5
        if (MemRW == 0) begin   // read
            if (pByte == 2'b00) begin
                case (RSel)
                    3'b000: // LB
                        DataR <= { {24{tempR[7]}}, tempR[7:0] };
                    3'b010: // LH
                        DataR <= { {16{tempR[15]}}, tempR[15:0] }; 
                    3'b011: // LW
                        DataR <= tempR;
                    3'b100: // LBU
                        DataR <= { {24{1'b0}}, tempR[7:0] };
                    3'b101: // LHU
                        DataR <= { {16{1'b0}}, tempR[15:0] };
                endcase
            end
        end
        else begin              // write
            if (pByte == 2'b00) begin
                case (WSel)
                    2'b00:  // SB
                        DMEM[pWord] <= (tempW & 32'hffffff00) | (DataW & 32'h000000ff);
                    2'b01:  // SH
                        DMEM[pWord] <= (tempW & 32'hffff0000) | (DataW & 32'h0000ffff);
                    2'b10:  // SW
                        DMEM[pWord] <= DataW;
                endcase
            end
        end
    end
endmodule
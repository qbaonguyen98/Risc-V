module ImmGen(imm_in, ImmSel, imm_out);
    input [31:7] imm_in;
    input [2:0] ImmSel;

    output reg [31:0] imm_out;

    always @(imm_in or ImmSel) begin
        case (ImmSel)
        3'd0:     // nhom I + JALR
            imm_out <= { {21{imm_in[31]}}, imm_in[30:20] };

        3'd1:     // nhom S
            imm_out <= { {21{imm_in[31]}}, imm_in[30:25], imm_in[11:7] };

        3'd2:     // nhom B
            imm_out <= { {20{imm_in[31]}}, imm_in[7], imm_in[30:25], imm_in[11:8], 1'b0 };

        3'd3:     // nhom U
            imm_out <= { imm_in[31:12], 12'b0 };
        
        3'd4:     // JAL 
            imm_out <= { {12{imm_in[31]}}, imm_in[19:12], imm_in[20], imm_in[30, 21], 1'b0 };
        endcase
    end
endmodule
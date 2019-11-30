module Control_W (inst_W, pc_W_sel, dmem_sel, w_sel, r_sel, wb_sel);

    input [31:0] inst_W;
    input pc_W_sel;

    output reg dmem_sel;
    output reg [1:0] w_sel;
    output reg [2:0] r_sel;
    output reg [1:0] wb_sel;

    // Command Category ----------------------------------------------------------------------
    parameter   
        R       = 5'b01100,
        I_arith = 5'b00100,
        I_load  = 5'b00000,
        S       = 5'b01000,
        B       = 5'b11000,
        JAL     = 5'b11011,
        JALR    = 5'b11001;

    parameter 
        ADD_SUB = 3'b000,   ADDI    = 3'b000,   LB  = 3'b000,   SB  = 3'b000,    BEQ = 3'b000,
        SLL     = 3'b001,   SLLI    = 3'b001,   SH      = 3'b001,   BNE = 3'b001,
        SLT     = 3'b010,   SLTI    = 3'b010,   LH      = 3'b010,   SW  = 3'b010, 
        SLTU    = 3'b011,   SLTIU   = 3'b011,   LW      = 3'b011, 
        XOR     = 3'b100,   XORI    = 3'b100,   LBU     = 3'b100,   BLT = 3'b100,
        SRL_SRA = 3'b101,   SRLI_SRAI = 3'b101, LHU     = 3'b101,   BGE = 3'b101, 
        OR      = 3'b110,   ORI     = 3'b110,   BLTU    = 3'b110,
        AND     = 3'b111,   ANDI    = 3'b111,   BGEU    = 3'b111;

    // data_out = DmemSel_WSel_RSel_WBSel ----------------------------------------------------
    reg [7:0] data_out; 

    always@ (*) begin
        case (inst_W[6:2])
            R: begin
            // data_out = DmemSel_WSel_RSel_WBSel
                case (inst_W[14:12])
                    ADD_SUB: begin
                        if (inst_W[30] == 0)  
                                data_out <= 8'b0_11_111_01;
                        else    data_out <= 8'b0_11_111_01;
                    end
                    SLL:        data_out <= 8'b0_11_111_01;
                    SLT:        data_out <= 8'b0_11_111_01;
                    SLTU:       data_out <= 8'b0_11_111_01;
                    XOR:        data_out <= 8'b0_11_111_01;
                    SRL_SRA: begin
                        if (inst_W[30] == 0)
                                data_out <= 8'b0_11_111_01;
                        else    data_out <= 8'b0_11_111_01;
                    end
                    OR:         data_out <= 8'b0_11_111_01;
                    AND:        data_out <= 8'b0_11_111_01;
                endcase
            end

            I_arith: begin
            // data_out = DmemSel_WSel_RSel_WBSel
                case (inst_W[14:12])
                    ADDI:       data_out <= 8'b0_11_111_01;
                    SLTI:       data_out <= 8'b0_11_111_01;
                    SLTIU:      data_out <= 8'b0_11_111_01;
                    XORI:       data_out <= 8'b0_11_111_01;
                    ORI:        data_out <= 8'b0_11_111_01;
                    ANDI:       data_out <= 8'b0_11_111_01;
                    // SLLI:   data_out <=
                    // SRLI_SRAI: begin
                    //     if (inst_W[30] == 0)  data_out <=
                    //     else    data_out <=
                    // end
                endcase
            end

            I_load: begin
            // data_out = DmemSel_WSel_RSel_WBSel
                case (inst_W[14:12])
                    LB:         data_out <= 8'b0_11_000_00;
                    LH:         data_out <= 8'b0_11_010_00;
                    LW:         data_out <= 8'b0_11_011_00;
                    LBU:        data_out <= 8'b0_11_100_00;
                    LHU:        data_out <= 8'b0_11_101_00;
                endcase
            end

            S: begin
            // data_out = DmemSel_WSel_RSel_WBSel
                case (inst_W[14:12])
                    SB:         data_out <= 8'b1_00_111_00;
                    SH:         data_out <= 8'b1_01_111_00;
                    SW:         data_out <= 8'b1_10_111_00;
                endcase
            end

            /********************************************************************************************************
             *                  BRANCH INSTRUCTIONS DOES NOT ACCESS DMEM AND WRITE BACK TO REGISTERS                *
             ********************************************************************************************************/

            // B: begin
            //     case (inst_W[14:12])
            //         BEQ: begin
            //             if (BrEq == 1)   
            //                     data_out <= 8'b1_010_0_1_1_1_0000_0_11_111_00;
            //             else    data_out <= 8'b0_111_0_1_0_0_0000_0_11_111_00;
            //         end
            //         BNE: begin
            //             if (BrEq == 0)   
            //                     data_out <= 8'b1_010_0_1_1_1_0000_0_11_111_00;
            //             else    data_out <= 8'b0_111_0_1_0_0_0000_0_11_111_00;
            //         end 
            //         BLT: begin
            //             if ((BrEq == 0) && (BrLt == 1))
            //                     data_out <= 8'b1_010_0_1_1_1_0000_0_11_111_00;
            //             else    data_out <= 8'b0_111_0_1_0_0_0000_0_11_111_00;
            //         end
            //         BGE: begin
            //             if ((BrEq == 1) || (BrLt == 0))     
            //                     data_out <= 8'b1_010_0_1_1_1_0000_0_11_111_00;
            //             else    data_out <= 8'b0_111_0_1_0_0_0000_0_11_111_00;
            //         end
            //         BLTU: begin
            //             if ((BrEq == 0) && (BrLt == 1)) 
            //                     data_out <= 8'b1_010_0_0_1_1_0000_0_11_111_00;
            //             else    data_out <= 8'b0_111_0_0_0_0_0000_0_11_111_00;
            //         end
            //         BGEU: begin
            //             if ((BrEq == 1) || (BrLt == 0))
            //                     data_out <= 8'b1_010_0_0_1_1_0000_0_11_111_00;
            //             else    data_out <= 8'b0_111_0_0_0_0_0000_0_11_111_00;
            //         end
            //     endcase
            // end

            // data_out = DmemSel_WSel_RSel_WBSel
            JAL:    data_out <= 8'b0_11_111_10;
            JALR:   data_out <= 8'b0_11_111_10;
        endcase

        //  Assign value of every single output: 
        dmem_sel    <= data_out[7];
        w_sel       <= data_out[6:5];
        r_sel       <= data_out[4:2];
        wb_sel      <= data_out[1:0];
    end

endmodule
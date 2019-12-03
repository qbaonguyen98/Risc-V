module Control_W (inst_W, pc_W_sel, dmem_sel, w_sel, r_sel, wb_sel, regWEn);

    input [31:0] inst_W;
    input pc_W_sel;

    output reg dmem_sel;
    output reg [1:0] w_sel;
    output reg [2:0] r_sel;
    output reg [1:0] wb_sel;
    output reg regWEn;

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

    // data_out = DmemSel_WSel_RSel_WBSel_regWEn ----------------------------------------------------
    reg [8:0] data_out;

    always@ (*) begin
        case (inst_W[6:2])
            R: begin
            // data_out = DmemSel_WSel_RSel_WBSel_regWEn
                case (inst_W[14:12])
                    ADD_SUB: begin
                        if (inst_W[30] == 0)  
                                data_out <= 9'b0_11_111_01_1;
                        else    data_out <= 9'b0_11_111_01_1;
                    end
                    SLL:        data_out <= 9'b0_11_111_01_1;
                    SLT:        data_out <= 9'b0_11_111_01_1;
                    SLTU:       data_out <= 9'b0_11_111_01_1;
                    XOR:        data_out <= 9'b0_11_111_01_1;
                    SRL_SRA: begin
                        if (inst_W[30] == 0)
                                data_out <= 9'b0_11_111_01_1;
                        else    data_out <= 9'b0_11_111_01_1;
                    end
                    OR:         data_out <= 9'b0_11_111_01_1;
                    AND:        data_out <= 9'b0_11_111_01_1;
                endcase
            end

            I_arith: begin
            // data_out = DmemSel_WSel_RSel_WBSel_regWEn
                case (inst_W[14:12])
                    ADDI:       data_out <= 9'b0_11_111_01_1;
                    SLTI:       data_out <= 9'b0_11_111_01_1;
                    SLTIU:      data_out <= 9'b0_11_111_01_1;
                    XORI:       data_out <= 9'b0_11_111_01_1;
                    ORI:        data_out <= 9'b0_11_111_01_1;
                    ANDI:       data_out <= 9'b0_11_111_01_1;
                    // SLLI:   data_out <=
                    // SRLI_SRAI: begin
                    //     if (inst_W[30] == 0)  data_out <=
                    //     else    data_out <=
                    // end
                endcase
            end

            I_load: begin
            // data_out = DmemSel_WSel_RSel_WBSel_regWEn
                case (inst_W[14:12])
                    LB:         data_out <= 9'b0_11_000_00_1;
                    LH:         data_out <= 9'b0_11_010_00_1;
                    LW:         data_out <= 9'b0_11_011_00_1;
                    LBU:        data_out <= 9'b0_11_100_00_1;
                    LHU:        data_out <= 9'b0_11_101_00_1;
                endcase
            end

            S: begin
            // data_out = DmemSel_WSel_RSel_WBSel_regWEn
                case (inst_W[14:12])
                    SB:         data_out <= 9'b1_00_111_11_0;
                    SH:         data_out <= 9'b1_01_111_11_0;
                    SW:         data_out <= 9'b1_10_111_11_0;
                endcase
            end

            /********************************************************************************************************
             *                  BRANCH INSTRUCTIONS DOES NOT ACCESS DMEM AND WRITE BACK TO REGISTERS                *
             ********************************************************************************************************/
            B: begin
            // data_out = DmemSel_WSel_RSel_WBSel_regWEn
                data_out <= 9'bx_xx_xxx_xx_0;
            end

            JAL: begin
            // data_out = DmemSel_WSel_RSel_WBSel_regWEn
                data_out <= 9'b0_11_111_10_1;
            end
            
            JALR: begin
            // data_out = DmemSel_WSel_RSel_WBSel_regWEn
                data_out <= 9'b0_11_111_10_1;
            end   
        endcase

        //  Assign value of every single output: 
        dmem_sel    <= data_out[8];
        w_sel       <= data_out[7:6];
        r_sel       <= data_out[5:3];
        wb_sel      <= data_out[2:1];
        regWEn      <= data_out[0];
    end

endmodule
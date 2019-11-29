module Control_Unit(
    inst, BrEq, BrLt,       // input
    PCSel, ImmSel, RegWEn, BrUn, BSel, ASel, ALUSel, MemRW, RSel, WSel, WBSel   // output
);
    input [31:0] inst;
    input BrEq, BrLt;

    output reg PCSel, RegWEn, BrUn, BSel, ASel, MemRW;
    output reg [1:0] WBSel, WSel;
    output reg [2:0] ImmSel, RSel;
    output reg [3:0] ALUSel;
    
    // Control Unit output data
    reg [19:0] data_out; 

    // Command classes
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
    
    always@ (*) begin
        case (inst[6:2])
            R: begin
                case (inst[14:12])
                // PCSel_ImmSel_RegWEn_BrUn_BSel_ASel_ALUSel_MemRW_WSel_RSel_WBSel
                    ADD_SUB: begin
                        if (inst[30] == 0)  
                                data_out <= 20'b0_111_1_0_0_0_0000_0_11_111_01;
                        else    data_out <= 20'b0_111_1_0_0_0_0001_0_11_111_01;
                    end
                    SLL:        data_out <= 20'b0_111_1_0_0_0_0101_0_11_111_01;
                    SLT:        data_out <= 20'b0_111_1_0_0_0_1000_0_11_111_01;
                    SLTU:       data_out <= 20'b0_111_1_0_0_0_1001_0_11_111_01;
                    XOR:        data_out <= 20'b0_111_1_0_0_0_0100_0_11_111_01;
                    SRL_SRA: begin
                        if (inst[30] == 0)
                                data_out <= 20'b0_111_1_0_0_0_0110_0_11_111_01;
                        else    data_out <= 20'b0_111_1_0_0_0_0111_0_11_111_01;
                    end
                    OR:         data_out <= 20'b0_111_1_0_0_0_0011_0_11_111_01;
                    AND:        data_out <= 20'b0_111_1_0_0_0_0010_0_11_111_01;
                endcase
            end
            // PCSel_ImmSel_RegWEn_BrUn_BSel_ASel_ALUSel_MemRW_WSel_RSel_WBSel
            I_arith: begin
                case (inst[14:12])
                    ADDI:       data_out <= 20'b0_000_1_0_1_0_0000_0_11_111_01;
                    SLTI:       data_out <= 20'b0_000_1_0_1_0_1000_0_11_111_01;
                    SLTIU:      data_out <= 20'b0_000_1_0_1_0_1001_0_11_111_01;
                    XORI:       data_out <= 20'b0_000_1_0_1_0_0100_0_11_111_01;
                    ORI:        data_out <= 20'b0_000_1_0_1_0_0011_0_11_111_01;
                    ANDI:       data_out <= 20'b0_000_1_0_1_0_0010_0_11_111_01;
                    // SLLI:   data_out <=
                    // SRLI_SRAI: begin
                    //     if (inst[30] == 0)  data_out <=
                    //     else    data_out <=
                    // end
                endcase
            end

            I_load: begin
                case (inst[14:12])
                    LB:         data_out <= 20'b0_000_1_0_1_0_0000_0_11_000_01;
                    LH:         data_out <= 20'b0_000_1_0_1_0_0000_0_11_010_01;
                    LW:         data_out <= 20'b0_000_1_0_1_0_0000_0_11_011_01;
                    LBU:        data_out <= 20'b0_000_1_0_1_0_0000_0_11_100_01;
                    LHU:        data_out <= 20'b0_000_1_0_1_0_0000_0_11_101_01;
                endcase
            end

            S: begin
                case (inst[14:12])
                    SB:         data_out <= 20'b0_001_0_0_1_0_0000_1_00_111_00;
                    SH:         data_out <= 20'b0_001_0_0_1_0_0000_1_01_111_00;
                    SW:         data_out <= 20'b0_001_0_0_1_0_0000_1_10_111_00;
                endcase
            end
            // PCSel_ImmSel_RegWEn_BrUn_BSel_ASel_ALUSel_MemRW_WSel_RSel_WBSel
            B: begin
                case (inst[14:12])
                    BEQ: begin
                        if (BrEq == 1)   
                                data_out <= 20'b1_010_0_1_1_1_0000_0_11_111_00;
                        else    data_out <= 20'b0_111_0_1_0_0_0000_0_11_111_00;
                    end
                    BNE: begin
                        if (BrEq == 0)   
                                data_out <= 20'b1_010_0_1_1_1_0000_0_11_111_00;
                        else    data_out <= 20'b0_111_0_1_0_0_0000_0_11_111_00;
                    end 
                    BLT: begin
                        if ((BrEq == 0) && (BrLt == 1))
                                data_out <= 20'b1_010_0_1_1_1_0000_0_11_111_00;
                        else    data_out <= 20'b0_111_0_1_0_0_0000_0_11_111_00;
                    end
                    BGE: begin
                        if ((BrEq == 1) || (BrLt == 0))     
                                data_out <= 20'b1_010_0_1_1_1_0000_0_11_111_00;
                        else    data_out <= 20'b0_111_0_1_0_0_0000_0_11_111_00;
                    end
                    BLTU: begin
                        if ((BrEq == 0) && (BrLt == 1)) 
                                data_out <= 20'b1_010_0_0_1_1_0000_0_11_111_00;
                        else    data_out <= 20'b0_111_0_0_0_0_0000_0_11_111_00;
                    end
                    BGEU: begin
                        if ((BrEq == 1) || (BrLt == 0))
                                data_out <= 20'b1_010_0_0_1_1_0000_0_11_111_00;
                        else    data_out <= 20'b0_111_0_0_0_0_0000_0_11_111_00;
                    end
                endcase
            end

            JAL:    data_out <= 20'b1_100_1_0_1_1_0000_0_11_111_10;

            JALR:   data_out <= 20'b1_000_1_0_1_0_0000_0_11_111_10;
        endcase

//  Assign value of every single output: 

/*              FETCH               */
        PCSel   <= data_out[19];

/*              EXECUTE             */
        ImmSel  <= data_out[18:16];
        RegWEn  <= data_out[15];
        BrUn    <= data_out[14];
        BSel    <= data_out[13];
        ASel    <= data_out[12];
        ALUSel  <= data_out[11:8];

/*              WRITE BACK          */
        MemRW   <= data_out[7];
        WSel    <= data_out[6:5];
        RSel    <= data_out[4:2];
        WBSel   <= data_out[1:0];
        
        

    end
endmodule 
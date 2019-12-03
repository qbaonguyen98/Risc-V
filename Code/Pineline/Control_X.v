`timescale 1ps/1ps
module Control_X (clk, inst_X, imm_sel, br_un, br_eq, br_lt, bsel, asel, alu_sel, latch_X_en, latch_W_en, X_ctrl);

    input clk;
    input [31:0] inst_X;
    input br_eq, br_lt;

    output reg [2:0] imm_sel;
    output reg br_un, bsel, asel; 
    output reg [3:0] alu_sel;
    output reg latch_X_en;
    output reg latch_W_en; 
    output reg X_ctrl;      // use to notify the Control_F to choose alu for new pc

    // Command Category ----------------------------------------------------------------------
    parameter   
        R       = 5'b01100,
        I_arith = 5'b00100,
        I_load  = 5'b00000,
        S       = 5'b01000,
        B       = 5'b11000,
        JAL     = 5'b11011,
        JALR    = 5'b11001,
        NOP     = 5'b11111;

    parameter 
        ADD_SUB = 3'b000,   ADDI        = 3'b000,   LB      = 3'b000,   SB  = 3'b000,    BEQ = 3'b000,
        SLL     = 3'b001,   SLLI        = 3'b001,   SH      = 3'b001,   BNE = 3'b001,
        SLT     = 3'b010,   SLTI        = 3'b010,   LH      = 3'b010,   SW  = 3'b010, 
        SLTU    = 3'b011,   SLTIU       = 3'b011,   LW      = 3'b011, 
        XOR     = 3'b100,   XORI        = 3'b100,   LBU     = 3'b100,   BLT = 3'b100,
        SRL_SRA = 3'b101,   SRLI_SRAI   = 3'b101,   LHU     = 3'b101,   BGE = 3'b101, 
        OR      = 3'b110,   ORI         = 3'b110,   BLTU    = 3'b110,
        AND     = 3'b111,   ANDI        = 3'b111,   BGEU    = 3'b111;

    // data_out = ImmSel_BrUn_BSel_ASel_ALUSel ---------------------------------------
    reg [9:0] data_out; 

    initial begin
        X_ctrl = 0;
        latch_X_en = 1;
        latch_W_en = 1;
    end

    always@ (*) begin
        case (inst_X[6:2])
            R: begin
            // ImmSel_BrUn_BSel_ASel_ALUSel
                case (inst_X[14:12])
                    ADD_SUB: begin
                        if (inst_X[30] == 0)  
                                data_out <= 10'b111_0_0_0_0000;
                        else    data_out <= 10'b111_0_0_0_0001;
                    end
                    SLL:        data_out <= 10'b111_0_0_0_0101;
                    SLT:        data_out <= 10'b111_0_0_0_1000;
                    SLTU:       data_out <= 10'b111_0_0_0_1001;
                    XOR:        data_out <= 10'b111_0_0_0_0100;
                    SRL_SRA: begin
                        if (inst_X[30] == 0)
                                data_out <= 10'b111_0_0_0_0110;
                        else    data_out <= 10'b111_0_0_0_0111;
                    end
                    OR:         data_out <= 10'b111_0_0_0_0011;
                    AND:        data_out <= 10'b111_0_0_0_0010;
                endcase
            end

            I_arith: begin
            // ImmSel_BrUn_BSel_ASel_ALUSel
                case (inst_X[14:12])
                    ADDI:       data_out <= 10'b000_0_1_0_0000;
                    SLTI:       data_out <= 10'b000_0_1_0_1000;
                    SLTIU:      data_out <= 10'b000_0_1_0_1001;
                    XORI:       data_out <= 10'b000_0_1_0_0100;
                    ORI:        data_out <= 10'b000_0_1_0_0011;
                    ANDI:       data_out <= 10'b000_0_1_0_0010;
                    // SLLI:   data_out <=
                    // SRLI_SRAI: begin
                    //     if (inst_X[30] == 0)  data_out <=
                    //     else    data_out <=
                    // end
                endcase
            end

            I_load: begin
            // ImmSel_BrUn_BSel_ASel_ALUSel
                case (inst_X[14:12])
                    LB:         data_out <= 10'b000_0_1_0_0000;
                    LH:         data_out <= 10'b000_0_1_0_0000;
                    LW:         data_out <= 10'b000_0_1_0_0000;
                    LBU:        data_out <= 10'b000_0_1_0_0000;
                    LHU:        data_out <= 10'b000_0_1_0_0000;
                endcase
            end

            S: begin
            // ImmSel_BrUn_BSel_ASel_ALUSel
                case (inst_X[14:12])
                    SB:         data_out <= 10'b001_0_1_0_0000;       // RegWEn = 1 --> solve: "add rd = a0" (W) then "sw a0 ..." (F)
                    SH:         data_out <= 10'b001_0_1_0_0000;
                    SW:         data_out <= 10'b001_0_1_0_0000;
                endcase
            end

            B: begin
            // ImmSel_BrUn_BSel_ASel_ALUSel
                case (inst_X[14:12])
                    BEQ: begin
                        if (br_eq == 1) begin   // jump   
                            data_out <= 10'b010_1_1_1_0000;
                            // notify the F and kill the fetched instruction
                            X_ctrl <= 1;
                            latch_X_en <= 0;
                            latch_W_en <= 0;
                        end
                        else begin    
                            data_out <= 10'b111_1_0_0_0000;
                            X_ctrl <= 0;
                            latch_X_en <= 1;
                            latch_W_en <= 1;
                        end
                    end
                    BNE: begin
                        if (br_eq == 0) begin   // jump   
                            data_out <= 10'b010_1_1_1_0000;
                            // notify the F and kill the fetched instruction
                            X_ctrl <= 1;
                            latch_X_en <= 0;
                            latch_W_en <= 0;
                        end
                        else begin    
                            data_out <= 10'b111_1_0_0_0000;
                            X_ctrl <= 0;
                            latch_X_en <= 1;
                            latch_W_en <= 1;
                        end
                    end 
                    BLT: begin
                        if ((br_eq == 0) && (br_lt == 1)) begin     // jump
                            data_out <= 10'b010_1_1_1_0000;
                            // notify the F and kill the fetched instruction
                            X_ctrl <= 1;
                            latch_X_en <= 0;
                            latch_W_en <= 0;
                        end
                        else begin     
                            data_out <= 10'b111_1_0_0_0000;
                            X_ctrl <= 0;
                            latch_X_en <= 1;
                            latch_W_en <= 1;
                        end
                    end
                    BGE: begin
                        if ((br_eq == 1) || (br_lt == 0)) begin     // jump     
                            data_out <= 10'b010_1_1_1_0000;
                            // notify the F and kill the fetched instruction
                            X_ctrl <= 1;
                            latch_X_en <= 0;
                            latch_W_en <= 0;
                        end
                        else begin    
                            data_out <= 10'b111_1_0_0_0000;
                            X_ctrl <= 0;
                            latch_X_en <= 1;
                            latch_W_en <= 1;
                        end
                    end
                    BLTU: begin
                        if ((br_eq == 0) && (br_lt == 1)) begin     // jump    
                            data_out <= 10'b010_0_1_1_0000;
                            // notify the F and kill the fetched instruction
                            X_ctrl <= 1;
                            latch_X_en <= 0;
                            latch_W_en <= 0;
                        end
                        else begin    
                            data_out <= 10'b111_0_0_0_0000;
                            X_ctrl <= 0;
                            latch_X_en <= 1;
                            latch_W_en <= 1;
                        end
                    end
                    BGEU: begin
                        if ((br_eq == 1) || (br_lt == 0)) begin     // jump
                            data_out <= 10'b010_0_1_1_0000;
                            // notify the F and kill the fetched instruction
                            X_ctrl <= 1;
                            latch_X_en <= 0;
                            latch_W_en <= 0;
                        end
                        else begin    
                            data_out <= 10'b111_0_0_0_0000;
                            X_ctrl <= 0;
                            latch_X_en <= 1;
                            latch_W_en <= 1;
                        end
                    end
                endcase
            end

            JAL: begin
            // ImmSel_BrUn_BSel_ASel_ALUSel
                data_out <= 10'b100_0_1_1_0000;
                // notify the F and kill the fetched instruction
                X_ctrl <= 1;
                latch_X_en <= 0;
                latch_W_en <= 1;
            end

            JALR: begin
            // ImmSel_BrUn_BSel_ASel_ALUSel   
                data_out <= 10'b000_0_1_0_0000;
                // notify the F and kill the fetched instruction
                X_ctrl <= 1;
                latch_X_en <= 0;
                latch_W_en <= 1;
            end
            
            NOP: begin
                X_ctrl <= 0;
                latch_X_en <= 1;
                latch_W_en <= 1;
            end

        endcase

        //  Assign value of every single output: 
        imm_sel     <= data_out[9:7];
        br_un       <= data_out[6];
        bsel        <= data_out[5];
        asel        <= data_out[4];
        alu_sel     <= data_out[3:0];
    end

    // testing: seem to be OK
    // always@ (posedge clk) begin
    //     #10
    //     if (inst_X[6:2] == NOP) begin
    //         X_ctrl <= 0;
    //         latch_X_en <= 1;
    //         latch_W_en <= 1;
    //     end
    // end

endmodule
module Control_Unit(
    inst, BrEq, BrLt,       // input
    PCSel, ImmSel, RegWEn, BrUn, BSel, ASel, ALUSel, MemRW, WBSel   // output
);
    input [31:0] inst;
    input BrEq, BrLt;

    output reg PCSel, RegWEn, BrUn, BSel, ASel, MemRW;
    output reg [1:0] WBSel;
    output reg [2:0] ImmSel;
    output reg [3:0] ALUSel;
    
    // Control Unit output data
    reg [14:0]data_out; // PCSel_RegWEn_BrUn_BSel_ASel_MemRW_WBSel(2)_ImmSel(3)_ALUSel(4)

    // Command classes
    parameter [5:0] R = 5'b01100;
    parameter [5:0] I_arith = 5'b00100;
    parameter [5:0] I_load = 5'b00000;
    parameter [5:0] S = 5'b01000;
    parameter [5:0] B = 5'b11000;
    parameter [5:0] JAL = 5'b11011;
    parameter [5:0] JALR = 5'b11001;

    // Command code --> distinguish 1 command from others in a command class
    parameter 
        ADD_SUB = 3'b000, ADDI = 3'b000, LB = 3'b000, SB = 3'b000, BEQ = 3'b000, JALR = 3'b000,
        SLL = 3'b001, SLLI = 3'b001, SH = 3'b001, BNE = 3'b001,
        SLT = 3'b010, SLTI = 3'b010, LH = 3'b010, SW = 3'b010, 
        SLTU = 3'b011, SLTIU = 3'b011, LW = 3'b011, 
        XOR = 3'b100, XORI = 3'b100, LBU = 3'b100, BLT = 3'b100,
        SRL_SRA = 3'b101, SRLI_SRAI = 3'b101, LHU = 3'b101, BGE = 3'b101, 
        OR = 3'b110, ORI = 3'b110, BLTU = 3'b110,
        AND = 3'b111, ANDI = 3'b111, BGEU = 3'b111;
    
    always@ (*) begin
        case (inst[6:2])
            R: begin
                case (inst[14:12])
                    ADD_SUB: begin
                        if (inst[30] == 0)  data_out <=
                        else    data_out <= 
                    end
                    SLL:    data_out <=
                    SLT:    data_out <=
                    SLTU:   data_out <=
                    XOR:    data_out <=
                    SRL_SRA: begin
                        if (inst[30] == 0)  data_out <=
                        else    data_out <=
                    end
                    OR:     data_out <=
                    AND:    data_out <=
                endcase
            end
            
            I_arith: begin
                case (inst[14:12])
                    ADDI:   data_out <=
                    SLTI:   data_out <=
                    SLTIU:  data_out <=
                    XORI:   data_out <=
                    ORI:    data_out <=
                    ANDI:   data_out <=
                    SLLI:   data_out <=
                    SRLI_SRAI: begin
                        if (inst[30] == 0)  data_out <=
                        else    data_out <=
                    end
                endcase
            end

            I_load: begin
                case (inst[14:12])
                    LB:     data_out <=
                    LH:     data_out <=
                    LW:     data_out <=
                    LBU:    data_out <=
                    LHU:    data_out <=
                endcase
            end

            S: begin
                case (inst[14:12])
                    SB:     data_out <=
                    SH:     data_out <=
                    SW:     data_out <=
                endcase
            end

            B: begin
                case (inst[14:12])
                    BEQ:    data_out <=
                    BNE:    data_out <=
                    BLT:    data_out <=
                    BGE:    data_out <=
                    BLTU:   data_out <=
                    BGEU:   data_out <=
                endcase
            end

            JAL:    data_out <=

            JALR:   data_out <=
        endcase
//  Assign value of every single output: 
//  data_out[14:0] = PCSel_RegWEn_BrUn_BSel_ASel_MemRW_WBSel(2)_ImmSel(3)_ALUSel(4)
        PCSel <= data_out[14];
        RegWEn <= data_out[13];
        BrUn <= data_out[12];
        BSel <= data_out[11];
        ASel <= data_out[10];
        MemRW <= data_out[9];
        WBSel <= data_out[8:7];
        ImmSel <= data_out[6:4];
        ALUSel <= data_out[3:0];
    end
endmodule 
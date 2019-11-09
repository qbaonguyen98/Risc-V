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
    reg [14:0]data_out; // PCSel_RegWEn_BrUn_BSel_ASel_MemRW_WBSel_ImmSel_ALUSel

    // Command classes
    parameter [5:0] R = 5'b01100;
    parameter [5:0] I_compute = 5'b00100;
    parameter [5:0] I_load = 5'b00000;
    parameter [5:0] S = 5'b01000;
    parameter [5:0] B = 5'b11000;
    parameter [5:0] JAL = 5'b11011;
    parameter [5:0] JALR = 5'b11001;

    // Command code --> distinguish 1 command from others in a command class
    parameter 
        ADD = 3'b000, SUB = 3'b000, ADDI = 3'b000, LB = 3'b000, SB = 3'b000, BEQ = 3'b000, JALR = 3'b000,
        SLL = 3'b001, SLLI = 3'b001, SH = 3'b001, BNE = 3'b001,
        SLT = 3'b010, SLTI = 3'b010, LH = 3'b010, SW = 3'b010, 
        SLTU = 3'b011, SLTIU = 3'b011, LW = 3'b011, 
        XOR = 3'b100, XORI = 3'b100, LBU = 3'b100, BLT = 3'b100,
        SRL = 3'b101, SRA = 3'b101, SRLI = 3'b101, SRAI = 3'b101, LHU = 3'b101, BGE = 3'b101, 
        OR = 3'b110, ORI = 3'b110, BLTU = 3'b110,
        AND = 3'b111, ANDI = 3'b111, BGEU = 3'b111;
        // JAL --> in case you forgot it 
    


endmodule 
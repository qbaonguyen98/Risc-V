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

    

endmodule 
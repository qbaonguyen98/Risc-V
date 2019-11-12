module map(rst, clk);
    input rst, clk;

    wire [31:0] pc_in, pc_out, pc_plus4_out, 
                rs1_out, rs2_out, 
                inst, imm_out,
                alumux1_out, alumux2_out, aluout,
                dmem_out, wb_out;
    wire [3:0]  aluop;
    wire [2:0]  imm_sel, RSel;
    wire [1:0]  WSel, wbmux_sel; 
    wire    br_eq, br_lt,
            pcmux_sel, regfilemux_sel, cmpop, alumux1_sel, alumux2_sel, dmem_sel;

    mux2 pcmux(pcmux_sel, pc_plus4_out, aluout, pc_in);
    pc pc(clk, rst, pc_in, pc_out);
    plus4 plus4(pc_out, pc_plus4_out);
    IMEM IMEM(pc_out, inst);
    Reg Reg(clk, regfilemux_sel, inst, wb_out, rs1_out, rs2_out);
    ImmGen ImmGen(inst, imm_sel, imm_out);
    Branch_Comparator Branch_Comparator(rs1_out, rs2_out, cmpop, br_eq, br_lt);
    mux2 alumux1(alumux1_sel, rs1_out, pc_out, alumux1_out);
    mux2 alumux2(alumux2_sel, rs2_out, imm_out, alumux2_out);
    ALU ALU(alumux1_out, alumux2_out, aluop, aluout);
    DMEM DMEM(clk, aluout, rs2_out, dmem_sel, WSel, RSel, dmem_out);
    mux3 wbmux(wbmux_sel, dmem_out, aluout, pc_plus4_out, wb_out);
    Control_Unit CU(inst, br_eq, br_lt, pcmux_sel, imm_sel, regfilemux_sel, cmpop, alumux2_sel, alumux1_sel, aluop, dmem_sel, RSel, WSel, wbmux_sel);
                
endmodule
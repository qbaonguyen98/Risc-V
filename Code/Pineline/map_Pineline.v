module map_Pineline(rst, clk);
    input rst, clk;

    // FETCH ------------------------------------------------------------------
    wire [31:0]     pc_F_in, 
                    pc_F, 
                    pc_F_plus4,
                    alu_X,              // from EXECUTE stage
                    inst_F;

        // control signal
        wire pc_F_sel;           


    // EXECUTE ----------------------------------------------------------------
    wire [31:0]     pc_X,
                    inst_X,
                    imm_out,
                    rs1_X,
                    rs2_X,
                    amux_out,
                    bmux_out,
                    //alu_X,          
                    inst_W, wb_out,     // from WRITE BACK stage
                    alu_W;              // for forwarding

        // control signal
        wire        regWEn, br_un, br_eq, br_lt, bsel;
        wire [1:0]  asel;
        wire [2:0]  imm_sel;
        wire [3:0]  alu_sel; 
    
    // WRITE BACK -------------------------------------------------------------
    wire [31:0]     pc_W,
                    //alu_W,    // addr
                    rs2_W,      // data_W
                    //inst_W,
                    dmem_out;
        
        // control signal
        wire        dmem_sel;
        wire [1:0]  w_sel, wb_sel;
        wire [2:0]  r_sel;

    
/************************************************************************************************************************************/


    // FETCH ----------------------------------------------------------------
    mux2 pc_F_mux (pc_F_sel, pc_F_plus4, alu_X, pc_F_in);
    pc pc (clk, rst, pc_F_in, pc_F);
    plus4 F_plus4 (pc_F, pc_F_plus4);
    IMEM IMEM (pc_F, inst_F);

            // latches
    latch pc_X_latch (clk, pc_F, pc_X);
    latch inst_X_latch (clk, inst_F, inst_X);


    // EXECUTE --------------------------------------------------------------
    Reg Reg (clk, regWEn, inst_X, wb_out, rs1_X, rs2_X);
    ImmGen ImmGen (inst_X, imm_sel, imm_out);
    Branch_Comparator Branch_Comparator (rs1_X, rs2_X, br_un, br_eq, br_lt);
    //mux3 amux (asel, rs1_X, pc_X, alu_W, amux_out);
    mux2 amux (asel, rs1_X, pc_X, amux_out);
    mux2 bmux (bsel, rs2_X, imm_out, bmux_out);
    ALU ALU (amux_out, bmux_out, alu_sel, alu_X);

            // latches
    latch pc_W_latch (clk, pcX, pc_W);
    latch alu_W_latch (clk, alu_X, alu_W);
    latch rs2_W_latch (clk, rs2_X, rs2_W);
    latch inst_W_latch (clk, inst_X, inst_W);
    

    // WRITE BACK -----------------------------------------------------------
    plus4 W_plus4 (pc_W, pc_W_plus4);
    DMEM DMEM (clk, alu_W, rs2_W, dmem_sel, w_sel, r_sel, dmem_out);
    mux3 wbmux (wb_sel, dmem_out, alu_W, pc_W_plus4, wb_out);



    Control_Unit CU (inst_F, br_eq, br_lt, pc_F_sel, imm_sel, regWEn, br_un, asel, bsel, alu_sel, dmem_sel, r_sel, w_sel, wb_sel);
                
endmodule
module Control_F (clk, X_ctrl, pc_F_sel);         // X_ctrl signal is used by Control_X to send command to Control_F

    input clk;
    input X_ctrl;
    output reg pc_F_sel;

    initial pc_F_sel = 0;

    always@ (posedge clk) begin
        pc_F_sel <= 0;        // temporarily skip branch commands
    end

endmodule
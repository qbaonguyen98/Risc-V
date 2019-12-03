module Control_F (X_ctrl, pc_F_sel);         // X_ctrl signal is used by Control_X to send command to Control_F

    input X_ctrl;
    output reg pc_F_sel;

    initial pc_F_sel = 0;

    always@ (*) begin
        // if (X_ctrl == 1) begin
        //     pc_F_sel <= 1;      // use alu for new pc
        // end
        // else begin
        //     pc_F_sel <= 0;      // use pc + 4
        // end
        pc_F_sel <= X_ctrl;
    end

endmodule
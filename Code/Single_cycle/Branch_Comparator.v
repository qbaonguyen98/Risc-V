module Branch_Comparator(rs1_out, rs2_out, cmpop, br_eq, br_lt);
    input [31:0] rs1_out, rs2_out;
    input cmpop;        // dieu khien bo so sanh: unsigned (0), signed (1)

    output reg br_eq;       // 0: DataA # DataB 
    output reg br_lt;       // 0: DataA >= DataB

    always@ (*) begin
        if (rs1_out[31] != rs2_out[31] && cmpop == 1'b1) begin    // co dau --> chi can so sanh TH khac nhau
            br_eq <= 1'b0;
            if (rs1_out[31] == 1)   // dataA < 0
                br_lt <= 1'b1;      
            else
                br_lt <= 1'b0;
        end
        else begin      // k dau hoac co dau va = nhau
            if(rs1_out == rs2_out)
                br_eq <= 1'b1;
		    else 
                br_eq <= 1'b0; 
            if(rs1_out < rs2_out) 
                br_lt <= 1'b1;
		    else 
                br_lt <= 1'b0;
        end
    end
endmodule
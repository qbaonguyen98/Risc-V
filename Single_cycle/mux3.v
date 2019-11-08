module mux3(sel, in1, in2, in3, out);

    input [1:0] sel;
    input [31:0] in1;
    input [31:0] in2;
    input [31:0] in3;


    output [31:0] out;

    assign out = (sel == 0)? in1 : (sel == 1)? in2 : (sel == 2)? in3 : 0;

endmodule 

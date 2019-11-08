module mux2(sel, in1, in2, out);

    input  sel;
    input [31:0] in1;
    input [31:0] in2;

    output [31:0] out;

    assign out = sel ? in2 : in1;

endmodule 
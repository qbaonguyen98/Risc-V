module ALU(alumux1_out, alumux2_out, aluop, aluout);
    input [31:0] alumux1_out, alumux2_out;
    input [3:0] aluop;

    output reg [31:0] aluout;
    
    always @(aluop or alumux1_out or alumux2_out) begin
        case (aluop):
            0:  // ADD
                aluout <= alumux1_out + alumux2_out;
            1:  // SUB
                aluout <= alumux1_out - alumux2_out;
            2:  // AND
                aluout <= alumux1_out & alumux2_out;
            3:  // OR
                aluout <= alumux1_out | alumux2_out;
            4:  // XOR
                aluout <= alumux1_out ^ alumux2_out;
            5:  // SLL: shift left logic
                
            6:  // SRL: shift right logic

            7:  // SRA: shift right arithmetic

            8:  // SLT: signed comparation

            9:  // SLTU: unsigned comparation 
    end
endmodule
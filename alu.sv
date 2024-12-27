module alu 
(
    input  logic [ 3:0] aluop,
    input  logic [31:0] opr_a,
    input  logic [31:0] opr_b,
    output logic [31:0] opr_res
);
    
    always_comb
    begin
        case(aluop)
            4'b0000: opr_res = opr_a            +  opr_b;
            4'b0001: opr_res = opr_a            -  opr_b;
            4'b0010: opr_res = opr_a            << opr_b;
            4'b0011: opr_res = opr_a            <  opr_b;
            4'b0100: opr_res = $unsigned(opr_a) <  $unsigned(opr_b);
            4'b0101: opr_res = opr_a            ^  opr_b;
            4'b0110: opr_res = opr_a            >> opr_b;
            // 4'b0111: opr_res = opr_a + opr_b; // SRA to be discussed
            4'b1000: opr_res = opr_a            | opr_b;
            4'b1001: opr_res = opr_a            & opr_b;
            4'b1010: opr_res = opr_b; // pass opr_b
        endcase
    end

endmodule
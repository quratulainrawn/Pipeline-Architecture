module br_cond
(
    input  logic [31:0] rdata1,
    input  logic [31:0] rdata2,
    input  logic [ 2:0] br_type,
    output logic        br_taken
);

    always_comb
    begin
        case (br_type)
            3'b000:  br_taken = $signed  (rdata1) == $signed(rdata2)   ? 1 : 0; // BEQ
            3'b001:  br_taken = $signed  (rdata1) != $signed(rdata2)   ? 1 : 0; // BNE
            3'b100:  br_taken = $signed  (rdata1) <  $signed(rdata2)   ? 1 : 0; // BLT
            3'b101:  br_taken = $signed  (rdata1) >= $signed(rdata2)   ? 1 : 0; // BGE
            3'b110:  br_taken = $unsigned(rdata1) <  $unsigned(rdata2) ? 1 : 0; // BLTU
            3'b111:  br_taken = $unsigned(rdata1) >= $unsigned(rdata2) ? 1 : 0; // BGEU
            default: br_taken = 0;
        endcase
    end

endmodule
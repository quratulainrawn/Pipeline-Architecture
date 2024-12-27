module mux_2x1
(
    input  logic [31:0] in_0,
    input  logic [31:0] in_1,
    input  logic        select_line,
    output logic [31:0] out
);

    always_comb
    begin
        case (select_line)
            1: out = in_1;
            0: out = in_0;
            default: out = in_0;
        endcase
    end

endmodule

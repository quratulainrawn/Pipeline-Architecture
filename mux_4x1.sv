module mux_4x1
(
    input  logic [31:0] in_0,
    input  logic [31:0] in_1,
    input  logic [31:0] in_2,
    input  logic [31:0] in_3,
    input  logic [ 1:0] select_line,
    output logic [31:0] out
);

    always_comb
    begin
        case (select_line)
            2'b00: out = in_0;
            2'b01: out = in_1;
            2'b10: out = in_2;
            2'b11: out = in_3;
        endcase
    end

endmodule

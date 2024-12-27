module data_mem
(
    input  logic        clk,
    input  logic        rd_en,
    input  logic        wr_en,
    input  logic [31:0] addr,
    input  logic [ 2:0] mem_acc_mode,
    input  logic [31:0] rdata2,
    output logic [31:0] rdata
);
    parameter BYTE              = 3'b000;
    parameter HALFWORD          = 3'b001;
    parameter WORD              = 3'b010;
    parameter BYTE_UNSIGNED     = 3'b011;
    parameter HALFWORD_UNSIGNED = 3'b100;

    logic [7:0] data_mem [100];

    // Here I'm using big-endian byte ordering in which MSB is stored at lower address and LSB at higher address

    // asynchronous read
    always_comb
    begin
        if (rd_en)
        begin
            case (mem_acc_mode)
            BYTE:
                rdata = $signed (data_mem[addr]) ;
            HALFWORD:
                rdata = $signed({data_mem[addr], data_mem[addr+1]});
            WORD:
                rdata = $signed({data_mem[addr], data_mem[addr+1], data_mem[addr+2], data_mem[addr+3]});
            BYTE_UNSIGNED:
                rdata = {24'b0, {data_mem[addr]}};
            HALFWORD_UNSIGNED:
                rdata = {16'b0, {data_mem[addr]}, {data_mem[addr+1]}};
            endcase
        end
    end

    //synchronous write
    always_ff @(posedge clk)
    begin
        if (wr_en)
        begin
            case (mem_acc_mode)
            BYTE:
                data_mem[addr] <= rdata2[7:0];
            HALFWORD:
                begin
                    data_mem[addr  ] <= rdata2[15:8];
                    data_mem[addr+1] <= rdata2[ 7:0];
                end
            WORD:
                begin
                    data_mem[addr  ] <= rdata2[31:24];
                    data_mem[addr+1] <= rdata2[23:16];
                    data_mem[addr+2] <= rdata2[15: 8];
                    data_mem[addr+3] <= rdata2[ 7: 0];
                end
            endcase
        end
    end

endmodule
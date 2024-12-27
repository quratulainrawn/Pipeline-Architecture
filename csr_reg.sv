module csr_reg
(
    input  logic         clk,
    input  logic         rst,
    input  logic [31: 0] addr,
    input  logic [31: 0] wdata,   // data from rs1
    input  logic [31: 0] pc,
    input  logic         trap,    // interrupt or exception
    input  logic         csr_rd,  // control signal for read
    input  logic         csr_wr,  // control signal for write
    input  logic         is_mret, // control signal for MRET inst
    input  logic [31: 0] inst,
    output logic [31: 0] rdata,
    output logic [31: 0] epc,
    output logic         epc_taken // it's a flag which is fed to the mux right before PC
);
    // logic [31: 0] mstatus;
    // logic [31: 0] mie;
    // logic [31: 0] mepc;
    // logic [31: 0] mip;

    logic [31: 0] csr_mem [6];
    logic         is_device_int_en;
    logic         is_global_int_en;


    always_comb
    begin
        if (csr_rd)
        begin
            case (inst[31:20])
                12'h300: rdata = csr_mem[0]; // mstatus 
                12'h304: rdata = csr_mem[1]; // mie 
                12'h305: rdata = csr_mem[2]; // mtvec 
                12'h341: rdata = csr_mem[3]; // mepc 
                12'h342: rdata = csr_mem[4]; // mcause 
                12'h344: rdata = csr_mem[5]; // mip 
            endcase
        end
        else
        begin
            rdata = 32'b0; 
        end
    end


    always_ff @(posedge clk)
    begin
        if (rst)
        begin
            csr_mem[0] <= 32'b0;
            csr_mem[1] <= 32'b0;
            csr_mem[2] <= 32'b0;
            csr_mem[3] <= 32'b0;
            csr_mem[4] <= 32'b0;
            csr_mem[5] <= 32'b0;
        end
        else if (csr_wr)
        begin
            case (inst[31:20])
                12'h300: csr_mem[0] <= wdata; // mstatus
                12'h304: csr_mem[1] <= wdata; // mie
                12'h305: csr_mem[2] <= wdata; // mtvec
                12'h341: csr_mem[3] <= wdata; // mepc
                12'h342: csr_mem[4] <= wdata; // mcause
                12'h344: csr_mem[5] <= wdata; // mip
            endcase
        end


        if (trap)
        begin
            csr_mem[4]       <= 32'b0;                              // since only timer interrupt is being handled so there's always going to be the one cause of interrupt 
            csr_mem[5]       <= csr_mem[5] | 32'd128;               // registering the timer interrupt at the 7th index bit of mip (see page 38 of riscv-privileged-v1.10 manual)
            is_device_int_en = csr_mem[5][7] & csr_mem[1][7];
            is_global_int_en = csr_mem[0][3] & is_device_int_en;    // 3rd index bit of mstatus register is MIE (see page 30 of riscv-privileged-v1.10 manual)
            if (is_global_int_en)
            begin
                csr_mem[3] = pc;                                    // saves the value of PC to mepc register
                epc        <= csr_mem[2] + (csr_mem[4] << 2); // mtvec + (mcause << 2) 
                epc_taken  <= 1'b1;
            end
        end
        else if (is_mret)
        begin
            epc_taken <= 1'b1;
            epc       <= csr_mem[3]; // reading the value of 'mepc' register
        end
        else
        begin
            epc_taken <= 1'b0;
            epc <= pc;
        end
    end

endmodule
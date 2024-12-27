module tb_processor();

    logic clk;
    logic rst;
    logic timer_interrupt;

    processor dut 
    (
        .clk             ( clk             ),
        .rst             ( rst             ),
        .timer_interrupt ( timer_interrupt )
    );

    timer timer_i
    (
        .clk( clk ),
        .rst( rst ),
        .timer_interrupt ( timer_interrupt )
    );

    // clock generator
    initial 
    begin
        clk = 0;
        forever 
        begin
            #5 clk = ~clk;
        end
    end

    // reset generator
    initial
    begin
        rst = 1;
        #10;
        rst = 0;
        #1000;
        $finish;
    end

    // initialize memory
    initial
    begin
        $readmemb("inst.mem", dut.inst_mem_i.mem);
        $readmemb("rf.mem", dut.reg_file_i.reg_mem);
        $readmemb("dm.mem", dut.data_mem_i.data_mem);
        $readmemb("csr_reg.mem", dut.csr_reg_i.csr_mem);
    end

    // dumping the waveform
    initial
    begin
        $dumpfile("processor.vcd");
        $dumpvars(0, dut);
    end

    final
    begin
        $writememh("rf_out.mem", dut.reg_file_i.reg_mem);
        $writememh("dm_out.mem", dut.data_mem_i.data_mem);
        $writememh("csr_reg_out.mem", dut.csr_reg_i.csr_mem);
    end

endmodule
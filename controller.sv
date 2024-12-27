module controller
(
    input  logic [6:0] opcode,
    input  logic [2:0] funct3,
    input  logic [6:0] funct7,
    input  logic       br_taken, // form br_cond block
    output logic [3:0] aluop,
    output logic       rf_en,    // control signal for write operation in register file
    output logic       sel_a,    // control signal to opr_a select MUX to ALU
    output logic       sel_b,    // control signal to opr_b select MUX to ALU
    output logic       rd_en,    // control signal for reading from data memory
    output logic       wr_en,    // control signal for writing into data memory
    output logic [1:0] wb_sel,   // control signal for writeback MUX
    output logic [2:0] mem_acc_mode,
    output logic [2:0] br_type,  // goes to branch cond block to tell which comparison to perform
    output logic       br_take,  // to program counter MUX
    output logic       csr_rd,   // control signal to read from CSR register file
    output logic       csr_wr,   // control signal to write to CSR register
    output logic       is_mret   // control signal for 'mret' instruction --- 1 will indicate that the inst is mret
);
    always_comb
    begin
        case(opcode)
            7'b0110011: //R-Type
            begin
                rf_en        = 1'b1;
                sel_a        = 1'b1;
                sel_b        = 1'b0;
                rd_en        = 1'b0;
                wb_sel       = 2'b01;
                wr_en        = 1'b0;
                br_take      = 1'b0;
                mem_acc_mode = 3'b111;
                br_type      = 3'b011;
                csr_rd       = 1'b0;
                csr_wr       = 1'b0;
                is_mret      = 1'b0;
                case(funct3)
                    3'b000: 
                    begin
                        case(funct7)
                            7'b0000000: aluop = 4'b0000; //ADD
                            7'b0100000: aluop = 4'b0001; //SUB
                        endcase
                    end
                    3'b001: aluop = 4'b0010; //SLL
                    3'b010: aluop = 4'b0011; //SLT
                    3'b011: aluop = 4'b0100; //SLTU
                    3'b100: aluop = 4'b0101; //XOR
                    3'b101:
                    begin
                        case(funct7)
                            7'b0000000: aluop = 4'b0110; //SRL
                            7'b0100000: aluop = 4'b0111; //SRA
                        endcase
                    end
                    3'b110: aluop = 4'b1000; //OR
                    3'b111: aluop = 4'b1001; //AND
                endcase
            end
            7'b0010011: // I-type - Data processing
            begin
                rf_en        = 1'b1;
                sel_a        = 1'b1;
                sel_b        = 1'b1;
                rd_en        = 1'b0;
                wb_sel       = 2'b01;
                wr_en        = 1'b0;
                br_take      = 1'b0;
                mem_acc_mode = 3'b111;
                br_type      = 3'b011;
                csr_rd       = 1'b0;
                csr_wr       = 1'b0;
                is_mret      = 1'b0;
                case (funct3)
                    3'b000: aluop = 4'b0000; //ADDI
                    3'b010: aluop = 4'b0011; //SLTI
                    3'b011: aluop = 4'b0100; //SLTIU
                    3'b100: aluop = 4'b0101; //XORI
                    3'b110: aluop = 4'b1000; //ORI
                    3'b111: aluop = 4'b1001; //ANDI
                    3'b001: aluop = 4'b0010; //SLLI
                    3'b101:
                    begin
                        case (funct7)
                            7'b0000000: aluop = 4'b0110; //SRLI
                            7'b0100000: aluop = 4'b0111; //SRAI
                        endcase
                    end
                endcase
            end
            7'b0000011: // I-type - Load Instructions
            begin
                rf_en     = 1'b1;
                sel_a     = 1'b1;
                sel_b     = 1'b1;
                rd_en     = 1'b1;
                wb_sel    = 2'b10;
                wr_en     = 1'b0;
                br_take   = 1'b0;
                aluop     = 4'b0000; // aluop is always addition in case of load instructions
                br_type   = 3'b011;
                csr_rd    = 1'b0;
                csr_wr    = 1'b0;
                is_mret   = 1'b0;
                case(funct3)
                    3'b000: mem_acc_mode = 3'b000; // Byte access
                    3'b001: mem_acc_mode = 3'b001; // Halfword access
                    3'b010: mem_acc_mode = 3'b010; // Word access
                    3'b100: mem_acc_mode = 3'b011; // Byte unsigned access
                    3'b101: mem_acc_mode = 3'b100; // Halfword unsigned access
                endcase
            end
            7'b0100011: // S-type - Store Instructions
            begin
                rf_en     = 1'b0;
                sel_a     = 1'b1;
                sel_b     = 1'b1;
                rd_en     = 1'b0;
                wb_sel    = 2'b01;  // in this case it is don't care because rf_en = 1'b0
                wr_en     = 1'b1;
                br_take   = 1'b0;
                aluop     = 4'b0000; // aluop is always addition in case of store instructions
                br_type   = 3'b011;
                csr_rd    = 1'b0;
                csr_wr    = 1'b0;
                is_mret   = 1'b0;
                case(funct3)
                    3'b000: mem_acc_mode = 3'b000; // Byte access
                    3'b001: mem_acc_mode = 3'b001; // Halfword access
                    3'b010: mem_acc_mode = 3'b010; // Word access
                endcase
            end
            7'b1100011: // B-type
            begin
                rf_en     = 1'b0;
                sel_a     = 1'b0;
                sel_b     = 1'b1;
                rd_en     = 1'b0;
                wb_sel    = 2'b01; // in this case it is don't care because rf_en = 1'b0
                wr_en     = 1'b0;
                aluop     = 4'b0000; // aluop is always addition in case of branch instructions
                br_type   = funct3;
                br_take   = br_taken;
                csr_rd    = 1'b0;
                csr_wr    = 1'b0;
                is_mret   = 1'b0;
            end
            7'b0110111: // U-type (LUI)
            begin
                rf_en     = 1'b1;
                sel_a     = 1'b0; //it's actually don't care bcz we don't need opr_a
                sel_b     = 1'b1;
                rd_en     = 1'b0;
                wb_sel    = 2'b01;
                wr_en     = 1'b0;
                aluop     = 4'b1010;
                br_type   = 3'b011;
                br_take   = 1'b0;
                csr_rd    = 1'b0;
                csr_wr    = 1'b0;
                is_mret   = 1'b0;
            end
            7'b0010111: // U-type (AUIPC)
            begin
                rf_en     = 1'b1;
                sel_a     = 1'b0;
                sel_b     = 1'b1;
                rd_en     = 1'b0;
                wb_sel    = 2'b01;
                wr_en     = 1'b0;
                aluop     = 4'b0000; // ADD
                br_type   = 3'b011;
                br_take   = 1'b0;
                csr_rd    = 1'b0;
                csr_wr    = 1'b0;
                is_mret   = 1'b0;
            end
            7'b1101111: // J-type (JAL)
            begin
                rf_en     = 1'b1;
                sel_a     = 1'b0;
                sel_b     = 1'b1;
                rd_en     = 1'b0;
                wb_sel    = 2'b00;
                wr_en     = 1'b0;
                aluop     = 4'b0000; // ADD
                br_type   = 3'b011;
                br_take   = 1'b1;
                csr_rd    = 1'b0;
                csr_wr    = 1'b0;
                is_mret   = 1'b0;
            end
            7'b1100111: // JALR
            begin
                rf_en     = 1'b1;
                sel_a     = 1'b1;
                sel_b     = 1'b1;
                rd_en     = 1'b0;
                wb_sel    = 2'b00;
                wr_en     = 1'b0;
                aluop     = 4'b0000;
                br_type   = 3'b011;
                br_take   = 1'b1;
                csr_rd    = 1'b0;
                csr_wr    = 1'b0;
                is_mret   = 1'b0;
            end
            7'b1110011: // CSRRW
            begin
                case (funct3)
                3'b000: // MRET
                    begin
                        rf_en        = 1'b0;
                        sel_a        = 1'b1;
                        sel_b        = 1'b0;
                        rd_en        = 1'b0;
                        wb_sel       = 2'b01;
                        wr_en        = 1'b0;
                        br_take      = 1'b0;
                        mem_acc_mode = 3'b111;
                        br_type      = 3'b011;
                        csr_rd       = 1'b0;
                        csr_wr       = 1'b0;
                        is_mret      = 1'b1;
                    end

                default:
                    begin
                        rf_en        = 1'b1;
                        sel_a        = 1'b1;
                        sel_b        = 1'b0;
                        rd_en        = 1'b0;
                        wb_sel       = 2'b11;
                        wr_en        = 1'b0;
                        br_take      = 1'b0;
                        mem_acc_mode = 3'b111;
                        br_type      = 3'b011;
                        csr_rd       = 1'b1;
                        csr_wr       = 1'b1;
                        is_mret      = 1'b0;
                    end
                endcase
            end
            default:
            begin
                rf_en        = 1'b0;
                sel_a        = 1'b1;
                sel_b        = 1'b0;
                rd_en        = 1'b0;
                wb_sel       = 2'b01;
                wr_en        = 1'b0;
                br_take      = 1'b0;
                mem_acc_mode = 3'b111;
                br_type      = 3'b011;
                csr_rd       = 1'b0;
                csr_wr       = 1'b0;
                is_mret      = 1'b0;
            end
        endcase
    end

endmodule
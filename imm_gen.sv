module imm_gen
(
    input  logic [31:0] inst,
    output logic [31:0] imm_val
);

    always_comb
    begin
        case (inst[6:0])
            7'b0010011: // I-type
                case(inst[14:12])
                3'b011: imm_val = {20'b0,inst[31:20]}; // SLTIU (SetLessThanImmUnsigned) doing zero-extension since the operation is for unsigned immediate
                3'b101: imm_val = $signed(inst[24:20]);
                default:
                begin
                    imm_val = $signed(inst[31:20]);
                end
                endcase
            
            7'b0100011: // S-type
                imm_val = $signed({inst[31:25], inst[11:7]});
            7'b1100011: // B-type
                imm_val = $signed({inst[31], inst[7], inst[30:25], inst[11:8], 1'b0});
            7'b0110111: // U-type
                imm_val = {inst[31:12],12'b0};
            7'b1101111: // J-type (JAL)
                imm_val = $signed({inst[31], inst[19:12], inst[20], inst[30:21], 1'b0});
            7'b1100111: // I-type (JALR)
                imm_val = $signed(inst[31:20]);
            7'b0000011: // Load Instruction
                imm_val = {20'b0, inst[31:20]};
        endcase
    end

endmodule

// This module is dataMemory which provides

module tt_um_himanshu5_prog_computeUnit ( input clk, 
                    input rstn, 
                    input [15:0] instruction, 
                    input en, 
                    output reg [7:0] data,
                    output reg data_valid,
                    output reg [3:0] reg_id);

    reg [15:0] physicalRegister [7:0];
    // register ID----------
    wire [3:0] src_reg0_id;
    wire [3:0] src_reg1_id;
    wire [3:0] tgt_reg_id;
    //----------------------
    // register data--------
    wire [7:0] src_reg0_data;
    wire [7:0] src_reg1_data;
    wire [7:0] tgt_reg_data;
    //-----------------------
    wire tgt_data_valid;
    
    wire load_data[7:0];

    assign src_reg0_id = instruction[7:4];
    assign src_reg1_id = instruction[3:0];
    assign tgt_reg_id  =  instruction[11:8];
    assign load_data   =   instruction[7:0];

    integer i;
    always@(posedge clk)
        if (!rstn) begin
            data_out <= 0;
            data_valid <= 0;
            reg_id <= 0;

            for (i = 0; i< 15; i= i + 1) begin
                physicalRegister[i] <= 0;
            end 
            
        end else if (en) begin
            case (instruction[15:12])
                4'b0000: // No-Op
                    begin
                        tgt_data_valid = 0;
                        tgt_reg_data = 0;
                    end
                4'b0001: // Load
                // Load the data into tgt register
                    begin
                        physicalRegister[tgt_reg_id] = load_data;
                        tgt_data_valid = 1'b1;
                    end
                4'b0010: // ADD
                    begin
                        physicalRegister[tgt_reg_id] <= physicalRegister[src_reg0_id] + physicalRegister[src_reg1_id];
                        tgt_data_valid = 1'b1;
                    end
                4'b0011: // subtract
                    begin
                        physicalRegister[tgt_reg_id] <= physicalRegister[src_reg0_id] - physicalRegister[src_reg1_id];
                        tgt_data_valid = 1'b1;
                    end
                4'b0100: // AND
                    begin
                        physicalRegister[tgt_reg_id] <= physicalRegister[src_reg0_id] & physicalRegister[src_reg1_id];
                        tgt_data_valid = 1'b1;
                    end
                4'b0101: // OR
                    begin
                        physicalRegister[tgt_reg_id] <= physicalRegister[src_reg0_id] | physicalRegister[src_reg1_id];
                        tgt_data_valid = 1'b1;
                    end
                4'b0110: // NOT
                    begin
                        physicalRegister[tgt_reg_id] <= !physicalRegister[src_reg0_id];
                        tgt_data_valid = 1'b1;
                    end
                4'b0111: // Xor
                    begin
                        physicalRegister[tgt_reg_id] <= physicalRegister[src_reg0_id] ^ physicalRegister[src_reg1_id];
                        tgt_data_valid = 1'b1;
                    end
                default:
                    begin
                        tgt_data_valid = 0;
                        tgt_reg_data = 0;
                    end
                data_valid <= tgt_data_valid;
                data <= physicalRegister[tgt_reg_id];
                reg_id <= tgt_reg_id;
            endcase
        end
   
endmodule
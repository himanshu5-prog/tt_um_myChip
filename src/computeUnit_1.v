module tt_um_himanshu5_prog_computeUnit ( input clk, 
                    input rst_n, 
                    //input [15:0] instruction, 
                    input ena,
                    //output reg [7:0] data,
                    //output reg [3:0] reg_id,
                    input  wire [7:0] ui_in,    // Dedicated inputs - connected to the input switches
                    output reg [7:0] uo_out,   // Dedicated outputs - connected to the 7 segment display
                    input  wire [7:0] uio_in,   // IOs: Bidirectional Input path
                    output wire [7:0] uio_out,  // IOs: Bidirectional Output path
                    output wire [7:0] uio_oe   // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
    );

    reg [7:0] physicalRegister [15:0];
    reg [15:0] instruction;

    
    // register ID----------
    reg [3:0] src_reg0_id;
    reg [3:0] src_reg1_id;
    reg [3:0] tgt_reg_id;
    //----------------------
    // register data--------
    reg [7:0] tgt_reg_data;
    //-----------------------
    
    reg [7:0] load_data;
    assign uio_oe = 8'b00000000;
    assign uio_out = 8'b00000000;
    initial
        begin 
            instruction = {ui_in, uio_in};
            src_reg0_id = instruction[7:4];
            src_reg1_id = instruction[3:0];
            tgt_reg_id  =  instruction[11:8];
            load_data   =   instruction[7:0];
        end

    integer i;
    always@(posedge clk) begin
        if (!rst_n) begin
            //data <= 0;
            uo_out <= 0;
            //reg_id <= 0;

            for (i = 0; i< 15; i= i + 1) begin
                physicalRegister[i] <= 0;
            end 
            
        end else if (ena) begin
            case (instruction[15:12])
                4'b0000: // No-Op
                    begin
                        tgt_reg_data <= 0;
                    end
                4'b0001: // Load
                // Load the data into tgt register
                    begin
                        physicalRegister[tgt_reg_id] <= load_data;
                        tgt_reg_data <= load_data;
                    end
                4'b0010: // ADD
                    begin
                        tgt_reg_data <= physicalRegister[src_reg0_id] + physicalRegister[src_reg1_id];
                        physicalRegister[tgt_reg_id] <= physicalRegister[src_reg0_id] + physicalRegister[src_reg1_id];

                    end
                4'b0011: // subtract
                    begin
                        physicalRegister[tgt_reg_id] <= physicalRegister[src_reg0_id] - physicalRegister[src_reg1_id];
                        tgt_reg_data <= physicalRegister[src_reg0_id] - physicalRegister[src_reg1_id];
                    end
                4'b0100: // AND
                    begin
                        physicalRegister[tgt_reg_id] <= physicalRegister[src_reg0_id] & physicalRegister[src_reg1_id];
                        tgt_reg_data <= physicalRegister[src_reg0_id] & physicalRegister[src_reg1_id];
                    end
                4'b0101: // OR
                    begin
                        physicalRegister[tgt_reg_id] <= physicalRegister[src_reg0_id] | physicalRegister[src_reg1_id];
                        tgt_reg_data <= physicalRegister[src_reg0_id] | physicalRegister[src_reg1_id];
                    end
                4'b0110: // NOT
                    begin
                        physicalRegister[tgt_reg_id][0] <= !physicalRegister[src_reg0_id][0];
                        physicalRegister[tgt_reg_id][1] <= !physicalRegister[src_reg0_id][1];
                        physicalRegister[tgt_reg_id][2] <= !physicalRegister[src_reg0_id][2];
                        physicalRegister[tgt_reg_id][3] <= !physicalRegister[src_reg0_id][3];
                        physicalRegister[tgt_reg_id][4] <= !physicalRegister[src_reg0_id][4];
                        physicalRegister[tgt_reg_id][5] <= !physicalRegister[src_reg0_id][5];
                        physicalRegister[tgt_reg_id][6] <= !physicalRegister[src_reg0_id][6];
                        physicalRegister[tgt_reg_id][7] <= !physicalRegister[src_reg0_id][7];
                        
                        tgt_reg_data[0] <= physicalRegister[tgt_reg_id][0];
                        tgt_reg_data[1] <= physicalRegister[tgt_reg_id][1];
                        tgt_reg_data[2] <= physicalRegister[tgt_reg_id][2];
                        tgt_reg_data[3] <= physicalRegister[tgt_reg_id][3];
                        tgt_reg_data[4] <= physicalRegister[tgt_reg_id][4];
                        tgt_reg_data[5] <= physicalRegister[tgt_reg_id][5];
                        tgt_reg_data[6] <= physicalRegister[tgt_reg_id][6];
                        tgt_reg_data[7] <= physicalRegister[tgt_reg_id][7];
                    end
                4'b0111: // Xor
                    begin
                        physicalRegister[tgt_reg_id] <= physicalRegister[src_reg0_id] ^ physicalRegister[src_reg1_id];
                        tgt_reg_data <= physicalRegister[src_reg0_id] ^ physicalRegister[src_reg1_id];
                    end
                default:
                    begin
                        tgt_reg_data <= 0;
                    end
            endcase
            
            //data <= physicalRegister[tgt_reg_id];
            uo_out <= tgt_reg_data;
            //reg_id <= tgt_reg_id;
        end
    end
   
endmodule
// This module is dataMemory which provides

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

    reg [15:0] physicalRegister [15:0];
    wire [15:0] instruction;

    
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
    
    wire [7:0] load_data;
    assign uio_oe = 8'b00000000;
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
                        tgt_reg_data = 0;
                    end
                4'b0001: // Load
                // Load the data into tgt register
                    begin
                        physicalRegister[tgt_reg_id] = load_data;
                    end
                4'b0010: // ADD
                    begin
                        physicalRegister[tgt_reg_id] <= physicalRegister[src_reg0_id] + physicalRegister[src_reg1_id];
                    end
                4'b0011: // subtract
                    begin
                        physicalRegister[tgt_reg_id] <= physicalRegister[src_reg0_id] - physicalRegister[src_reg1_id];
                    end
                4'b0100: // AND
                    begin
                        physicalRegister[tgt_reg_id] <= physicalRegister[src_reg0_id] & physicalRegister[src_reg1_id];
                    end
                4'b0101: // OR
                    begin
                        physicalRegister[tgt_reg_id] <= physicalRegister[src_reg0_id] | physicalRegister[src_reg1_id];
                    end
                4'b0110: // NOT
                    begin
                        physicalRegister[tgt_reg_id] <= !physicalRegister[src_reg0_id];
                    end
                4'b0111: // Xor
                    begin
                        physicalRegister[tgt_reg_id] <= physicalRegister[src_reg0_id] ^ physicalRegister[src_reg1_id];
                    end
                default:
                    begin
                        tgt_reg_data = 0;
                    end
            endcase
            
            //data <= physicalRegister[tgt_reg_id];
            uo_out <= physicalRegister[tgt_reg_id];
            //reg_id <= tgt_reg_id;
        end
    end
   
endmodule
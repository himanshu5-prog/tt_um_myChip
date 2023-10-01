module test();
  reg clk;
  reg rst_n;
  reg ena;
  reg [7:0] ui_in;
  reg [7:0] uio_in;
  
  wire [7:0] uo_out;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;
  
  computeUnit_0 dut (
    .clk(clk),
    .rst_n (rst_n),
    .ena (ena),
    .ui_in(ui_in),
    .uio_in (uio_in),
    .uo_out (uo_out),
    .uio_out(uio_out),
    .uio_oe(uio_oe)
     );
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(1);
  end
  
  initial
    begin
      clk = 0;
      
      forever
        begin
          #5 clk = ~clk;
        end
    end
  
  initial begin
    #200 $finish;
  end
  
  initial
  	begin
      $monitor ("time: %3d, rst_n: %b, ena: %b, ui_in: %b, uio_in: %b, uo_out: %b", $time, rst_n, ena, ui_in, uio_in, uo_out);
      $display ("In reset mode");
  		rst_n = 0;
      	ena = 0;
      	uio_in = 8'b0000_0000;
      	ui_in  = 8'b0000_0000;
      $display ("functional mode");     
      	#12
      	rst_n = 1;
      	ena = 1;
      // load reg[0] <= 8'b0100_1000
      	ui_in = 8'b1001_0000;
        uio_in = 8'b0100_1000;
      
      	#11
      // load reg[1] <= 8'b1000_0001
      	ui_in = 8'b1001_0001;
        uio_in = 8'b1000_0001;
      
      #14
      // reg[2] <= reg[0] + reg[1]
      
      	ui_in = 8'b1010_0010;
        uio_in = 8'b0000_0001;
      
      	
  	end
  
endmodule
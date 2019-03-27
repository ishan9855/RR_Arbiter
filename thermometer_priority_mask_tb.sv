module tb();

	logic	rst;
  	logic	clk;
  logic	[3: 0]	req;
  logic	[3: 0]	mask_req;

  
 

  thermometer_priority_mask #(4) dut (
  .clk	(clk),
  .rst	(rst),
  .req	(req),
  .mask_req	(mask_req));
  
initial 
	begin
      $monitor("Value of grant is %b\n", mask_req);
      $dumpfile("dump.vcd");
      $dumpvars(0, tb);
    end

initial
begin
	clk = 0;
	req	=	4'b000;
	rst = 1'b1;
	#10 rst = 0;
	#10 rst = 1;
	repeat (1) @ (posedge clk);
	req <= 4'b0001;
	repeat (1) @ (posedge clk);
	req <= 4'b0010;
	repeat (1) @ (posedge clk);
	req <= 4'b0100;
	repeat (1) @ (posedge clk);
	req <= 4'b1000;
	repeat (1) @ (posedge clk);
	req <= 4'b1100;
	repeat (1) @ (posedge clk);
	req <= 4'b1110;
	repeat (1) @ (posedge clk);
	req <= 4'b1111;
	repeat (1) @ (posedge clk);
	#10  $finish;

end

always	#1 clk = ~clk;
endmodule

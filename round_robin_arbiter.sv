module round_robin_arbiter #(
  parameter request_lines = 4)
  (
    rst,
    clk,
    req,
    grant);
  
  input	logic	clk;
  input	logic	rst;
  input	logic	[request_lines - 1: 0 ] req;
  output logic	[request_lines - 1: 0] grant;
  
  
  logic	[request_lines - 1: 0]	normal_grant;
  logic	[request_lines - 1: 0]	masked_grant_previous;
  logic	[request_lines  - 1: 0]  masked_requests;
  logic	[request_lines - 1: 0]	masked_grant;
  
  priority_arbiter #(.request_lines(request_lines))
  (	.rst		(rst),
   .clk			(clk),
   .req			(req),
   .grant		(normal_grant));

  
  thermometer_priority_mask #(.request_lines (request_lines))
  (
    .rst		(rst),
    .clk		(clk),
    .req		(grant),
    .mask_req	(masked_grant_previous));
  
  assign masked_requests = req & normal_grant;
  
  
  priority_arbiter	#(.request_lines(request_lines))
  (.rst		(rst),
   .clk		(clk),
   .req		(masked_requests),
   .grant	(masked_grant));
  
  
  always @(posedge clk or negedge rst) begin
    if(!rst) grant <= '0;
    else
      grant <= (masked_grant == {request_lines{1'b0}}) ? normal_grant : masked_grant;
  end
  
  
  
endmodule


module priority_arbiter #(
  parameter request_lines = 4)
  (
	rst,
    clk,
    req,
	grant
);

input	logic								clk;
input	logic								rst;
input  logic 	[request_lines -1 : 0]		req;
output logic	[request_lines - 1 : 0]		grant;

  
  /*always @(posedge clk or negedge rst)
    	begin
          if(!rst) 
            	grant <= '0;
           else
             	grant <= req & -req;
        end
  */
  
  assign grant = ~rst ? '0 : req & ~req;
  
endmodule
  
module thermometer_priority_mask #(
  parameter request_lines = 4)
  (
	rst,
    clk,
    req,
	mask_req
);

input	logic								clk;
input	logic								rst;
input  logic 	[request_lines -1 : 0]		req;
output logic	[request_lines - 1 : 0]		mask_req;

  logic	[request_lines - 1 : 0]	mask;
  
  always @(*) begin
    mask = req ^ (req - 1);
    mask = (req == {request_lines{1'b0}}) ? mask : ~mask;
    mask = mask | req;
  end
 
  
  assign mask_req = !rst ? '0 : mask;
  
  /*
  always @(posedge clk or negedge rst)
    	begin
          if(!rst) 
            	mask_req <= '0;
           else
             	mask_req <= mask;
        end
  */
  
endmodule

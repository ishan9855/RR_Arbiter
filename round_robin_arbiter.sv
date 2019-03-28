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
  normal_arbiter (	.rst		(rst),
   .clk			(clk),
   .req			(req),
   .grant		(normal_grant));
  
  thermometer_priority_mask #(.request_lines (request_lines))
  thermometer_masking(
    .rst		(rst),
    .clk		(clk),
    .req		(grant),
    .mask_req	(masked_grant_previous));
  
  assign masked_requests = req & masked_grant_previous;
  
  
  priority_arbiter	#(.request_lines(request_lines))
  masking_arbiter (.rst		(rst),
   .clk		(clk),
   .req		(masked_requests),
   .grant	(masked_grant));
  
  
  always @(posedge clk or negedge rst) begin
    if(!rst) grant <= '0;
    else
      grant <= (masked_grant == {request_lines{1'b0}}) ? normal_grant : masked_grant;
  end
  
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

  initial begin 
    	mask_req = '0;
  end 
  
  always @(*) begin
    mask_req = req ^ (req - 1);
    mask_req = (req == {request_lines{1'b0}}) ? mask_req : ~mask_req;
    mask_req = mask_req | req;
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

  
  assign grant = ~rst ? '0 : req & -req;
  
endmodule

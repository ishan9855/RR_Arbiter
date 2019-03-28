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

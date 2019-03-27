
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
 
  
  always @(posedge clk or negedge rst)
    	begin
          if(!rst) 
            	mask_req <= '0;
           else
             	mask_req <= mask;
        end
  
  
endmodule

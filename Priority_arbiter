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

  
  always @(posedge clk or negedge rst)
    	begin
          if(!rst) 
            	grant <= '0;
           else
             	grant <= req & -req;
        end
  
  
endmodule

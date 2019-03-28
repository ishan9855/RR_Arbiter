module round_robin_mask_arbiter #( 
  parameter request_lines = 4)
  ( clk,
    rst,
    req,
    grant);


  input bit clk;
  input logic rst;
  input logic [request_lines - 1 : 0] req;
  output  logic [request_lines - 1 : 0] grant;  
  
  logic [request_lines - 1 : 0] pointer_req;
  logic [request_lines - 1 : 0] req_masked;
  logic [request_lines - 1 : 0] unmask_higher_pri_reqs;
  logic [request_lines - 1 : 0] mask_higher_pri_reqs;
  logic [request_lines - 1 : 0] grant_masked;
  logic 						no_req_masked;
  logic [request_lines - 1 : 0] grant_unmasked;
  
 
//Simple priority arbitration for masked portion
  assign req_masked = req & pointer_req;
  assign mask_higher_pri_reqs[request_lines - 1 : 1] = mask_higher_pri_reqs[request_lines - 2 : 0] | req_masked[request_lines - 2 : 0];
  assign mask_higher_pri_reqs[0] = 1'b0;
  assign grant_masked[request_lines - 1: 0] = req_masked[request_lines - 1: 0] & ~mask_higher_pri_reqs[request_lines - 1 : 0];
  
//Simple priority arbitration for unmasked portion
  assign unmask_higher_pri_reqs[request_lines - 1 : 1] = unmask_higher_pri_reqs[request_lines - 2 : 0] | req[request_lines - 2 : 0];
  assign unmask_higher_pri_reqs[0] = 1'b0;
  assign grant_unmasked[request_lines - 1 : 0] = req[request_lines - 1 : 0] & ~unmask_higher_pri_reqs[request_lines - 1 : 0];
  
  //Use grant_masked if there is any there, otherwise use grant_unmasked.
  assign no_req_masked = ~(|req_masked);
  assign grant = ({request_lines{no_req_masked}} & grant_unmasked ) | grant_masked;
 

//Updating the round robin pointer
always @(posedge clk or negedge rst) begin
  if(!rst) begin
    pointer_req <= {request_lines{1'b1}};
  end
  else begin
    if(|req_masked) begin //To find out which arbiter was used in previous iteration
        pointer_req <= mask_higher_pri_reqs;
    end
    else begin
        if(|req) begin
          pointer_req <= unmask_higher_pri_reqs;
        end 
        else begin
          pointer_req <= pointer_req;
        end
      end
   end
end
  
endmodule

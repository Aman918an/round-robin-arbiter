`timescale 1ns / 1ps
module round_robin_arbiter(
input clk,rst,
input logic [3:0] request,
output logic [3:0] grant
    );
logic [1:0] pointer;
logic [1:0] next_pointer;


always_comb begin  
logic found;
logic [1:0] winner;
found=1'b0;
winner=2'b00;
next_pointer=pointer;
        for (integer i=0;i<4;i++) begin
        integer actual_requester=(pointer+i)%4;
            if(request[actual_requester] && !found)begin
                found=1;
                winner=actual_requester;
                if(actual_requester==3)
                    next_pointer=0;
                else
                    next_pointer=actual_requester+1;
            end
        end
        if(!found)
            grant=4'b0000;
        else
            grant=4'b0001<<winner;   
    end
always_ff@(posedge clk) begin
if(rst)
    pointer<=0;
else
    pointer<=next_pointer;

end
endmodule

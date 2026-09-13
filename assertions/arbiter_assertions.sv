`timescale 1ns / 1ps
module arbiter_assertions(
input logic clk,rst,
input logic [3:0] grant,
input logic [3:0] request,
input logic [1:0] pointer
);
assert property(
@(posedge clk)
rst |=> pointer==2'b00
);

assert property (@(posedge clk) $onehot0(grant));    

assert property (
@(posedge clk)
disable iff(rst)
(request!=4'b0000) |-> $onehot(grant)
);

assert property (
@(posedge clk)
disable iff(rst)
(grant & ~request) == 4'b0000
);

assert property(
@(posedge clk)
disable iff(rst)
(request==4'b0000) |=> pointer==$past(pointer)
);

assert property (
    @(posedge clk)
    // requester 0
    disable iff(rst)
    $past(grant) == 4'b0001 |-> pointer == 2'b01
);   
assert property (
    @(posedge clk) 
    disable iff(rst)
    // requester 1
    $past(grant) == 4'b0010 |-> pointer == 2'b10
); 
assert property (
    @(posedge clk)    
    disable iff(rst)
    // requester 2
    $past(grant) == 4'b0100 |-> pointer == 2'b11
); 
assert property (
    @(posedge clk)    
    disable iff(rst)
    // requester 3
    $past(grant) == 4'b1000 |-> pointer == 2'b00
); 
endmodule

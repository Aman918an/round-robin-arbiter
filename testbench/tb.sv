`timescale 1ns / 1ps
module tb;
logic clk,rst;
logic [3:0] request;
logic [3:0] grant;
logic [1:0] model_pointer;
logic [1:0] model_next_pointer;
logic [3:0] random_request;
logic [15:0] request_seen;

round_robin_arbiter dut(
.clk(clk),
.rst(rst),
.request(request),
.grant(grant));

task test_case(
input logic [3:0] req);
logic [3:0] expected;
request=req;
reference_model(req,expected);
#1;
if (grant !== expected)
    $error("Test failed: request=%b, grant=%b, expected=%b", request, grant, expected);
else
    $display("Test passed: request=%b, grant=%b, expected=%b", request, grant, expected);
model_pointer=model_next_pointer;
endtask



task reference_model(
input logic [3:0] req,
output logic [3:0] expected);
logic found;
integer actual_requester;
found=0;
expected=4'b0000;
model_next_pointer=model_pointer;
for(integer i=0; i<4; i++) begin
    actual_requester=(model_pointer+i)%4;
    if(req[actual_requester] && !found) begin
        found=1;
        expected=4'b0001<< actual_requester;
    
        if(actual_requester==3)
            model_next_pointer=0;
        else
            model_next_pointer=actual_requester+1;
    end

end
endtask

always #5 clk=~clk;


initial begin
//logic [3:0] expected_grant;

clk=0;
rst=1;
model_pointer=0;
request=4'b0000;
request_seen=16'b0;

rst=0;
// No requests
@(negedge clk);
test_case(4'b0000);


// Single requester 1
@(negedge clk);
test_case(4'b0010);

// Single requester 2
@(negedge clk);
test_case(4'b0100);

// Single requester 3
@(negedge clk);
test_case(4'b1000);

// Multiple requests
@(negedge clk);
test_case(4'b1010);

@(negedge clk);
test_case(4'b1100);

@(negedge clk);
test_case(4'b1001);

$display("STARTING RANDOM TESTS at t=%0t", $time);
repeat (100) begin
    @(negedge clk);
    random_request=$urandom_range(0,15);
    request_seen[random_request]=1'b1;
    test_case(random_request);
end
$display("FINISHED RANDOM TESTS at t=%0t", $time);
for(integer i=0; i<16; i++) begin
    if(request_seen[i]==0)
        $display("pattern %04b was not tested", i);
end

if (request_seen == 16'b1111_1111_1111_1111)
    $display("All 16 request patterns were covered!");
else
    $display("Some request patterns were not covered.");

$finish;
end
endmodule

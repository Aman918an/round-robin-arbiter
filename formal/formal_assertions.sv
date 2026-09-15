module formal_assertions(
    input logic       clk,
    input logic [3:0] grant,
    input logic [3:0] request,
    input logic       f_past_valid
);

always @(posedge clk) begin
if (f_past_valid) begin

    // Grant is zero or one-hot
    assert ($onehot0(grant));

    // If there is a request, exactly one grant must exist
    if (request != 4'b0000)
        assert ($onehot(grant));

    // Never grant a requester that is not requesting
    assert ((grant & ~request) == 4'b0000);

    // Round-robin rotation: only check when the previous cycle
    // was also a valid (non-reset) cycle, so $past(grant) is meaningful
    if ($past(f_past_valid)) begin
        if ($past(grant) == 4'b0001 && request[1])
            assert (grant == 4'b0010);

        if ($past(grant) == 4'b0010 && request[2])
            assert (grant == 4'b0100);

        if ($past(grant) == 4'b0100 && request[3])
            assert (grant == 4'b1000);

        if ($past(grant) == 4'b1000 && request[0])
            assert (grant == 4'b0001);
    end

end
end

endmodule

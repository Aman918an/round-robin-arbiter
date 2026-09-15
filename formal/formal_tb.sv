module formal_tb;
    (* gclk *) logic clk;
    logic rst;
    logic [3:0] request;
    logic [3:0] grant;

    // Track whether we are past the initial cycle
    reg f_past_valid = 0;
    always @(posedge clk)
        f_past_valid <= 1;

    round_robin_arbiter dut (
        .clk(clk),
        .rst(rst),
        .request(request),
        .grant(grant)
    );

    // Reset high when f_past_valid is 0 (step 0), low after
    always @(*) begin
        if (!f_past_valid)
            assume (rst);
        else
            assume (!rst);
    end

    formal_assertions assertions_inst (
        .clk(clk),
        .grant(grant),
        .request(request),
        .f_past_valid(f_past_valid)
    );
endmodule

`timescale 1ns/1ps

module tb_mac_par_comb;

    parameter W = 8;
    parameter N = 9;

    logic clk = 0;
    logic reset_n = 0;
    logic weight_enable = 0;
    logic [3:0] weight_addr = 0;
    logic signed [W-1:0] weight_in;
    logic signed [W-1:0] in [0:N-1];

    logic signed [2*W+4:0] mac_out;
    logic out_valid;

    integer i;
    integer expected;

    mac_par_comb #(W, N) dut (
        .clk(clk),
        .reset_n(reset_n),
        .weight_enable(weight_enable),
        .weight_addr(weight_addr),
        .weight_in(weight_in),
        .in(in),
        .mac_out(mac_out),
        .out_valid(out_valid)
    );

    always #5 clk = ~clk;

    initial begin
        weight_in = 0;
        expected = 0;

        for (i = 0; i < N; i = i + 1)
            in[i] = 0;

        repeat (2) @(negedge clk);
        reset_n = 1;

        // Load weights 1 through 9
        for (i = 0; i < N; i = i + 1) begin
            @(negedge clk);
            weight_enable = 1;
            weight_addr = i;
            weight_in = i + 1;
        end

        @(negedge clk);
        weight_enable = 0;

        // Apply all 9 inputs together
        for (i = 0; i < N; i = i + 1) begin
            in[i] = i + 1;
            expected = expected + ((i + 1) * (i + 1));
        end

        @(negedge clk);
        #1;

        if (out_valid && mac_out == expected)
            $display("PASS: output=%0d expected=%0d",
                     mac_out, expected);
        else
            $display("FAIL: output=%0d expected=%0d valid=%b",
                     mac_out, expected, out_valid);

        #10;
        $finish;
    end

endmodule

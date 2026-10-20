`timescale 1ns/1ps

module mac_par_pipe #(
    parameter W = 8,
    parameter N = 9
)(
    input logic clk,
    input logic reset_n,
    input logic weight_enable,
    input logic [3:0] weight_addr,
    input logic signed [W-1:0] weight_in,
    input logic signed [W-1:0] in [0:N-1],
    output logic signed [2*W+4:0] mac_out,
    output logic out_valid
);

    logic signed [W-1:0] kernel_buff [0:N-1];

    logic signed [2*W-1:0] product [0:N-1];
    logic signed [2*W-1:0] product_reg [0:N-1];

    // Registers after the two-level adder tree
    logic signed [2*W+4:0] sum_a_reg;
    logic signed [2*W+4:0] sum_b_reg;
    logic signed [2*W+4:0] sum_c_reg;

    logic signed [2*W+4:0] sum_a;
    logic signed [2*W+4:0] sum_b;
    logic signed [2*W+4:0] sum_c;
    logic signed [2*W+4:0] final_sum;

    logic valid_stage1;
    logic valid_stage2;

    integer i;

    // Stage 1: nine parallel multipliers
    genvar g;
    generate
        for (g = 0; g < N; g = g + 1) begin : MULTIPLIERS
            assign product[g] =
                $signed(kernel_buff[g]) * $signed(in[g]);
        end
    endgenerate

    // Stage 2: two-level adder tree
    assign sum_a =
        $signed(product_reg[0]) +
        $signed(product_reg[1]) +
        $signed(product_reg[2]) +
        $signed(product_reg[3]);

    assign sum_b =
        $signed(product_reg[4]) +
        $signed(product_reg[5]) +
        $signed(product_reg[6]) +
        $signed(product_reg[7]);

    assign sum_c = $signed(product_reg[8]);

    // Stage 3: final adder, combinational
    assign final_sum = sum_a_reg + sum_b_reg + sum_c_reg;

    assign mac_out = final_sum;
    assign out_valid = valid_stage2;

    always_ff @(posedge clk) begin
        if (!reset_n) begin
            for (i = 0; i < N; i = i + 1) begin
                kernel_buff[i] <= '0;
                product_reg[i] <= '0;
            end

            sum_a_reg <= '0;
            sum_b_reg <= '0;
            sum_c_reg <= '0;
            valid_stage1 <= 1'b0;
            valid_stage2 <= 1'b0;
        end
        else if (weight_enable) begin
            kernel_buff[weight_addr] <= weight_in;
            valid_stage1 <= 1'b0;
            valid_stage2 <= 1'b0;
        end
        else begin
            // Pipeline register 1: multiplier outputs
            for (i = 0; i < N; i = i + 1)
                product_reg[i] <= product[i];

            valid_stage1 <= 1'b1;

            // Pipeline register 2: adder-tree outputs
            sum_a_reg <= sum_a;
            sum_b_reg <= sum_b;
            sum_c_reg <= sum_c;
            valid_stage2 <= valid_stage1;
        end
    end

endmodule

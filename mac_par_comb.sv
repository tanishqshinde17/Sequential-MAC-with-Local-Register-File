`timescale 1ns/1ps

module mac_par_comb #(
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

    wire signed [2*W-1:0] product [0:N-1];
    wire signed [2*W+4:0] sum;

    integer i;

    always_ff @(posedge clk) begin
        if (!reset_n) begin
            for (i = 0; i < N; i = i + 1)
                kernel_buff[i] <= '0;
            mac_out <= '0;
            out_valid <= 1'b0;
        end
        else if (weight_enable) begin
            kernel_buff[weight_addr] <= weight_in;
            out_valid <= 1'b0;
        end
        else begin
            mac_out <= sum;
            out_valid <= 1'b1;
        end
    end

    genvar g;
    generate
        for (g = 0; g < N; g = g + 1) begin : MULTIPLIERS
            assign product[g] =
                $signed(kernel_buff[g]) * $signed(in[g]);
        end
    endgenerate

    assign sum =
        product[0] + product[1] + product[2] +
        product[3] + product[4] + product[5] +
        product[6] + product[7] + product[8];

endmodule

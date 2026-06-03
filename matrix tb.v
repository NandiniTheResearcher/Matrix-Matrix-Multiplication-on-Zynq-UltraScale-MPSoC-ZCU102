`timescale 1ns / 1ps

module matrix_vector_mult_tb;

    parameter N = 10;
    parameter M = 10;
    parameter W = 32;

    reg  [N*N*W-1:0] matrix;
    reg  [N*M*W-1:0] vector_in;
    wire [N*M*W-1:0] result;
    wire [7:0] num_elements;

    integer i, j;

    matrix_vector_mult #(N, M, W) dut (
        .matrix(matrix),
        .vector_in(vector_in),
        .result(result),
        .num_elements(num_elements)
    );

    initial begin
        // Initialize matrix (row-major)
        for (i = 0; i < N*N; i = i + 1)
            matrix[i*W +: W] = i + 1;

        // Initialize vector
        for (i = 0; i < N*M; i = i + 1)
            vector_in[i*W +: W] = 1;

        #10;

        $display("Matrix × Vector Result:");
        for (i = 0; i < N; i = i + 1) begin
            for (j = 0; j < M; j = j + 1) begin
                $display("result[%0d][%0d] = %0d",
                    i, j,
                    result[(i*M + j)*W +: W]);
            end
        end

        $display("Number of elements = %0d", num_elements);
        $stop;
    end

endmodule

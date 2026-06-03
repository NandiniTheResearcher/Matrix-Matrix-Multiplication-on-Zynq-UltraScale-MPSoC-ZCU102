`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.01.2026 11:02:09
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.10.2024 09:58:25
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module top(
    output wire [95:0] result,   // Result vector
    output wire [1:0] num
);

    wire [287:0] matrix;
    wire [95:0] vector_in;

    // Instantiate matrix-vector multiplication
    matrix_vector_mult uut (
        .matrix(matrix),
        .vector_in(vector_in),
        .result(result),
        .num(num)
    );

    // Constant inputs
    assign matrix = {
        32'd5, 32'd6, 32'd7,   // Row 0
        32'd3, 32'd2, 32'd9,   // Row 1
        32'd1, 32'd7, 32'd8    // Row 2
    };

    assign vector_in = {
        32'd8,
        32'd2,
        32'd6
    };

endmodule
 

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.01.2026 11:02:44
// Design Name: 
// Module Name: matrix_vector_mult
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


module matrix_vector_mult(
    input [287:0] matrix,                   // Flattened 3x3 matrix (3x3x32 bits = 288 bits)
    input [95:0] vector_in,                 // Flattened 3x1 vector (3x32 bits = 96 bits)
    output reg [95:0] result,               // Flattened result vector (3x32 bits = 96 bits)                        // Done signal
    output reg [1:0] num                    // Number of elements in the result
);

localparam ELEMENT_WIDTH = 32;            // Width of each element
localparam TOTAL_BITS = 96;                // Total bits in result
localparam NUM_ELEMENTS = TOTAL_BITS / ELEMENT_WIDTH; // Calculate the number of elements

// Extract elements from flattened matrix and vector
integer i, j;
wire [31:0] mat[0:2][0:2];
wire [31:0] vec[0:2];
reg [31:0] temp_sum[0:2];

assign mat[0][0] = matrix[287:256];
assign mat[0][1] = matrix[255:224];
assign mat[0][2] = matrix[223:192];
assign mat[1][0] = matrix[191:160];
assign mat[1][1] = matrix[159:128];
assign mat[1][2] = matrix[127:96];
assign mat[2][0] = matrix[95:64];  
assign mat[2][1] = matrix[63:32];  
assign mat[2][2] = matrix[31:0];   


assign vec[0] = vector_in[95:64];
assign vec[1] = vector_in[63:32];
assign vec[2] = vector_in[31:0];



// Perform matrix-vector multiplication combinationally
always @(*) begin
    
     // Temporary sums for each row

    // Initialize outputs
    result = 96'b0;      // Clear the result
    num = NUM_ELEMENTS;   // Set the number of elements

    // Perform multiplication
    for (i = 0; i < 3; i = i + 1) begin
        temp_sum[i] = 32'b0; // Initialize temp_sum for each row
        for (j = 0; j < 3; j = j + 1) begin
            temp_sum[i] = temp_sum[i] + mat[i][j] * vec[j];
        end
        result[31 + i*32 -: 32] = temp_sum[i]; // Store result
    end
    
    //if(result !=0) begin
    // done = 1'b1
    // num = NUM_ELEMENTS
    //end
    
end

endmodule
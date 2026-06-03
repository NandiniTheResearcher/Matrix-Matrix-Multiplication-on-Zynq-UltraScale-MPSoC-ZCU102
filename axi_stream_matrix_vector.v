`timescale 1ns / 1ps

module axi_stream_matrix_vector #
(
    parameter DATA_WIDTH = 32
)
(
    input  wire                  aclk,
    input  wire                  aresetn,

    // AXI-Stream Slave (Input Vector)
    input  wire                  s_axis_tvalid,
    output reg                   s_axis_tready,
    input  wire [DATA_WIDTH-1:0] s_axis_tdata,
    input  wire                  s_axis_tlast,

    // AXI-Stream Master (Output Result)
    output reg                   m_axis_tvalid,
    input  wire                  m_axis_tready,
    output reg  [DATA_WIDTH-1:0] m_axis_tdata,
    output reg                   m_axis_tlast
);

    // ------------------------------
    // Fixed 3×3 Matrix
    // ------------------------------
    reg [DATA_WIDTH-1:0] matrix [0:2][0:2];
    initial begin
        matrix[0][0]=5; matrix[0][1]=6; matrix[0][2]=7;
        matrix[1][0]=3; matrix[1][1]=2; matrix[1][2]=9;
        matrix[2][0]=1; matrix[2][1]=7; matrix[2][2]=8;
    end

    // ------------------------------
    // Vector Buffer
    // ------------------------------
    reg [DATA_WIDTH-1:0] vector [0:2];
    reg [1:0] vec_cnt;
    reg vec_done;

    // ------------------------------
    // Result Buffer
    // ------------------------------
    reg [DATA_WIDTH-1:0] result [0:2];
    reg [1:0] out_cnt;

    integer i;

    // ------------------------------
    // AXI-Stream Input Logic
    // ------------------------------
    always @(posedge aclk) begin
        if (!aresetn) begin
            vec_cnt   <= 0;
            vec_done  <= 0;
            s_axis_tready <= 1;
        end
        else if (s_axis_tvalid && s_axis_tready) begin
            vector[vec_cnt] <= s_axis_tdata;
            vec_cnt <= vec_cnt + 1;

            if (s_axis_tlast) begin
                vec_done <= 1;
                s_axis_tready <= 0;
            end
        end
    end

    // ------------------------------
    // Matrix × Vector Computation
    // ------------------------------
    always @(posedge aclk) begin
        if (!aresetn) begin
            for (i = 0; i < 3; i = i + 1)
                result[i] <= 0;
        end
        else if (vec_done) begin
            for (i = 0; i < 3; i = i + 1)
                result[i] <= matrix[i][0]*vector[0]
                           + matrix[i][1]*vector[1]
                           + matrix[i][2]*vector[2];
        end
    end

    // ------------------------------
    // AXI-Stream Output Logic
    // ------------------------------
    always @(posedge aclk) begin
        if (!aresetn) begin
            m_axis_tvalid <= 0;
            m_axis_tdata  <= 0;
            m_axis_tlast  <= 0;
            out_cnt <= 0;
        end
        else if (vec_done && m_axis_tready) begin
            m_axis_tvalid <= 1;
            m_axis_tdata  <= result[out_cnt];
            m_axis_tlast  <= (out_cnt == 2);

            if (out_cnt == 2) begin
                out_cnt  <= 0;
                vec_done <= 0;
                s_axis_tready <= 1;
                m_axis_tvalid <= 0;
            end
            else begin
                out_cnt <= out_cnt + 1;
            end
        end
    end

endmodule

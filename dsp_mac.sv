module dsp_mac #(
    parameter int DATA_WIDTH = 8,
    parameter int ACC_WIDTH = 24
)(
    input  logic clk,
    input  logic rst_n,

    input  logic signed [DATA_WIDTH-1:0] a,
    input  logic signed [DATA_WIDTH-1:0] b,

    input  logic mult_en,
    input  logic acc_en,
    input  logic acc_clr,

    output logic signed [ACC_WIDTH-1:0] result,
    output logic signed [2*DATA_WIDTH-1:0] mult_out
);

    logic rst;
    assign rst = ~rst_n;

    logic signed [2*DATA_WIDTH-1:0] product;
    logic signed [2*DATA_WIDTH-1:0] mult_reg;
    logic signed [ACC_WIDTH-1:0] accumulator;

    // Умножение
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            product <= 0;
            mult_reg <= 0;
        end else if (mult_en) begin
            product <= a * b;
            mult_reg <= a * b;
        end
    end

    // Накопление
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            accumulator <= 0;
        end else if (acc_clr) begin
            accumulator <= 0;
        end else if (acc_en) begin
            accumulator <= accumulator + product;
        end
    end

    assign result = accumulator;
    assign mult_out = mult_reg;

endmodule

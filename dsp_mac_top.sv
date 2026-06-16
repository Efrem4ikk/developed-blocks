module top_simple (
    input  logic clk,
    input  logic rst_n,

    input  logic btn_mult,
    input  logic btn_acc,
    input  logic btn_clr,

    input  logic [7:0] sw_a,
    input  logic [7:0] sw_b,

    output logic [5:0] led
);

    logic rst;
    assign rst = ~rst_n;

    logic mult_prev, acc_prev, clr_prev;
    logic mult_edge, acc_edge, clr_edge;
    
    logic signed [23:0] result;
    logic signed [15:0] mult_out;

    // Обработка кнопок
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            mult_prev <= 0;
            acc_prev <= 0;
            clr_prev <= 0;
        end else begin
            mult_prev <= btn_mult;
            acc_prev <= btn_acc;
            clr_prev <= btn_clr;
        end
    end
    
    assign mult_edge = btn_mult && !mult_prev;
    assign acc_edge  = btn_acc  && !acc_prev;
    assign clr_edge  = btn_clr  && !clr_prev;
    
    // MAC модуль
    dsp_mac #(
        .DATA_WIDTH(8),
        .ACC_WIDTH(24)
    ) u_mac (
        .clk(clk),
        .rst_n(rst_n),
        .a(sw_a),
        .b(sw_b),
        .mult_en(mult_edge),
        .acc_en(acc_edge),
        .acc_clr(clr_edge),
        .result(result),
        .mult_out(mult_out)
    );
    
    // Извлекаем младшие 6 бит результата
    assign led = result[5:0];

endmodule

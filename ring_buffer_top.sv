module top (
    input  logic clk,
    input  logic rst_n,

    input  logic btn_wr,
    input  logic btn_rd,

    output logic [5:0] led
);

    logic rst;
    assign rst = ~rst_n;

    logic [5:0] wr_data;
    logic [5:0] rd_data;

    logic full, empty;

    // простой генератор данных
    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            wr_data <= 6'b000001;
        else if (btn_wr)
            wr_data <= wr_data + 1;
    end

    ring_buffer #(
        .DATA_WIDTH(6),
        .DEPTH(8)
    ) rb (
        .clk(clk),
        .rst(rst),

        .wr_en(btn_wr),
        .wr_data(wr_data),

        .rd_en(btn_rd),
        .rd_data(rd_data),

        .full(full),
        .empty(empty)
    );

    // вывод на светодиоды
    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            led <= 6'b0;
        else
            led <= rd_data;
    end

endmodule

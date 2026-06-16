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

    // Генератор данных
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            wr_data <= 6'b000001;
        end else if (btn_wr && !full) begin
            wr_data <= wr_data + 1'b1;
        end
    end

    fifo #(
        .DATA_WIDTH(6),
        .DEPTH(8)
    ) u_fifo (
        .clk(clk),
        .rst(rst),
        .wr_en(btn_wr),
        .wr_data(wr_data),
        .rd_en(btn_rd),
        .rd_data(rd_data),
        .full(full),
        .empty(empty)
    );

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            led <= 6'b0;
        end else begin
            led <= rd_data;
        end
    end

endmodule

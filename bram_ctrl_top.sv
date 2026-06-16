module top (
    input  wire clk,
    input  wire rst_n,

    input  wire btn_wr,
    input  wire btn_rd,

    input  wire [2:0] addr,

    output reg [5:0] led
);

    wire rst;
    assign rst = ~rst_n;

    reg [5:0] wr_data;
    wire [5:0] rd_data;

    // Генератор данных для записи
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            wr_data <= 6'b000001;
        end else if (btn_wr) begin
            wr_data <= wr_data + 1'b1;
        end
    end

    // Контроллер BRAM
    bram_ctrl #(
        .DATA_WIDTH(6),
        .ADDR_WIDTH(3)
    ) u_bram (
        .clk(clk),
        .rst(rst),
        .wr_en(btn_wr),
        .rd_en(btn_rd),
        .wr_data(wr_data),
        .addr(addr),
        .rd_data(rd_data)
    );

    // Вывод на светодиоды
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            led <= 6'b0;
        end else begin
            led <= rd_data;
        end
    end

endmodule

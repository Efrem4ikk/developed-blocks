module bram_ctrl #(
    parameter int DATA_WIDTH = 6,
    parameter int ADDR_WIDTH = 3
)(
    input  wire clk,
    input  wire rst,

    input  wire wr_en,
    input  wire rd_en,

    input  wire [DATA_WIDTH-1:0] wr_data,
    input  wire [ADDR_WIDTH-1:0] addr,

    output reg [DATA_WIDTH-1:0] rd_data
);

    // Память: 2^ADDR_WIDTH ячеек по DATA_WIDTH бит
    reg [DATA_WIDTH-1:0] mem [0:(1<<ADDR_WIDTH)-1];

    integer i;

    // Инициализация памяти нулями при старте
    initial begin
        for (i = 0; i < (1<<ADDR_WIDTH); i = i + 1) begin
            mem[i] = 0;
        end
    end

    // Запись: синхронная, по переднему фронту такта
    always @(posedge clk) begin
        if (wr_en) begin
            mem[addr] <= wr_data;
        end
    end

    // Чтение: асинхронное (комбинаторное)
    always @(*) begin
        if (rd_en) begin
            rd_data = mem[addr];
        end else begin
            rd_data = 0;
        end
    end

endmodule

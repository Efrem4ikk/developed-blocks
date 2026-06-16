module fifo #(
    parameter int DATA_WIDTH = 6,
    parameter int DEPTH = 8
)(
    input  logic clk,
    input  logic rst,

    input  logic wr_en,
    input  logic [DATA_WIDTH-1:0] wr_data,

    input  logic rd_en,
    output logic [DATA_WIDTH-1:0] rd_data,

    output logic full,
    output logic empty
);

    logic [DATA_WIDTH-1:0] mem [0:DEPTH-1];

    // Указываем точную ширину: log2(8)=3 бита
    logic [2:0] wr_ptr;
    logic [2:0] rd_ptr;
    // log2(8)+1=4 бита для count (0..8)
    logic [3:0] count;

    integer i;

    // ============================================================
    // WRITE - только запись
    // ============================================================
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            wr_ptr <= 0;
        end else if (wr_en && !full) begin
            mem[wr_ptr] <= wr_data;
            wr_ptr <= wr_ptr + 1'b1;
        end
    end

    // ============================================================
    // READ - только чтение
    // ============================================================
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            rd_ptr <= 0;
            rd_data <= 0;
        end else if (rd_en && !empty) begin
            rd_data <= mem[rd_ptr];
            rd_ptr <= rd_ptr + 1'b1;
        end
    end

    // ============================================================
    // COUNT - счётчик количества элементов
    // ============================================================
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 0;
        end else begin
            if (wr_en && !full && rd_en && !empty) begin
                count <= count;  // одновременные запись и чтение
            end else if (wr_en && !full) begin
                count <= count + 1'b1;
            end else if (rd_en && !empty) begin
                count <= count - 1'b1;
            end
        end
    end

    assign full  = (count == DEPTH);
    assign empty = (count == 0);

endmodule

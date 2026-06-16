module ring_buffer #(
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

    logic [DATA_WIDTH-1:0] mem [DEPTH];

    logic [$clog2(DEPTH)-1:0] wr_ptr;
    logic [$clog2(DEPTH)-1:0] rd_ptr;
    logic [$clog2(DEPTH):0] count;

    // WRITE
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            wr_ptr <= 0;
        end else if (wr_en && !full) begin
            mem[wr_ptr] <= wr_data;
            wr_ptr <= wr_ptr + 1;
        end
    end

    // READ
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            rd_ptr <= 0;
            rd_data <= 0;
        end else if (rd_en && !empty) begin
            rd_data <= mem[rd_ptr];
            rd_ptr <= rd_ptr + 1;
        end
    end

    // COUNT
    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            count <= 0;
        else begin
            case ({wr_en && !full, rd_en && !empty})
                2'b10: count <= count + 1;
                2'b01: count <= count - 1;
                default: count <= count;
            endcase
        end
    end

    assign full  = (count == DEPTH);
    assign empty = (count == 0);

endmodule

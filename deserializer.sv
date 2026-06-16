module serial_to_parallel #(
    parameter int WIDTH = 6
)(
    input  logic clk,
    input  logic rst,

    input  logic serial_in,
    input  logic valid_in,

    output logic [WIDTH-1:0] parallel_out,
    output logic valid_out
);

    logic [WIDTH-1:0] shift_reg;
    logic [$clog2(WIDTH):0] bit_cnt;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            shift_reg   <= '0;
            bit_cnt     <= '0;
            parallel_out<= '0;
            valid_out   <= 1'b0;
        end else begin
            valid_out <= 1'b0;

            if (valid_in) begin
                shift_reg <= {shift_reg[WIDTH-2:0], serial_in};
                bit_cnt   <= bit_cnt + 1;

                if (bit_cnt == WIDTH-1) begin
                    parallel_out <= {shift_reg[WIDTH-2:0], serial_in};
                    valid_out    <= 1'b1;
                    bit_cnt      <= '0;
                end
            end
        end
    end

endmodule

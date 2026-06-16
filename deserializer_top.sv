module top (
    input  logic clk,
    input  logic rst_n,

    input  logic btn,
    input  logic btn_valid,

    output logic [5:0] led
);

    logic rst;
    assign rst = ~rst_n;

    logic [7:0] data;
    logic valid;

    serial_to_parallel #(.WIDTH(8)) s2p (
        .clk(clk),
        .rst(rst),
        .serial_in(btn),
        .valid_in(btn_valid),
        .parallel_out(data),
        .valid_out(valid)
    );

    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            led <= 6'b0;
        else if (valid)
            led <= data[5:0];
    end

endmodule

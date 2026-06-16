module top (
    input  logic clk,
    input  logic rst_n,
    output logic [5:0] led
);

    timer #(.WIDTH(26)) u_timer (
        .clk(clk),
        .rst_n(rst_n),
        .led(led)
    );

endmodule

module timer #(
    parameter int WIDTH = 26  // достаточно для видимого деления частоты
)(
    input  logic clk,
    input  logic rst_n,

    output logic [5:0] led
);

    logic rst;
    assign rst = ~rst_n;

    logic [WIDTH-1:0] counter;

    // основной счётчик
    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            counter <= 0;
        else
            counter <= counter + 1;
    end

    // вывод старших битов на LED
    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            led <= 6'b0;
        else
            led <= counter[WIDTH-1:WIDTH-6];
    end

endmodule

module top (
    input wire clk_27mhz,
    input wire rst_button,
    output wire [5:0] led,
    
    output wire O_psram_ck,
    output wire O_psram_ck_n,
    inout wire [7:0] IO_psram_dq,
    inout wire IO_psram_rwds,
    output wire O_psram_cs_n,
    output wire O_psram_reset_n
);

    wire clk = clk_27mhz;
    wire rst_n = rst_button;
    wire [31:0] wr_data;
    wire [31:0] rd_data;
    wire rd_data_valid;
    wire [20:0] addr;
    wire cmd;
    wire cmd_en;
    wire init_calib;
    wire [3:0] data_mask;
    wire clk_out;
    
    wire [5:0] led_test;
    
    //--------------------------- IP-модуль PSRAM ---------------------------
    PSRAM_Memory_Interface_HS_Top u_psram (
        .clk(clk),
        .memory_clk(clk),
        .pll_lock(1'b1),
        .rst_n(rst_n),
        
        // Физический интерфейс - подключаем напрямую к портам top
        .O_psram_ck(O_psram_ck),
        .O_psram_ck_n(O_psram_ck_n),
        .IO_psram_dq(IO_psram_dq),
        .IO_psram_rwds(IO_psram_rwds),
        .O_psram_cs_n(O_psram_cs_n),
        .O_psram_reset_n(O_psram_reset_n),
        
        // Пользовательский интерфейс
        .wr_data(wr_data),
        .rd_data(rd_data),
        .rd_data_valid(rd_data_valid),
        .addr(addr),
        .cmd(cmd),
        .cmd_en(cmd_en),
        .init_calib(init_calib),
        .clk_out(clk_out),
        .data_mask(data_mask)
    );
    
    //--------------------------- Тестовый модуль ---------------------------
    psram_test u_test (
        .clk(clk),
        .rst_n(rst_n),
        .wr_data(wr_data),
        .rd_data(rd_data),
        .rd_data_valid(rd_data_valid),
        .addr(addr),
        .cmd(cmd),
        .cmd_en(cmd_en),
        .init_calib(init_calib),
        .data_mask(data_mask),
        .led(led_test)
    );
    
    assign led = led_test;

endmodule

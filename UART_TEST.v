module UART_TEST #(
    parameter CLKS_PER_BIT = 5208,
    parameter ROMADDRESS = 256,
    parameter ROMDATABIT = 8,
    parameter INFILE = "ASCII.txt"
) (
    // SYSTEM I/O
    input i_clk,
    input i_rst, // sw[0]
    input i_en_txd, // sw[1]
    output o_txd
);
reg [ROMDATABIT-1:0] mem [0:ROMADDRESS-1];
reg [9:0] r_addr;

reg [7:0] r_tx_byte;
reg r_tx_dv;
reg r_rev_delayed;
wire w_en_txd;
wire w_tx_done;

// memory initialize
initial begin
    $readmemb(INFILE,mem,0,ROMADDRESS-1);
end

// Inter Connection
uart_tx #(.CLKS_PER_BIT(CLKS_PER_BIT)) uart_tx
(
    .i_Clock(i_clk),
    .i_Tx_DV(r_tx_dv),
    .i_Tx_Byte(r_tx_byte),
    .o_Tx_Active(),
    .o_Tx_Done(w_tx_done),
    .o_Tx_Serial(o_txd)
);

// Combinational logic
always @(*) begin
    r_tx_dv <= i_en_txd & r_rev_delayed;
end

// Sequential Logic
always @(posedge i_clk) begin
    if(i_rst) r_addr <= 0;
    else if(w_tx_done) r_addr <= r_addr + 1;
end

always @(posedge i_clk) begin
    if(i_rst) r_rev_delayed <= 1;
    else if(i_en_txd) r_rev_delayed <= 0;
    else r_rev_delayed <= 1;
end

always @(posedge i_clk) begin
    if(i_rst) r_tx_byte <= 0;
    else r_tx_byte <= mem[r_addr];
end

endmodule
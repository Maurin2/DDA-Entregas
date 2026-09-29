`timescale 1ns/100ps

module top_tb();
parameter DATA_LEN = 3;

// INPUT  : Type = reg
// OUTPUT : Type = wire

reg [DATA_LEN-1:0]      i_data1;
reg [DATA_LEN-1:0]      i_data2;
reg [1:0]               i_sel;
reg                     i_reset;
wire [2*DATA_LEN-1:0]   o_data;
wire                    o_overflow;
reg  clk;
integer                 n_ciclos;   // ciclos de reloj hasta el overflow

always #10 clk = ~clk;


top #(
    .DATA_LEN(DATA_LEN)
) u_top(
    .i_data1(i_data1),
    .i_data2(i_data2),
    .i_sel(i_sel),
    .i_reset(i_reset),
    .o_data(o_data),
    .o_overflow(o_overflow),
    .clk(clk)
);

 initial begin
    clk   = 1'b0;
    i_reset = 1'b0;     //activo en 0
    i_sel    = 2'b00;
    i_data1   = 3'b010;
    i_data2   = 3'b001;

    #100  i_reset   = 1'b1;
    #200 // Suma 10 veces 1   => 10
    i_sel    = 2'b10;
    #200 // Suma 10 veces 2   => 30
    i_sel    = 2'b01;
    #200 // Suma 10 veces 1+2 => 60


    #2000 //para ver el overflow

    // Reseteo
    @(negedge clk) i_reset = 1'b0;
    i_sel    = 2'b01;
    i_data1  = 3'b001;
    i_data2  = 3'b001;
    n_ciclos = 0;
    @(negedge clk) i_reset = 1'b1;

    while (!o_overflow) begin
        @(posedge clk) n_ciclos = n_ciclos + 1;
        #1;                         // espera a que se actualicen los registros
    end
    $display("Overflow en el ciclo %0d (o_data = %0d)", n_ciclos, o_data);

    #100 $finish;
  end

endmodule
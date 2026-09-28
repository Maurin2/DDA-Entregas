`timescale 1ns/100ps

module top_tb();

parameter DATA_LEN = 8;

// INPUT  : Type = reg
// OUTPUT : Type = wire

reg  signed [DATA_LEN-1:0]  i_x;
wire signed [(DATA_LEN + 4) -1:0]  o_y;   //Se le suma 3 para evitar overflow
reg  clk;
reg  reset;

reg  [DATA_LEN-1:0] aux_tb_data;

always #10 clk = ~clk;  // 


top #(
    .DATA_LEN(DATA_LEN)
) u_top(
    .i_x(i_x),
    .o_y(o_y),
    .i_reset(reset),
    .clk(clk)
);
// Constantes de todo
localparam real    CTE_2PI  = 2.0*3.1415926;
localparam         NB_INPUT = 8;                        // NB of input
localparam         NBF_INPUT = NB_INPUT-1;              // NB fraccionarios, S(8,7)
localparam integer MAX_VAL  =   2**(NB_INPUT-1) - 1;    // +127
localparam integer MIN_VAL  = -(2**(NB_INPUT-1));       // -128

localparam real    FS       = 25000.0;                  // Sampling frequency
localparam integer N_SAMPLE = 4000;                     // Numero se sampleos

//Constantes de la señal principal
localparam real    FREQ     = 300.0;                   // Input signal frequency

//Constantes de la señal PARASITA
localparam real    FREQ_PAR    = 4000.0;                // Le agrego una señal parasita de 4k, deberia estar MUY atenuada en comparacion a la de 1k (es un filtro PB)
// Notese, que el filtro  elimina justamente la banda de (aprox) 4KHZ>

real i;
real aux;
real par;

real noisy_signal;

initial begin
    i_x         = {DATA_LEN{1'b0}};
    aux_tb_data = {DATA_LEN{1'b0}};
    clk   = 1'b0;
    reset = 1'b1;
    #10;
    reset = 1'b0;
    #10;
    @(negedge clk);

    $display("Simulation Started");
    for (i = 0; i < N_SAMPLE; i = i + 1) begin
        aux = 0.5  * $sin(CTE_2PI * (FREQ/FS) * i) * (2.0**NBF_INPUT);      // Multiplico por 0.5 para que no se sature cuando sumo
        par = 0.25 * $sin(CTE_2PI * (FREQ_PAR/FS) * i) * (2.0**NBF_INPUT);  // Idem arriba
        noisy_signal = aux + par;
        if (aux > MAX_VAL)
            aux_tb_data = MAX_VAL;
        else if (aux < MIN_VAL)
            aux_tb_data = MIN_VAL;
        else
            aux_tb_data = noisy_signal;
        @(negedge clk);
    end
    repeat (10) @(negedge clk);
    $display("Simulation Finished");
    $finish;
end

  always @(posedge clk) begin
    i_x <= aux_tb_data;
  end


endmodule
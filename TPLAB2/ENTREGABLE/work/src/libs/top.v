module top#(
    parameter NB_INPUT   = 8,
    parameter NBF_INPUT  = 6,
    parameter N_TAPS     = 15,
    parameter NB_OUTPUT  = NB_INPUT + $clog2(N_TAPS),
    parameter NBF_OUTPUT = NBF_INPUT
)
(
    input                               clk,
    input signed [N_TAPS*NB_INPUT-1:0]  coef_flat

);
// Bajo el clk por que sino no cierra timing
wire clk_50;
clk_wiz_0 u_clk (.clk_in1(clk), .clk_out1(clk_50));

wire                               i_reset;
wire signed [NB_OUTPUT-1:0]        o_y_n;



// -------------- Creacion de señal ------------- //
wire [8  - 1 : 0] x_n;
 
    signal_generator
    u_signal_generator(
        .o_signal(x_n),
        .i_reset(i_reset),
        .i_clock(clk_50)
    );
// ----------------------------------------------  //


// ------------- Creacion del filtro ------------ //
 
    fir_filter#(
        .NB_INPUT(NB_INPUT),
        .NBF_INPUT(NBF_INPUT),
        .N_TAPS(N_TAPS),
        .NB_OUTPUT(NB_OUTPUT),
        .NBF_OUTPUT(NBF_OUTPUT)
    )
    u_fir_filter(
        .clk(clk_50),
        .reset(i_reset),
        .i_x_n(x_n),
        .i_h(coef_flat),
        .o_y_n(o_y_n)
    );
// ----------------------------------------------  //

// -------------- Instancio VIO/ILA -------------- //

ila_0 u_ila0 (
	.clk(clk_50), // input wire clk
	.probe0(x_n), // input wire [7:0]  probe0  
	.probe1(o_y_n) // input wire [11:0]  probe1
);


vio_0 u_vio0 (
  .clk(clk_50),                // input wire clk
  .probe_out0(i_reset)  // output wire [0 : 0] probe_out0
);
// ----------------------------------------------  //

endmodule


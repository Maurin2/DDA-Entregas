`timescale 1ns / 1ps

/*
    Esto implementa el circuito de la practica 1
*/
module top_vio_ila
#(
    parameter NB_LEDS = 4,
    parameter NB_SW = 4,
    parameter NB_COUNTER = 32
)
(
    output [NB_LEDS-1:0] o_led,
    output [NB_LEDS-1:0] o_led_b,
    output [NB_LEDS-1:0] o_led_g,
    input  [NB_SW - 1:0] i_sw,
    input                i_reset,
    input        clock
);

wire connect_valid;
wire [NB_LEDS-1:0]  connect_led;

wire [NB_SW-1:0]    i_sw_vio;
wire                i_reset_vio;
wire                sel_mux_vio;

wire [NB_SW-1:0]    i_sw_w;
wire                i_reset_w;

assign i_sw_w    = sel_mux_vio ? i_sw_vio    : i_sw;
assign i_reset_w = sel_mux_vio ? i_reset_vio : i_reset;

vio_0 u_vio (
  .clk(clock),                // input wire clk
  .probe_out0(i_sw_vio),  // output wire [3 : 0] probe_out0
  .probe_out1(i_reset_vio),  // output wire [0 : 0] probe_out1
  .probe_out2(sel_mux_vio)  // output wire [0 : 0] probe_out2
);

ila_0 u_ila (
	.clk(clock), // input wire clk
	.probe0(o_led), // input wire [3:0]  probe0  
	.probe1(o_led_b), // input wire [3:0]  probe1 
	.probe2(o_led_g) // input wire [3:0]  probe2
);

count #(
    .NB_SW(NB_SW - 1),
    .NB_COUNTER(NB_COUNTER)
) u_count(
    .i_reset(i_reset_w),
    .i_sw(i_sw_w[NB_SW - 2:0]),
    .o_valid(connect_valid),
    .clock(clock)
);
shiftreg #(
    .NB_LEDS(NB_LEDS)
) u_shiftreg(
    .clock(clock),
    .i_reset(i_reset_w),
    .i_valid(connect_valid),
    .o_led(connect_led)
);

assign o_led = connect_led;
assign o_led_b = !i_sw_w[NB_SW-1] ? connect_led : {NB_LEDS{1'b0}};
assign o_led_g = i_sw_w[NB_SW-1] ? connect_led : {NB_LEDS{1'b0}};

endmodule

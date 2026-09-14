`timescale 1ns / 1ps

/*
    Esto implementa el circuito de la practica 1
*/
module top
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





count #(
    .NB_SW(NB_SW - 1),
    .NB_COUNTER(NB_COUNTER)
) u_count(
    .i_reset(i_reset),
    .i_sw(i_sw[NB_SW - 2:0]),
    .o_valid(connect_valid),
    .clock(clock)
);
shiftreg #(
    .NB_LEDS(NB_LEDS)
) u_shiftreg(
    .clock(clock),
    .i_reset(i_reset),
    .i_valid(connect_valid),
    .o_led(connect_led)
);

assign o_led = connect_led;
assign o_led_b = !i_sw[NB_SW-1] ? connect_led : {NB_LEDS{1'b0}};
assign o_led_g = i_sw[NB_SW-1] ? connect_led : {NB_LEDS{1'b0}};

endmodule

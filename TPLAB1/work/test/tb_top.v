`timescale 1ns/100ps

module tb_top();
parameter NB_LEDS = 4;
parameter NB_SW = 4;
parameter NB_COUNTER = 14;

// INPUT  : Type = reg
// OUTPUT : Type = wire

wire [NB_LEDS-1:0] o_led;
wire [NB_LEDS-1:0] o_led_b;
wire [NB_LEDS-1:0] o_led_g;
reg  [NB_SW - 1:0] i_sw;
reg                i_reset;
reg        clock;

always #4 clock = ~clock;

top #(
    .NB_LEDS(NB_LEDS),
    .NB_SW(NB_SW),
    .NB_COUNTER(NB_COUNTER)
) u_top(
    .o_led(o_led),
    .o_led_b(o_led_b),
    .o_led_g(o_led_g),
    .i_sw(i_sw),
    .i_reset(i_reset),
    .clock(clock)
);

 initial begin
    clock   = 1'b0;
    i_reset = 1'b1;
    i_sw    = 4'b0000;

    #100  i_reset   = 1'b0;
    #100  i_sw[0]   = 1'b1;

    #1000 i_sw[2:1] = 2'b01;  // 1. rota cada 32 ciclos
    #2000 i_sw[2:1] = 2'b10;  //    rota cada 64 ciclos
    #3000 i_sw[2:1] = 2'b11;  //    rota cada 128 ciclos

    #5000 i_sw[3]   = 1'b1;   // 2. color:o_led_g
    #3000 i_sw[0]   = 1'b0;   // 3. deshabilitado el enable
    #2000 i_sw[0]   = 1'b1;   //    re-habilitado el enable

    #3000 i_reset   = 1'b1;   // 4. reseteo -> vuelve a 0001
    #100  i_reset   = 1'b0;

    #2000 $finish;
  end

wire [NB_COUNTER-1:0] tb_count;
wire                  tb_valid;
assign tb_count = tb_top.u_top.u_count.counter;
assign tb_valid = tb_top.u_top.connect_valid;
endmodule
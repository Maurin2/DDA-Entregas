`timescale 1ns / 1ps

module shiftreg#(
    parameter NB_LEDS = 4
)
(
    input clock,
    input i_reset,
    input i_valid,
    output [NB_LEDS-1:0] o_led
);
reg [NB_LEDS - 1:0] shiftReg;

always @(posedge clock) begin
    if (i_reset)
        shiftReg <= {{NB_LEDS-1{1'b0}}, 1'b1};                     // Carga la semilla: un solo bit en 1
    else if (i_valid)
        shiftReg <= {shiftReg[NB_LEDS-2:0], shiftReg[NB_LEDS-1]};  // Rota a la izquierda
    else
        shiftReg <= shiftReg;                                      // Retencion explicita
end
assign o_led = shiftReg;

endmodule

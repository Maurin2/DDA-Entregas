`timescale 1ns / 1ps

module count #(
    parameter NB_SW = 3,
    parameter NB_COUNTER = 32
)
(
    input                   i_reset,
    input   [NB_SW-1 :0]    i_sw,
    output                  o_valid,
    input                   clock

);

localparam R0 = (2**(NB_COUNTER-10))- 1; // Para que este parametrizado en funcion del numero de bits del contador
localparam R1 = (2**(NB_COUNTER-9))-  1;
localparam R2 = (2**(NB_COUNTER-8))-  1;
localparam R3 = (2**(NB_COUNTER-7))-  1; // Este va a ser el mas rapido

wire [NB_COUNTER -1: 0] limit_sh;
reg                     valid;
reg  [NB_COUNTER -1: 0] counter;

assign limit_sh = (i_sw[2:1] == 2'b00) ? R0 :
                  (i_sw[2:1] == 2'b01) ? R1 :
                  (i_sw[2:1] == 2'b10) ? R2 :
                  (i_sw[2:1] == 2'b11) ? R3 : R0;

// Es una buena practica no colocar dentro del comportamiento de un always bloques de asignacion de salida, por eso se hace un assign fuera del always
always @(posedge clock) begin
    if(i_reset) begin
        valid <= 1'b0;
        counter <= {NB_COUNTER{1'b0}};
    end else if (i_sw[0])begin // i_sw[0] es el enable
        if (counter >= limit_sh) begin
            valid <= 1'b1;
            counter <= {NB_COUNTER{1'b0}};
        end else begin
            counter <= counter + 1'b1;
            valid <= 1'b0;
        end
    end else begin
        valid <= 1'b0; 
    end
end


assign o_valid = valid;

endmodule

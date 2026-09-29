module normalizador
#(
    parameter MANTISA_LEN   = 8,
    parameter EXPONENTE_LEN = 4
)
(
    input [2*MANTISA_LEN - 1:0]  mantisa_y,
    input [EXPONENTE_LEN:0]      exponente_y,
    input       signo_y,

    output overflow,
    output [MANTISA_LEN + EXPONENTE_LEN:0]  o_y
);

wire        [MANTISA_LEN-1:0]       mantisa_y_norm;
wire        [EXPONENTE_LEN:0]       exponente_y_norm;
wire                                signo_y_norm;

assign mantisa_y_norm = mantisa_y[2*MANTISA_LEN-1]? mantisa_y[2*MANTISA_LEN-1:MANTISA_LEN] : mantisa_y[2*MANTISA_LEN-2:MANTISA_LEN-1]; // 15 - 8 // 14 - 7 

assign exponente_y_norm = mantisa_y[2*MANTISA_LEN-1]? exponente_y + 1 : exponente_y;

assign overflow = exponente_y_norm[EXPONENTE_LEN];

assign signo_y_norm = signo_y;

assign o_y = {signo_y_norm, mantisa_y_norm, exponente_y_norm[EXPONENTE_LEN-1:0]};

endmodule
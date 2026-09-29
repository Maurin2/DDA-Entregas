
// IMPORTANTE: el codigo usa MSB de mantisa explicita. es decir, la mantisa es el numero completo, no hay un 1 implicito como recomienda la IEEE
module top
#(
    parameter MANTISA_LEN = 8,
    parameter EXPONENTE_LEN = 4
)
(
    input  [(1 + MANTISA_LEN + EXPONENTE_LEN) - 1:0]  i_a, // signo + mantisa + exponente
    input  [(1 + MANTISA_LEN + EXPONENTE_LEN) - 1:0]  i_b,

    output [(1 + MANTISA_LEN + EXPONENTE_LEN) - 1:0]  o_y,
    output overflow
);
localparam WIDTH = 1 + MANTISA_LEN + EXPONENTE_LEN;

wire        [MANTISA_LEN-1:0]    mantisa_a;
wire        [EXPONENTE_LEN-1:0]  exponente_a;
wire                           signo_a;
assign mantisa_a    = i_a[WIDTH-2:EXPONENTE_LEN];
assign exponente_a  = i_a[EXPONENTE_LEN-1:0];
assign signo_a      = i_a[WIDTH-1];


wire        [MANTISA_LEN-1:0]    mantisa_b;
wire        [EXPONENTE_LEN-1:0]  exponente_b;
wire                           signo_b;
assign mantisa_b    = i_b[WIDTH-2:EXPONENTE_LEN];
assign exponente_b  = i_b[EXPONENTE_LEN-1:0];
assign signo_b      = i_b[WIDTH-1];


wire [2*MANTISA_LEN-1:0] mantisa_y;
wire [EXPONENTE_LEN:0]   exponente_y;
wire                     signo_y;


multiplicador#(
    .DATA_LEN(MANTISA_LEN)
) u_multiplicador(
    .i_a(mantisa_a),
    .i_b(mantisa_b),
    .o_y(mantisa_y)
);

sumador#(
    .DATA_LEN(EXPONENTE_LEN)
) u_sumador(
    .i_a(exponente_a),
    .i_b(exponente_b),
    .o_y(exponente_y)
);

assign signo_y = signo_a ^ signo_b;


normalizador#(
    .MANTISA_LEN(MANTISA_LEN),
    .EXPONENTE_LEN(EXPONENTE_LEN)
) u_normalizador(
    .mantisa_y(mantisa_y),
    .exponente_y(exponente_y),
    .signo_y(signo_y),
    .o_y(o_y),
    .overflow(overflow)
);


endmodule
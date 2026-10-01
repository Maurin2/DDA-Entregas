module fir_filter
#(
    parameter NB_INPUT   = 16,
    parameter NBF_INPUT  = 15,
    parameter N_TAPS     = 4,
    parameter NB_OUTPUT  = NB_INPUT + $clog2(N_TAPS),  // 18
    parameter NBF_OUTPUT = NBF_INPUT                   // 15
)
(
    input                               clk,
    input                               reset,
    input  signed [NB_INPUT-1:0]        i_x_n,
    input         [N_TAPS*NB_INPUT-1:0] i_h,
    output signed [NB_OUTPUT-1:0]       o_y_n
);

// ----------- Paso H a matriz de coeficientes ----------- //
wire signed [NB_INPUT-1:0] coef [N_TAPS-1:0];
genvar k;
generate
    for (k = 0; k < N_TAPS; k = k + 1) begin : gen_unpack
        assign coef[k] = i_h[k*NB_INPUT +: NB_INPUT];   // +: indica el inicio y el ancho
    end
endgenerate
// ------------------------------------------------------- //


integer j;
reg signed [NB_INPUT-1:0] x_reg [1:N_TAPS-1];   // x[n-1], x[n-2], x[n-3]
always @ (posedge clk or posedge reset) begin
    if (reset == 1) begin
        for (j = 1; j < N_TAPS; j = j + 1)
            x_reg[j] <= {NB_INPUT{1'b0}};
    end
    else begin
        x_reg[1] <= i_x_n;
        for (j = 2; j < N_TAPS; j = j + 1)
            x_reg[j] <= x_reg[j-1];
    end
end


// x_n[d] = x[n-d], incluyendo d = 0 (la entrada actual)
wire signed [NB_INPUT-1:0] x_n [0:N_TAPS-1];
assign x_n[0] = i_x_n;

genvar d;
generate
    for (d = 1; d < N_TAPS; d = d + 1) begin : gen_taps
        assign x_n[d] = x_reg[d];
    end
endgenerate

wire signed [2*NB_INPUT-NBF_INPUT-1 : 0] res [N_TAPS-1:0];
genvar i;
generate
    for (i = 0; i < N_TAPS; i = i + 1) begin : multiplicadores
    multiplicador#(
        .NB_INPUT(NB_INPUT),
        .NBF_INPUT(NBF_INPUT)
    ) u_multiplicador(
        .x_n(x_n[i]),
        .h_n(coef[i]),
        .res(res[i])
    );
    end
endgenerate


// ----------- Cadena de sumas ----------- //
// acc[s] = res[0] + ... + res[s]
wire signed [NB_OUTPUT-1:0] acc [0:N_TAPS-1];
assign acc[0] = res[0];                       // 17 -> NB_OUTPUT, extiende signo

genvar s;
generate
    for (s = 1; s < N_TAPS; s = s + 1) begin : gen_sum
        assign acc[s] = acc[s-1] + res[s];
    end
endgenerate

assign o_y_n = acc[N_TAPS-1];

endmodule


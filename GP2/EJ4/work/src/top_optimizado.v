module top_optimizado
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



// ----------- Genero los registros para x1,etc ----------- //
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
// ------------------------------------------------------- //



// ----------- Genero los 1° sumadores para xn ----------- //
wire signed [NB_INPUT:0] acc [0:N_TAPS/2-1];   // Acc queda en 17 bits
// acc[0] = x[n] + x[n-3]  -- acc[1] = x[n-1] + x[n-2] -- etc
genvar s;
generate
    for (s = 1; s <= N_TAPS/2; s = s + 1) begin : gen_sum
        assign acc[s-1] = x_n[s-1] + x_n[N_TAPS - s];
    end
endgenerate
// ------------------------------------------------------- //



// ----------- Genero los multiplicadors de xn ----------- //

wire signed [NB_INPUT+1: 0] res [N_TAPS/2-1:0];  //Res queda en 18 bits

genvar i;
generate
    for (i = 0; i < N_TAPS/2; i = i + 1) begin : multiplicadores
    multiplicador#(
        .NB_INPUT(NB_INPUT+1),
        .NBF_INPUT(NBF_INPUT)
    ) u_multiplicador(
        .x_n(acc[i]),
        .h_n({coef[i][NB_INPUT-1], coef[i]}),   // S(16,15) -> S(17,15), extension de signo)
        .res(res[i])
    );
    end
endgenerate
// ------------------------------------------------------- //


// ----------- Genero los 2° sumadores para xn ----------- //
wire signed [NB_OUTPUT-1:0] acc_2 [0:N_TAPS/2-1];   //acc_2 en 18 bits
// acc[0] = x[n] + x[n-3]  -- acc[1] = x[n-1] + x[n-2] -- etc
assign acc_2[0] = res[0];
genvar s2;
generate
    for (s2 = 1; s2 < N_TAPS/2; s2 = s2 + 1) begin : gen_sum2
        assign acc_2[s2] = acc_2[s2-1] + res[s2];
    end
endgenerate
// ------------------------------------------------------- //


assign o_y_n = acc_2[N_TAPS/2-1];

endmodule


module multiplicador
#(
    parameter NB_INPUT   = 16,
    parameter NBF_INPUT  = 15
)
(
    input  signed [NB_INPUT-1:0]    x_n,
    input  signed [NB_INPUT-1:0]    h_n,
    output signed [2*NB_INPUT-NBF_INPUT-1:0] res    // S(2·NB - NBF, NBF) → [16:0] -> Se le suma un bit para tener S(17,15)
);

localparam NB_PROD = 2*NB_INPUT;                    // 32
localparam NB_DROP = 2*NBF_INPUT - NBF_INPUT;       // 15

wire signed [NB_PROD-1:0] res_long;
assign res_long = x_n * h_n;

assign res = res_long[NB_PROD-1:NB_DROP];           // [31:15] -> S(17,15) -> quedan 2 enteros, y retengo los 15 decimales

endmodule
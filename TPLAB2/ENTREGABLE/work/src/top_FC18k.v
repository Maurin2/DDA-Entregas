module top_FC18k#
(
    parameter NB_INPUT   = 8,
    parameter NBF_INPUT  = 6,
    parameter N_TAPS     = 15
)(
    input                               clk
);
// ----------- Coeficientes del filtro ----------- //
wire signed [NB_INPUT-1:0] coef [0:N_TAPS-1];
wire [N_TAPS*NB_INPUT-1:0] coef_flat;

assign coef[0]   =  8'shFF;
assign coef[1]   =  8'sh00;
assign coef[2]   =  8'shFF;
assign coef[3]   =  8'shFF;
assign coef[4]   =  8'sh03;
assign coef[5]   =  8'shF7;
assign coef[6]   =  8'sh0C;
assign coef[7]   =  8'sh32;
assign coef[8]   =  8'sh0C;
assign coef[9]   =  8'shF7;
assign coef[10]  =  8'sh03;
assign coef[11]  =  8'shFF;
assign coef[12]  =  8'shFF;
assign coef[13]  =  8'sh00;
assign coef[14]  =  8'shFF;

// Empaquetado para el puerto i_h
genvar k;
generate
    for (k = 0; k < N_TAPS; k = k + 1) begin : pack
        assign coef_flat[k*NB_INPUT +: NB_INPUT] = coef[k];
    end
endgenerate

// ----------------------------------------------  //

top u_top(
    .coef_flat(coef_flat),
    .clk(clk)
);

endmodule


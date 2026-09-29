module multiplicador
#(
    parameter DATA_LEN = 8
)
(
    input [DATA_LEN-1:0]  i_a,
    input [DATA_LEN-1:0]  i_b,

    output [(2*DATA_LEN)-1:0]  o_y
);

assign o_y = i_a * i_b;

// Implementacion a mano de un multiplcador combinacional de 8 bits, usando sumadores y desplazamientos.

/*
wire [(2*DATA_LEN)-1:0]  acc [DATA_LEN-1:0];


genvar i;
generate
  for (i = 0; i < DATA_LEN; i = i + 1) begin : accumulator
    assign acc[i] = i_a[i] ? (i_b << i) : {2*DATA_LEN{1'b0}};
  end
endgenerate

genvar TC;
genvar i_t;
localparam LEVELS = $clog2(DATA_LEN);
wire [(2*DATA_LEN)-1:0]  acc_i [DATA_LEN-1:0][LEVELS-1:0];

generate
  for (i_t = 1; i_t <= LEVELS; i_t = i_t + 1) begin : tree_gen


for (i = 0; i < (DATA_LEN >> i_t); i = i + 1) begin : adder
  if (i_t == 1) begin : from_pp
    assign acc_i[i][0]      = acc[2*i] + acc[2*i+1];
  end else begin : from_lvl
    assign acc_i[i][i_t-1]  = acc_i[2*i][i_t-2] + acc_i[2*i+1][i_t-2];
  end
end

  end
endgenerate
// 
assign o_y =   acc_i[0][LEVELS-1];
*/
endmodule
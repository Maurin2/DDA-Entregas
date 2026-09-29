module sumador
#(
    parameter DATA_LEN = 4
)
(
    input [DATA_LEN-1:0]  i_a,
    input [DATA_LEN-1:0]  i_b,

    output [DATA_LEN:0]  o_y
);

assign o_y = i_a + i_b - 3'd7; // Se le resta el sesgo

endmodule
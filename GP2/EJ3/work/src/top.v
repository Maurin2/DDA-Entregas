module top
#(
    parameter DATA_LEN = 16
)
(
    input [DATA_LEN-1:0]    i_a,
    input [DATA_LEN-1:0]    i_b,

    input                   SU_op1,     // Signed/Unsigned OP1
    input                   SU_op2,     // Signed/Unsigned OP2
    input                   fractional, 

    output  [2*DATA_LEN-1:0]  o_data,
    output                  o_overflow
);

wire signed [DATA_LEN:0] op1, op2;
wire [2*DATA_LEN-1:0] mult;
wire [2*DATA_LEN-1:0] mult_recortado;
wire corner = (i_a == 16'h8000) & (i_b == 16'h8000); //

wire  flag_recorte = fractional & SU_op1 & SU_op2;

assign op1 = SU_op1? $signed({i_a[DATA_LEN-1], i_a}) : $signed({1'b0 , i_a});
assign op2 = SU_op2? $signed({i_b[DATA_LEN-1], i_b}) : $signed({1'b0 , i_b});

assign mult = op1 * op2;

assign mult_recortado = flag_recorte? {mult[2*DATA_LEN-2:0], 1'b0} : mult;

assign o_overflow = flag_recorte & corner;

assign o_data = o_overflow ? 32'h7FFF_FFFF : mult_recortado;

endmodule



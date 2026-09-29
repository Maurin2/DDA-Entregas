module top
#(
    parameter DATA_LEN = 3
)
(
    input [DATA_LEN-1:0]    i_data1,
    input [DATA_LEN-1:0]    i_data2,
    input [1:0]             i_sel,
    input                   i_reset,
    output [2*DATA_LEN-1:0] o_data,
    output                  o_overflow,
    input  clk
);
wire [DATA_LEN:0] selected_data;

/*
wire [DATA_LEN-1:0] data1, data2;
wire [1:0] sel;
*/

selector#(
    .DATA_LEN(DATA_LEN)
) u_selector(
    .data1(i_data1),
    .data2(i_data2),
    .sel(i_sel),
    .selected_data(selected_data)
);

accumulator#(
    .DATA_LEN(DATA_LEN)
) u_accumulator(
    .selected_data(selected_data),
    .reset(i_reset),
    .data(o_data),
    .overflow(o_overflow),
    .clk(clk)
);



endmodule


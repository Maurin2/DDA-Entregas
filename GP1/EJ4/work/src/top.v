module top
#(
    parameter DATA_LEN = 8
)
(
    input  signed [DATA_LEN-1:0]  i_x,
    output signed [(DATA_LEN + 4) -1:0]  o_y,   //Se le suma 3 para evitar overflow
    input  clk,
    input  i_reset
);
reg signed [DATA_LEN-1:0] x_1;   // x[n-1]
reg signed [DATA_LEN-1:0] x_2;   // x[n-2]
reg signed [DATA_LEN-1:0] x_3;   // x[n-3]

reg signed [(DATA_LEN + 4)-1:0] y_1;   // y[n-1]
reg signed [(DATA_LEN + 4)-1:0] y_2;   // y[n-2]

always @(posedge clk or posedge i_reset) begin
    if (i_reset) begin
        x_1 <= {DATA_LEN{1'b0}};
        x_2 <= {DATA_LEN{1'b0}};
        x_3 <= {DATA_LEN{1'b0}};

        y_1 <= {(DATA_LEN + 3){1'b0}};
        y_2 <= {(DATA_LEN + 3){1'b0}};
    end
    else begin
        x_1 <= i_x;
        x_2 <= x_1;
        x_3 <= x_2;

        y_1 <= o_y;
        y_2 <= y_1;
    end
end

assign o_y = i_x 
            - x_1
            + x_2
            + x_3
            + (y_1 >>> 1)     // desplazamiento aritmetico
            + (y_2 >>> 2);    // desplazamiento aritmetico


endmodule


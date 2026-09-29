module accumulator#(
    parameter DATA_LEN = 3
)(
    input [DATA_LEN:0]      selected_data,  
    input                   reset,
    output [2*DATA_LEN-1:0] data,
    output                  overflow,
    input  clk
);
reg [2*DATA_LEN-1:0] data_r;
reg                  overflow_r;
always @(posedge clk, negedge reset) begin
    if (!reset) begin
        data_r <= 0;
        overflow_r <= 0;
    end else begin
        {overflow_r, data_r} <= data_r + selected_data;
    end
end

assign data = data_r;
assign overflow = overflow_r;
endmodule
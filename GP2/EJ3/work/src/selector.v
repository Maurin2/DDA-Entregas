module selector
#(
    parameter DATA_LEN = 3
)
(
    input  [DATA_LEN-1:0]  data1,
    input  [DATA_LEN-1:0]  data2,
    input  [1:0]           sel,
    output [DATA_LEN:0] selected_data
);
wire [DATA_LEN:0] sum;
wire [DATA_LEN:0] data1_ext, data2_ext;

assign data1_ext = {1'b0, data1};
assign data2_ext = {1'b0, data2};


assign sum = data1_ext + data2_ext;
assign selected_data = (sel == 2'b00) ? data2_ext :
                       (sel == 2'b01) ? sum :
                       (sel == 2'b10) ? data1_ext   :
                            sum; // Por default va a "sum" si sel es 2'b11 (no esta contemplado el caso)

endmodule
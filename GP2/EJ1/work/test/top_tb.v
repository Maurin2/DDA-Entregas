`timescale 1ns/1ps
module tb_top;
    reg  [12:0] a, b;
    wire [12:0] y;
    wire        ovf;
    integer     errores = 0;
    integer     casos_probados = 0;

    top dut (
        .i_a(a),
        .i_b(b),
        .o_y(y),
        .overflow(ovf)
    );

    task check(input [12:0] in_a, input [12:0] in_b,
               input [12:0] y_esp, input ovf_esp);
        begin
            a = in_a;
            b = in_b;
            #10;
            if (ovf !== ovf_esp || (!ovf_esp && y !== y_esp)) begin
                $display("ERROR: a=%h b=%h -> y=%h ovf=%b | esperado y=%h ovf=%b",
                         in_a, in_b, y, ovf, y_esp, ovf_esp);
                errores = errores + 1;
            end else begin
                $display("OK:    a=%h b=%h -> y=%h ovf=%b", in_a, in_b, y, ovf);
            end
            casos_probados = casos_probados + 1;
        end
    endtask

    initial begin
        //IMPORTANTE: los casos fueron generados con case_generator.py
        check({1'b0, 8'h90, 4'd8}, {1'b0, 8'hFE, 4'd14}, {1'b0, 8'h00, 4'd0},      1'b1);
        check({1'b1, 8'hE1, 4'd6}, {1'b0, 8'hFC, 4'd0}, {1'b1, 8'hDD, 4'd0},      1'b0);
        check({1'b1, 8'hEE, 4'd0}, {1'b1, 8'hC4, 4'd7}, {1'b0, 8'hB6, 4'd1},      1'b0);
        check({1'b0, 8'hD1, 4'd0}, {1'b0, 8'h86, 4'd0}, {1'b0, 8'h00, 4'd0},      1'b1);
        check({1'b1, 8'hB7, 4'd13}, {1'b0, 8'hB8, 4'd14}, {1'b1, 8'h00, 4'd0},      1'b1);
        check({1'b1, 8'hBB, 4'd11}, {1'b0, 8'hB8, 4'd14}, {1'b1, 8'h00, 4'd0},      1'b1);
        check({1'b1, 8'h85, 4'd13}, {1'b0, 8'hAF, 4'd9}, {1'b1, 8'hB5, 4'd15},      1'b0);
        check({1'b0, 8'hD5, 4'd13}, {1'b0, 8'hCD, 4'd9}, {1'b0, 8'h00, 4'd0},      1'b1);
        check({1'b1, 8'hE4, 4'd1}, {1'b1, 8'hBE, 4'd12}, {1'b0, 8'hA9, 4'd7},      1'b0);
        check({1'b1, 8'hAC, 4'd11}, {1'b1, 8'h96, 4'd14}, {1'b0, 8'h00, 4'd0},      1'b1);
        check({1'b0, 8'hA9, 4'd12}, {1'b1, 8'hFD, 4'd0}, {1'b1, 8'hA7, 4'd6},      1'b0);
        check({1'b1, 8'h8B, 4'd9}, {1'b1, 8'hAB, 4'd5}, {1'b0, 8'hB9, 4'd7},      1'b0);
        check({1'b0, 8'h83, 4'd6}, {1'b0, 8'hE7, 4'd11}, {1'b0, 8'hEC, 4'd10},      1'b0);
        check({1'b1, 8'hF5, 4'd8}, {1'b0, 8'hE2, 4'd4}, {1'b1, 8'hD8, 4'd6},      1'b0);
        check({1'b0, 8'hED, 4'd1}, {1'b1, 8'hDD, 4'd6}, {1'b1, 8'hCC, 4'd1},      1'b0);
        check({1'b1, 8'hFC, 4'd11}, {1'b1, 8'hD8, 4'd0}, {1'b0, 8'hD4, 4'd5},      1'b0);
        check({1'b1, 8'hF5, 4'd0}, {1'b0, 8'hAD, 4'd5}, {1'b1, 8'h00, 4'd0},      1'b1);
        check({1'b0, 8'hC1, 4'd1}, {1'b0, 8'h95, 4'd0}, {1'b0, 8'h00, 4'd0},      1'b1);
        check({1'b1, 8'h83, 4'd8}, {1'b0, 8'hC4, 4'd3}, {1'b1, 8'hC8, 4'd4},      1'b0);
        check({1'b0, 8'hD8, 4'd9}, {1'b0, 8'hAA, 4'd5}, {1'b0, 8'h8F, 4'd8},      1'b0);

        $display("Fin: %0d casos probados con %0d errores",casos_probados, errores);
        $finish;
    end
endmodule
`timescale 1ns/100ps

module top_optimizado_tb;

    // ---------------- Parametros del DUT ---------------- //
    localparam NB_INPUT   = 16;
    localparam NBF_INPUT  = 15;
    localparam N_TAPS     = 4;
    localparam NB_OUTPUT  = NB_INPUT + $clog2(N_TAPS);   // 18
    localparam NBF_OUTPUT = NBF_INPUT;                   // 15

    // ---------------- Estimulo ---------------- //
    localparam real    PI       = 3.14159265358979;
    localparam real    FS       = 48000.0;
    localparam real    FREQ     = 300.0;     // señal útil
    localparam real    FREQ_PAR = 16000.0;   // parásita: fs/3 cae justo en un cero de H
    localparam integer N_SAMPLE = 4000;
    localparam integer MAX_VAL  =   2**(NB_INPUT-1) - 1;   // +32767
    localparam integer MIN_VAL  = -(2**(NB_INPUT-1));      // -32768

    reg                               clk;
    reg                               reset;
    reg  signed [NB_INPUT-1:0]        i_x_n;
    reg         [N_TAPS*NB_INPUT-1:0] i_h;
    wire signed [NB_OUTPUT-1:0]       o_y_n;

    top_optimizado #(
        .NB_INPUT  (NB_INPUT),
        .NBF_INPUT (NBF_INPUT),
        .N_TAPS    (N_TAPS)
    ) u_top_optimizado (
        .clk   (clk),
        .reset (reset),
        .i_x_n (i_x_n),
        .i_h   (i_h),
        .o_y_n (o_y_n)
    );

    always #10 clk = ~clk;   // 1 muestra por ciclo

    integer n;
    real    v;

    initial begin


        // h[k] va en i_h[k*NB +: NB]; h[0] multiplica a x[n]
        i_h[0*NB_INPUT +: NB_INPUT] = (0.25 * (2.0**NBF_INPUT));   // 16'h2000
        i_h[1*NB_INPUT +: NB_INPUT] = (0.50 * (2.0**NBF_INPUT));   // 16'h4000
        i_h[2*NB_INPUT +: NB_INPUT] = (0.50 * (2.0**NBF_INPUT));
        i_h[3*NB_INPUT +: NB_INPUT] = (0.25 * (2.0**NBF_INPUT));

        clk   = 1'b0;
        reset = 1'b1;
        i_x_n = {NB_INPUT{1'b0}};
        repeat (3) @(posedge clk);
        @(negedge clk)
        reset = 1'b0;

        $display("Simulation Started");
        for (n = 0; n < N_SAMPLE; n = n + 1) begin
            v = 0.5  * $sin(2.0*PI*FREQ    /FS*n)
              + 0.25 * $sin(2.0*PI*FREQ_PAR/FS*n);
            @(posedge clk);                // o_y_n = f(x[n], x[n-1], x[n-2], x[n-3])

            i_x_n <=  v * (2.0**NBF_INPUT);           // cambia en negedge -> estable en el posedge

            @(negedge clk);
        end


        $display("Simulation Finished");
        $finish;
    end

endmodule
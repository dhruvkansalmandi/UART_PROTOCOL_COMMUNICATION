module TEST_UART_RX;
    reg clk;
    reg rst;
    reg TX_start;
    reg [7:0] DATA_in;
    wire [7:0] DATA_out;
    wire parity_error;
    wire stop_error;
    wire op_valid;
    wire TX_busy;

    // Instantiate the Top-level UART module
    UART dut (
        .clk(clk), 
        .rst(rst), 
        .TX_start(TX_start), 
        .DATA_in(DATA_in), 
        .TX_busy(TX_busy), 
        .DATA_out(DATA_out), 
        .parity_error(parity_error), 
        .stop_error(stop_error), 
        .op_valid(op_valid)
    );

    // Clock generation: toggles every 0.001 time units 
    always #0.001 clk = !clk;

    // Task to initialize signals
    task initialize;
        begin
            clk = 0; 
            rst = 0; 
            DATA_in = 0; 
            TX_start = 0; 
        end
    endtask

    // Task to perform a reset
    task reset;
        begin
            rst = 1; 
            #0.002; 
            rst = 0; 
        end
    endtask

    // Task to drive data into the transmitter
    task data;
        begin
            @(negedge clk); 
            TX_start = 1; 
            DATA_in = 8'hAB; // Example 8-bit hex data 
            
            #500 $finish; 
        end
    endtask

    // Main simulation block
    initial begin
        $dumpfile("UART.vcd"); 
        $dumpvars; 
        initialize; 
        reset; 
        data; 
    end

    // Monitor output 
    always @ (posedge op_valid) $strobe ("op_data = %h", DATA_out);

endmodule
module BRG (clk_in, rst, clk_rx, clk_tx);
    parameter n = 50;
    input clk_in;
    input rst;
    output reg clk_rx;
    output reg clk_tx;
    reg [11:0] count;
    reg [4:0] count1;

    always @ (posedge clk_in, posedge rst) begin
        if (rst) count <= 0;
        else begin
            count <= count + 1;
            if (count == n-1) count <= 0;
        end
    end

    always @ (count) begin
        if (count == 0) clk_rx = 1;
        else if (count == (n >> 1)) clk_rx = 0;
        else clk_rx = clk_rx;
    end

    always @ (posedge clk_rx, posedge rst) begin
        if (rst) count1 <= 0;
        else begin
            count1 <= count1 + 1;
            if (count1 == 15) count1 <= 0;
        end
    end

    always @ (count1) begin
        if (count1 == 0) clk_tx = 1;
        else if (count1 == 8) clk_tx = 0;
        else clk_tx = clk_tx;
    end
endmodule
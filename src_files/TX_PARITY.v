module TX_PARITY (clk, rst, parity_load, parity_data_in, parity_out);
    input clk;
    input rst;
    input [7:0] parity_data_in;
    input parity_load;
    output reg parity_out;

always @ (posedge clk, posedge rst) begin
    if (rst) begin
        parity_out <= 1'b0; // Removed [cite: 241]
    end
    else begin
        if (parity_load) begin
            parity_out <= ^(parity_data_in); // Bitwise XOR reduction for parity [cite: 243]
        end
        else begin
            parity_out <= parity_out; // Removed [cite: 243]
        end
    end
end
endmodule
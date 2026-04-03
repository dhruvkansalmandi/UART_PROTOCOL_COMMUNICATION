module TX_FSM(clk, rst, TX_start, select, load, shift, parity_load, TX_busy);
    input clk;
    input rst; 
    input TX_start;
    output reg [1:0] select; 
    output reg load; 
    output reg shift;
    output reg parity_load; 
    output reg TX_busy;

    reg [2:0] count;
    reg count_en;
    wire data_done;

    parameter IDLE   = 3'b000, 
              START  = 3'b001, 
              DATA   = 3'b010, 
              PARITY = 3'b011, 
              STOP   = 3'b100;

    reg [2:0] present_state, next_state;
    assign data_done = (count == 7); 

    // Counter Logic
    always @ (posedge clk, posedge rst) begin 
        if (rst) count <= 0; 
        else begin
            if (count_en) count <= count + 1; 
            else count <= 0; 
        end
    end

    // State Register
    always @ (posedge clk, posedge rst) begin 
        if (rst) present_state <= IDLE; 
        else present_state <= next_state; 
    end

    // Next State Logic
    always @ (*) begin 
        case (present_state) 
            IDLE: if (TX_start) next_state = START; else next_state = IDLE; 
            START: next_state = DATA; 
            DATA: if (data_done) next_state = PARITY; else next_state = DATA; 
            PARITY: next_state = STOP; 
            STOP: if (TX_start) next_state = START; else next_state = IDLE; 
            default: next_state = IDLE;
        endcase
    end

    // Output Logic
    always @ (*) begin 
        case (present_state) 
            IDLE: begin
                select = 2'b11; load = 1'b0; shift = 1'b0; parity_load = 1'b0; TX_busy = 1'b0; count_en = 1'b0; 
            end
            START: begin
                select = 2'b00; load = 1'b1; shift = 1'b0; parity_load = 1'b1; TX_busy = 1'b1; count_en = 1'b0; 
            end
            DATA: begin
                select = 2'b01; load = 1'b0; shift = 1'b1; parity_load = 1'b0; TX_busy = 1'b1; count_en = 1'b1; 
            end
            PARITY: begin
                select = 2'b10; load = 1'b0; shift = 1'b0; parity_load = 1'b0; TX_busy = 1'b1; count_en = 1'b0; 
            end
            STOP: begin
                select = 2'b11; load = 1'b0; shift = 1'b0; parity_load = 1'b0; TX_busy = 1'b1; count_en = 1'b0; 
            end
            default: begin
                select = 2'b11; load = 1'b0; shift = 1'b0; parity_load = 1'b0; TX_busy = 1'b0; count_en = 1'b0;
            end
        endcase
    end
endmodule
module fsm_5sec #(
    parameter int CLK_FREQ = 50_000_000 // parameter type: integer
)(
    input  logic clk,      
    input  logic rst_n,
    input  logic enable,
    output logic [1:0] state_out // register
);

    typedef enum logic [1:0] {
        S0 = 2'b00,
        S1 = 2'b01,
        S2 = 2'b10,
        S3 = 2'b11
    } state_t;

    state_t current_state, next_state;

    // 5 second delay
    localparam int DELAY_CYCLES = 5 * CLK_FREQ;
    logic [31:0] counter;
    logic delay_done;

    // counter block
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= '0; // 
            delay_done <= 1'b0;
        end else if (enable) begin
            if (counter == DELAY_CYCLES - 1) begin
                counter <= '0;
                delay_done <= 1'b1;
            end else begin
                counter <= counter + 1;
                delay_done <= 1'b0;
            end
        end else begin
            counter <= '0;
            delay_done <= 1'b0;
        end
    end

    // State Register
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= S0;
        end else begin
            current_state <= next_state;
        end
    end

    
    always_comb begin
        next_state = current_state; 
        
        if (delay_done) begin
            unique case (current_state)
                S0: next_state = S1;
                S1: next_state = S2;
                S2: next_state = S3;
                S3: next_state = S0;
                default: next_state = S0;
            endcase
        end
    end

    always_comb begin
        state_out = current_state;
    end

endmodule
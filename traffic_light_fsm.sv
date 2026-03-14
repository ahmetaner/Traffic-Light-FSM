module traffic_light_fsm #(
	parameter int CLK_FREQ = 50_000_000 // parameter type integer
)(	input logic clk,
	input logic reset,
	input logic TAORB,
	output logic [1:0] state_out
);

typedef enum logic [1:0] {
	s0 = 2'b00,
	s1 = 2'b01,
	s2 = 2'b10,
	s3 = 2'b11
} state_t;

state_t current_state, next_state;

// 5 seconds delay
localparam int DELAY_CYCLES = 5 * CLK_FREQ;
logic [31:0] counter;
logic delay_done;

// counter block
always_ff @(posedge clk or posedge reset)
	if(reset) begin
		counter <= '0;
		delay_done <= 1'b0;
	end else if(current_state == s0 || current_state == s2) begin
		counter <= '0;
		delay_done <= 1'b0;
	end else if(counter == DELAY_CYCLES - 1) begin
		counter <= '0;
		delay_done <= 1'b1;
	end else begin
		counter <= counter + 1;
		delay_done <= 1'b0;
end


//state register
always_ff @(posedge clk or posedge reset)
	if(reset) begin
		current_state <= s0;
	end else begin
		current_state <= next_state;
end

always_comb begin 
	next_state = current_state;
	unique case(current_state)
		s0: begin
			if(!TAORB) begin
				next_state = s1;
			end
		end
		s1: begin
			if(delay_done) begin
				next_state = s2;
			end
		end
		s2: begin
			if(TAORB) begin
				next_state = s3;
			end
		end
		s3: begin
			if(delay_done) begin
				next_state = s0;
			end
		end
	endcase
end

assign state_out = current_state;
endmodule	
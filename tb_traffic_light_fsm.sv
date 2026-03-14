`timescale 1ns / 1ps

module tb_traffic_light_fsm();

    // 1. Testbench Signals
    logic clk;
    logic reset;
    logic TAORB;
    logic [1:0] state_out;

    localparam int TEST_FREQ = 10;

    traffic_light_fsm #(
        .CLK_FREQ(TEST_FREQ)
    ) uut (
        .clk(clk),
        .reset(reset),
        .TAORB(TAORB),
        .state_out(state_out)
    );

    // 3. Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_traffic_light_fsm);

        reset = 1;
        TAORB = 1; 
        
        #20;
        reset = 0; 
        $display("Time: %0t | Reset was finished. FSM should wait at s0.", $time);

        // s0->s1
        #30;
        TAORB = 0; 
        $display("Time: %0t | TAORB=0. FSM --> s1", $time);

         
        // 50 clock cycle * 10ns = 500ns
        #600;
        $display("Time: %0t | 5 seconds were over. FSM -->s2.", $time);

        // s2->s3
        #50;
        TAORB = 1;
        $display("Time: %0t | TAORB=1. FSM--> s3.", $time);

        // wait500ns)
        #600;
        $display("Time: %0t | 5 second was over. FSM -> s0.", $time);

      
        #100;
        $display("Time: %0t | Simulation completed succesfully", $time);
        $finish;
    end

    // Mobitor block
    always @(state_out) begin
        case(state_out)
            2'b00: $display("-> [STATE CHANGE] New State: s0 (Time: %0t)", $time);
            2'b01: $display("-> [STATE CHANGE] New State: s1 (Time: %0t)", $time);
            2'b10: $display("-> [STATE CHANGE] New State: s2 (Time: %0t)", $time);
            2'b11: $display("-> [STATE CHANGE] New State: s3 (Time: %0t)", $time);
        endcase
    end

endmodule
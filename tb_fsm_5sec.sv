`timescale 1ns / 1ps
module tb_fsm_5sec;
	logic clk;
	logic rst_n;
	logic enable;
	logic[1:0] state_out;
	
	 // call (UUT - Unit Under Test)
    // CLK_FREQ = 10 to make simulation faster
    fsm_5sec #(
        .CLK_FREQ(10) 
    ) uut (
        .clk(clk),
        .rst_n(rst_n),
        .enable(enable),
        .state_out(state_out)
    );
	 
	 always #5 clk = ~clk;
	 
	 initial begin
		// initial values
		clk = 0;
		rst_n = 0;
		enable = 0;
		
		// use $monitor to write instant change
		$monitor("Zaman: %0t ns | Reset: %b | Enable: %b | Durum Çıktısı: %b", 
                 $time, rst_n, enable, state_out);
					  
		// 2. remove reset
      #20 rst_n = 1;
        
      // 3. run FSM
      #10 enable = 1;

      // 4. wait until each state performed
      #2100;

      // 5. exit
      enable = 0;
      #50;
      $display("Simülasyon tamamlandı!");
      $finish;
	end
endmodule
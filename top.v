module top(
	input wire pin_clock,
	input wire pin_n_reset,
	input wire [3:0] pin_switch,
	output wire [3:0] pin_led
);

wire clk;
prescaler #(.RATIO(24_000_000)) prescaler(
	.quick_clock(pin_clock),
	.slow_clock(clk)
);

mother_board mother_board(
	.clk(clk),
	.n_reset(pin_n_reset),
	.switch(pin_switch),
	.led(pin_led)
);

endmodule

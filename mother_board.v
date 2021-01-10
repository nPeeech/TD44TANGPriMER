module mother_board(
	input wire clk,
	input wire n_reset,
	input wire [3:0] switch,
	output wire [3:0] led
);

wire [3:0] addr;
wire [7:0] data;

cpu cpu(.clk(clk), .n_reset(n_reset), .addr(addr), .data(data), .switch(switch), .led(led));
rom rom(.addr(addr), .data(data));

endmodule

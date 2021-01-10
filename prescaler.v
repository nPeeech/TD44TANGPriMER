module prescaler #(parameter RATIO = 2)(
	input wire quick_clock,
	output reg slow_clock
);
	reg [31:0] counter;
	wire [31:0] next_counter;
	wire inv;
	assign inv = (counter ==(RATIO/2 - 1));
	
	assign next_counter = inv ? 32'd0 : counter + 32'd1;
	always @(posedge quick_clock) begin
		counter <= next_counter;
	end
	
	wire next_slow_clock;
	assign next_slow_clock = inv ? ~slow_clock : slow_clock;
	always @(posedge quick_clock) slow_clock <= next_slow_clock;


endmodule
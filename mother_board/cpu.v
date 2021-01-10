module cpu(
	input wire clk,
	input wire n_reset,
	output wire [3:0] addr,
	input wire [7:0] data,
	input wire [3:0] switch,
	output wire [3:0] led
);



reg [3:0] a, next_a; //汎用レジスタ
reg [3:0] b, next_b; //汎用レジスタ
reg cf, next_cf; //キャリーフラグ
reg [3:0] ip, next_ip; //命令ポインタ
reg [3:0] out;
reg [3:0] next_out; //LEDに接続する


always @(posedge clk) begin
	if (~n_reset) begin
		a <= 4'b0;
		b <= 4'b0;
		cf <= 1'b0;
		ip <= 4'b0;
		out <= 4'b0;
	end else begin
		a <= next_a;
		b <= next_b;
		cf <= next_cf;
		ip <= next_ip;
		out <= next_out;
	end
end


wire [3:0] opecode, imm; //ADDやMOV等の命令と，即値を表すワイヤー
assign opecode = data[7:4]; //romから受け取ったデータのMSB側を，命令として解釈
assign imm = data[3:0]; //命令ポインタの値を，アドレスとしてromに渡す
assign addr = ip;
assign led = out; //LEDをoutレジスタで制御



always @* begin
	// next系ワイヤーの値をNOP命令の結果にする
	next_a = a;	// 汎用レジスタは現在の値のままにする
	next_b = b;	//　汎用レジスタは現在の値のままにする
	next_cf = 1'b0;	// キャリーフラグは0にリセットする
	next_ip = ip + 4'b1;	// 命令ポインタは1増やす．
	next_out = out;	// LEDは現在の値のままにする
	
	// next系ワイヤーの値を上塗りして，ADDやMOV等の結果にする
	case (opecode)
		4'b0000: {next_cf, next_a} = a + imm;	// ADD A, IMM
		4'b0101: {next_cf, next_b} = b + imm;	// ADD B, IMM
		4'b0011: next_a = imm;	// MOV A, IMM
		4'b0111: next_b = imm;	// MOV B, IMM
		4'b0001: next_a = b;	// MOV A, B
		4'b0100: next_b = a;	// MOV B, A
		4'b1111: next_ip = imm;	// JMP IMM
		4'b1110: next_ip = cf ? ip + 4'b1 : imm;	// JNC IMM
		4'b0010: next_a = ~switch;	// IN A
		4'b0110: next_b = ~switch;	// IN B	こっちも負論理
		4'b1001: next_out = b;	// OUT B
		4'b1011: next_out = imm;	// OUT IMM
		default: ;
	endcase
end

endmodule

module cpu(
	input wire clk,
	input wire n_reset,
	output wire [3:0] addr,
	input wire [7:0] data,
	input wire [3:0] switch,
	output wire [3:0] led
);



reg [3:0] a, next_a; //�ėp���W�X�^
reg [3:0] b, next_b; //�ėp���W�X�^
reg cf, next_cf; //�L�����[�t���O
reg [3:0] ip, next_ip; //���߃|�C���^
reg [3:0] out;
reg [3:0] next_out; //LED�ɐڑ�����


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


wire [3:0] opecode, imm; //ADD��MOV���̖��߂ƁC���l��\�����C���[
assign opecode = data[7:4]; //rom����󂯎�����f�[�^��MSB�����C���߂Ƃ��ĉ���
assign imm = data[3:0]; //���߃|�C���^�̒l���C�A�h���X�Ƃ���rom�ɓn��
assign addr = ip;
assign led = out; //LED��out���W�X�^�Ő���



always @* begin
	// next�n���C���[�̒l��NOP���߂̌��ʂɂ���
	next_a = a;	// �ėp���W�X�^�͌��݂̒l�̂܂܂ɂ���
	next_b = b;	//�@�ėp���W�X�^�͌��݂̒l�̂܂܂ɂ���
	next_cf = 1'b0;	// �L�����[�t���O��0�Ƀ��Z�b�g����
	next_ip = ip + 4'b1;	// ���߃|�C���^��1���₷�D
	next_out = out;	// LED�͌��݂̒l�̂܂܂ɂ���
	
	// next�n���C���[�̒l����h�肵�āCADD��MOV���̌��ʂɂ���
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
		4'b0110: next_b = ~switch;	// IN B	�����������_��
		4'b1001: next_out = b;	// OUT B
		4'b1011: next_out = imm;	// OUT IMM
		default: ;
	endcase
end

endmodule

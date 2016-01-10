module GammaCorrectionBalanced(x, r, z);

	input [5: 0] x;
	input [9: 0] r;
	output reg z;

	wire wire0_1, wire1_1, wire2_1, wire3_1, wire4_1, wire5_1, wire6_1;
	wire [2: 0] sumOut;

	assign sumOut = x[0] + x[1] + x[2] + x[3] + x[4] + x[5];

	always @(*) begin
		z = 0;
		case(sumOut)
			6'd0: z = wire0_1;
			6'd1: z = wire1_1;
			6'd2: z = wire2_1;
			6'd3: z = wire3_1;
			6'd4: z = wire4_1;
			6'd5: z = wire5_1;
			6'd6: z = wire6_1;
			default: z = 0;
		endcase
	end


	wire wire0_2;
	assign wire0_1 = (r[9] & wire0_2);
	wire wire0_3;
	assign wire0_2 = (r[8] & wire0_3);
	wire wire0_4;
	assign wire0_3 = (r[7] & wire0_4);
	wire wire0_5;
	assign wire0_4 = (r[6] | wire0_5);
	wire wire0_6;
	assign wire0_5 = (r[5] | wire0_6);
	wire wire0_7;
	assign wire0_6 = (r[4] & wire0_7);
	wire wire0_8;
	assign wire0_7 = (r[3] & wire0_8);
	wire wire0_9;
	assign wire0_8 = (r[2] & wire0_9);
	wire wire0_10;
	assign wire0_9 = (r[1] | wire0_10);
	assign wire0_10 = 0;


	wire wire1_2;
	assign wire1_1 = (r[9] | wire1_2);
	wire wire1_3;
	assign wire1_2 = (r[8] & wire1_3);
	wire wire1_4;
	assign wire1_3 = (r[7] | wire1_4);
	assign wire1_4 = wire0_4;


	wire wire2_2;
	assign wire2_1 = (r[9] & wire2_2);
	wire wire2_3;
	assign wire2_2 = (r[8] | wire2_3);
	wire wire2_4;
	assign wire2_3 = (r[7] & wire2_4);
	wire wire2_5;
	assign wire2_4 = (r[6] | wire2_5);
	wire wire2_6;
	assign wire2_5 = (r[5] | wire2_6);
	wire wire2_7;
	assign wire2_6 = (r[4] & wire2_7);
	wire wire2_8;
	assign wire2_7 = (r[3] & wire2_8);
	wire wire2_9;
	assign wire2_8 = (r[2] | wire2_9);
	assign wire2_9 = 0;


	wire wire3_2;
	assign wire3_1 = (r[9] | wire3_2);
	wire wire3_3;
	assign wire3_2 = (r[8] | wire3_3);
	wire wire3_4;
	assign wire3_3 = (r[7] | wire3_4);
	wire wire3_5;
	assign wire3_4 = (r[6] | wire3_5);
	wire wire3_6;
	assign wire3_5 = (r[5] | wire3_6);
	wire wire3_7;
	assign wire3_6 = (r[4] | wire3_7);
	wire wire3_8;
	assign wire3_7 = (r[3] | wire3_8);
	wire wire3_9;
	assign wire3_8 = (r[2] | wire3_9);
	wire wire3_10;
	assign wire3_9 = (r[1] | wire3_10);
	wire wire3_11;
	assign wire3_10 = (r[0] | wire3_11);
	assign wire3_11 = 0;


	wire wire4_2;
	assign wire4_1 = (r[9] | wire4_2);
	wire wire4_3;
	assign wire4_2 = (r[8] & wire4_3);
	wire wire4_4;
	assign wire4_3 = (r[7] | wire4_4);
	wire wire4_5;
	assign wire4_4 = (r[6] | wire4_5);
	wire wire4_6;
	assign wire4_5 = (r[5] & wire4_6);
	wire wire4_7;
	assign wire4_6 = (r[4] & wire4_7);
	assign wire4_7 = wire3_7;


	wire wire5_2;
	assign wire5_1 = (r[9] | wire5_2);
	wire wire5_3;
	assign wire5_2 = (r[8] | wire5_3);
	wire wire5_4;
	assign wire5_3 = (r[7] | wire5_4);
	wire wire5_5;
	assign wire5_4 = (r[6] | wire5_5);
	wire wire5_6;
	assign wire5_5 = (r[5] | wire5_6);
	assign wire5_6 = ~wire3_6;


	wire wire6_2;
	assign wire6_1 = (r[9] | wire6_2);
	wire wire6_3;
	assign wire6_2 = (r[8] | wire6_3);
	wire wire6_4;
	assign wire6_3 = (r[7] | wire6_4);
	wire wire6_5;
	assign wire6_4 = (r[6] | wire6_5);
	wire wire6_6;
	assign wire6_5 = (r[5] | wire6_6);
	wire wire6_7;
	assign wire6_6 = (r[4] | wire6_7);
	wire wire6_8;
	assign wire6_7 = (r[3] | wire6_8);
	assign wire6_8 = wire0_8;


endmodule

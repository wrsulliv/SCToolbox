module PolySmallBalanced(x, r, z);

	input [2: 0] x;
	input [5: 0] r;
	output reg z;

	wire wire0_1, wire1_1, wire2_1, wire3_1;
	wire [1: 0] sumOut;

	assign sumOut = x[0] + x[1] + x[2];

	always @(*) begin
		z = 0;
		case(sumOut)
			3'd0: z = wire0_1;
			3'd1: z = wire1_1;
			3'd2: z = wire2_1;
			3'd3: z = wire3_1;
			default: z = 0;
		endcase
	end


	wire wire0_2;
	assign wire0_1 = (r[5] | wire0_2);
	wire wire0_3;
	assign wire0_2 = (r[4] & wire0_3);
	wire wire0_4;
	assign wire0_3 = (r[3] | wire0_4);
	wire wire0_5;
	assign wire0_4 = (r[2] | wire0_5);
	wire wire0_6;
	assign wire0_5 = (r[1] & wire0_6);
	wire wire0_7;
	assign wire0_6 = (r[0] | wire0_7);
	assign wire0_7 = 0;


	wire wire1_2;
	assign wire1_1 = (r[5] & wire1_2);
	wire wire1_3;
	assign wire1_2 = (r[4] & wire1_3);
	wire wire1_4;
	assign wire1_3 = (r[3] & wire1_4);
	wire wire1_5;
	assign wire1_4 = (r[2] | wire1_5);
	wire wire1_6;
	assign wire1_5 = (r[1] | wire1_6);
	assign wire1_6 = 0;


	assign wire2_1 = ~wire1_1;


	assign wire3_1 = ~wire0_1;


endmodule

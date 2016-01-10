module alaki(x, r, z);

	input [2, 0] x;
	input [3: 0] r;
	output reg z;

	always @(*) begin
		z = 0;
		case(x)
			2'd0: z = temp_wire0_1;
			2'd1: z = temp_wire1_1;
			2'd2: z = temp_wire2_1;
			2'd3: z = temp_wire3_1;
			default: z = 0;
		endcase
	end


	assign wire0_1 = 0;


	assign wire1_1 = (r[3] & wire1_2);
	assign wire1_2 = (r[2] | wire1_3);
	assign wire1_3 = (r[1] & wire1_4);
	assign wire1_4 = (r[0] | wire1_5);
	assign wire1_5 = 0;


	assign wire2_1 = ~wire1_1;


	assign wire3_1 = 1;


endmodule

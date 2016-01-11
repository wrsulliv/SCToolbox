module test(x, r, z);

	input [2: 0] x;
	input [5: 0] r;
	output reg z;

	always @(*) begin
		z = 0;
		case(x)
			3'd0: z = temp_wire0_1;
			3'd1: z = temp_wire1_1;
			3'd2: z = temp_wire2_1;
			3'd3: z = temp_wire3_1;
			3'd4: z = temp_wire4_1;
			3'd5: z = temp_wire5_1;
			3'd6: z = temp_wire6_1;
			3'd7: z = temp_wire7_1;
			default: z = 0;
		endcase
	end


	assign wire0_1 = (r[5] & wire0_2);
	assign wire0_2 = (r[4] & wire0_3);
	assign wire0_3 = (r[3] | wire0_4);
	assign wire0_4 = (r[2] | wire0_5);
	assign wire0_5 = (r[1] & wire0_6);
	assign wire0_6 = (r[0] | wire0_7);
	assign wire0_7 = 0;


	assign wire1_1 = (r[5] & wire1_2);
	assign wire1_2 = ~wire0_2;


	assign wire2_1 = wire1_1;


	assign wire3_1 = (r[5] & wire3_2);
	assign wire3_2 = (r[4] | wire3_3);
	assign wire3_3 = (r[3] | wire3_4);
	assign wire3_4 = (r[2] & wire3_5);
	assign wire3_5 = (r[1] | wire3_6);
	assign wire3_6 = 0;


	assign wire4_1 = wire1_1;


	assign wire5_1 = wire3_1;


	assign wire6_1 = wire3_1;


	assign wire7_1 = (r[5] | wire7_2);
	assign wire7_2 = 0;


endmodule

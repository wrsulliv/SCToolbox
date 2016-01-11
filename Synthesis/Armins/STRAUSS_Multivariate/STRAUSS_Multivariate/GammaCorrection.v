module GammaCorrection(x, r, z);

	input [5: 0] x;
	input [9: 0] r;
	output reg z;

	wire wire0_1, wire1_1, wire2_1, wire3_1, wire4_1, wire5_1, wire6_1, wire7_1, wire8_1, wire9_1, wire10_1, wire11_1, wire12_1, wire13_1, wire14_1, wire15_1, wire16_1, wire17_1, wire18_1, wire19_1, wire20_1, wire21_1, wire22_1, wire23_1, wire24_1, wire25_1, wire26_1, wire27_1, wire28_1, wire29_1, wire30_1, wire31_1, wire32_1, wire33_1, wire34_1, wire35_1, wire36_1, wire37_1, wire38_1, wire39_1, wire40_1, wire41_1, wire42_1, wire43_1, wire44_1, wire45_1, wire46_1, wire47_1, wire48_1, wire49_1, wire50_1, wire51_1, wire52_1, wire53_1, wire54_1, wire55_1, wire56_1, wire57_1, wire58_1, wire59_1, wire60_1, wire61_1, wire62_1, wire63_1;

	always @(*) begin
		z = 0;
		case(x)
			6'd0: z = wire0_1;
			6'd1: z = wire1_1;
			6'd2: z = wire2_1;
			6'd3: z = wire3_1;
			6'd4: z = wire4_1;
			6'd5: z = wire5_1;
			6'd6: z = wire6_1;
			6'd7: z = wire7_1;
			6'd8: z = wire8_1;
			6'd9: z = wire9_1;
			6'd10: z = wire10_1;
			6'd11: z = wire11_1;
			6'd12: z = wire12_1;
			6'd13: z = wire13_1;
			6'd14: z = wire14_1;
			6'd15: z = wire15_1;
			6'd16: z = wire16_1;
			6'd17: z = wire17_1;
			6'd18: z = wire18_1;
			6'd19: z = wire19_1;
			6'd20: z = wire20_1;
			6'd21: z = wire21_1;
			6'd22: z = wire22_1;
			6'd23: z = wire23_1;
			6'd24: z = wire24_1;
			6'd25: z = wire25_1;
			6'd26: z = wire26_1;
			6'd27: z = wire27_1;
			6'd28: z = wire28_1;
			6'd29: z = wire29_1;
			6'd30: z = wire30_1;
			6'd31: z = wire31_1;
			6'd32: z = wire32_1;
			6'd33: z = wire33_1;
			6'd34: z = wire34_1;
			6'd35: z = wire35_1;
			6'd36: z = wire36_1;
			6'd37: z = wire37_1;
			6'd38: z = wire38_1;
			6'd39: z = wire39_1;
			6'd40: z = wire40_1;
			6'd41: z = wire41_1;
			6'd42: z = wire42_1;
			6'd43: z = wire43_1;
			6'd44: z = wire44_1;
			6'd45: z = wire45_1;
			6'd46: z = wire46_1;
			6'd47: z = wire47_1;
			6'd48: z = wire48_1;
			6'd49: z = wire49_1;
			6'd50: z = wire50_1;
			6'd51: z = wire51_1;
			6'd52: z = wire52_1;
			6'd53: z = wire53_1;
			6'd54: z = wire54_1;
			6'd55: z = wire55_1;
			6'd56: z = wire56_1;
			6'd57: z = wire57_1;
			6'd58: z = wire58_1;
			6'd59: z = wire59_1;
			6'd60: z = wire60_1;
			6'd61: z = wire61_1;
			6'd62: z = wire62_1;
			6'd63: z = wire63_1;
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


	assign wire2_1 = wire1_1;


	wire wire3_2;
	assign wire3_1 = (r[9] & wire3_2);
	wire wire3_3;
	assign wire3_2 = (r[8] | wire3_3);
	wire wire3_4;
	assign wire3_3 = (r[7] & wire3_4);
	wire wire3_5;
	assign wire3_4 = (r[6] | wire3_5);
	wire wire3_6;
	assign wire3_5 = (r[5] | wire3_6);
	wire wire3_7;
	assign wire3_6 = (r[4] & wire3_7);
	wire wire3_8;
	assign wire3_7 = (r[3] & wire3_8);
	wire wire3_9;
	assign wire3_8 = (r[2] | wire3_9);
	assign wire3_9 = 0;


	assign wire4_1 = wire1_1;


	assign wire5_1 = wire3_1;


	assign wire6_1 = wire3_1;


	wire wire7_2;
	assign wire7_1 = (r[9] | wire7_2);
	wire wire7_3;
	assign wire7_2 = (r[8] | wire7_3);
	wire wire7_4;
	assign wire7_3 = (r[7] | wire7_4);
	wire wire7_5;
	assign wire7_4 = (r[6] | wire7_5);
	wire wire7_6;
	assign wire7_5 = (r[5] | wire7_6);
	wire wire7_7;
	assign wire7_6 = (r[4] | wire7_7);
	wire wire7_8;
	assign wire7_7 = (r[3] | wire7_8);
	wire wire7_9;
	assign wire7_8 = (r[2] | wire7_9);
	wire wire7_10;
	assign wire7_9 = (r[1] | wire7_10);
	wire wire7_11;
	assign wire7_10 = (r[0] | wire7_11);
	assign wire7_11 = 0;


	assign wire8_1 = wire1_1;


	assign wire9_1 = wire3_1;


	assign wire10_1 = wire3_1;


	assign wire11_1 = wire7_1;


	assign wire12_1 = wire3_1;


	assign wire13_1 = wire7_1;


	assign wire14_1 = wire7_1;


	wire wire15_2;
	assign wire15_1 = (r[9] | wire15_2);
	wire wire15_3;
	assign wire15_2 = (r[8] & wire15_3);
	wire wire15_4;
	assign wire15_3 = (r[7] | wire15_4);
	wire wire15_5;
	assign wire15_4 = (r[6] | wire15_5);
	wire wire15_6;
	assign wire15_5 = (r[5] & wire15_6);
	wire wire15_7;
	assign wire15_6 = (r[4] & wire15_7);
	assign wire15_7 = wire7_7;


	assign wire16_1 = wire1_1;


	assign wire17_1 = wire3_1;


	assign wire18_1 = wire3_1;


	assign wire19_1 = wire7_1;


	assign wire20_1 = wire3_1;


	assign wire21_1 = wire7_1;


	assign wire22_1 = wire7_1;


	assign wire23_1 = wire15_1;


	assign wire24_1 = wire3_1;


	assign wire25_1 = wire7_1;


	assign wire26_1 = wire7_1;


	assign wire27_1 = wire15_1;


	assign wire28_1 = wire7_1;


	assign wire29_1 = wire15_1;


	assign wire30_1 = wire15_1;


	wire wire31_2;
	assign wire31_1 = (r[9] | wire31_2);
	wire wire31_3;
	assign wire31_2 = (r[8] | wire31_3);
	wire wire31_4;
	assign wire31_3 = (r[7] | wire31_4);
	wire wire31_5;
	assign wire31_4 = (r[6] | wire31_5);
	wire wire31_6;
	assign wire31_5 = (r[5] | wire31_6);
	assign wire31_6 = ~wire7_6;


	assign wire32_1 = wire1_1;


	assign wire33_1 = wire3_1;


	assign wire34_1 = wire3_1;


	assign wire35_1 = wire7_1;


	assign wire36_1 = wire3_1;


	assign wire37_1 = wire7_1;


	assign wire38_1 = wire7_1;


	assign wire39_1 = wire15_1;


	assign wire40_1 = wire3_1;


	assign wire41_1 = wire7_1;


	assign wire42_1 = wire7_1;


	assign wire43_1 = wire15_1;


	assign wire44_1 = wire7_1;


	assign wire45_1 = wire15_1;


	assign wire46_1 = wire15_1;


	assign wire47_1 = wire31_1;


	assign wire48_1 = wire3_1;


	assign wire49_1 = wire7_1;


	assign wire50_1 = wire7_1;


	assign wire51_1 = wire15_1;


	assign wire52_1 = wire7_1;


	assign wire53_1 = wire15_1;


	assign wire54_1 = wire15_1;


	assign wire55_1 = wire31_1;


	assign wire56_1 = wire7_1;


	assign wire57_1 = wire15_1;


	assign wire58_1 = wire15_1;


	assign wire59_1 = wire31_1;


	assign wire60_1 = wire15_1;


	assign wire61_1 = wire31_1;


	assign wire62_1 = wire31_1;


	wire wire63_2;
	assign wire63_1 = (r[9] | wire63_2);
	wire wire63_3;
	assign wire63_2 = (r[8] | wire63_3);
	wire wire63_4;
	assign wire63_3 = (r[7] | wire63_4);
	wire wire63_5;
	assign wire63_4 = (r[6] | wire63_5);
	wire wire63_6;
	assign wire63_5 = (r[5] | wire63_6);
	wire wire63_7;
	assign wire63_6 = (r[4] | wire63_7);
	wire wire63_8;
	assign wire63_7 = (r[3] | wire63_8);
	assign wire63_8 = wire0_8;


endmodule

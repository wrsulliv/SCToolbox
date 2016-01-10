function CompareAllMethods(BernTT, noOfR, filename_prefix, result_filename)

	%given a BernTT, compares all methods
	%does not include LFSR area

	if(exist(result_filename) == 0)
		fp = fopen(result_filename, 'w');
		fprintf(fp, 'BernTTSize,noOfR,BernCompLiteralCount,BernCompArea,BernCompMultiLiteralCount,BernCompMultiArea,');
		fprintf(fp, 'SymCompLiteralCount,SymCompArea,AsymCompLiteralCount,AsymCompArea,');
		fprintf(fp, 'BernICCDLiteralCount,BernICCDArea,SymICCDLiteralCount,SymICCDArea,AsymICCDLiteralCount,AsymICCDArea,');
		fprintf(fp, 'BernTCADLiteralCount,BernTCADArea,SymTCADLiteralCount,SymTCADArea,AsymTCADLiteralCount,AsymTCADArea,AsymSlowGreedyLiteralCount,AsymSlowGreedyArea,AsymExhaustiveLiteralCount,AsymExhaustiveArea');
		fflush(fp);
		
	else
		fp = fopen(result_filename, 'a');
	end
	
	%results include 
	%BernTT size, noOfR, litera and area of, BernComparator, BernCompMulti, SymComparator, AsymComparator
	%BernICCD, SymICCD, AsymICCD
	%BernTCAD, SymTCAD, AsymTCAD, AsymSlowGreedy, AsymExhaustive

	fprintf(fp, '\n%d,%d,', length(BernTT), noOfR);
	fflush(fp);

	noOfX = length(BernTT) - 1;

	SymTT = Bern2TTSymQuantized(BernTT, noOfR)

	%search for best asym using the fast greedy algorithm
	printf('\ncalculating asym TT via fast greedy ...\n');
	fflush(stdout);
	AsymFastGreedyTT = GreedySearchForAsymScalable(BernTT, noOfR)
	printf('\nDone!\n');
	fflush(stdout);


	%Bern Comparator Single LFSR
	filename = sprintf('%s_BernCompSingle.blif', filename_prefix);
	modelname = sprintf('%s_BernCompSingle', filename_prefix);
	WriteBLIFBernCompareSingleLFSR(BernTT, noOfX, noOfR, filename, modelname);
	lit = CalculateSoP(filename);
	area = CalculateArea(filename);
	fprintf(fp, '%d,%f,', lit, area);
	fflush(fp);
	printf('\nBernCompSingle, literal = %d, area = %f\n', lit, area);
	fflush(stdout);


	%Bern Comparator Multi LFSR
	filename = sprintf('%s_BernCompMulti.blif', filename_prefix);
	modelname = sprintf('%s_BernCompMulti', filename_prefix);
	WriteBLIFBernCompareMultiLFSR(BernTT, noOfX, noOfR, filename, modelname);
	lit = CalculateSoP(filename);
	area = CalculateArea(filename);
	fprintf(fp, '%d,%f,', lit, area);
	fflush(fp);
	printf('\nBernCompMulti, literal = %d, area = %f\n', lit, area);
	fflush(stdout);

	%Symmetric Comparator 
	filename = sprintf('%s_SymComp.blif', filename_prefix);
	modelname = sprintf('%s_SymComp', filename_prefix);
	WriteBLIFCompare(SymTT, noOfX, noOfR, filename, modelname);
	lit = CalculateSoP(filename);
	area = CalculateArea(filename);
	fprintf(fp, '%d,%f,', lit, area);
	fflush(fp);
	printf('\nSymComp, literal = %d, area = %f\n', lit, area);
	fflush(stdout);

	%Asymmetric Comparator 
	filename = sprintf('%s_AsymComp.blif', filename_prefix);
	modelname = sprintf('%s_AsymComp', filename_prefix);
	WriteBLIFCompare(AsymFastGreedyTT, noOfX, noOfR, filename, modelname);
	lit = CalculateSoP(filename);
	area = CalculateArea(filename);
	fprintf(fp, '%d,%f,', lit, area);
	fflush(fp);
	printf('\nAsymComp, literal = %d, area = %f\n', lit, area);
	fflush(stdout);

	%Bern ICCD
	filename = sprintf('%s_BernICCD.blif', filename_prefix);
	modelname = sprintf('%s_BernICCD', filename_prefix);
	WriteBLIFBernWithoutSharing(BernTT, noOfX, noOfR, filename, modelname);
	lit = CalculateSoP(filename);
	area = CalculateArea(filename);
	fprintf(fp, '%d,%f,', lit, area);
	fflush(fp);
	printf('\nBernICCD, literal = %d, area = %f\n', lit, area);
	fflush(stdout);

	%Sym ICCD
	filename = sprintf('%s_SymICCD.blif', filename_prefix);
	modelname = sprintf('%s_SymICCD', filename_prefix);
	WriteBLIFWithoutSharing(SymTT, noOfX, noOfR, filename, modelname);
	lit = CalculateSoP(filename);
	area = CalculateArea(filename);
	fprintf(fp, '%d,%f,', lit, area);
	fflush(fp);
	printf('\nSymICCD, literal = %d, area = %f\n', lit, area);
	fflush(stdout);

	%Asym ICCD
	filename = sprintf('%s_AsymICCD.blif', filename_prefix);
	modelname = sprintf('%s_AsymICCD', filename_prefix);
	WriteBLIFWithoutSharing(AsymFastGreedyTT, noOfX, noOfR, filename, modelname);
	lit = CalculateSoP(filename);
	area = CalculateArea(filename);
	fprintf(fp, '%d,%f,', lit, area);
	fflush(fp);
	printf('\nAsymICCD, literal = %d, area = %f\n', lit, area);
	fflush(stdout);

	%Bern TCAD
	filename = sprintf('%s_BernTCAD.blif', filename_prefix);
	modelname = sprintf('%s_BernTCAD', filename_prefix);
	WriteBLIFBernWithSharing(BernTT, noOfX, noOfR, filename, modelname);
	lit = CalculateSoP(filename);
	area = CalculateArea(filename);
	fprintf(fp, '%d,%f,', lit, area);
	fflush(fp);
	printf('\nBernTCAD, literal = %d, area = %f\n', lit, area);
	fflush(stdout);

	%Sym TCAD
	filename = sprintf('%s_SymTCAD.blif', filename_prefix);
	modelname = sprintf('%s_SymTCAD', filename_prefix);
	WriteBLIFWithSharing(SymTT, noOfX, noOfR, filename, modelname);
	lit = CalculateSoP(filename);
	area = CalculateArea(filename);
	fprintf(fp, '%d,%f,', lit, area);
	fflush(fp);
	printf('\nSymTCAD, literal = %d, area = %f\n', lit, area);
	fflush(stdout);

	%Asym TCAD
	filename = sprintf('%s_AsymTCAD.blif', filename_prefix);
	modelname = sprintf('%s_AsymTCAD', filename_prefix);
	WriteBLIFWithSharing(AsymFastGreedyTT, noOfX, noOfR, filename, modelname);
	lit = CalculateSoP(filename);
	area = CalculateArea(filename);
	fprintf(fp, '%d,%f,', lit, area);
	fflush(fp);
	printf('\nAsymTCAD, literal = %d, area = %f\n', lit, area);
	fflush(stdout);

	%search for best asym using the slow greedy algorithm
	printf('\ncalculating asym TT via slow greedy ...\n');
	fflush(stdout);
	AsymSlowGreedyTT = GreedySearchForAsym(BernTT, noOfR)
	printf('\nDone!\n');
	fflush(stdout);

	%Asym TCAD slow greedy
	filename = sprintf('%s_AsymTCADSlow.blif', filename_prefix);
	modelname = sprintf('%s_AsymTCADSlow', filename_prefix);
	WriteBLIFWithSharing(AsymSlowGreedyTT, noOfX, noOfR, filename, modelname);
	lit = CalculateSoP(filename);
	area = CalculateArea(filename);
	fprintf(fp, '%d,%f,', lit, area);
	fflush(fp);
	printf('\nAsymTCADSlow, literal = %d, area = %f\n', lit, area);
	fflush(stdout);

	%search for best asym using the exhaustive algorithm
	printf('\ncalculating asym TT via exhaustive ...\n');
	fflush(stdout);
	AsymExhaustiveTT = ExhaustiveSearchForAsym(BernTT, noOfR)
	printf('\nDone!\n');
	fflush(stdout);
	
	%Asym TCAD exhaustive
	filename = sprintf('%s_AsymTCADExhaustive.blif', filename_prefix);
	modelname = sprintf('%s_AsymTCADExhaustive', filename_prefix);
	WriteBLIFWithSharing(AsymExhaustiveTT, noOfX, noOfR, filename, modelname);
	lit = CalculateSoP(filename);
	area = CalculateArea(filename);
	fprintf(fp, '%d,%f,', lit, area);
	fflush(fp);
	printf('\nAsymTCADExhaustive, literal = %d, area = %f\n', lit, area);
	fflush(stdout);

	fflush(fp);
	fclose(fp);
end

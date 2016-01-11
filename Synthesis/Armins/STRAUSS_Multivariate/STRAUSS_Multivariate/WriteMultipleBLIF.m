function WriteMultipleBLIF(TTs, filename_prefix, noOfR, TTSym)

	%writes BLIF files for all asym TTs in TTs, and a TTSym

	ll = size(TTs, 1);
	noOfX = log2(size(TTs, 2));

	for i = 1:ll
		filename = sprintf('%s_%d.blif', filename_prefix, i);
		modelname = sprintf('%s_%d', filename_prefix, i);
		WriteBLIFWithSharing(TTs(i, :), noOfX, noOfR, filename, modelname);
	end

	filename = sprintf('%s_sym.blif', filename_prefix);
	modelname = sprintf('%s_sym.blif', filename_prefix);
	WriteBLIFWithSharing(TTSym, noOfX, noOfR, filename, modelname);



end

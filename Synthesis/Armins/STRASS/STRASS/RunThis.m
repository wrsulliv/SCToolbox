function RunThis(a)

	TTSym = Bern2TTSym(a)
	TTAsym = Bern2TTAsym(a)

	TT1 = UP2IBP(TTSym)
	TT2 = UP2IBP(TTAsym)

	FF1 = (walsh(log2(length(TT1)))*TT1')'
	FF2 = (walsh(log2(length(TT1)))*TT2')'


%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Prepare the Dataset
%%%%%%%%%%%%%%%%%%%%%%%%%%%
load iris_dataset.mat
phi = mapminmax(irisInputs)';
t = irisTargets;

%%%%%%%%%%%%%%%%%%%%%%%%%%%
% User Defined Variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%
hiddenLayerDepth = 1;
hiddenLayerBreadth = 1;
N = 300;

[sc_error, nnt_error] = SNN(hiddenLayerDepth, hiddenLayerBreadth, N, phi, t);
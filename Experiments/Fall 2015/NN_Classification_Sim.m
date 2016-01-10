function nnData = NN_Classification_Sim(seed, hiddenLayerDepth, hiddenLayerBreadth, data, numClasses, trainPercentage)
%{

Explanation:
    Constructs a new neural network for user set combination of hidden
    layer breadth and depth, as well as bit-stream length.  

%}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Set User Defined Parameters 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% net_error and sc_error are matrices of (breadth x depth)
rng(seed)
format short g;
nnData = NNData;

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Prepare the Dataset
%%%%%%%%%%%%%%%%%%%%%%%%%%%

numSamples = size(data, 1);

% Shuffle rows of the dataset
data = data(randperm(numSamples), :);


numTrain = floor(numSamples*trainPercentage);
numTest = numSamples - numTrain;
numFeatures = size(data, 2) - 1;


phi_all = mapminmax(data(:,1:end-1)')';
phi_train = phi_all(1:numTrain,:);
phi_test = phi_all(numTrain+1:end,:);
labels = data(:,end);
label_offset = 0;
if (min(labels) == 0)
    label_offset = 1;  %  Offset the labels for the 0 indexed labels
end
t_all = zeros(numClasses, numSamples); % A (numClasses) x (numSamples) matrix
for i = 1:length(labels)
    t_all(labels(i) + label_offset, i) = 1;
end
t_train = t_all(:, 1:numTrain);
t_test = t_all(:, numTrain+1:end);



%  Comment the above and use this for Iris
% load iris_dataset.mat
% phi = mapminmax(irisInputs)';
% t = irisTargets;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Calculated Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
numOfLayers = hiddenLayerDepth + 1;  % One output layer
numNodesInLayer = [ones(1, hiddenLayerDepth)*hiddenLayerBreadth numClasses];
numInputsToNeuronsInLayer = [(numFeatures+1) ones(1,hiddenLayerDepth)*(hiddenLayerBreadth+1)];

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Create the Network
%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Create a Pattern Recognition Network
hiddenLayerVector = ones(1, hiddenLayerDepth).*hiddenLayerBreadth;
hiddenLayerSizes = hiddenLayerVector;
net = patternnet(hiddenLayerSizes);

% Choose Input and Output Pre/Post-Processing Functions
% For a list of all processing functions type: help nnprocess
net.input.processFcns = {};
net.output.processFcns = {};

%for iii = 1:numel(net.inputs{1}.processFcns)
%      phi = feval( net.inputs{1}.processFcns{iii}, ...
%          'apply', phi, net.inputs{1}.processSettings{iii} );
%end

%net.inputs{1}.processFcns = {'mapminmax'};
%net.outputs{2}.processFcns = {};


% Setup Division of Data for Training, Validation, Testing
% For a list of all data division functions type: help nndivide
net.divideFcn = 'dividerand';  % Divide data randomly
net.divideMode = 'sample';  % Divide up every sample
net.divideParam.trainRatio = 100/100;
%net.divideParam.valRatio = 15/100;
%net.divideParam.testRatio = 15/100;

% For help on training function 'trainscg' type: help trainscg
% For a list of all training functions type: help nntrain

% Note:  The default for the toolbox is set to "trainscg"
net.trainFcn = 'trainlm';  % Scaled conjugate gradient

% Choose a Performance Function
% For a list of all performance functions type: help nnperformance
net.performFcn = 'mse';  % Cross-entropy

% Choose Plot Functions
% For a list of all plot functions type: help nnplot
net.plotFcns = {'plotperform','plottrainstate','ploterrhist', ...
  'plotregression', 'plotfit'};



% Train the Network
[net,tr] = train(net,phi_train',t_train);



nnData.net = net;
nnData.phi_test = phi_test;
nnData.t_test = t_test;
nnData.numSamples = numSamples;
nnData.seed = seed;
nnData.numTest = numTest;
nnData.numTrain = numTrain;
nnData.numFeatures = numFeatures;
nnData.numOfLayers = numOfLayers;
nnData.numNodesInLayer = numNodesInLayer;
nnData.numInputsToNeuronsInLayer = numInputsToNeuronsInLayer;
nnData.numClasses = numClasses;


end
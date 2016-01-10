function [sc_error, nnt_error] = SNN(hiddenLayerDepth, hiddenLayerBreadth, N, phi, t)

%{

Explanation:
    Constructs a new neural network for user set combination of hidden
    layer breadth and depth, as well as bit-stream length.  

%hiddenLayerDepth = How many hidden layers (includes the input layer)
%hiddenLayerBreadth = How many neurons in each hidden layer (includes the input layer)
N = Bitstream Length;
phi = Matrix where every row is a sample, and each column is the value of a
feature. 
t = The target matrix, where each row is a sample target, and the column
represents the 1-of-K class.  
%}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Calculated Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
numOfLayers = hiddenLayerDepth + 1;  % One output layer
numNodesInLayer = [ones(1, hiddenLayerDepth)*hiddenLayerBreadth size(t, 1)];
numInputsToNeuronsInLayer = [(size(phi, 2)+1) ones(1,hiddenLayerDepth)*(hiddenLayerBreadth+1)];
numSamples = size(phi, 1);

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
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;

% For help on training function 'trainscg' type: help trainscg
% For a list of all training functions type: help nntrain
net.trainFcn = 'trainscg';  % Scaled conjugate gradient

% Choose a Performance Function
% For a list of all performance functions type: help nnperformance
net.performFcn = 'mse';  % Cross-entropy

% Choose Plot Functions
% For a list of all plot functions type: help nnplot
net.plotFcns = {'plotperform','plottrainstate','ploterrhist', ...
  'plotregression', 'plotfit'};



% Train the Network
[net,tr] = train(net,phi',t);

%  Now that the network is trained, we can extract the weights and use
%  these in our stochastic network

% We can extract the biases for the (ith) layer with: net.b{i}  The result
% will be an (M) dimensional vector where M is the number of neurons in the
% (ith) layer.


%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Prepare for SC
%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Find the normalization constant for all the weights / bias vectors
all_w = getwb(net);
norm_c = max(abs(all_w));

%
%  Extra information:  calculating a lower bound on N
%

% Note, one simple test to get an estimate for a lower bound on N is to
% multiply the smallest absolute valued, non-zero weight and the smallest 
% absolute valued, non-zero input.  While other numbers
% may be smaller within the activation function, this is the smallest
% number which will have to be represented from the inputs to the NN alone.

% We can get a lower bound for N (bit-stream length) by:
% N > 1/(smallest represented value);

% There is no upper bound on N, but in general, the larger N, the more 
% computation time, but the more accurate. 

dummy_weights = getwb(net); % Make a copy of the weights
dummy_weights(dummy_weights == 0) = 1;
dummy_weights(abs(dummy_weights) < 10^(-14)) = 1;
min_nonzero_weight = min(abs(dummy_weights));

dummy_phi = phi;  % Make a copy of phi
dummy_phi(dummy_phi == 0) = 1; %  Set all zeros to 1
dummy_phi(abs(dummy_phi) < 10^(-14)) = 1;
min_nonzero_input = min(min(abs(dummy_phi)));


N_lower_bound = 1/(min_nonzero_weight*min_nonzero_input)

%norm_c = 1;

%{
    How do I access the neural network weights?

    The biases for each layer are stored in net.b{l}
    The bias to the kth neuron in the lth layer is net.b{l}(k) 

    The weights to the input layer are in a different variable than the weights
    to the other layers.  To get the weights to the input layer, use
    net.IW{1}(k,w) where k is the neuron and w is the weight.  

    Now, for non-input layers, to get the weights to layer i from layer j, use 
    net.LW{i,j}(k,w) where w is the weight and k is the neuron. 

%}

% Divide the weights and biases to scale between -1 and 1.
sc_b = gdivide(net.b, norm_c);
sc_IW = gdivide(net.IW, norm_c);
sc_LW = gdivide(net.LW, norm_c);



FSM_STATES_I = ceil(norm_c*2*numInputsToNeuronsInLayer(1));
FSM_STATES_HO = ceil(norm_c*2*numInputsToNeuronsInLayer(2));
    


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Perform the Feedforward
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    results = [];
    for i = 1:numSamples
        i;
        % Get the sample point
        x = (phi(i,:)');
        
        % Convert the input to the Uni-Polar range
        dec_signals_squished = BIPOL_2_UNIPOL([x; 1]);

        % Convert the decimal values to stochastic numbers
        sc_signals = DEC2SC_ARRAY(dec_signals_squished, N);

        % Start the feedforward propogation
        % At the output of each layer we should get a vector which represents
        % the input to the next layer

        current_input_normal = sc_signals;
        current_output = [];
        for l = 1:numOfLayers
            current_output = [];
            for k = 1:numNodesInLayer(l)

                %  Differentiate between the input layer weights and other
                %  layers
                if(l == 1)
                    % For the first layer the three correlation types
                    % remain the same.

                    % We need to generate the sc weight matrix which is
                    % (size(phi, 2) + 1) x (N)
                    weights = [sc_IW{1}(k,:)'; sc_b{l}(k)];
                    dec_weights_squished = BIPOL_2_UNIPOL(weights);
                    sc_weights = DEC2SC_ARRAY(dec_weights_squished, N);
                    current_output = [current_output; NEURON(current_input_normal, sc_weights, FSM_STATES_I, false, false)];

                elseif(l == numOfLayers)
                    weights = [sc_LW{l,l-1}(k,:)'; sc_b{l}(k)];
                    dec_weights_squished = BIPOL_2_UNIPOL(weights);
                    sc_weights = DEC2SC_ARRAY(dec_weights_squished, N);
                    current_output = [current_output; NEURON(current_input_normal, sc_weights, 0, false, true)];
                else
                    weights = [sc_LW{l,l-1}(k,:)'; sc_b{l}(k)];
                    dec_weights_squished = BIPOL_2_UNIPOL(weights);
                    sc_weights = DEC2SC_ARRAY(dec_weights_squished, N);
                    current_output = [current_output; NEURON(current_input_normal, sc_weights, FSM_STATES_HO, false, false)];
                end

            end

            % Update the current input
            current_input_normal = [current_output; ones(1, N)];
        end


        % Now that we have the stochastic outputs, we need to convert these
        % to decimal again.
        dec_out = S2D_ARRAY(current_output);

        % Convert the decimal numbers back to the original space
        dec_out = UNIPOL_2_BIPOL(dec_out);

        % Use the softmax function to get a valid posterior distribution
        output = softmax(dec_out)';

        output = output - max(output);
        output = (output >= 0);
        results = [results; output];
    end

    % Print the misclassification count error 
    sc_error = sum(sum(abs((results - t')), 2) > 0) / length(t);
    
    raw_output = sim(net, phi');
    actual_output = (raw_output - ones(3, 1)*max(raw_output)) >= 0;
    nnt_error = sum(sum(abs((actual_output' - t')), 2) > 0) / length(t);


end
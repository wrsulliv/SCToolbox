%{

Explanation:
    Plots bit-stream length vs. Classification Error for the Iris dataset using
    a stochastic, feedforward network with 1 hidden layer, where the state
    machine size is set by the smallest of all the weights. 

Notes:
    This is the file I used to generate the plot given at the end of the
    winter term presentation.

%}

clear all;
load iris_dataset.mat


phi = mapminmax(irisInputs)';
% Normalize the data
%mean_sample = mean(phi);
%phi = phi - ones(size(phi, 1), 1)*mean_sample;
%phi_std = sqrt(var(phi));
%std_mat = ones(size(phi, 1), 1)*sqrt(var(phi));
%phi = phi ./ std_mat;

% Scale everything between -1 and 1
%phi = phi ./ max(max(abs(phi)));

t = irisTargets;

% Create a Pattern Recognition Network
hiddenLayerSize = 1;
net = patternnet(hiddenLayerSize);

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

% Find the normalization constant for all the weights / bias vectors
all_w = getwb(net);
norm_c = max(abs(all_w));
%norm_c = 1;

% Get the first layer inputs
l1_weights = [net.b{1}; net.IW{1}']./norm_c;

% Get the biases for the next layer which consists of three neurons
l2_biases = [net.b{2}]./norm_c;
l2_weights = [net.LW{2}]./norm_c;

% Get the weights of these three output neurons
l2wn1 = [l2_biases(1); l2_weights(1)]./norm_c;
l2wn2 = [l2_biases(2); l2_weights(2)]./norm_c;
l2wn3 = [l2_biases(3); l2_weights(3)]./norm_c;

% Lets loop through the inputs to see 
% TODO:  We have scaled the weights, but we have not adjusted the neuron
% output functions to correct for this change.  So, the outputs may not be
% correct.

sc_error = [];
space = 30000:1000:30000;
for N = space%  Stochastic number length
    N
    FSM_STATES = ceil(norm_c*2*length(l1_weights));
    AVG_STEPS = 1;

    neuron_output = zeros(1,size(-1:.01:1,2));

    % Convert the decimal weights to stochastic weights
    l1_weights_squished = BIPOL_2_UNIPOL(l1_weights);
    l1_weights_sc = DEC2SC_ARRAY(l1_weights_squished, N);

    % Convert the decimal weights of the output layers to stochastic
    % weights.
    l2wn1_squished = BIPOL_2_UNIPOL(l2wn1);
    l2wn1_sc = DEC2SC_ARRAY(l2wn1_squished, N);

    l2wn2_squished = BIPOL_2_UNIPOL(l2wn2);
    l2wn2_sc = DEC2SC_ARRAY(l2wn2_squished, N);

    l2wn3_squished = BIPOL_2_UNIPOL(l2wn3);
    l2wn3_sc = DEC2SC_ARRAY(l2wn3_squished, N);
        

    results = [];
    for i = 1:size(phi,1)
        % Get the sample point
        x = (phi(i,:)');

        % Convert the input to the Uni-Polar range
        dec_signals_squished = BIPOL_2_UNIPOL([1; x]);
        
        % Convert the decimal values to stochastic numbers
        sc_signals = DEC2SC_ARRAY(dec_signals_squished, N);
        
        % Remember: the sigmoidal activation function is equivelent to
        % tanh(Nx/2) (where N is the number of FSM states).  
        % Normally the network would just perform tanh(x),
        % but we have divided x by norm_c.  So, we need to multiply x
        % by norm_c.  So, N/2 = norm_c.  => N = norm_c*2.
        input_out = NEURON(sc_signals, l1_weights_sc, FSM_STATES, false, false);        

        % Let's check this output (This is only for debugging)
        expected = tanh(norm_c*[1;x]'*l1_weights);
        actual = UNIPOL_2_BIPOL(S2D_ARRAY(input_out));
        
        %input_out = BIPOL_2_UNIPOL(expected);
        %input_out = DEC2SC_ARRAY(input_out, N);
        
        % Put the first output into the last layer (FSM_STATES is zero becuase 
        % it's not applicable for linear neurons)
        out_1 = NEURON([ones(1, N);input_out], l2wn1_sc, 0, false, true); 
        out_2 = NEURON([ones(1, N);input_out], l2wn2_sc, 0, false, true); 
        out_3 = NEURON([ones(1, N);input_out], l2wn3_sc, 0, false, true); 
        
        % Now that we have the stochastic outputs, we need to convert these
        % to decimal again.
        dec_out_1 = S2D_ARRAY(out_1);
        dec_out_2 = S2D_ARRAY(out_2);
        dec_out_3 = S2D_ARRAY(out_3);
        
        % Convert the decimal numbers back to the original space
        dec_out_1 = UNIPOL_2_BIPOL(dec_out_1);
        dec_out_2 = UNIPOL_2_BIPOL(dec_out_2);
        dec_out_3 = UNIPOL_2_BIPOL(dec_out_3);
        
        % Use the softmax function to get a valid posterior distribution
        output = softmax([dec_out_1; dec_out_2; dec_out_3])';

        output = output - max(output);
        output = (output >= 0);
        results = [results; output];
    end
    
% Print the misclassification count error 
my_error = sum(sum(abs((results - t')), 2) > 0) / length(t);
sc_error = [sc_error my_error];
end

plot(space, sc_error)
% Test the network on all the data
output = sim(net, phi');
output = (output - ones(3, 1)*max(output)) >= 0;
net_error = sum(sum(abs((output' - t')), 2) > 0) / length(t);

% Test the Network
y = net(phi');
e = gsubtract(t,y);
tind = vec2ind(t);
yind = vec2ind(y);
percentErrors = sum(tind ~= yind)/numel(tind);
performance = perform(net,t,y)

% Recalculate Training, Validation and Test Performance
trainTargets = t .* tr.trainMask{1};
valTargets = t  .* tr.valMask{1};
testTargets = t  .* tr.testMask{1};
trainPerformance = perform(net,trainTargets,y)
valPerformance = perform(net,valTargets,y)
testPerformance = perform(net,testTargets,y)

% View the Network
view(net)

% Plots
% Uncomment these lines to enable various plots.
%figure, plotperform(tr)
%figure, plottrainstate(tr)
%figure, plotconfusion(t,y)
%figure, plotroc(t,y)
%figure, ploterrhist(e)

% Deployment
% Change the (false) values to (true) to enable the following code blocks.
if (false)
  % Generate MATLAB function for neural network for application deployment
  % in MATLAB scripts or with MATLAB Compiler and Builder tools, or simply
  % to examine the calculations your trained neural network performs.
  genFunction(net,'myNeuralNetworkFunction');
  y = myNeuralNetworkFunction(x);
end
if (false)
  % Generate a matrix-only MATLAB function for neural network code
  % generation with MATLAB Coder tools.
  genFunction(net,'myNeuralNetworkFunction','MatrixOnly','yes');
  y = myNeuralNetworkFunction(x);
end
if (false)
  % Generate a Simulink diagram for simulation or deployment with.
  % Simulink Coder tools.
  gensim(net);
end

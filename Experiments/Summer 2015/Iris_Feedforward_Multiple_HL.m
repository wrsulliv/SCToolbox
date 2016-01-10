%{

Explanation:
    Constructs a new neural network for user set combination of hidden
    layer breadth and depth, as well as bit-stream length.  

%}

clear all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Set User Defined Parameters 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% net_error and sc_error are matrices of (breadth x depth)
 rng(4151945)
net_error = [];
sc_error = [];
debug_error = [];
max_depth = 3;
max_breadth = 4;
format short g;

for hiddenLayerDepth = 1:max_depth
    hiddenLayerDepth
    for hiddenLayerBreadth = 2:max_breadth
        hiddenLayerBreadth
   
        clearvars -except net_error sc_error debug_error hiddenLayerDepth hiddenLayerBreadth max_depth max_breadth
        
%hiddenLayerDepth = 3; % How many hidden layers (includes the input layer)
%hiddenLayerBreadth = 10; % How many neurons in each hidden layer (includes the input layer)
N = 50000;


%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Prepare the Dataset
%%%%%%%%%%%%%%%%%%%%%%%%%%%
load iris_dataset.mat
phi = mapminmax(irisInputs)';
t = irisTargets;


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
min_weight = min(abs(all_w));

% Note that we can get a lower bound for N (bit-stream length) by:
% N > 1/min_weight;

% There is no upper bound on N, but in general, the larger N, the more 
% computation time, but the more accurate. 

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
    results_debug = [];
    network_percent_error_map = zeros(numOfLayers, max(numNodesInLayer)); % Create a map to show which neurons have the most error
    for sample = 55:55
        sample
        % Get the sample point
        x = [phi(sample,:)'; 1];
        
        % Convert the input to the Uni-Polar range
        dec_signals_squished = BIPOL_2_UNIPOL(x);

        % Convert the decimal values to stochastic numbers
        sc_signals = DEC2SC_ARRAY(dec_signals_squished, N);

        % Start the feedforward propogation
        % At the output of each layer we should get a vector which represents
        % the input to the next layer
        current_input_debug = x; % Used to perform my own feedforward in software without the NN Toolbox
        current_output_debug = [];
        current_input_normal = sc_signals;
        current_output = [];
        for l = 1:numOfLayers
            current_output = [];
            current_output_debug = [];
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
                    neuron_out = NEURON(current_input_normal, sc_weights, FSM_STATES_I,true, false);
                    current_output = [current_output; neuron_out];
                    
                    %  DEBUGGING
                    actual_output = UNIPOL_2_BIPOL(S2D_ARRAY(neuron_out, N))
                    expected_output = tanh(current_input_debug'*(weights*norm_c))
                    neuron_percent_error_hidden = abs(100*(actual_output - expected_output)/expected_output)
                    current_output_debug = [current_output_debug; expected_output];
                    network_percent_error_map(l, k) = network_percent_error_map(l, k) + neuron_percent_error_hidden;

                    min_val = min(abs(weights.*x))
                    blah = 1;
                elseif(l == numOfLayers)
                    weights = [sc_LW{l,l-1}(k,:)'; sc_b{l}(k)];
                    dec_weights_squished = BIPOL_2_UNIPOL(weights);
                    sc_weights = DEC2SC_ARRAY(dec_weights_squished, N);
                    neuron_out = NEURON(current_input_normal, sc_weights, 0, false, true);
                    current_output = [current_output; neuron_out];
                    
                    %  DEBUGGING
                    actual_output = UNIPOL_2_BIPOL(S2D_ARRAY(neuron_out, N))
                    expected_output = current_input_debug'*(weights)/numInputsToNeuronsInLayer(l);
                    neuron_percent_error_output = abs(100*(actual_output - expected_output)/expected_output)
                    current_output_debug = [current_output_debug; expected_output];
                    network_percent_error_map(l, k) = network_percent_error_map(l, k) + neuron_percent_error_output;
                else
                    weights = [sc_LW{l,l-1}(k,:)'; sc_b{l}(k)];
                    dec_weights_squished = BIPOL_2_UNIPOL(weights);
                    sc_weights = DEC2SC_ARRAY(dec_weights_squished, N);
                    neuron_out = NEURON(current_input_normal, sc_weights, FSM_STATES_HO, true, false);
                    current_output = [current_output; neuron_out];
                    
                    %  DEBUGGING
                    actual_output = UNIPOL_2_BIPOL(S2D_ARRAY(neuron_out, N))
                    expected_output = tanh(current_input_debug'*(weights*norm_c))
                    neuron_percent_error_hidden = abs(100*(actual_output - expected_output)/expected_output)
                    current_output_debug = [current_output_debug; expected_output];
                    network_percent_error_map(l, k) = network_percent_error_map(l, k) + neuron_percent_error_hidden;
                end

            end

            % Update the current input
            current_input_normal = [current_output; ones(1, N)];
            current_input_debug = [current_output_debug; 1];
        end

        % Now that we have the stochastic outputs, we need to convert these
        % to decimal again.
        dec_out = S2D_ARRAY(current_output, N);

        % Convert the decimal numbers back to the original space
        dec_out = UNIPOL_2_BIPOL(dec_out);

        % Use the softmax function to get a valid posterior distribution
        output = softmax(dec_out)';
        output_debug = softmax(current_output_debug)';

        output = output - max(output);
        output_debug = output_debug - max(output_debug);
        
        output = (output >= 0);
        output_debug = (output_debug >= 0);
        
        results = [results; output];
        results_debug = [results_debug; output_debug];
        
        if(max(max(network_percent_error_map ./ numSamples)) > 50)
            stop = 1;
        end
    end
    
    %  Normalize the network error map
    network_percent_error_map = network_percent_error_map;

    if(hiddenLayerDepth == 3)
        if(hiddenLayerBreadth == 2)
            e = 4;
        end
    end
    % Print the misclassification count error 
    current_debug_error = sum(sum(abs((results_debug - t')), 2) > 0) / length(t);
    my_error = sum(sum(abs((results - t')), 2) > 0) / length(t);
    sc_error(hiddenLayerBreadth, hiddenLayerDepth) = my_error;
    debug_error(hiddenLayerBreadth, hiddenLayerDepth) = current_debug_error;
    
    output = sim(net, phi');
    output = (output - ones(3, 1)*max(output)) >= 0;
    net_error(hiddenLayerBreadth, hiddenLayerDepth) = sum(sum(abs((output' - t')), 2) > 0) / length(t);

    
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Plot the Error
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%plot(1:10, net_error(1,:), 1:10, net_error(2,:))
%plot(1:10, (net_error(1,:) - sc_error(1,:)).^2, 1:10, (net_error(2,:) - sc_error(2,:)).^2)

% Plot (net_error - sc_error)^2 error. 
fig = figure();
color_map = hsv(max_depth);
legend_strings = [];
for depth = 1:max_depth
    hold on;
    plot(1:max_breadth, (net_error(1:max_breadth, depth) - sc_error(1:max_breadth, depth)).^2, 'color',color_map(depth,:));
    legend_strings = [legend_strings; ['Depth = ' int2str(depth) ',']];
end

legend(legend_strings);

% Create xlabel
xlabel('Hidden Layer Breadth','FontWeight','bold','FontSize',16);

% Create ylabel
ylabel('Squared Error','FontWeight','bold','FontSize',16);




% %  --- This section used for preious code ---
% %plot(space, sc_error)
% % Test the network on all the data
% %output = sim(net, phi');
% %output = (output - ones(3, 1)*max(output)) >= 0;
% %net_error = sum(sum(abs((output' - t')), 2) > 0) / length(t);
% 
% % Test the Network
% y = net(phi');
% e = gsubtract(t,y);
% tind = vec2ind(t);
% yind = vec2ind(y);
% percentErrors = sum(tind ~= yind)/numel(tind);
% performance = perform(net,t,y)
% 
% % Recalculate Training, Validation and Test Performance
% trainTargets = t .* tr.trainMask{1};
% valTargets = t  .* tr.valMask{1};
% testTargets = t  .* tr.testMask{1};
% trainPerformance = perform(net,trainTargets,y)
% valPerformance = perform(net,valTargets,y)
% testPerformance = perform(net,testTargets,y)
% 
% % View the Network
% view(net)
% 
% % Plots
% % Uncomment these lines to enable various plots.
% %figure, plotperform(tr)
% %figure, plottrainstate(tr)
% %figure, plotconfusion(t,y)
% %figure, plotroc(t,y)
% %figure, ploterrhist(e)
% 
% % Deployment
% % Change the (false) values to (true) to enable the following code blocks.
% if (false)
%   % Generate MATLAB function for neural network for application deployment
%   % in MATLAB scripts or with MATLAB Compiler and Builder tools, or simply
%   % to examine the calculations your trained neural network performs.
%   genFunction(net,'myNeuralNetworkFunction');
%   y = myNeuralNetworkFunction(x);
% end
% if (false)
%   % Generate a matrix-only MATLAB function for neural network code
%   % generation with MATLAB Coder tools.
%   genFunction(net,'myNeuralNetworkFunction','MatrixOnly','yes');
%   y = myNeuralNetworkFunction(x);
% end
% if (false)
%   % Generate a Simulink diagram for simulation or deployment with.
%   % Simulink Coder tools.
%   gensim(net);
% end

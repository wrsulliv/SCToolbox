%{ 

Author: Will Sullivan

Explanation
    This script illustrates how adding de-correlation elements to a network
    can reduce the correlation of the output neuron.  The weights are
    initialized randomly and heterogeneously and the inputs are from the Iris 
    dataset.  Heterogeneous weights are weights which differ for each
    neuron. The FSM size of each neuron is determined by the minimum 
    of the weights at that neuron.

Notes
    This was used to generate plots in the summer work proposal

%}
clear all;
load iris_dataset.mat


phi = mapminmax(irisInputs)';

% Remove all samples which have zeros 
% phi = phi(find(~sum(phi == 0, 2)), :);

% Normalize the data
%mean_sample = mean(phi);
%phi = phi - ones(size(phi, 1), 1)*mean_sample;
%phi_std = sqrt(var(phi));
%std_mat = ones(size(phi, 1), 1)*sqrt(var(phi));
%phi = phi ./ std_mat;

% Scale everything between -1 and 1
%phi = phi ./ max(max(abs(phi)));

    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% User defined simulation parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

numSimulatedLayers = 10;
numNodesPerLayer = 2;
numInputs = size(phi, 2);
bitstreamLength = 10000;
randomWeightScaleFactor = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Auto generated variables and constants
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define the number of inputs from the input and hidden layers including
% the bias term.
numInputsFromInput = numInputs+1; 
numInputsFromHidden = numNodesPerLayer + 1;

% Define a variable to hold the irisTargets
t = irisTargets;

% Define variables to hold the results to be plotted
sc_error = [];
corr_normal_avg = [];
corr_regen_avg = [];
corr_delay_avg = [];

% Generate a set of weights to be used by all the neurons.  The denominator
% of the fraction determines the range for which we define the weights.
% For example, /10 will put the weights between 0 and 1/10.

w_input = rand(numInputsFromInput, numNodesPerLayer)/randomWeightScaleFactor;

% Note:  For hidden layers other than the first hidden layer, we will keep
% a matrix of weights which has one extra vector as a dummy vector to make
% the indexing easier (since the first hidden layer is already defined,
% we'd like to still be able access the layers in order as 1 = first hidden
% layer, 2 = the next hidden layer that (w_hidden) defines the weights for.
%  So, (w_hidden(:,:,1)) will be a dummy set of weights.
w_hidden = rand(numInputsFromHidden, numNodesPerLayer, numSimulatedLayers)/randomWeightScaleFactor;

%w_all = rand(numInputs+1)/10;
    
% Loop through starting with only one layer and incraseing to the desired
% number (numSimulatedLayers)
for numHiddenLayers = 1:1:numSimulatedLayers

    numHiddenLayers
    

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %     Construct the weight streams
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    
    % Set up the weights for the first hidden layer
    %w_i_dec = 0 + rand(numInputs+1, numNodesPerLayer)/10; % Generate all positive weights between .6 and 1.
    w_i_sc = zeros(bitstreamLength, numInputs+1, numNodesPerLayer);
    for input = 1:numInputs+1
        for node = 1:numNodesPerLayer
            for n = 1:bitstreamLength
                w_i_sc(n, input, node) = rand(1) < w_input(input, node);
            end
        end
    end
    
   % Set up the weights for the remaning hidden layers
   % w_ho_dec = 0 + rand(numNodesPerLayer+1, numNodesPerLayer, numLayers-1)/10;
    w_ho_sc = zeros(bitstreamLength, numNodesPerLayer+1, numNodesPerLayer, numHiddenLayers-1);
    for weight = 1:numNodesPerLayer+1
        for neuron = 1:numNodesPerLayer
            for layer = 2:numHiddenLayers
                for n = 1:bitstreamLength
                    w_ho_sc(n, weight, neuron, layer) = rand(1) < w_hidden(weight, node, layer);
                end
            end
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %     Set up the network parameters
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Here I use the equation 
    % FSM_STATES = floor(2*|w|*max(w))
    %   where (w) is the vector of weights at the input to a neuron
    
    % Note:  For this small example, I ignore the weight scaling, as it is
    % essentially arbitrary.
    
    % Make two matrics to hold the number of states in the FSM at each
    % neuron
    
    FSM_STATES_I = zeros(numNodesPerLayer, 1);
    FSM_STATES_HO = zeros(numHiddenLayers, numNodesPerLayer);
    
    % Set up the FSM sizes for the first hidden layer
    for node = 1:numNodesPerLayer
       FSM_STATES_I(node)  = floor(2*numInputsFromInput*max(abs(w_input(:, node))));
    end
    
    % Set up the FSM sizes for the remaining hidden layers.  Once again, as
    % described in the section on defining the weights, we create a dummy
    % layer to simplify the indexing.
    for layer = 2:numHiddenLayers
        for node = 1:numNodesPerLayer
            FSM_STATES_HO(layer, node) = floor(2*numInputsFromHidden*max(abs(w_hidden(:, node, layer))));
        end
   end


    AVG_STEPS = 1;
    
    results = [];
    corr_normal = [];
    corr_regen = [];
    corr_delay = [];
    sample_count = size(phi, 1);
    %sample_count = 1;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %       Loop through each sample 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    for i = 1:sample_count
        i;
        
        % Get the next sample point
        x = (phi(i,:)');

        % Convert the input to the Uni-Polar range
        dec_signals_squished = BIPOL_2_UNIPOL([1; x]);
        
        % Convert the decimal values to stochastic numbers
        sc_signals = DEC2SC_ARRAY(dec_signals_squished, bitstreamLength);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %       Perform the Feedforward
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
        % Start the feedforward propogation
        % At the output of each layer we should get a vector which represents
        % the input to the next layer
        current_input_normal = sc_signals;
        current_input_regen = sc_signals;
        current_innput_delay = sc_signals;
        current_output_normal = zeros(numNodesPerLayer, bitstreamLength);
        current_output_regen = zeros(numNodesPerLayer, bitstreamLength);
        current_output_delay = zeros(numNodesPerLayer, bitstreamLength);
        for layer = 1:numHiddenLayers
            for node = 1:numNodesPerLayer
                
                %  Differentiate between the input layer weights and other
                %  layers
                if(layer == 1)
                    % For the first layer the three correlation types
                    % remain the same.
                    current_output_normal(node, :) = NEURON(current_input_normal, w_i_sc(:, :, node)', FSM_STATES_I(node), false, false);
                    current_output_regen(node, :) = current_output_normal(node, :);
                    current_output_delay(node, :) = current_output_normal(node, :);
                elseif(layer == numHiddenLayers)
                     % The last layer uses linear neurons
                    current_output_normal(node, :) = NEURON(current_input_normal, w_ho_sc(:, :, node, layer)', FSM_STATES_HO(layer, node), false, true);
                    current_output_regen(node, :) = NEURON(current_input_regen, w_ho_sc(:, :, node, layer)', FSM_STATES_HO(layer, node), false, true);
                    current_output_delay(node, :) = NEURON(current_input_delay, w_ho_sc(:, :, node, layer)', FSM_STATES_HO(layer, node), false, true);
                    
                else
                    current_output_normal(node, :) = NEURON(current_input_normal, w_ho_sc(:, :, node, layer)', FSM_STATES_HO(layer, node), false, false);
                    current_output_regen(node, :) = NEURON(current_input_regen, w_ho_sc(:, :, node, layer)', FSM_STATES_HO(layer, node), false, false);
                    current_output_delay(node, :) = NEURON(current_input_delay, w_ho_sc(:, :, node, layer)', FSM_STATES_HO(layer, node), false, false);
                end
 
            end
  
            % Update the current input
            
            % Since for now we are only assuming two layers, delay /
            % regeneraete the first element of this vector
            
            current_output_regen(1, :) = DEC2SC_ARRAY(S2D_ARRAY(current_output_regen(1,:), bitstreamLength), bitstreamLength);
            current_output_delay(1, :) = DELAY(current_output_delay(1,:));
            
            current_input_normal = [ones(1, bitstreamLength); current_output_normal];
            current_input_regen = [ones(1, bitstreamLength); current_output_regen];
            current_input_delay = [ones(1, bitstreamLength); current_output_delay];
            

            
        end
        
        curr_corr_normal = sc_correlation(current_output_normal(1,:), current_output_normal(2,:));
        curr_corr_regen = sc_correlation(current_output_regen(1,:), current_output_regen(2,:));
        curr_corr_delay = sc_correlation(current_output_delay(1,:), current_output_delay(2,:));
        corr_normal = [corr_normal curr_corr_normal];
        corr_regen = [corr_regen curr_corr_regen];
        corr_delay = [corr_delay curr_corr_delay];
        
        if((isnan(curr_corr_normal)) || (isnan(curr_corr_regen)) || (isnan(curr_corr_delay)))
            blah = 1;
        end
        

    end
    
        corr_normal_avg = [corr_normal_avg mean(abs(corr_normal))];
        corr_delay_avg = [corr_delay_avg  mean(abs(corr_delay))];
        corr_regen_avg = [corr_regen_avg mean(abs(corr_regen))];
        
    
    % Plot the histograms
    %figure(1);
    %range = linspace(-200, 200, 21);
    %subplot(3, 1, 1)
    %hist(round((corr_normal*10000)), range)
    %set(get(gca,'child'),'FaceColor',[255/255	215/255	0]);
    %title('Normal')
    
    %subplot(3, 1, 2)
    %hist(round((corr_delay*10000)), range)
    %set(get(gca,'child'),'FaceColor',[205/255	55/255	0]);
    %title('Delay')
    
    %subplot(3, 1, 3)
    %hist(round((corr_regen*10000)), range)
    %findobj(gca,'Type','patch');
    %set(get(gca,'child'),'FaceColor',[255/255	127/255	0]);
    %title('Regeneration')
    
    % Plot the averages
%     figure1 = figure(2);
%     axes1 = axes('Parent',figure1,...
%     'XTickLabel',{'Normal','Delay','Regeneration'},...
%     'XTick',[1 2 3]);
% box(axes1,'on');
% hold(axes1,'all');
% 
%     b1 = bar(1, mean(abs(corr_normal)))
%     hold on;
%     b2 = bar(2, mean(abs(corr_delay)))
%     hold on;
%     b3 = bar(3, mean(abs(corr_regen)))
% 
% 
%     set(b1, 'FaceColor', [255/255	215/255	0]);
%     set(b2, 'FaceColor', [205/255	55/255	0]);
%     set(b3, 'FaceColor', [255/255	127/255	0]);

    
end

plot(1:numSimulatedLayers, corr_normal_avg, 'Color', [255/255;215/255;0]);
hold on;
plot(1:numSimulatedLayers, corr_delay_avg, 'Color', [205/255 55/255 0]);
hold on;
plot(1:numSimulatedLayers, corr_regen_avg,  'Color', [255/255 127/255 0]);
legend('Normal', 'Delay', 'Regeneration');


% Create xlabel
xlabel('Hidden Layers','FontWeight','bold','FontSize',16);

% Create ylabel
ylabel('SCC','FontWeight','bold','FontSize',16);

% Create title
title('1 - 20 Hidden Layers with Weights in [0 .1]   ','FontWeight','bold',...
    'FontSize',16);

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

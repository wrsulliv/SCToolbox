
clear all;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %   Set User Defined Parameters 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % net_error and sc_error are matrices of (breadth x depth)
    seed = 'shuffle';
    format short g;
    hiddenLayerDepth = 2;
    hiddenLayerBreadth = 2;
    %N = 2000;
    trainPercentage = 0.95;


    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    %   Prepare the Dataset
    %%%%%%%%%%%%%%%%%%%%%%%%%%%

    data = csvread('iris.csv'); % A (numSamples) x (numFeatures + 1) matrix
    
    numClasses = length(unique(data(:, end)));
    nnData = NN_Classification_Sim(seed, hiddenLayerDepth, hiddenLayerBreadth, data,numClasses, trainPercentage);


    maxN = 40000
    

        sc_output = SC_NN_Sim_Progressive(nnData, maxN, 64, .1);
        %sc_output = SC_NN_Sim(nnData, maxN);
        sc_error = NN_Calc_Misclassification_Error(sc_output', nnData.t_test)
        software_output = sim(nnData.net, nnData.phi_test');
        software_output = (software_output - ones(nnData.numClasses, 1)*max(software_output)) >= 0;
        software_error = NN_Calc_Misclassification_Error(software_output, nnData.t_test)




clear all;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %   Set User Defined Parameters 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % net_error and sc_error are matrices of (breadth x depth)
    seed = 4151945
    format short g;
    hiddenLayerDepth = 4
    hiddenLayerBreadth = 3
    %N = 2000;
    trainPercentage = 0.95;


    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    %   Prepare the Dataset
    %%%%%%%%%%%%%%%%%%%%%%%%%%%

    data = csvread('iris.csv'); % A (numSamples) x (numFeatures + 1) matrix
    
    numClasses = length(unique(data(:, end)));
    nnData = NN_Classification_Sim(seed, hiddenLayerDepth, hiddenLayerBreadth, data,numClasses, trainPercentage);

   
    
test_vec = [500 1000 5000 10000]
result_vec = []
for index = 1:4
    N = test_vec(index)
    
    total = 0
    for avg = 1:5
        output = SC_NN_Sim(nnData, N);
        sc_error = NN_Calc_Misclassification_Error(output, nnData.t_test')
        total = total + sc_error
        %output = sim(nnData.net, nnData.phi_test');
        %output = (output - ones(nnData.numClasses, 1)*max(output)) >= 0;
        %software_error = NN_Calc_Misclassification_Error(output, nnData.t_test)
    end
    result_vec = [result_vec total / 3]
end

plot(result_vec)
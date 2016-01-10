
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

   
maxN = 40000;
tol_vec = [1  .5 .1 .05 .01];
avg_steps = 7;

avg_vec = [];
var_vec = [];
avg_bitstream_length_over_tol = [];

for index = 1:5
    tol = tol_vec(index);
    total = [];
    avg_bitstream_length_over_avg_steps = [];
    index
    for avg = 1:avg_steps
        [sc_output, required_bitstream_length_each_sample] = SC_NN_Sim_Progressive(nnData, maxN, 64, tol);
        sc_error = NN_Calc_Misclassification_Error(sc_output', nnData.t_test);
        total = [total  sc_error];
        avg_bitstream_length_over_avg_steps = [avg_bitstream_length_over_avg_steps; required_bitstream_length_each_sample];
        
        %software_output = sim(nnData.net, nnData.phi_test');
        %software_output = (software_output - ones(nnData.numClasses, 1)*max(software_output)) >= 0;
        %software_error = NN_Calc_Misclassification_Error(software_output, nnData.t_test)
    end
    avg_bitstream_length_over_tol = [avg_bitstream_length_over_tol; mean(avg_bitstream_length_over_avg_steps)];
    
    avg_vec = [avg_vec mean(total)];
    var_vec = [var_vec var(total)];
end

%plot(tol_vec, avg_vec, tol_vec, mean(avg_bitstream_length_over_tol, 2))
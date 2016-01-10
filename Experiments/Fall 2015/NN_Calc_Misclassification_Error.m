% Takes as input (numSamples) x (numClasses) matrices
function misclassification_error = NN_Calc_Misclassification_Error(generated_1_of_k, actual_1_of_k)
    misclassification_error = sum(sum(abs(generated_1_of_k' - actual_1_of_k'), 2) > 0) / size(actual_1_of_k, 2);
end
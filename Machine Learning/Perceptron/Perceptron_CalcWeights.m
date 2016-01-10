function [ w ] = Perceptron_CalcWeights(phi, class_labels)
%Computes the weights for the perceptron learning algorithm
%   This function takes as input a matrix of datapoints with which to train
%   on 'phi', a vector of class labels 'class_labels' where the classes are either 
%   +1 or -1, and outputs a set of weights which can be used to perform 
%   classification based on the Perceptron learning algorithm.

%
% Implementation of Perceptron
%

% Generate the weight vectors
w = zeros(size(phi, 2), 1);

% Define algorithm parameters
learn_rate = 10^(-5);
max_iterations = 2000;



% Perform Stochastic Gradient Descent
n = 1;
iterations = 0;
correct = 0;
while iterations < max_iterations && correct < size(phi, 1)
    % Check to see if point n is misclassified
    a = w'*phi(n,:)';
    val = PerceptronActivation(a);
    if(val ~= class_labels(n))
        % If the point is misclassified then...
        w = w + learn_rate*phi(n,:)'*class_labels(n);
        iterations = iterations + 1;
        correct = 0;
    else
        correct = correct + 1;
    end

    % Go to the next point
    n = mod(n, size(phi, 1)) + 1;
end

end


% Stochastic Perceptron Learning
%clear all;

% Load the data
DATA = csvread('data/D2_train.csv', 1);
phi = DATA(:, 1:2);
class_labels = DATA(:, 3);

% Normalize the data
% Now, we have to pre-process the input matrices
phi_u = mean(phi);
u_mat = ones(size(phi, 1), 1)*mean(phi);
phi = phi - u_mat;
phi_std = sqrt(var(phi));
std_mat = ones(size(phi, 1), 1)*sqrt(var(phi));
phi = phi ./ std_mat;
    
% Also, divide by the largest element in each vector
phi = phi ./ (ones(size(phi, 1), 1)*max(abs(phi)));

% Add an intercept term
phi = [phi ones(size(phi, 1), 1)];
    
%scatter(phi(:,1), phi(:,2))

%  Convert the classes to -1 and 1 for the Perceptron algorithm
class_labels(class_labels == 0) = -1;

addpath('ML/');
addpath('Precision/');
w = ML_CalcWeights_Perceptron(phi, class_labels);
w = w / norm(w);
[est_class_labels, classification_error] = ML_Classify_Perceptron( phi, class_labels, w )

%
% Implementation of the stochastic Perceptron
%
class_error_vec = [];
for n = 100:100:4000
    
N = n; %  Stochastic number length
FSM_STATES = 16;
AVG_STEPS = 1;
tol = .1;

% Implement the Perceptron
dec_signals = phi';
% dec_weights should be a number between -1 and 1
%dec_weights(1,:) = ones(1,size(dec_signals, 2))*0.7;
dec_weights = bsxfun(@times, w, ones(3,size(dec_signals, 2)));

neuron_output = zeros(1,size(phi, 1));

    % dec_signals is equivelent to the transpose of phi, such that each column
    % of dec_signals is a sample.


    % Convert from the [-1, 1] range to [0, 1]
    dec_signals_squished = BIPOL_2_UNIPOL(dec_signals);
    sc_signals = DEC2SC_ARRAY(dec_signals_squished, N);


    dec_weights_squished = BIPOL_2_UNIPOL(dec_weights);
    sc_weights = DEC2SC_ARRAY(dec_weights_squished, N);


    sc_out = NEURON(sc_signals, sc_weights, N);
    dec_out = S2D_ARRAY(sc_out, N);
    dec_out_expanded = UNIPOL_2_BIPOL(dec_out);

    neuron_output = neuron_output + dec_out_expanded;


dec_out_correct = NEURON_TEST(dec_signals, dec_weights, FSM_STATES);

correct = sum(abs(dec_out_correct - neuron_output) < tol)/length(neuron_output)
%se_output = mean((neuron_output - dec_out_correct).^2)

dec_out_correct(dec_out_correct < 0) = -1;
dec_out_correct(dec_out_correct >= 0) = 1;
dec_out_correct = dec_out_correct.*(1);

neuron_output(neuron_output < 0) = -1;
neuron_output(neuron_output >= 0) = 1;
neuron_output = neuron_output.*(1);

%  Compute the Perceptron classification error
classification_error = length(find((neuron_output - class_labels') ~= 0))/length(class_labels)

class_error_vec = [class_error_vec classification_error];

%[est_class_labels, classification_error] = ML_Classify_Perceptron( phi, class_labels, w )
end

%  Generate a plot which shows the two classes and the points which were
%  incorreclty classified
gscatter(phi(:,1), phi(:,2), neuron_output, ['b', 'g', 'r'], ['x', 'x', 'o']);
legend('Class 1', 'Class 2', 'Incorrect');
plot(100:100:4000, class_error_vec);


% Create title
title('Bitstream Length (N) vs. Misclassification Error','FontWeight','bold',...
    'FontSize',16);

% Create xlabel
xlabel('N','FontWeight','bold','FontSize',16);

% Create ylabel
ylabel('Error','FontWeight','bold','FontSize',16);

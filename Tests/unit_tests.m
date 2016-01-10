%
% Stochastic Research Unit Testing Script
%

% Run this script to ensure that the components of the Matlab code are
% working properly

% Each test generally has some actual output from SC components and an
% expected output.  Since SC is intrinsically random, it is not possible to
% test the output with certainty.  Instead, define 'tol' as the allowed percentage error.
% Then if [abs((actual - expected)/expected) < tol] is true, then the test
% will succseed.  Just make sure that when constructing new tests you keep
% this tolerance in mind to ensure the circuit is capable of such
% precision.  N is the bitstream length.  Set this very high for tests to
% reduce the random fluctuations.  
tol = 10; 
N = 50000;

% Test the decimal to stochastic and stochastic to binary converting
% functions

    % Name: B2S_Test_1
    % Description: Check the decimal to stochastic converting function for
    % a 2x3 matrix of decimal numbers.
    
    % Convert from the [-1, 1] range to [0, 1]
    dec_signals = [-1 0.1 1; -.2 .5 .8];
    dec_signals_squished = BIPOL_2_UNIPOL(dec_signals);
    sc_signals = DEC2SC_ARRAY(dec_signals_squished, N);
    dec_out = S2D_ARRAY(sc_signals, N);
    dec_out_expanded = UNIPOL_2_BIPOL(dec_out);

    % We are hoping for [-1 0 1; -.2 .5 .8]
    exp = dec_signals;
    percent_error_vec = 100*abs((dec_out_expanded - exp)./exp)
    B2S_Test_1 = sum(sum(percent_error_vec <= tol))/6
    

% Test the stochastic neuron code to ensure the neuron is computing
% properly.

    % Name: Neuron_Test_1
    % Description: Checks the stochastic neuron with 3 inputs.
    dec_signals = [-.4; .8; .4];
    dec_signals_squished = BIPOL_2_UNIPOL(dec_signals);
    sc_signals = DEC2SC_ARRAY(dec_signals_squished, N);

    dec_weights = [.1; 1; .9];
    dec_weights_squished = BIPOL_2_UNIPOL(dec_weights);
    sc_weights = DEC2SC_ARRAY(dec_weights_squished, N);

    sc_out = NEURON(sc_signals, sc_weights, 6, true, false);
    dec_out = S2D_ARRAY(sc_out, N);
    dec_out_expanded = UNIPOL_2_BIPOL(dec_out);
    expected = tanh(dec_signals'*dec_weights);
    percent_error = 100*abs((dec_out_expanded - expected)/expected);
    Neuron_Test = (percent_error <= tol)
     
     
    % Name: Neuron_Test_2
    % Description: Checks the stocashtic neuron with 5 inputs. 
    
    % Convert from the [-1, 1] range to [0, 1]
    dec_signals = [1.0000; -0.5556; 0.2500; -0.8644; -0.9167];
    dec_signals_squished = BIPOL_2_UNIPOL(dec_signals);
    sc_signals = DEC2SC_ARRAY(dec_signals_squished, N);

    dec_weights = [0.0681; 0.0527; 0.1248; -0.1371; -0.3525];
    dec_weights_squished = BIPOL_2_UNIPOL(dec_weights);
    sc_weights = DEC2SC_ARRAY(dec_weights_squished, N);

    sc_out = NEURON(sc_signals, sc_weights, 5, true, false);
    dec_out = S2D_ARRAY(sc_out, N);
    dec_out_expanded = UNIPOL_2_BIPOL(dec_out);
    expected = tanh(dec_signals'*dec_weights);

    percent_error = 100*abs((dec_out_expanded - expected)/expected);
    Neuron_Test = (percent_error <= tol)
    
    % Name: Neuron_Test_3
    % Description: This test is to check sample 55 from the Iris dataset.
    
    dec_signals = [0.22222 -0.33333 0.22034 0.16667 1]';
    dec_signals_squished = BIPOL_2_UNIPOL(dec_signals);
    sc_signals = DEC2SC_ARRAY(dec_signals_squished, N);

    dec_weights = [0.0093427 0.024828 -0.064917 -0.07067 0.019572]';
    dec_weights_squished = BIPOL_2_UNIPOL(dec_weights);
    sc_weights = DEC2SC_ARRAY(dec_weights_squished, N);

    weight_percent_error  = PercentError(dec_weights, UNIPOL_2_BIPOL(S2D_ARRAY(sc_weights, N)));
    FSM_STATES = 250;
    norm_c = 24.969;
    
    
    [sc_out, percent_error_map, actual, expected] = NEURON_INTROSPECTIVE(sc_signals, sc_weights, dec_signals, dec_weights, dec_weight_scale_factor, FSM_STATES, true, false)

    percent_error = percent_error_map(3,1);
    Neuron_Test = (percent_error <= tol)
    
    
    % Name: Neuron_Test_4
    % Description: This test is to check sample 55 from the Iris dataset.
    % Using a different set of weights. 
    
    dec_signals = [0.22222 -0.33333 0.22034 0.16667 1]';
    dec_signals_squished = BIPOL_2_UNIPOL(dec_signals);
    sc_signals = DEC2SC_ARRAY(dec_signals_squished, N);

    dec_weights = [-0.35145 -0.0051668 1 0.21542 -0.4105]';
    dec_weights_squished = BIPOL_2_UNIPOL(dec_weights);
    sc_weights = DEC2SC_ARRAY(dec_weights_squished, N);

    weight_percent_error  = PercentError(dec_weights, UNIPOL_2_BIPOL(S2D_ARRAY(sc_weights, N)));
    FSM_STATES = 89;
    dec_weight_scale_factor = 8.8481;
    
    [sc_out, percent_error_map, actual, expected] = NEURON_INTROSPECTIVE(sc_signals, sc_weights, dec_signals, dec_weights, dec_weight_scale_factor, FSM_STATES, true, false)

    percent_error = percent_error_map(3,1);
    Neuron_Test = (percent_error <= tol)
     
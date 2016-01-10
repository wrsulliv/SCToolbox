
N = 1024; %  Stochastic number length
FSM_STATES = 16;
AVG_STEPS = 200;

neuron_output = zeros(1,size(-1:.01:1,2));

for i = 1:AVG_STEPS
% dec_signals should be a number between -1 and 1
dec_signals(1,:) = -1:.01:1;
dec_signals(2,:) = -1:.01:1;
dec_signals_squished = BIPOL_2_UNIPOL(dec_signals);
sc_signals = DEC2SC_ARRAY(dec_signals_squished, N);

% dec_weights should be a number between -1 and 1
%dec_weights(1,:) = ones(1,size(dec_signals, 2))*0.7;
dec_weights = ones(2,size(dec_signals, 2))*1;
dec_weights_squished = BIPOL_2_UNIPOL(dec_weights);
sc_weights = DEC2SC_ARRAY(dec_weights_squished, N);


sc_out = NEURON_PLAY(sc_signals, sc_weights, N);
dec_out = S2D_ARRAY(sc_out, N);
dec_out_expanded = UNIPOL_2_BIPOL(dec_out);

neuron_output = neuron_output + dec_out_expanded;
end

neuron_output = neuron_output ./ AVG_STEPS;
dec_out_correct = NEURON_TEST(dec_signals, dec_weights, FSM_STATES)

se_output = (neuron_output - dec_out_correct).^2;

figure % create new figure
subplot(2,1,1) % first subplot

plot(dec_signals, neuron_output);
legend('Neuron Output');

% Create xlabel
xlabel('Input','FontWeight','bold','FontSize',16);

% Create ylabel
ylabel('Output','FontWeight','bold','FontSize',16);

% Create title
title('Neuron Output','FontWeight','bold','FontSize',16);


subplot(2,1,2) % first subplot
plot(dec_signals, se_output);
legend('Output Error');

% Create xlabel
xlabel('Input','FontWeight','bold','FontSize',16);

% Create ylabel
ylabel('Squared Error','FontWeight','bold','FontSize',16);

% Create title
title('FSM Reset Error','FontWeight','bold','FontSize',16);

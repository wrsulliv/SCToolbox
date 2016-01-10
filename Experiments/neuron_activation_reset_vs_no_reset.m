
N = 1024; %  Stochastic number length
FSM_STATES = 16;
AVG_STEPS = 100;

reset_out_avg = zeros(1,size(-1:.01:1,2));
no_reset_out_avg = zeros(1,size(-1:.01:1,2));

for i = 1:AVG_STEPS
% dec_signals should be a number between -1 and 1
dec_signals(1,:) = -1:.01:1;
dec_signals(2,:) = -1:.01:1;
dec_signals_squished = BIPOL_2_UNIPOL(dec_signals);
sc_signals = DEC2SC_ARRAY(dec_signals_squished, N);

% dec_weights should be a number between -1 and 1
%dec_weights(1,:) = ones(1,size(dec_signals, 2))*0.7;
dec_weights = ones(2,size(dec_signals, 2))*-0.2;
dec_weights_squished = BIPOL_2_UNIPOL(dec_weights);
sc_weights = DEC2SC_ARRAY(dec_weights_squished, N);


sc_out = NEURON(sc_signals, sc_weights, FSM_STATES, 1);
dec_out = S2D_ARRAY(sc_out, N);
dec_out_expanded = UNIPOL_2_BIPOL(dec_out)

sc_out2 = NEURON(sc_signals, sc_weights, FSM_STATES, 0);
dec_out2 = S2D_ARRAY(sc_out2, N);
dec_out_expanded2 = UNIPOL_2_BIPOL(dec_out2)

reset_out_avg = reset_out_avg + dec_out_expanded;
no_reset_out_avg = no_reset_out_avg + dec_out_expanded2;
end

reset_out_avg = reset_out_avg ./ AVG_STEPS;
no_reset_out_avg = no_reset_out_avg ./ AVG_STEPS;

%dec_out_correct = NEURON_TEST(dec_signals, dec_weights, FSM_STATES)
%plot(dec_signals, dec_out_expanded, dec_signals, dec_out_expanded2, dec_signals, dec_out_correct);
%legend('FSM Reset','No FSM Reset', 'Expected');

% Create xlabel
%xlabel('Input','FontWeight','bold','FontSize',16);

% Create ylabel
%ylabel('Output','FontWeight','bold','FontSize',16);

% Create title
%title('FSM Reset Test','FontWeight','bold','FontSize',16);


se_reset = (reset_out_avg - dec_out_correct).^2;
se_no_reset = (no_reset_out_avg - dec_out_correct).^2;
plot(dec_signals, se_reset, dec_signals, se_no_reset);
legend('FSM Reset','No FSM Reset');

% Create xlabel
xlabel('Input','FontWeight','bold','FontSize',16);

% Create ylabel
ylabel('Squared Error','FontWeight','bold','FontSize',16);

% Create title
title('FSM Reset Error','FontWeight','bold','FontSize',16);

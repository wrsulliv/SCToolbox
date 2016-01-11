% This script is used to compare the three different activation functions.
% Original (software), Brown and Card and Synthesis method.

N = 20000;
multiplier = 1;
degree = 3;
max_iterations = 7;

software_results = [];
bc_results = [];
synthesis_results = [];
BIPOL_Range = -1:0.1:1;

for val = BIPOL_Range
    % Create the bitstream
    S = SNG(BIPOL_2_UNIPOL(val), N);
    
    % Run the stream through the functions
    syms a;
    software = 2/(1+exp(-2*a*multiplier))-1;
    bc = FSM(S, 2*multiplier);
    [synthesis, poly, scale_factor] = SIGMOID_SYNTHESIZED(S, degree, max_iterations, multiplier);
    
    software_results = [software_results software];
    bc_results = [bc_results UNIPOL_2_BIPOL(S2D_ARRAY(bc, N))];
    synthesis_results = [synthesis_results scale_factor*UNIPOL_2_BIPOL(S2D_ARRAY(synthesis, N))];
    
end
%plot(BIPOL_Range, polyval(fliplr(poly), BIPOL_Range), BIPOL_Range, synthesis_results);
%plot(BIPOL_Range, software_results, BIPOL_Range, polyval(fliplr(poly), BIPOL_Range), BIPOL_Range, bc_results, BIPOL_Range, synthesis_results);
%legend('Software', 'Polynomial', 'Brown and Card', 'Synthesis');


hold on;
cmap = colormap(jet)
num_plots = 4;
cmap_increment = size(cmap, 1)/num_plots;
plot(BIPOL_Range, subs(software, a, BIPOL_Range),'-o', 'Color', cmap(8, :));
plot(BIPOL_Range, bc_results, '-*', 'Color', cmap(24, :));
plot(BIPOL_Range, polyval(fliplr(poly),BIPOL_Range), '-x', 'Color', cmap(32, :));
plot(BIPOL_Range, synthesis_results, '-d', 'Color', cmap(56, :));
legend('Original', 'Brown and Card', 'Polynomial', 'STRAUSS');
axis([-1, 1, -1, 1])


% Create xlabel
xlabel('IBP Input   ','FontWeight','bold','FontSize',16);

% Create ylabel
ylabel('IBP Output   ','FontWeight','bold','FontSize',16);





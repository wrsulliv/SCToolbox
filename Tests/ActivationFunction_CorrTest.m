

fsm_size = 16;
sc_size = 10000;
avg_steps = 100;
[in, out, scc_reg, scc_del] = ACTIVATION(avg_steps, sc_size, fsm_size);
plot(in, scc_reg, in, scc_del);
legend('Regeneration','Delay')

title('SC-Tanh Correlation (n=512, N=32, avg=100)','FontWeight','bold',...
    'FontSize',16);

% Create xlabel
xlabel('Input','FontWeight','bold','FontSize',16);

% Create ylabel
ylabel('SCC','FontWeight','bold','FontSize',16);



%plot(X,SCC_REG, X, SCC_DEL, X, tanh(x*(N/2)));
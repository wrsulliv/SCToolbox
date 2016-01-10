

N = 32;
n = 512;
[in, out, scc_reg, scc_del] = ACTIVATION(1, n, N);
subplot(1,2,1);
plot(in,out, in, tanh(in*((N)/2)));
legend('SC-Tanh','Tanh')

title('SC Tanh (n=512, N=32, avg=1)','FontWeight','bold',...
    'FontSize',16);

% Create xlabel
xlabel('Input','FontWeight','bold','FontSize',16);

% Create ylabel
ylabel('Output','FontWeight','bold','FontSize',16);



N = 32;
n = 512;
[in, out, scc_reg, scc_del] = ACTIVATION(100, n, N);
subplot(1,2,2);
plot(in,out, in, tanh(in*((N)/2)));


hold on;
legend('SC-Tanh','Tanh')


% Create title
title('SC Tanh (n=512, N=32, avg=1000)','FontWeight','bold',...
    'FontSize',16);

% Create xlabel
xlabel('Input','FontWeight','bold','FontSize',16);

% Create ylabel
ylabel('Output','FontWeight','bold','FontSize',16);

%plot(X,SCC_REG, X, SCC_DEL, X, tanh(x*(N/2)));
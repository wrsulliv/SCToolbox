n = 1000;
results = [];
for d = 0:n
   results = [results 1/((d/n)*2 - 1)];
end


% Create figure
figure1 = figure;

% Create axes
axes1 = axes('Parent',figure1,...
    'XTickLabel',{'-1','-0.8','-0.6','-0.4','-0.2','0','0.2','0.4','0.6','0.8','1.0'});
%% Uncomment the following line to preserve the X-limits of the axes
% xlim(axes1,[0 1000]);
box(axes1,'on');
hold(axes1,'on');

% Create plot
plot(results);

% Create xlabel
xlabel('Denominator Value','FontSize',16);

% Create ylabel
ylabel('ESL Value','FontSize',16);

% Create title
title('Denominator Values vs. ESL Values (N=1000)','FontSize',16);

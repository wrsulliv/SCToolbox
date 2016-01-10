% Plots each row in (data) as a new line, with names specific in a column vector
% (legend_strings)
function GeneratePlotFromMatrix(data, x_ticks, legend_strings, x_label, y_label)
    fig = figure();
    num_rows = size(data, 1);
    color_map = hsv(num_rows);
    for row = 1:num_rows
        hold on;
        plot(x_ticks, data(row, :), 'color',color_map(row,:));
    end

    legend(legend_strings);

    % Create xlabel
    xlabel(x_label,'FontWeight','bold','FontSize',16);

    % Create ylabel
    ylabel(y_label,'FontWeight','bold','FontSize',16);
end
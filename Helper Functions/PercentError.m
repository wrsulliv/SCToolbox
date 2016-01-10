function percent_error = PercentError(expected, actual)
    percent_error = 100*abs((actual - expected)./expected);
end
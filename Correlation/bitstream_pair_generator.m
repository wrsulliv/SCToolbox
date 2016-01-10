function [s1, s2] = bitstream_pair_generator(I, N)

s1 = [];
s2 = [];

    for i = 1:N
        a = discrete_distribution_sampler(I, [1 2 3 4])

        % Str  12
        % -------
        % 1 -> 00
        % 2 -> 01
        % 3 -> 10
        % 4 -> 11

        if(a == 1)
            s1 = [s1 0];
            s2 = [s2 0];
        elseif (a == 2)
            s1 = [s1 0];
            s2 = [s2 1];
        elseif (a == 3)
            s1 = [s1 1];
            s2 = [s2 0];
        else
            s1 = [s1 1];
            s2 = [s2 1];
        end
    end

end

% Found help in creating this function here: 
% http://www.mathworks.com/matlabcentral/answers/23319-easy-question-with-probability
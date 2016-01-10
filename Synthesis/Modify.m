function f_star_star = Modify(f_star, max_iterations) 
    f_star_star = f_star;
    for k = 1:max_iterations
        % Check if each element in f is 1 or -1, if so, return f
        if(sum(ismember(f_star, [1 -1])) == length(f_star))
            f_star_star = f_star;
            return
        else
            % Create f** which is twice the length of f*
            f_star_star = zeros(1, length(f_star)*2);
            
            % For each element in f_star
            for i = 1:length(f_star)
                if(f_star(i) < 0)
                    f_star_star(2*i - 1) = -1;
                    f_star_star(2*i) = 2*f_star(i)+1;
                else
                    f_star_star(2*i - 1) = 1;
                    f_star_star(2*i) = 2*f_star(i)-1;
                end
            end
        end
        
        f_star = f_star_star;
    end
    
    for i = 1:length(f_star_star)
        if(f_star_star(i) < 0)
            f_star_star(i) = -1;
        else
            f_star_star(i) = 1;
        end
    end
end
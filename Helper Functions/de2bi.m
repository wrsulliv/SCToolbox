function bin = de2bi(dec)

    if dec <= 0
        bin = 0;
        return
    end

    bin = [];
    while (dec > 0)
        current = mod(dec, 2);
        if current == 1
            bin = [1 bin];
            dec = dec - 1;
        else
            bin = [0 bin];
        end
        dec = dec / 2;
    end


end
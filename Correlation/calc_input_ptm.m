function I = calc_input_ptm(px, py, scc)
px_ = 1 - px;
py_ = 1 - py;
    I_0 = [px_*py_; px_*py; px*py_; px*py];
    I_n1 = [max(1-px-py, 0); min(1-px,py); min(1-py, px); max(px+py-1, 0)];
    I_p1 = [min(px_,py_); max(py-px,0); max(px-py,0); min(px,py)];
    
    
    if(scc < 0)
        I = (1+scc).*I_0 - scc.*I_n1;
    else
        I = (1-scc).*I_0 + scc*I_p1;
    end
    
    
end
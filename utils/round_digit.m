function [data] = round_digtal(data, k)
    %% Judge...
    if ~exist('k', 'var') 
        k = 4;
    end
    
    %% Return.
    data = round(data * 10  ^ k) / 10 ^ k; 
end
function [lambda_2, alpha_2, f_2, w_2, b_2] = QPP_2(A, B,...
    alpha_2_0, w_2_0, b_2_0, lambda_2_0, log)
    %% If print log.
    if ~exist('log', 'var')
        log = 0;
    end
    
    %% Load global params.
    variables();
    %% Constant.
    l_1 = size(A, 1);
    l_2 = size(B, 1);
    
    n = l_1 + l_2;
    
    e_1 = ones(l_1, 1);
    e_2 = ones(l_2, 1);
    
    m = size(A, 2);
    
    P = [A e_1];
    Q = [B e_2];
    
    Q_inv = pinv(Q' * Q + delta * eye(m + 1));
    %% Initize the first step.
    l = 1; % Current step
    
    alpha_2(:, 1) = alpha_2_0;
    w_2(:, 1) = w_2_0;
    b_2(1) = b_2_0;
    lambda_2(1) = lambda_2_0;
    
    f_2(:, 1) = A * w_2(:, 1) + b_2(1);
    
    % Divide sets.
    L_A = find(abs(alpha_2 - 1) < tol);
    E_A = find(1 - alpha_2 >= tol & alpha_2 - 0 >= tol);
    R_A = find(abs(alpha_2 - 0) < tol);

    p(l) = 0;   % Event
    pos(l) = 0; % Pos of point corresponds to the event.
    
    %% Iteration Loop.
    while (lambda_2(l) > threshold) & (l < maxIter)
        %% Initilize params before eacg loop
        len_E_A = length(E_A);
        len_L_A = length(L_A);
        len_R_A = length(R_A);
        
        if len_E_A ~= 0
            B_Aar = P(E_A, :) * Q_inv * P(E_A, :)'; 
            B_Aar_inv = pinv(B_Aar + delta * eye(size(B_Aar)));
            
            e = ones(len_E_A, 1);
            theta = B_Aar_inv * e;
            g = P * Q_inv * P(E_A, :)' * theta;
        else
            e_empty = [zeros(1, m), 0];
            B_Aar = e_empty * Q_inv * e_empty'; 
            B_Aar_inv = pinv(B_Aar + delta * eye(size(B_Aar)));
            
            e = ones(1, 1);
            theta = B_Aar_inv * e;
            g = P * Q_inv * e_empty' * theta;
        end
        
        %% Event 1.
        if len_E_A ~= 0
            lambda_2_1 = lambda_2(l) - (alpha_2(E_A, l) - 1) ./ theta;
        else
            lambda_2_1 = [];
        end
        
        %% Event 2.
        if len_E_A ~= 0
            lambda_2_2 = lambda_2(l) - alpha_2(E_A, l) ./ theta;
        else
            lambda_2_2 = [];
        end
        
        %% Event 3.
        if len_L_A ~= 0
            lambda_2_3 = lambda_2(l) * (f_2(L_A, l) - g(L_A, :)) ./ (1 - g(L_A, :));
        else
            lambda_2_3 = [];
        end
        
        %% Event 4.
        if len_R_A ~= 0
            lambda_2_4 = lambda_2(l) * (f_2(R_A, l) - g(R_A, :)) ./ (1 - g(R_A, :));
        else
            lambda_2_4 = [];
        end
        
        %% Select the first event.
        lambda_sum = [lambda_2_1; lambda_2_2; lambda_2_3; lambda_2_4];
        idx_sum = [E_A; E_A; L_A; R_A];
        
        lambda_sum(lambda_sum + tol > lambda_2(l)) = 0;
        
        [lambda, idx] = max(lambda_sum);

        %% Judge if ending the loop.
        if lambda <= 0
            fprintf('Step %d: Can''t find the next step! \n', l + 1);
            break;
        end
        
        %% Update the (l + 1)-step event.
        if idx <= len_E_A
            p(l + 1) = 1;
        elseif (idx > len_E_A) & (idx <= len_E_A * 2)
            p(l + 1) = 2;
        elseif (idx > len_E_A * 2) & (idx <= len_E_A * 2 + len_L_A)
            p(l + 1) = 3;
        else
            p(l + 1) = 4;
        end
        
        pos(l + 1) = idx_sum(idx);
        
        %% Print log.
        if log
            if p(l + 1) == 1
                desc = 'E -> L';
            elseif p(l + 1) == 2
                desc = 'E -> R';
            elseif p(l + 1) == 3
                desc = 'L -> E';
            else
                desc = 'R -> E';
            end
            
            fprintf('[QPP-2, STEP %3d] Event %d (%s) %d, lambda = %.4f\n',...
                l, p(l + 1), desc, pos(l + 1), lambda);
        end
        
        %% Update paras.
        lambda_2(l + 1) = lambda;

        alpha_2(:, l + 1) = alpha_2(:, l); % Initialize with the last step.
        if len_E_A ~= 0
            alpha_2(E_A, l + 1) = alpha_2(E_A, l)...
                - (lambda_2(l) - lambda_2(l + 1)) * theta;
        end
        
        %% Update index sets.
        if p(l + 1) == 1
            alpha_2(pos(l + 1), l + 1) = 1;
            E_A = setdiff(E_A, pos(l + 1));
            L_A = sort([L_A; pos(l + 1)]);
        end
        
        if p(l + 1) == 2
            alpha_2(pos(l + 1), l + 1) = 0;
            E_A = setdiff(E_A, pos(l + 1));
            R_A = sort([R_A; pos(l + 1)]);
        end
        
        if p(l + 1) == 3
            f_2(pos(l + 1), l + 1) = -1;
            L_A = setdiff(L_A, pos(l + 1));
            E_A = sort([E_A; pos(l + 1)]);
        end
        
        if p(l + 1) == 4
            f_2(pos(l + 1), l + 1) = -1;
            R_A = setdiff(R_A, pos(l + 1));
            E_A = sort([E_A; pos(l + 1)]);
        end
        
        %% Update weight.
        v = 1 / lambda_2(l + 1) * Q_inv * P' * alpha_2(:, l + 1);
        w_2(:, l + 1) = v(1 : end - 1);
        b_2(:, l + 1) = v(end);
        
        f_2(:, l + 1) = A * w_2(:, l + 1) + b_2(:, l + 1);
        
        %% Update step.
        l = l + 1;
        
    end
    
    %% Print Info.
    fprintf('\n------------[QPP 2]--------------\n');
    for i = 1 : 4
        fprintf('Event %d\t', i);
    end
    fprintf('Sum\n');
    for i = 1 : 4
        num = sum(p == i);
        fprintf('%d\t', num);
    end
    fprintf('%d\n', length(p) - 1);
    
end
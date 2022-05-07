function [lambda_1, alpha_1, f_1, w_1, b_1] = QPP_1(A, B,...
    alpha_1_0, w_1_0, b_1_0, lambda_1_0, log)
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
    
    F = [A e_1];
    G = [B e_2];
    
    F_inv = pinv(F' * F + delta * eye(m + 1));
    
    %% Initize the first step.
    l = 1; % Current step

    alpha_1(:, 1) = alpha_1_0;
    w_1(:, 1) = w_1_0;
    b_1(1) = b_1_0;
    
    lambda_1(1) = lambda_1_0;
    
    f_1(:, 1) = B * w_1 + b_1;
    
    % Divide sets.
    L_B = find(abs(alpha_1 - 1) < tol);
    E_B = find(1 - alpha_1 >= tol & alpha_1 - 0 >= tol);
    R_B = find(abs(alpha_1 - 0) < tol);
    
    p(l) = 0;   % Event
    pos(l) = 0; % Pos of point corresponds to the event.
    
    %% Iteration Loop.
    while (lambda_1(l) > threshold) & (l < maxIter)
        %% Initilize params before each loop
        len_E_B = length(E_B);
        len_L_B = length(L_B);
        len_R_B = length(R_B);
        
        if len_E_B ~= 0
            A_bar = G(E_B, :) * F_inv * G(E_B, :)'; 
            A_bar_inv = pinv(A_bar + delta * eye(size(A_bar)));
            
            e = ones(len_E_B, 1);
            theta = A_bar_inv * e;
            h = G * F_inv * G(E_B, :)' * theta;
        else
            e_empty = [zeros(1, m), 0];
            A_bar = e_empty * F_inv * e_empty'; 
            A_bar_inv = pinv(A_bar + delta * eye(size(A_bar)));
            
            e = ones(1, 1);
            theta = A_bar_inv * e;
            h = G * F_inv * e_empty' * theta;
        end
        
        %% Event 1.
        if len_E_B ~= 0
            lambda_1_1 = lambda_1(l) - (alpha_1(E_B, l) - 1) ./ theta;
        else
            lambda_1_1 = [];
        end
        
        %% Event 2.
        if len_E_B ~= 0
            lambda_1_2 = lambda_1(l) - alpha_1(E_B, l) ./ theta;
        else
            lambda_1_2 = [];
        end
        
        %% Event 3.
        if len_L_B ~= 0
            lambda_1_3 = lambda_1(l) * (f_1(L_B, l) + h(L_B, :)) ./ (-1 + h(L_B, :));
        else
            lambda_1_3 = [];
        end
        
        %% Event 4.
        if len_R_B ~= 0
            lambda_1_4 = lambda_1(l) * (f_1(R_B, l) + h(R_B, :)) ./ (-1 + h(R_B, :));
        else
            lambda_1_4 = [];
        end
        
        %% Select the first event.
        lambda_sum = [lambda_1_1; lambda_1_2; lambda_1_3; lambda_1_4];
        idx_sum = [E_B; E_B; L_B; R_B];
        
        lambda_sum(lambda_sum + tol > lambda_1(l)) = 0;
        [lambda, idx] = max(lambda_sum);
        

        %% Judge if ending the loop.
        if lambda <= 0
            fprintf('Step %d: Can''t find the next step! \n', l + 1);
            break;
        end
        
        %% Update the (l + 1)-step event.
        if idx <= len_E_B
            p(l + 1) = 1;
        elseif (idx > len_E_B) & (idx <= len_E_B * 2)
            p(l + 1) = 2;
        elseif (idx > len_E_B * 2) & (idx <= len_E_B * 2 + len_L_B)
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
            
            fprintf('[QPP-1, STEP %3d] Event %d (%s) %d, lambda = %.4f\n',...
                l, p(l + 1), desc, pos(l + 1), lambda);
        end
        
        %% Update paras.
        lambda_1(l + 1) = lambda; 
        
        alpha_1(:, l + 1) = alpha_1(:, l); % Initialize with the last step.
        if len_E_B ~= 0
            alpha_1(E_B, l + 1) = alpha_1(E_B, l)...
                - (lambda_1(l) - lambda_1(l + 1)) * theta;
        end
        
        %% Update index sets.
        if p(l + 1) == 1
            alpha_1(pos(l + 1), l + 1) = 1;
            E_B = setdiff(E_B, pos(l + 1));
            L_B = sort([L_B; pos(l + 1)]);
        end
        
        if p(l + 1) == 2
            alpha_1(pos(l + 1), l + 1) = 0;
            E_B = setdiff(E_B, pos(l + 1));
            R_B = sort([R_B; pos(l + 1)]);
        end
        
        if p(l + 1) == 3
            L_B = setdiff(L_B, pos(l + 1));
            E_B = sort([E_B; pos(l + 1)]);
        end
        
        if p(l + 1) == 4
            R_B = setdiff(R_B, pos(l + 1));
            E_B = sort([E_B; pos(l + 1)]);
        end
        
        %% Update weight.
        u = -1 / lambda_1(l + 1) * F_inv * G' * alpha_1(:, l + 1);
        w_1(:, l + 1) = u(1 : end - 1);
        b_1(:, l + 1) = u(end);
        
        f_1(:, l + 1) = B * w_1(:, l + 1) + b_1(:, l + 1);

        %% Update step.
        l = l + 1;
        
    end
    
    %% Print Info.
    fprintf('\n------------[QPP 1]--------------\n');
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
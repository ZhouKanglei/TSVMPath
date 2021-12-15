function [lambda_2, alpha_2, f_2, w_2, b_2, alpha0_2, theta_0, h_1, h_2, p] = QPP_2(A, B,...
    alpha_2_0, w_2_0, b_2_0, lambda_2_0)
    variables();
    %% Divid Data Set.
    l_1 = size(A, 1);
    l_2 = size(B, 1);
    n = l_1 + l_2;
    
    e_1 = ones(l_1, 1);
    e_2 = ones(l_2, 1);
    
    m = size(B, 2);
    
    B_star = inv(B' * B + delta * eye(m));

    l = 1;
    
    alpha_2(:, 1) = alpha_2_0;
    w_2(:, 1) = w_2_0;
    b_2(1) = b_2_0;
    lambda_2(1) = lambda_2_0;
    alpha0_2(1) = lambda_2_0 * b_2_0;
    
%     w_2(:, 1) = - 1 / lambda_2(l) * B_star * (lambda_2(l) * b_2(1) * B' * e_2...
%         - sum(alpha_2(:, 1)' * A));

    
    f_2(:, 1) = A * w_2(:, 1) + b_2(1);
    
    L_A = find(alpha_2 == 1);
    E_A = find(alpha_2 < 1 & alpha_2 > 0);
    R_A = find(alpha_2 == 0);
    
    B_11 = 1 - e_2' * B * B_star * B' * e_2;
    
    p(1) = 0;
    
    %% Iter.
    while lambda_2(l) > threshold && l < maxIter
        if length(E_A) ~= 0
            B_12 = e_2' * B * B_star * A(E_A, :)' - 1;
            B_21 = A(E_A, :) * B_star * B' * e_2 - 1;
            B_22 = A(E_A, :) * B_star * A(E_A, :)'; 
            len_E_A = length(E_A);
        else
            B_12 = -1;
            B_21 = -1;
            B_22 = 0;
            len_E_A = 1;
        end
        B_bar = [B_11, B_12; B_21, B_22];
        e = [0 ones(1, len_E_A)]';
        inv_Be = inv(B_bar + delta * eye(1 + len_E_A)) * e;
        
        theta_0 = inv_Be(1);
        theta = inv_Be(2 : end);
        
        if length(E_A) ~= 0
            h_1 = theta_0 * B_star * B' * e_2 +  B_star * (theta' * A(E_A, :))';
            h_2 = -theta_0 * (1 - A * B_star * B' * e_2)...
                - A * B_star * (theta' * A(E_A, :))';
        else
            h_1 = theta_0 * B_star * B' * e_2;
            h_2 = -theta_0 * (1 - A * B_star * B' * e_2);            
        end
        
        %% Event 1 - 4.
        if length(E_A) ~= 0
            lambda_2_1 = lambda_2(l) + (alpha_2(E_A, l) - 1) ./ theta;
            lambda_2_1(lambda_2_1 >= lambda_2(l)) = 0;
            [lambda_2_1_max, pos(1)] = max(lambda_2_1);
        else
            lambda_2_1_max = 0;
        end
        
        if length(E_A) ~= 0
            lambda_2_2 = lambda_2(l) + alpha_2(E_A, l) ./ theta;
            lambda_2_2(lambda_2_2 >= lambda_2(l)) = 0;
            [lambda_2_2_max, pos(2)] = max(lambda_2_2);
        else
            lambda_2_2_max = 0;
        end
        
        if length(L_A) ~= 0
            lambda_2_3 = lambda_2(l) * (f_2(L_A, l) - h_2(L_A, :)) ./ (1 - h_2(L_A, :));
            lambda_2_3(lambda_2_3 >= lambda_2(l)) = 0;
            [lambda_2_3_max, pos(3)] = max(lambda_2_3);
        else
            lambda_2_3_max = 0;
        end
        
        if length(R_A) ~= 0
            lambda_2_4 = lambda_2(l) * (f_2(R_A, l) - h_2(R_A, :)) ./ (1 - h_2(R_A, :));
            lambda_2_4(lambda_2_4 >= lambda_2(l)) = 0;
            [lambda_2_4_max, pos(4)] = max(lambda_2_4);
        else
            lambda_2_4_max = 0;
        end
        lambda_2_l = [lambda_2_1_max, lambda_2_2_max,...
            lambda_2_3_max, lambda_2_4_max];
        
        if max(lambda_2_l) <= 0
            fprintf('\nStep %d: Can''t find the next step!', l + 1);
            break;
        end
        
        [lambda, p(l + 1)] = max(lambda_2_l);
        
        %% Update paras.
        lambda_2(l + 1) = lambda;
        alpha0_2(l + 1) = alpha0_2(l) - (lambda_2(l) - lambda_2(l + 1)) * theta_0;
        alpha_2(:, l + 1) = alpha_2(:, l);
        if length(E_A) ~= 0
            alpha_2(E_A, l + 1) = alpha_2(E_A, l)...
                - (lambda_2(l) - lambda_2(l + 1)) * theta;
            idx_over = find(alpha_2(E_A, l + 1) > 1 | alpha_2(E_A, l + 1) < 0);
            alpha_2(E_A(idx_over), l + 1) = alpha_2(E_A(idx_over), l);
        end
        f_2(:, l + 1) = lambda_2(l) / lambda_2(l + 1) * (f_2(:, l) - h_2) + h_2;
        w_2(:, l + 1) = lambda_2(l) / lambda_2(l + 1) * (w_2(l) + h_1) - h_1;
%         w_2(:, l + 1) = - 1 / lambda_2(l + 1) * B_star * (alpha0_2(l + 1) * B' * e_2...
%         - sum(alpha_2(:, l + 1)' * A));
        
        %% Update index sets.
        if p(l + 1) == 1
            idx(l + 1) = E_A(pos(p(l + 1)));
            alpha_2(idx(l + 1), l + 1) = 1;
            E_A = setdiff(E_A, idx(l + 1));
            L_A = sort([L_A; idx(l + 1)]);
        end
        
        if p(l + 1) == 2
            idx(l + 1) = E_A(pos(p(l + 1)));
            alpha_2(idx(l + 1), l + 1) = 0;
            E_A = setdiff(E_A, idx(l + 1));
            R_A = sort([R_A; idx(l + 1)]);
        end
        
        if p(l + 1) == 3
            idx(l + 1) = L_A(pos(p(l + 1)));
            f_2(idx(l + 1), l + 1) = 1;
            L_A = setdiff(L_A, idx(l + 1));
            E_A = sort([E_A; idx(l + 1)]);
        end
        
        if p(l + 1) == 4
            idx(l + 1) = R_A(pos(p(l + 1)));
            f_2(idx(l + 1), l + 1) = 1;
            R_A = setdiff(R_A, idx(l + 1));
            E_A = sort([E_A; idx(l + 1)]);
        end
        
        l = l + 1;
        %% Print mode.
        fprintf('+');
        if mod(l - 1, 50) == 0
            fprintf('\n');
        end
        
    end
    b_2 = alpha0_2 ./ lambda_2;
    
    %% Print Info.
    fprintf('\n----------------------\n');
    for i = 1 : 4
        fprintf('Event %d\t', i);
    end
    fprintf('Sum\n');
    for i = 1 : 4
        num = sum(p == i);
        pos_p = find(p == i);
        fprintf('%d\t', num);
    end
    fprintf('%d\n----------------------\nQPP 2 Done...\n', length(p) - 1);
    
end
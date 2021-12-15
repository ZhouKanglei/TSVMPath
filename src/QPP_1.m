function [lambda_1, alpha_1, f_1, w_1, b_1,...
    alpha0_1, theta_0, h_1, h_2, p] = QPP_1(A, B,...
    alpha_1_0, w_1_0, b_1_0, lambda_1_0)
    variables();
    %% Divid Data Set.

    l_1 = size(A, 1);
    l_2 = size(B, 1);
    n = l_1 + l_2;
    e_1 = ones(l_1, 1);
    e_2 = ones(l_2, 1);
    m = size(A, 2);
    
    A_star = inv(A' * A + delta * eye(m));

    l = 1;

    alpha_1(:, 1) = alpha_1_0;
    w_1(:, 1) = w_1_0;
    b_1(1) = b_1_0;
    
    lambda_1(1) = lambda_1_0;
    alpha0_1(1) = lambda_1_0 * b_1_0;
    
%     w_1(:, 1) = - 1 / lambda_1(l) * A_star * (lambda_1(l) * b_1 * A' * e_1...
%         + sum(alpha_1(:, 1)' * B));
    
    f_1(:, 1) = B * w_1 + b_1;
    
    L_B = find(alpha_1 == 1);
    E_B = find(alpha_1 < 1 & alpha_1 > 0);
    R_B = find(alpha_1 == 0);
    
    A_11 = 1 - e_1' * A * A_star * A' * e_1;
    
    p(1) = 0;
    
    %% Iter.
    while lambda_1(1) > threshold && l < maxIter
        if length(E_B) ~= 0
            A_12 = 1 - e_1' * A * A_star * B(E_B, :)';
            A_21 = B(E_B, :) * A_star * A' * e_1 - 1;
            A_22 = B(E_B, :) * A_star * B(E_B, :)'; 
            len_E_B = length(E_B);
        else
            A_12 = 1;
            A_21 = -1;
            A_22 = 0;
            len_E_B = 1;
        end
        A_bar = [A_11, A_12; A_21, A_22];
        e = [0 ones(1, len_E_B)]';
        inv_Ae = inv(A_bar + delta * eye(1 + len_E_B)) * e;
        
        theta_0 = inv_Ae(1);
        theta = inv_Ae(2 : end);
        
        if length(E_B) ~= 0
            h_1 = theta_0 * A_star * A' * e_1 +  A_star * (theta' * B(E_B, :))';
            h_2 = theta_0 * (1 - B * A_star * A' * e_1)...
                - B * A_star * (theta' * B(E_B, :))';
        else
            h_1 = theta_0 * A_star * A' * e_1;
            h_2 = theta_0 * (1 - B * A_star * A' * e_1);            
        end
        
        %% Event 1 - 4.
        if length(E_B) ~= 0
            lambda_1_1 = lambda_1(l) - (alpha_1(E_B, l) - 1) ./ theta;
            lambda_1_1(lambda_1_1 >= lambda_1(l)) = 0;
            [lambda_1_1_max, pos(1)] = max(lambda_1_1);
        else
            lambda_1_1_max = 0;
        end
        
        if length(E_B) ~= 0
            lambda_1_2 = lambda_1(l) - alpha_1(E_B, l) ./ theta;
            lambda_1_2(lambda_1_2 >= lambda_1(l)) = 0;
            [lambda_1_2_max, pos(2)] = max(lambda_1_2);
        else
            lambda_1_2_max = 0;
        end
        
        if length(L_B) ~= 0
            lambda_1_3 = lambda_1(l) * (f_1(L_B, l) - h_2(L_B, :)) ./ (-1 - h_2(L_B, :));
            lambda_1_3(lambda_1_3 >= lambda_1(l)) = 0;
            [lambda_1_3_max, pos(3)] = max(lambda_1_3);
        else
            lambda_1_3_max = 0;
        end
        
        if length(R_B) ~= 0
            lambda_1_4 = lambda_1(l) * (f_1(R_B, l) - h_2(R_B, :)) ./ (-1 - h_2(R_B, :));
            lambda_1_4(lambda_1_4 >= lambda_1(l)) = 0;
            [lambda_1_4_max, pos(4)] = max(lambda_1_4);
        else
            lambda_1_4_max = 0;
        end
        lambda_1_l = [lambda_1_1_max, lambda_1_2_max,...
            lambda_1_3_max, lambda_1_4_max];
        
        if max(lambda_1_l) <= 0
            fprintf('\nStep %d: Can''t find the next step! ', l + 1);
            break;
        end
        
        [lambda, p(l + 1)] = max(lambda_1_l);
        
        %% Update paras.
        lambda_1(l + 1) = lambda; 
%         plot(lambda_1); text(l + 1, 100, num2str(p(l + 1)));
        alpha0_1(l + 1) = alpha0_1(l) - (lambda_1(l) - lambda_1(l + 1)) * theta_0;
        alpha_1(:, l + 1) = alpha_1(:, l);
        if length(E_B) ~= 0
            alpha_1(E_B, l + 1) = alpha_1(E_B, l)...
                - (lambda_1(l) - lambda_1(l + 1)) * theta;
            idx_over = find(alpha_1(E_B, l + 1) > 1 | alpha_1(E_B, l + 1) < 0);
            alpha_1(E_B(idx_over), l + 1) = alpha_1(E_B(idx_over), l);
        end
        f_1(:, l + 1) = lambda_1(l) / lambda_1(l + 1) * (f_1(:, l) - h_2) + h_2;
        w_1(:, l + 1) = lambda_1(l) / lambda_1(l + 1) * (w_1(l) + h_1) - h_1;
%         w_1(:, l + 1) = - 1 / lambda_1(l + 1) * A_star * (alpha0_1(l + 1) * A' * e_1...
%         + sum(alpha_1(:, l + 1)' * B));
        
        %% Update index sets.
        if p(l + 1) == 1
            idx(l + 1) = E_B(pos(p(l + 1)));
            alpha_1(idx(l + 1), l + 1) = 1;
            E_B = setdiff(E_B, idx(l + 1));
            L_B = sort([L_B; idx(l + 1)]);
        end
        
        if p(l + 1) == 2
            idx(l + 1) = E_B(pos(p(l + 1)));
            alpha_1(idx(l + 1), l + 1) = 0;
            E_B = setdiff(E_B, idx(l + 1));
            R_B = sort([R_B; idx(l + 1)]);
        end
        
        if p(l + 1) == 3
            idx(l + 1) = L_B(pos(p(l + 1)));
            f_1(idx(l + 1), l + 1) = -1;
            L_B = setdiff(L_B, idx(l + 1));
            E_B = sort([E_B; idx(l + 1)]);
        end
        
        if p(l + 1) == 4
            idx(l + 1) = R_B(pos(p(l + 1)));
            f_1(idx(l + 1), l + 1) = -1;
            
            R_B = setdiff(R_B, idx(l + 1));
            E_B = sort([E_B; idx(l + 1)]);
        end
        
%         w_2(:, l + 1) = - 1 / lambda_1(l + 1) * A_star * (alpha0_1(l + 1) * A' * e_1...
%         + sum(alpha_1(:, l + 1)' * B));
%     
%         w_2(:, l + 1) - w_1(:, l + 1)
%         plot(alpha_1');
        
        l = l + 1;
        %% Print mode.
        fprintf('+');
        if mod(l - 1, 50) == 0
            fprintf('\n');
        end
        
    end
    b_1 = alpha0_1 ./ lambda_1;
    
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
    fprintf('%d\n----------------------\nQPP 1 Done...\n', length(p) - 1);

end
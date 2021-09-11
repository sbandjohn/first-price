function y = eps_greedy(R, C, T, eps_r, eps_c)
MR = size(R, 1); MC = size(R, 2); 

avg_reward_r = zeros(MR, 1);  count_r = zeros(MR, 1);
avg_reward_c = zeros(MC, 1);  count_c = zeros(MC, 1); 

row_w_s = zeros(MR, T);
col_w_s = zeros(MC, T);

for t = 1:T
    [max_r, argmax_r] = max(avg_reward_r); 
    tmp_r = zeros(MR, 1); 
    tmp_r(argmax_r) = 1;
    prop_r = eps_r * ones(MR, 1) / MR  +  (1-eps_r) * tmp_r; 
    
    [max_c, argmax_c] = max(avg_reward_c); 
    tmp_c = zeros(MC, 1); 
    tmp_c(argmax_c) = 1;
    prop_c = eps_c * ones(MR, 1) / MR  +  (1-eps_c) * tmp_c; 
    
    b_r = randsample(MR, 1, true, prop_r);
    b_c = randsample(MC, 1, true, prop_c);
  
    reward_r = R(b_r, b_c);
    reward_c = C(b_r, b_c);
    
    count_r(b_r) = count_r(b_r) + 1; 
    avg_reward_r(b_r) = ((count_r(b_r)-1)*avg_reward_r(b_r) + reward_r) / count_r(b_r); 
    count_c(b_c) = count_c(b_c) + 1;
    avg_reward_c(b_c) = ((count_c(b_c)-1)*avg_reward_c(b_c) + reward_c) / count_c(b_c);
    
    row_w_s(:, t) = prop_r;
    col_w_s(:, t) = prop_c;
end

y = {row_w_s, col_w_s, prop_r, prop_c}; 
end

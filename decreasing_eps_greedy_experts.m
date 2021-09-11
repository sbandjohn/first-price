function res = decreasing_eps_greedy_experts(P1, P2, T, func1, func2)
M1 = size(P1, 1); M2 = size(P2, 2); 

sum_reward_1 = zeros(M1, 1);
sum_reward_2 = zeros(M2, 1);

bid_seq_1 = zeros(1, T); 
bid_seq_2 = zeros(1, T); 

strategy_seq_1 = zeros(M1, T);
strategy_seq_2 = zeros(M2, T);

for t = 1:T
    eps_1 = func1(t); 
    [~, argmax_1] = max(sum_reward_1); 
    tmp_1 = zeros(M1, 1); 
    tmp_1(argmax_1) = 1;
    prop_1 = eps_1 * ones(M1, 1) / M1  +  (1-eps_1) * tmp_1; 
    
    eps_2 = func2(t); 
    [~, argmax_2] = max(sum_reward_2); 
    tmp_2 = zeros(M2, 1); 
    tmp_2(argmax_2) = 1;
    prop_2 = eps_2 * ones(M2, 1) / M2  +  (1-eps_2) * tmp_2; 
    
    b_1 = randsample(M1, 1, true, prop_1);
    b_2 = randsample(M2, 1, true, prop_2);
    
    sum_reward_1 = sum_reward_1 + P1(:, b_2);
    sum_reward_2 = sum_reward_2 + P2(b_1, :)'; 

    bid_seq_1(t) = b_1;
    bid_seq_2(t) = b_2; 
    strategy_seq_1(:, t) = prop_1;
    strategy_seq_2(:, t) = prop_2;
end

res = {bid_seq_1, bid_seq_2, strategy_seq_1, strategy_seq_2}; 
end

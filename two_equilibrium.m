N = 2;
M = 4;
v1 = M;
v2 = M; 
P1 = zeros(M);
P2 = zeros(M);

for i = 0:(M-1)
    P1(i+1, i+1) = (v1-i)/2;  P2(i+1, i+1) = (v2-i)/2;
    for j = 0:(M-1)
        if (j < i)
            P1(i+1, j+1) = v1-i;  P2(i+1, j+1) = 0;
        else
            if (j > i)
               P1(i+1, j+1) = 0;  P2(i+1, j+1) = v2-j;  
            end
        end
    end
end


T = 20000;

% res = MWU(R, C, T, eps_r, eps_c, "uniform", "uniform")
% res = eps_greedy(R, C, T, eps_r, eps_c);

c1 = 1; c2 = 1;
para_func_1 = @(t) c1 / sqrt(t); 
para_func_2 = @(t) c2 / sqrt(t); 

% handle = @() decreasing_eps_greedy_experts(P1, P2, T, para_func_1, para_func_2); 
% name = "decreasing \epsilon greedy, experts"; 

handle = @() eps_greedy(P1, P2, T, para_func_1, para_func_2); 
name = "decreasing \epsilon greedy, bandit"; 



%%%%%%%%%% BEGIN: show results for once %%%%%%%%%%%%
res = handle();

bid_seq_1 = res{1}; 
bid_seq_2 = res{2}; 
strategy_seq_1 = res{3}; 
strategy_seq_2 = res{4}; 

frequency_seq = get_frequency_seq(bid_seq_1, M); 

xs = 1:T; 

figure()
bids = [0 1 2 3]; 
styles = {"-.", ":", "-", "--"}; 
for i = bids
    plot(xs, frequency_seq(i+1, :), styles{i+1}, "LineWidth", 1.5)
    hold on 
end
legend("0", "1", "2", "3")
title("bid frequency of player 1 -- "+name+" -- v1="+num2str(M)) 
hold off

figure()
for i = bids
    plot(xs, strategy_seq_1(i+1, :), styles{i+1}, "LineWidth", 1.5)
    hold on
end
legend("0", "1", "2", "3")
title("strategy of player 1 -- "+name+" -- v1="+num2str(M)) 
hold off


%%%%%%%%%% END: show results for once %%%%%%%%%%%%


%%%%%%%%%% BEGIN: count the times of the two NE %%%%%%%%%%%%%%
%%%%%%%%%% change T to a big number before running the following 
res = count_which_NE(M, T, 1000, handle)
%%%%%%%%%% END: count the times of the two NE %%%%%%%%%%%%%%





%%%%%%%% helper functions %%%%%%%%%%%%%

function f_seq = get_frequency_seq(a_seq, M)
T = size(a_seq, 2); assert(size(a_seq, 1) == 1); 
f_seq = zeros(M, T);
f_seq(a_seq(1), 1) = 1; 
for t = 2:T
    f_seq(:, t) = f_seq(:, t-1); 
    f_seq(a_seq(t), t) = f_seq(a_seq(t), t-1) + 1; 
end
for t = 2:T
    f_seq(:, t) = f_seq(:, t) ./ t; 
end
end

function res = count_which_NE(M, T, times, handle)
    second = 0;
    first = 0;
    other = 0;
    for i = 1:times
        res = handle(); 
        bid_seq = res{1}; 
        f_seq = get_frequency_seq(bid_seq, M); 
        f = f_seq(:, T); 
        if f(M) > 0.9
            second = second + 1; 
        else
            if f(M-1) > + 0.9
                first = first + 1;
            else
                other = other + 1;
            end
        end
    end
    res = [first, second, other]; 
end



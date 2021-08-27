N = 2;
M = 10;
v1 = M;
v2 = M-2; 
R = zeros(M);
C = zeros(M);

for i = 1:M
    R(i, i) = (v1-i)/2;  C(i, i) = (v2-i)/2;
    for j = 1:M
        if (j < i)
            R(i, j) = v1-i;  C(i, j) = 0;
        else
            if (j > i)
               R(i, j) = 0;  C(i, j) = v2-j;  
            end
        end
    end
end


T = 200000;
eps_r = 0.08;
eps_c = 0.08; 

% res = MWU(R, C, T, eps_r, eps_c, "uniform", "uniform")
res = eps_greedy(R, C, T, eps_r, eps_c);
row_w_s = res{1}; 
col_w_s = res{2}; 
row_w = res{3}
col_w = res{4}

xs = 1:T; 

figure()
is = [2 3 4 5 6 7 8]
for i = is
    plot(xs, row_w_s(i, :))
    hold on 
end
% legend("1", "3", "5", "7", "9", "12")
legend("2", "3", "4", "5", "6", "7", "8")
hold off

figure()
for i = is
    plot(xs, col_w_s(i, :))
    hold on
end
% legend("1", "3", "5", "7", "9", "12")
legend("2", "3", "4", "5", "6", "7", "8")
hold off


function y = MWU(R, C, T, eps_r, eps_c, R_init, C_init)
MR = size(R, 1); MC = size(R, 2); 

row_w = R_init; col_w = C_init;
if (isa(R_init, 'string') && R_init == "uniform")
    row_w = ones(MR, 1);
end
if (isa(C_init, 'string') && C_init == "uniform")
    col_w = ones(MC, 1);
end
row_w = row_w / sum(row_w);  col_w = col_w / sum(col_w); 

row_w_s = zeros(MR, T);    row_w_s(:, 1) = row_w;
col_w_s = zeros(MC, T);    col_w_s(:, 1) = col_w;

for t = 2:T
    row_r = R * col_w; 
    col_r = (row_w' * C)'; 
    row_w = row_w .* (1+eps_r).^row_r; 
    row_w = row_w / sum(row_w); 
    col_w = col_w .* (1+eps_c).^col_r; 
    col_w = col_w / sum(col_w); 
    row_w_s(:, t) = row_w;
    col_w_s(:, t) = col_w;
end

y = {row_w_s, col_w_s, row_w, col_w}; 
end

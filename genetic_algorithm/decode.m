
function pop_real = decode(upper, lower, n_bits, pop, N_pop)
% pop: N_pop x n_total_bits (0/1 em logical/uint8/double)
% n_bits: nº de bits por variável (ex.: [b1 b2 b3 b4] ou coluna)
% upper, lower: limites por variável (colunas)

    n_var = numel(n_bits);
    pop_real = zeros(N_pop, n_var);

    % índices de fim e início de cada segmento (por variável)
    ends   = cumsum(n_bits(:));            % (n_var x 1)
    starts = [1; ends(1:end-1) + 1];       % (n_var x 1)

    for i = 1:N_pop
        for j = 1:n_var
            seg = double(pop(i, starts(j):ends(j)));  % bits da variável j para o indivíduo i
            b   = numel(seg);

            % --- LSB-first como na figura: primeiro bit tem peso 2^0 ---
            dec = sum(seg .* 2.^(0:b-1));             % x_{i,bin} = Σ 2^{h-1} b_h

            max_dec = 2^b - 1;
            pop_real(i,j) = lower(j) + dec * (upper(j) - lower(j)) / max_dec;
        end
    end
end


function pop_bin = encode(upper, lower, n_bits, X_real, N_pop)
% Converte população real X_real (N_pop x n_var) para binário LSB-first.
% upper, lower : (n_var x 1) limites
% n_bits       : (n_var x 1) nº de bits por variável
% pop_real       : (N_pop x n_var) valores reais
% N_pop        : nº de indivíduos
%
% Saída:
%   pop_bin    : (N_pop x n_total_bits) com 0/1 (double) em LSB-first

    n_var = numel(n_bits);
    n_total_bits = sum(n_bits);
    pop_bin = zeros(N_pop, n_total_bits);  % podes trocar para 'uint8' se quiseres

    % índices de início/fim de cada segmento (por variável)
    ends   = cumsum(n_bits(:));            % (n_var x 1)
    starts = [1; ends(1:end-1) + 1];       % (n_var x 1)

    for i = 1:N_pop
        for j = 1:n_var
            b = n_bits(j);
            x = X_real(i, j);

            % garantir que está dentro dos limites
            if x < lower(j), x = lower(j); end
            if x > upper(j), x = upper(j); end

            % escalar para inteiro entre [0, 2^b-1]
            max_dec = 2^b - 1;
            dec = round( (x - lower(j)) / (upper(j) - lower(j)) * max_dec );

            % converter 'dec' para bits LSB-first: b1 (LSB) ... b_b (MSB)
            % b_h = bitget(dec, h) devolve o bit na posição h (LSB=1)
            bits = zeros(1, b);
            for h = 1:b
                bits(h) = bitget(dec, h);   % LSB-first
            end

            % armazenar no cromossoma (segmento da variável j)
            pop_bin(i, starts(j):ends(j)) = bits;
        end
    end
end

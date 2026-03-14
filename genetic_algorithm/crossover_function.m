
function filhos_bin = crossover_function(P_cross, selected, upper, lower, n_bits)
% selected: matriz (N_sel x n_var) de pais em real
% Retorna: filhos em real (mesma dimensão que selected)
%
% Estratégia: encode -> crossover uniforme

    % nº de pais selecionados
    n_indiv_selec = size(selected, 1);

    % codificar pais para binário (LSB-first, consistente com o teu 'encode')
    pop_bin = encode(upper, lower, n_bits, selected, n_indiv_selec);
    n_total = sum(n_bits);  % comprimento do cromossoma binário

    % prealocar filhos (binários)
    filhos_bin = zeros(n_indiv_selec, n_total);

    % garantir número par de pais (se ímpar, último fica igual)
    last_pair = n_indiv_selec - mod(n_indiv_selec, 2);

    for i = 1:2:last_pair
        % pais i e i+1 (linhas)
        parent1 = pop_bin(i,   :);
        parent2 = pop_bin(i+1, :);

        if rand < P_cross
            % máscara aleatória para crossover uniforme
            M = randi([0, 1], 1, n_total);  % vetor 1 x n_total

            % filhos por gene
            child1 = parent1;  % inicializa
            child2 = parent2;
            % aplicar máscara: onde M==1, troca genes
            idx = (M == 1);
            child1(idx) = parent2(idx);
            child2(idx) = parent1(idx);

            filhos_bin(i,   :) = child1;
            filhos_bin(i+1, :) = child2;
        else
            % sem crossover: filhos iguais aos pais
            filhos_bin(i,   :) = parent1;
            filhos_bin(i+1, :) = parent2;
        end
    end

    % se número de pais é ímpar, último pai vai direto
    if mod(n_indiv_selec, 2) == 1
        filhos_bin(end, :) = pop_bin(end, :);
    end

   
end

function filhos_mutados = mutacao(filhos_bin, P_mut,n_bits)

n_indiv = size(filhos_bin,1);
n_total = sum(n_bits);
filhos_mutados = zeros(n_indiv,n_total);

for i = 1:n_indiv
    for j = 1:n_total
        P = rand;
        if P<P_mut
            filhos_mutados(i, j) = ~filhos_bin(i, j); % Flip the bit
        else
            filhos_mutados(i, j) = filhos_bin(i, j); % Keep the original bit
        end
    end
end

end
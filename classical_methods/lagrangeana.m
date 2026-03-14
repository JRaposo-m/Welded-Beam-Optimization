function La = lagrangeana(x, lambda, epsilon, params)
    % Função objetivo
    f = funcao_objetivo(x);
    
    % Restrições
    g = calcular_restricoes(params, x);
    
    % Lagrangeana Aumentada: La = f + λᵀmax(g, -ε/2 λ) + 1/ε ||max(g, -ε/2 λ)||²
    max_term = max(g, -epsilon/2 * lambda);
    
    La = f + lambda' * max_term + (1/epsilon) * norm(max_term)^2;
end       
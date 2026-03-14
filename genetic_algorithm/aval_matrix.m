function [Aval_CCA,pen] = aval_matrix(x,params,lambda)

    % --- objetivo ---
    f = funcao_objetivo(x);

    % --- restrições ---
    g = calcular_restricoes(params, x);  
    g = g(:);                            % força coluna

    % --- violações positivas ---
    u = max(0, g);                       % só contam as violações (g>0)
    pen = sum(u);                        % L1: soma das violações
    

    penal_weight = lambda;


    % --- avaliador ---
    Aval = f + penal_weight * (pen^2);


    % --- proteção contra zero/negativo ---
    eps_min = 1e-12;
    Aval_CCA = max(Aval, eps_min);

end
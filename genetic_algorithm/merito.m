
function Mer = merito(x, params, C, alfa, beta, k)
% MERITO: retorna métrica para maximização (maior Mer = melhor).
% Convenção: restrições g(x) <= 0 são viáveis.

    % --- objetivo ---
    f = funcao_objetivo(x);

    % --- restrições ---
    g = calcular_restricoes(params, x);  
    g = g(:);                            % força coluna

    % --- violações positivas ---
    u = max(0, g);                       % só contam as violações (g>0)
    pen = sum(u);                        % L1: soma das violações
    
    C_max = 100;

    % --- peso da penalização (cresce com k) ---
    penal_weight = (C * k)^alfa;


    % --- avaliador ---
    Aval = f + penal_weight * (pen^beta);

    % --- proteção contra zero/negativo ---
    eps_min = 1e-12;
    Aval = max(Aval, eps_min);

    if C_max<Aval
        Aval = C_max - 1e-6;
    end

    % --- mérito para maximização ---
     Mer = C_max - Aval;



end

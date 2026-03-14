
function KKT = verifica_KKT(x_k, lambda_k, params)

    tolerancia = 1e-4;

    % Calcula gradiente da função objetivo
    grad_f = calcula_grad_f(x_k);

    % Gradiente das restrições (6x4)
    %grad_restri = calculo_grad_restri(x_k, params);

    % Valores das restrições
    restri = calcular_restricoes(params, x_k);

    % Gradiente das restrições (6x4)
    
    grad_restri = zeros(6,4);

    for j = 1:6
        f_j = @(xx) subsref(calcular_restricoes(params, xx), struct('type','()','subs',{{j}}));
        grad_restri(j,:) = gradient_f(f_j, x_k);
    end

    % Condições KKT
    cond1 = norm(grad_f + grad_restri' * lambda_k);  % ||∇f + Σ λ∇g||
    cond2 = norm(lambda_k .* restri);                % λ_i * g_i ≈ 0

    % Mostrar estado
    fprintf('\n--- Verificação KKT ---\n');
    fprintf('x = [%.4f, %.4f, %.4f, %.4f]\n', x_k(1), x_k(2), x_k(3), x_k(4));
    fprintf('Norma(∇f + Σ λ∇g) = %.6f\n', cond1);
    fprintf('Norma(λ .* g)     = %.6f\n', cond2);
    fprintf('Máxima violação restrições = %.6f\n', max(restri));
    fprintf('Multiplicadores λ = [');
    fprintf(' %.4f', lambda_k);
    fprintf(' ]\n');
    fprintf('Restrições g(x)   = [');
    fprintf(' %.4f', restri);
    fprintf(' ]\n');
    fprintf('------------------------\n');

    % Verifica condições
    if cond1 < tolerancia && cond2 < tolerancia
        fprintf('Condições KKT satisfeitas.\n');
        KKT = true;
    else
        fprintf('Condições KKT NÃO satisfeitas.\n');
        KKT = false;
    end


% José Miguel Raposo
% up202207557

function x = calcular_conjugado(x,params,epsilon,lambda)

c = 0.1; % Step size parameter
gama = 0.1; % Armijo condition parameter
delta = 0.5; % Reduction factor for alpha

La = @(x) lagrangeana(x,lambda,epsilon,params);
x_hist = x';
La_hist = La(x);


tolerancia = 1e-4;

%fprintf('Iter  |    h       l       t       b    |    La(x)     |     Grad_La(x)\n');
%fprintf('-----------------------------------------------------\n');

max_iter = 500;
    
for k = 1:max_iter

    g_novo = gradient_f(La,x);
   
    g_norm = norm(g_novo);
    
    
    %fprintf('%4d | %7.4f %7.4f %7.4f %7.4f | %10.6f  |  %10.6f\n', ...
    %    k, x(1), x(2), x(3), x(4), La(x), g_norm);

    if g_norm < tolerancia
        break
    end

    if k == 1
        d = -g_novo;
    else
        beta = (norm(g_novo)) / (norm(g_antigo)); % Fletcher Reeves
        % beta = (g_novo' * (g_novo - g_antigo)) / abs(g_antigo' * g_antigo);
            % Polak - Ribière - to use this formula comment the Fletcher
            % and uncomment the line 41
        d = -g_novo + beta * d;
    end
    
    alpha = Armijo_f(x,delta,gama,c ,d,La,g_novo);
    
                
    x = x + alpha * d;


    lb = [0.125; 0.1; 0.1; 0.1];   % limites inferiores
    ub = [2.0; 10.0; 10.0; 2.0]; % limites superiores
    x = min(max(x, lb), ub);
       
    
    g_antigo = g_novo;

    x_hist(end+1,:) = x';
    La_hist(end+1) = La(x);
    
end

% iteraction = k;
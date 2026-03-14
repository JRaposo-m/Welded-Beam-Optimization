clear
clear all
clc

% Defina as constantes do problema
P = 6000;           % lb
L = 14;             % in
E = 30e6;           % psi
G = 12e6;           % psi
tau_max = 13600;    % psi
sigma_max = 30000;  % psi
delta_max = 0.25;   % in

params = [P,L,E,G,tau_max,sigma_max,delta_max];

% Ponto inicial
x = [0.4; 6.0; 9.0; 0.5];

%
epsilon = 0.1;
lambda = zeros(6,1);
max_iter = 100;
ro = 0.9;


fprintf('Iter |    h      l      t      b   |   La(x)   |  ||grad||  | max(g) | epsilon\n');
fprintf('-----------------------------------------------------------------------------\n');

t_start = tic;
for k = 1:max_iter
    
    
% Calcula novo x pelo método do conjugado
   
    x_k = calcular_conjugado(x, params, epsilon, lambda);
     
    
    % Calcula restrições e gradiente para monitorização
    restri = calcular_restricoes(params, x_k);
    La_val = lagrangeana(x_k, lambda, epsilon, params);
    grad_norm = norm(calculo_grad_La(x_k, params, epsilon, lambda));
    
    % Mostra estado atual
    fprintf('%4d | %6.3f %6.3f %6.3f %6.3f | %9.3f | %9.3f | %7.3f | %7.4f\n', ...
        k, x_k(1), x_k(2), x_k(3), x_k(4), La_val, grad_norm, max(restri), epsilon);
    
    % Verifica KKT
    if verifica_KKT(x_k, lambda, params)
        fprintf('Condições KKT satisfeitas na iteração %d.\n', k);
        break;
    end

    
    epsilon = epsilon * ro;

    restri = calcular_restricoes(params,x_k);
    
    for i = 1:6
        lambda(i) = max(0, lambda(i) + (2/epsilon) * restri(i));
    end
   
    x = x_k;

    fprintf('Iter |    h      l      t      b   |   La(x)   |  ||grad||  | max(g) | epsilon\n');
fprintf('-----------------------------------------------------------------------------\n');

    
end
t_run = toc(t_start);  

fprintf('Última solução: h=%.4f, l=%.4f, t=%.4f, b=%.4f\n', ...
    x_k(1), x_k(2), x_k(3), x_k(4));
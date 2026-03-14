% Calculo das Restrições

function restri = calcular_restricoes(params,x)

% x(1) = h; x(2) = l; x(3) = t; x(4) = b
% Vamos calcular os componentes necessários para as restrições
% Depois calculamos as restrições

P = params(1);
L = params(2);
E = params(3);
G = params(4);
tau_max = params(5);
sigma_max = params(6);
delta_max = params(7);

% Momento gerado por P
M = P * (L + (x(2))/2);

R = sqrt(((x(2) ^ 2) / 4) + ((x(1) + x(3))/2)^2);

J = 2 * (((x(1) * x(2))/sqrt(2)) * ((x(2)^2/12) + ...
    ((x(1) + x(3))/2)^2));

tau_duas_linhas = M * R / J;

tau_linha = P / (sqrt(2) * x(1) * x(2));

tau = sqrt(tau_linha^2 + 2 * tau_linha * tau_duas_linhas * x(2)/(2 * R) + ...
    tau_duas_linhas^2);

sigma = (6 * P * L) / (x(4) * (x(3))^2);

delta = (4 * P * (L^3)) / (E * x(4) * (x(3))^2);

Pc = (4.013 * sqrt(E * G * ((x(3)^2) * (x(4)^6)) / 36) / (L^2)) * ( ...
    1 - ((x(3)/(2 * L)) * sqrt(E / (4 * G))));

% Restrições normalizadas
restri = zeros(6,1);

restri(1) = (tau/tau_max) - 1;
restri(2) = (sigma/sigma_max) - 1;
restri(3) = (x(1) / x(4)) - 1;
restri(4) = ((0.10471 * (x(1)^2) + 0.04811 * x(3) * x(4) * ...
    (14.0 + x(2))) / 5.0) - 1;
%restri(5) = (0.125 / x(1)) - 1;
restri(5) = (delta/delta_max) - 1;
restri(6) = (P / Pc) - 1;
%restri(8) = (0.1 / x(1)) - 1;
%restri(9) = (x(1) / 2.0) - 1;
%restri(10) = (0.1 / x(4)) - 1;
%restri(11) = (x(4) / 2.0) - 1;
%restri(12) = (0.1 / x(2)) - 1;
%restri(13) = (x(2) / 10.0) - 1;
%restri(14) = (0.1 / x(3)) - 1;
%restri(15) = (x(3) / 10.0) - 1;

end


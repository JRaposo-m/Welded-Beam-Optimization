% Calculo dos gradientes das restrições

function grad_restri = calculo_grad_restri(x,params)

% Iniciar parametros para facilitar escrever
P = params(1);
L = params(2);
E = params(3);
G = params(4);
tau_max = params(5);
sigma_max = params(6);
delta_max = params(7);

x1 = x(1);
x2 = x(2);
x3 = x(3);
x4 = x(4);

%%%% calculo do gradiente de g1(x)

% Funções auxiliares:
R = sqrt(x2^2/4 + ((x1+x3)/2)^2);
J = 2*(x1*x2/sqrt(2))*(x2^2/12 + ((x1+x3)/2)^2);
M = P*(L + x2/2);

tau_linha = P/(sqrt(2)*x1*x2);
tau_duas_linha = M*R/J;
    
tau = sqrt(tau_linha^2 + 2*tau_linha*tau_duas_linha*x2/(2*R) + ...
    tau_duas_linha^2);

% derivadas de R
dR_dx = zeros(4,1);

dR_dx(1) = (1 /(2*R)) * (x3 + x1); % Derivative of R with respect to x1
dR_dx(2) = x2 / (4 * R); % Derivative of R with respect to x2
dR_dx(3) = (1 / (2 * R)) * (x3 + x1); % Derivative of R with respect to x3
dR_dx(4) = 0; % Derivative of R with respect to x4

% derivadas de J
dJ_dx = zeros(4,1);

dJ_dx(1) = (2*x2/sqrt(2))*(x2^2/12 + ((x1+x3)/2)^2) + ...
         (2*x1*x2/sqrt(2))*(x1+x3)/2;
dJ_dx(2) = (2*x1/sqrt(2))*(x2^2/12 + ((x1+x3)/2)^2) + ...
         (2*x1*x2/sqrt(2))*x2/6;
dJ_dx(3) = (2*x1*x2/sqrt(2))*(x1+x3)/2;
dJ_dx(4) = 0;

% Derivadas de tau_linha
dtau_linha_dx = zeros(4,1);

dtau_linha_dx(1) = -P/(sqrt(2)*x1^2*x2);
dtau_linha_dx(2) = -P/(sqrt(2)*x1*x2^2);
dtau_linha_dx(3) = 0;
dtau_linha_dx(4) = 0;

% Derivadas de M
dM_dx = zeros(4,1);

dM_dx(1) = 0;
dM_dx(2) = P/2;
dM_dx(3) = 0;
dM_dx(4) = 0;

% derivas de tau_duas_linhas
dtau_duas_linhas_dx = zeros(4,1);

for i = 1:4
    dtau_duas_linhas_dx(i) = (J*(dM_dx(i)*R + M*dR_dx(i)) - ...
        M*R*dJ_dx(i)) / J^2;
end
% derivadas de tau
dtau_dx = zeros(4,1);

%%% derivada auxiliar d/dxi *(x2/R)
dx2_R_dx = zeros(4,1);

dx2_R_dx(1) = - (x2 * (x1+x3)) / (2 * R^3);
dx2_R_dx(2) = ((x1+x3)^2) / (4*R^3);
dx2_R_dx(3) = - (x2 * (x1+x3)) / (2 * R^3);
dx2_R_dx(4) = 0;

for i = 1:4
    dtau_dx(i) = 1/(2*tau) * (2*tau_linha*dtau_linha_dx(i) + ...
        2 * (dtau_linha_dx(i)*tau_duas_linha + tau_linha*dtau_duas_linhas_dx(i)) ...
        * (x2/(2*R)) + 2*tau_linha*tau_duas_linha*dx2_R_dx(i) + ...
        2 * tau_duas_linha * dtau_duas_linhas_dx(i));
end

% gradiente de g1
dg1_dx = zeros(4,1);

for i = 1:4
    dg1_dx(i) = 1/tau_max * dtau_dx(i);
end

%%%%%% calculo do gradiente de g2

sigma = 6 * P * L / (x4 * x3^2);

% Derivadas de sigma
dsigma_dx = zeros(4,1);
dsigma_dx(1) = 0;
dsigma_dx(2) = 0;
dsigma_dx(3) = - 2*sigma / x3;
dsigma_dx(4) = -sigma / x4;

% gradiente de g2
dg2_dx = zeros(4,1);

for i = 1:4
    dg2_dx(i) = 1/sigma_max * dsigma_dx(i);
end


%%%% calculo do gradiente de g3

dg3_dx = zeros(4,1);

dg3_dx(1) = 1/x4;
dg3_dx(4) = - x1/(x4^2);

%%%% calculo do gradiente de g4

dg4_dx = zeros(4,1);

dg4_dx(1) = (1/5) * 0.20942*x1;
dg4_dx(2) = (1/5) * 0.04811 * x3 * x4;
dg4_dx(3) = (1/5) * 0.04811 * x4 * (14.0 + x2);
dg4_dx(4) = (1/5) * 0.04811 * x3 * (14.0 + x2);


%%%% calculo do gradiente de g5

%dg5_dx = zeros(4,1);

%dg5_dx(1) = -0.125 / (x1^2);


%%%% calculo do gradiente de g6

delta = 4 * P * L^3 / (E * x4 * x3^3);

d_delta_dx = zeros(4,1);

d_delta_dx(1) = 0;
d_delta_dx(2) = 0;
d_delta_dx(3) = -3*delta / x3;
d_delta_dx(4) = -delta/x4;

% gradiente de g6
dg6_dx = zeros(4,1);

for i = 1:4
    dg6_dx(i) = (1/delta_max) * d_delta_dx(i);
end


%%%% gradiente de g7

Pc = (4.013 * sqrt(E*G) * x3^2 * (x4^6)/36) / (L^2 * ...
    (1 - (x3/(2*L) * sqrt(E / (4*G)))));

% funções auxiliares
A = 4.013 * sqrt(E*G) * x3^2 * (x4^6)/36;
B = L^2 * (1 - (x3/(2*L) * sqrt(E / (4*G))));

% gradientes auxiliares
dA_dx = zeros(4,1);

dA_dx(1) = 0;
dA_dx(2) = 0;
dA_dx(3) = 4.013 * sqrt(E*G) * 2*x3 * (x4^6)/36;
dA_dx(4) = 4.013 * sqrt(E*G) * x3^2 * 6 * (x4^5)/36;

dB_dx = zeros(4,1);

dB_dx(3) = -(L/2) * sqrt(E/(4*G));

dPc_dx = zeros(4,1);

for i = 1:4
    dPc_dx(i) = (B * dA_dx(i) - A * dB_dx(i)) / B^2;
end

% gradiente g7
dg7_dx = zeros(4,1);

for i = 1:4
    dg7_dx(i) = -(P/Pc^2) * dPc_dx(i);
end


%%%% calculo gradiente 8, 9, 10, 11, 12, 13, 14, 15

%dg8_dx = zeros(4,1);
%dg8_dx(1) = -0.1/x1^2;

%dg9_dx = zeros(4,1);
%dg9_dx(1) = 1/2;

%dg10_dx = zeros(4,1);
%dg10_dx(4) = -0.1/x4^2;

%dg11_dx = zeros(4,1);
%dg11_dx(4) = 1/2;

%dg12_dx = zeros(4,1);
%dg12_dx(2) = -0.1/x2^2;

%dg13_dx = zeros(4,1);
%dg13_dx(2) = 1/10;

%dg14_dx = zeros(4,1);
%dg14_dx(3) = -0.1/x3^2;

%dg15_dx = zeros(4,1);
%dg15_dx(3) = 1/10;


%%%%%%%% matriz restrições


grad_restri = [dg1_dx'; dg2_dx'; dg3_dx'; dg4_dx';
               dg6_dx'; dg7_dx'];



end
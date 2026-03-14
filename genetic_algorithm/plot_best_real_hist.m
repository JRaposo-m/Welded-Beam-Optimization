

function plot_best_real_hist(best_hist, k_stop)%, motivo_paragem, save_path)
% Plota apenas a evolução do melhor f(x) por geração.
%
% Inputs:
%   best_hist      : vetor [G x 1] com o melhor f(x) por geração
%   k_stop         : (opcional) geração onde parou; [] se não aplicável
%   motivo_paragem : (opcional) string para anotação
%   save_path      : (opcional) caminho para guardar a imagem (ex.: 'melhor_fx.png')

    best_hist = best_hist(:); % garantir coluna
    
    x_axis = (1:k_stop)'; % Preencher o eixo x com as gerações


    % Criar figura
    figure('Name','Evolução do melhor f(x)','Color','w');
    hold on; grid on; box on;

    % Plot da curva do melhor f(x)
    plot(x_axis, best_hist, 'LineWidth', 2.5, 'Color', [0.10 0.45 0.85]);

    % Rótulos e título
    xlabel('Geração');
    ylabel('f(x)');
    title('Evolução do melhor f(x)');

    hold off;

end

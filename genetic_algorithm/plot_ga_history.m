
function plot_ga_history(best_hist, mean_hist, k_stop, motivo_paragem)
% Plota a evolução do GA com duas linhas: melhor e média por geração.
%
% Inputs:
%   best_hist       - vetor (1 x G) com o melhor mérito por geração
%   mean_hist       - vetor (1 x G) com a média do mérito por geração
%   k_stop          - geração onde parou (opcional; [] se não aplicável)
%   motivo_paragem  - string com o motivo (opcional)

    if nargin < 3, k_stop = []; end
    if nargin < 4, motivo_paragem = ''; end

    G = numel(best_hist);

    figure('Name','Histórico GA','Color','w');
    hold on; grid on;

    % Linhas principais
    plot(1:G, best_hist, 'LineWidth', 2.2, 'Color', [0.10 0.45 0.85]);   % azul (melhor)
    plot(1:G, mean_hist, '--', 'LineWidth', 1.8, 'Color', [0.90 0.30 0.20]); % vermelho tracejado (média)

    % Linha vertical na geração de paragem (se fornecida)
    if ~isempty(k_stop) && k_stop >= 1 && k_stop <= G
        xline(k_stop, ':k', 'LineWidth', 1.5);
        if ~isempty(motivo_paragem)
            text(k_stop + 0.3, best_hist(max(1,min(G,k_stop))), ...
                sprintf('Paragem (%s)', motivo_paragem), ...
                'FontSize', 10, 'Color', 'k', 'Interpreter','none');
        end
    end

    xlabel('Geração');
    ylabel('Mérito');
    title('Evolução do mérito por geração');
    legend({'Melhor', 'Média', 'Paragem'}, 'Location','best');

    hold off;
end

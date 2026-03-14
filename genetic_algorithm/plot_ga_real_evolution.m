
function plot_ga_real_evolution(best_real_hist, mean_real_hist, var_names)
% Desenha a evolução REAL do melhor indivíduo e da média da população por variável.
%
% Inputs:
%   best_real_hist  - (G x n_var) histórico do melhor indivíduo (real)
%   mean_real_hist  - (G x n_var) histórico da média (real)
%   var_names       - cellstr 1 x n_var com nomes das variáveis (opcional)

    [G, n_var] = size(best_real_hist);

    if nargin < 3 || isempty(var_names)
        var_names = arrayfun(@(i) sprintf('x_%d', i), 1:n_var, 'UniformOutput', false);
    end

    figure('Name','Evolução das variáveis reais','Color','w');
    t = tiledlayout(ceil(n_var/2), 2, 'TileSpacing','compact','Padding','compact'); % 2 colunas

    for j = 1:n_var
        nexttile;
        plot(1:G, best_real_hist(:, j), 'LineWidth', 2.0, 'Color', [0.10 0.45 0.85]); hold on;
        plot(1:G, mean_real_hist(:, j), '--', 'LineWidth', 1.6, 'Color', [0.90 0.30 0.20]);
        grid on; box on;
        xlabel('Geração');
        ylabel(sprintf('%s (real)', var_names{j}));
        title(sprintf('Evolução de %s', var_names{j}));
        legend({'Melhor (real)', 'Média (real)'}, 'Location','best');
    end

    title(t, 'Evolução real: Melhor indivíduo vs Média da população');

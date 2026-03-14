function selection = sus_selection(Mer, N_pop, N_elite)

% numero de seleções a fazer no crossover
p = N_pop - N_elite;

% codigo para fazer apenas com 1 volta:
r = rand * 1/p;

pos_markers = zeros(p,1);
for i = 1:p
    pos_markers(i) = r + (i - 1)/p;
end

P_selection = zeros(N_pop,1);
for i = 1:N_pop
    P_selection(i) = Mer(i)/sum(Mer);
end

% Cumulative probability distribution for selection
cumulativeProb = cumsum(P_selection);

% Perform selection based on the cumulative probabilities
selection = zeros(p,1);
for i = 1:p
    selection(i) = find(pos_markers(i) <= cumulativeProb, 1, 'first');
end

end
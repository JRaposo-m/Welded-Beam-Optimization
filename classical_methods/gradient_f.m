% Gradient Auxiliar function
function gradf = gradient_f(f,x)

    gradf = zeros(size(x));
    h = 1e-6;
    for i = 1:length(x)
        di = zeros(size(x));  % <--- reinicializar para mudar a 
        % posiçao do escalar  
        di(i) = h;
        % É importante perceber que devemos usar di e nao di(i) pois quero
        % somar o vetor e nao o escalar 
        gradf(i) = (f(x + di) - f(x - di)) / (2 * h);
            
    end
end
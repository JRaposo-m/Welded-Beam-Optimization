% Hessian Auxiliar Function
function hessian = hessian_f(f,x)

    n = numel(x);
    hessian = zeros(n, n);

   
    h = 1e-6;
    for i = 1:length(x)
        
        for j = 1:length(x)
            di = zeros(size(x));   % <--- reinicializar para mudar a 
            % posiçao do escalar 
            dj = zeros(size(x));   % <--- reinicializar para mudar a 
            % posiçao do escalar
            di(i) = h;
            dj(j) = h;
            
            if i ==j
                % É importante perceber que devemos usar di e nao di(i) pois quero
                % somar o vetor e nao o escalar 
                hessian(i,j) = (f(x + di) - 2 * f(x) + f(x - di)) / ( ...
                    h ^2);
            else
                % É importante perceber que devemos usar di e dj e nao di(i) pois 
                % quero somar o vetor e nao o escalar 
                hessian(i,j) = (f(x + di + dj) - f(x + di - ...
                    dj) - f(x - di + dj) + f(x - di - dj)) /( ...
                    4 * h^2);
            end

        end
    end

end
% Armijo Auxiliar function
function alphak = Armijo_f(x,delta, gamma, c, d, f, g)

    alpha = c * abs(g'*d) / norm(d)^2;
    while f(x+alpha*d) > f(x) + gamma * alpha * g' * d
        alpha = delta * alpha;
    end
   
    % Update
    alphak = alpha;

end

%%%% Função que calcula o gradiente do lagrangeano aumentado


function grad_lagrangeano = calculo_grad_La(x,params,epsilon, lambda)



%%%%% gradiente de f

grad_f = calcula_grad_f(x);


restri = calcular_restricoes(params,x);
grad_restri = calculo_grad_restri(x,params);


grad_lagrangeano = zeros(4,1);

sum = zeros(4,1);

for i = 1:4
    for j = 1:6
        if restri(j) > -epsilon/2 * lambda(j)
            sum(i) = sum(i) + lambda(j)' * grad_restri(j,i) + 2/epsilon * restri(j) * grad_restri(j,i);
        end
    end

    grad_lagrangeano(i) = grad_f(i) + sum(i);

end


end
function grad_f = calcula_grad_f(x)

grad_f = zeros(4,1);

x1 = x(1);
x2 = x(2);
x3 = x(3);
x4 = x(4);

grad_f(1) = 2.20942 * x1 * x2;
grad_f(2) = 1.10471 * x1^2 + 0.04811 * x3 * x4;
grad_f(3) = 0.04811 * x4 * (14 + x2);
grad_f(4) = 0.04811 * x3 * (14 + x2);

end
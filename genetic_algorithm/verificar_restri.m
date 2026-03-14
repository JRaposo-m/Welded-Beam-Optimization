function validade = verificar_restri(melhor_indiv, params)

resti = calcular_restricoes(params, melhor_indiv);

validade = all(resti <= 0);


end
-- Incluindo implementação da pilha
require "pilha"

-- ------------------------- Funções para resolver SMC-------------------------

function resolverExpressoes(s, m, c)
  print("Resolver Expressões")

  printSMC(s,m,c)

  elemento = c:pop(1)
  
  if elemento ~= nil then
    if(type(elemento) ~= "number") then
      elemento = loadFromMemory(elemento, m)
    end
    if tonumber(elemento) ~= nil then
      numero = tonumber(elemento)
      s:push(numero)
      resolverExpressoes(s,m,c)
      return numero
    elseif string.sub(elemento, 0, 4) == "add(" then
      print("Resolvendo Soma")
      soma(s,m,c)     

    elseif string.sub(elemento, 0, 4) == "sub(" then
      print("Resolvendo Subtração")
      subtracao(s,m,c)
      

    elseif string.sub(elemento, 0 , 4) == "mul(" then
      print("Resolvendo Multiplicação")
      multiplicacao(s,m,c)
      
    end
  end
end 

function loadFromMemory(elemento, m)
    local e = elemento
    e = m[e]
    if e ~= nil then
      elemento = e
    end
    return elemento
end

function soma(s,m,c)
-- Separando operandos
  operando1 = string.sub(elemento, 5, identificarVirgula(elemento)[1])
  operando2 = string.sub(elemento, identificarVirgula(elemento)[1] + 2 , string.len(elemento)-1)

  -- Empilhando em C como pósfixada
  print("Empilhando em C como pósfixado")
  c:push("add")
  c:push(operando2)
  c:push(operando1)
  --printSMC(s,m,c)

  resolverExpressoes(s,m,c)

  printSMC(s,m,c)

  valor1 = s:pop(1)
  valor2 = s:pop(1)

  resultado = tonumber(valor1) + tonumber(valor2)

  s:push(resultado)

  printSMC(s,m,c)

  resolverExpressoes(s,m,c)
end

function subtracao(s,m,c)
-- Separando operandos
  operando1 = string.sub(elemento, 5, identificarVirgula(elemento)[1])
  operando2 = string.sub(elemento, identificarVirgula(elemento)[1] + 2 , string.len(elemento)-1)

  -- Empilhando em C como pósfixada
  print("Empilhando em C como pósfixado")
  c:push("sub")
  c:push(operando2)
  c:push(operando1)
  --printSMC(s,m,c)

  resolverExpressoes(s,m,c)

  printSMC(s,m,c)

  valor1 = s:pop(1)
  valor2 = s:pop(1)


  resultado = tonumber(valor2) - tonumber(valor1)

  s:push(resultado)

  printSMC(s,m,c)

  resolverExpressoes(s,m,c)
end

function multiplicacao(s,m,c)
-- Separando operandos
  operando1 = string.sub(elemento, 5, identificarVirgula(elemento)[1])
  operando2 = string.sub(elemento, identificarVirgula(elemento)[1] + 2 , string.len(elemento)-1)

  -- Empilhando em C como pósfixada
  print("Empilhando em C como pósfixado")
  c:push("mul")
  c:push(operando2)
  c:push(operando1)
  --printSMC(s,m,c)

  resolverExpressoes(s,m,c)

  printSMC(s,m,c)

  valor1 = s:pop(1)
  valor2 = s:pop(1)

  resultado = tonumber(valor1) * tonumber(valor2)

  s:push(resultado)

  printSMC(s,m,c)

  resolverExpressoes(s,m,c)

end

function resolverExpressaoBooleana(s,m,c)
  print("Resolver Expressões Booleanas")

  printSMC(s,m,c)

  elemento = c:pop(1)

  if elemento ~= nil then
    if string.sub(elemento,1,1) == "~" then 
      print("Negação")
      valor = string.sub(elemento, 2, string.len(elemento))
      c:push("~")
      c:push(valor)

      resolverExpressoes(s,m,c)
      

      if elemento == "tt" then
        s:push("ff")
      else
        s:push("tt")
      end
      c:pop(1)
    else
      elemento = c:pop(1)
      s:push(elemento)
      c:pop(1)
    end 
  end
end

function identificarVirgula(operacao)
  i = 0
  contador_operacoes = 0
  contador_virgulas = 0
  qtd_parenteses_abertos = 0
  qtd_parenteses_fechados = 0

  while i < string.len(operacao) do
    
    if string.sub(operacao, i, i + 3) == "add" or 
      string.sub(operacao, i, i + 3) == "sub"  or 
      string.sub(operacao, i, i + 3) == "mul" then
      contador_operacoes = contador_operacoes + 1
    elseif string.sub(operacao, i , i) == "," then
      contador_virgulas = contador_virgulas + 1 
    elseif string.sub(operacao, i, i) == "(" then
      qtd_parenteses_abertos = qtd_parenteses_abertos + 1
    elseif string.sub(operacao, i , i) == ")" then
      qtd_parenteses_fechados = qtd_parenteses_fechados + 1
    end

    if (qtd_parenteses_fechados == qtd_parenteses_abertos - 1) and (string.sub(operacao, i+1, i+1) == ",") then
      return {i, contador_operacoes, qtd_parenteses_abertos, qtd_parenteses_fechados}
    end
    i = i + 1
  end 
end


function printSMC(s, m, c)
	local smc = "< "
	stack = Stack:Create()
  for i,v in pairs(s._et) do
    stack:push(v)
  end
	element = stack:pop(1)
	while element ~= nil do
		smc = smc..element.." "
		element = stack:pop(1)
	end
	smc = smc.."S, "
	for i, v in pairs(m) do
		smc = smc.."["..i.."]".."="..v.." "
	end
	smc = smc.."M, "
	for i,v in pairs(c._et) do
    stack:push(v)
  end
  element = stack:pop(1)
  while element ~= nil do
    smc = smc..element.." "
    element = stack:pop(1)
  end
	smc = smc.."C >\n"
	print(smc)
end
-- -------------------------------- SMC ---------------------------------------
s = Stack:Create()
m = {}
m['a'] = 7
m['b'] = 21
c = Stack:Create()


entrada = "mul(add(2,5),add(2,a))"
-- entrada = "add(5,a)"
print("Entrada...")
c:push(entrada)
printSMC(s,m,c)
-- c:list()

print("-------------------------------Tratando expressões-------------------------------")
-- Tratamento da expressões
resolverExpressoes(s, m, c)
print("Resposta final")
printSMC(s,m,c)


-- entrada_booleana = "~tt"
-- c:push(entrada_booleana)
-- resolverExpressaoBooleana(s,m,c)
-- printSMC(s,m,c)

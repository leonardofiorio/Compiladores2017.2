-- Incluindo implementação da pilha
require "pilha"

-- ------------------------- Funções para resolver SMC-------------------------

function resolverExpressoes(s, m, c)
  print("Resolver Expressões")

  s:list()
  c:list()

  elemento = c:pop(1)
  
  if elemento ~= nil then
    if tonumber(elemento) ~= nil then
      numero = tonumber(elemento)
      s:push(numero)
      resolverExpressoes(s,m,c)
      return numero
    elseif string.sub(elemento, 0, 4) == "add(" then
      print("Resolvendo Soma")

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

      print("S")
      s:list()
      print("C")
      c:list()

      valor1 = s:pop(1)
      valor2 = s:pop(1)

      print("Valor 1", valor1)
      print("Valor 2", valor2)

      resultado = tonumber(valor1) + tonumber(valor2)

      s:push(resultado)

      s:list()
      c:list()

      resolverExpressoes(s,m,c)

    elseif string.sub(elemento, 0, 4) == "sub(" then
      print("Resolvendo Subtração")

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

      print("S")
      s:list()
      print("C")
      c:list()

      valor1 = s:pop(1)
      valor2 = s:pop(1)

      print("Valor 1", valor1)
      print("Valor 2", valor2)

      resultado = tonumber(valor2) - tonumber(valor1)

      s:push(resultado)

      s:list()
      c:list()

      resolverExpressoes(s,m,c)

    elseif string.sub(elemento, 0 , 4) == "mul(" then
      print("Resolvendo Multiplicação")

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

      print("S")
      s:list()
      print("C")
      c:list()

      valor1 = s:pop(1)
      valor2 = s:pop(1)

      print("Valor 1", valor1)
      print("Valor 2", valor2)

      resultado = tonumber(valor1) * tonumber(valor2)

      s:push(resultado)

      s:list()
      c:list()

      resolverExpressoes(s,m,c)
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


-- Essa função retorna valor boolean para identificar se valor passado como parâmetro
-- é uma operação aceita pela linguagem ou outro componente da linguagem
function verificaOperacao(op)
	if op == "+" or 
    op == "-" or 
    op == "*" or
    op == ">" or
    op == "<" or
    op == "==" or
    op == ">=" or
    op == "<=" or
    op == "!=" then 
		return true
	end
	return false
end
 
function printSMC(s, m, c)
	local smc = "< "
	stack = Stack:Create()
	element = s:pop(1)
	while element ~= nil do
		stack:push(element)
		element = s:pop(1)
	end
	element = stack:pop(1)
	while element ~= nil do
		smc = smc..element.." "
		element = stack:pop(1)
	end
	smc = smc.."S, "
	for k, v in pairs(m) do
		smc = smc.."["..k.."]".."="..v.." "
	end
	smc = smc.."M, "
	element = c:pop(1)
	while element ~= nil do
		stack:push(element)
		element = c:pop(1)
	end
	element = stack:pop(1)
	while element ~= nil do
		smc = smc..element.." "
		element = stack:pop(1)
	end
	smc = smc.."C >"
	print(smc)
end
-- -------------------------------- SMC ---------------------------------------
s = Stack:Create()
m = {}
m['a'] = 7
m['b'] = 21
c = Stack:Create()


entrada = "mul(5,add(2,8))"
print("Entrada...")
c:push(entrada)
print(entrada)
c:list()

print("-------------------------------Tratando expressões-------------------------------")
-- Tratamento da expressões
resolverExpressoes(s, m, c)
print("Resposta final")
--printSMC(s,m,c)


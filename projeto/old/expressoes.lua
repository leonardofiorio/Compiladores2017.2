-- Incluindo implementação da pilha
require "pilha"

-- ------------------------- Funções para resolver SMC-------------------------
-- Pilha auxiliar para guardar números naturais
naturais = Stack:Create()
--Pilha auxiliar para guardar operadores
operadores = Stack:Create()

-- Esta função ordena c empilhando naturais e depois operadores recursivamente
function ordenarC(s, m , c, naturais, operadores)
  --print("ordenarC está começando a executar")

  tmp = c:pop(1)
  --print("Tmp", tmp)
  if verificaOperacao(tmp) == false and tmp~=nil then
    s:push(tmp)
  end
  
  tmp = c:pop(1)
  --print("Tmp", tmp)
  if verificaOperacao(tmp) and tmp ~= nil then
    operadores:push(tmp)
  end

  if tmp ~= nil then
    return ordenarC(s, m, c,naturais, operadores)
  end

  auxoperadores = Stack:Create()
  tmp = operadores:pop(1)
  while tmp ~=nil do
    auxoperadores:push(tmp)
    tmp = operadores:pop(1)
  end

  tmp = auxoperadores:pop(1)
  while tmp ~=nil do
    c:push(tmp)
    tmp = auxoperadores:pop(1)
  end

  --c:list()
end 

function resolverExpressoes(s, m, c, flag)
  -- print("resolverExpressoes está começando a executar")

  print("Pilha S")
  s:list()
  print("")
  -- print("Pilha M")
  --m:list()
  print("Pilha C")
  c:list()
  print("")
  print("------------------")

  elemento = s:pop(1)
  if(type(elemento) ~= "number") then
    local e = elemento
    elemento = m[elemento]
    if elemento == nil then
      error("Não foi possível encontrar o símbolo '"..e.."' na memória.")
    end
  end
  operacao = c:pop(1)
  
  aux = 0
  if operacao ~=nil then
    if operacao == "+" then
      aux = elemento + resolverExpressoes(s,m,c, false)
      if flag then
        s:push(aux)
      end
      return aux
    elseif operacao == "-" then
      aux = elemento - resolverExpressoes(s,m,c, false)
      if flag then
        s:push(aux)
      end
      return aux
    elseif operacao == "*" then
      aux = elemento * resolverExpressoes(s,m,c, false)
      if flag then
        s:push(aux)
      end
      return aux
    elseif operacao == ">" then
      aux = (elemento > resolverExpressoes(s,m,c, false))
      if flag then
        s:push(pegarBoolean(aux))  
      end
      return aux
    elseif operacao == "<" then
      aux = (elemento < resolverExpressoes(s,m,c, false))
      if flag then
        s:push(pegarBoolean(aux))  
      end
      return aux  
    elseif operacao == "==" then
      aux = (elemento == resolverExpressoes(s,m,c, false))
      if flag then
        s:push(pegarBoolean(aux))  
      end
      return aux  
    elseif operacao == ">=" then
      aux = (elemento >= resolverExpressoes(s,m,c, false))
      if flag then
        s:push(pegarBoolean(aux))  
      end
      return aux  
    elseif operacao == "<=" then
      aux = (elemento <= resolverExpressoes(s,m,c, false))
      if flag then
        s:push(pegarBoolean(aux))  
      end
      return aux  
    elseif operacao == "!=" then
      aux = (elemento ~= resolverExpressoes(s,m,c, false))
      if flag then
        s:push(pegarBoolean(aux))  
      end
      return aux  
    end
  else
    return elemento
  end

  c:push(aux)

  -- print("Pilha S depois ")
  -- s:list()
  -- print("Pilha C depois")
  -- c:list()
end

function pegarBoolean(b)
  if b then
    return "tt"
  else
    return "ff"
  end
end

-- Essa função é responsável por 
function tratamentoExpressoes(s, m, c, naturais, operadores)
	ordenarC(s, m, c, naturais, operadores)
	resolverExpressoes(s, m , c, true)
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
 
-- -------------------------------- SMC ---------------------------------------

s = Stack:Create()
m = {}
m['a'] = 7
c = Stack:Create()

--------------------------------------------
-- entrada= {4, ">" , 5, "*", 2 }
-- entrada = {10, "<", 10, "+", 10 , "*", 2}
entrada = {1, "+", 3, "*", 2}
tamanho_entrada = table.maxn(entrada)

-- i = tamanho_entrada
-- while i > 0 do
--   c:push(entrada[i])
--   i=i-1 
-- end

i = 1
while i <= tamanho_entrada do
  c:push(entrada[i])
  i=i+1 
end


print("Entrada...")
c:list()

print("-------------------------------Tratando expressões-------------------------------")
-- Tratamento da expressões
tratamentoExpressoes(s, m, c, naturais, operadores)
print("Resposta final")
print("Pilha S")
s:list()
print("")
-- print("Pilha M")
-- m:list()
print("Pilha C")
c:list()
print("")


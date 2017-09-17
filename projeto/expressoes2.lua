-- Incluindo implementação da pilha
require "pilha"

-- ------------------------- Funções para resolver SMC-------------------------
s = Stack:Create()
m = Stack:Create()
c = Stack:Create()


function resolverExpressoes(s, m, c)
  print("Resolver Expressões")

  elemento = c:pop(1)

  if tonumber(elemento) ~= nil then
    s:push(tonumber(elemento))
    resolverExpressoes(s,m,c)
  elseif string.sub(elemento, 0, 4) == "add(" then
    -- Separando operandos
    operando1 = string.sub(elemento, 5, identificarVirgula(elemento)[1])
    operando2 = string.sub(elemento, identificarVirgula(elemento)[1] + 2 , string.len(elemento)-1)

    -- Empilhando em C como pósfixada
    print("Empilhando em C como pósfixado")
    c:push("add")
    c:push(operando2)
    c:push(operando1)
    s:list()
    m:list()
    c:list()

    resolverExpressoes(s,m,c)

    operando2 = s:pop(1)
    operando1 = s:pop(1)

    resultado = operando2 + operando1

    s:push(resultado)

  elseif string.sub(elemento, 0, 3) == "sub" then
    -- Separando operandos
    operando1 = string.sub(elemento, 5, identificarVirgula(elemento)[1])
    operando2 = string.sub(elemento, identificarVirgula(elemento)[1] + 2 , string.len(elemento)-1)

    -- Empilhando em C como pósfixada
    c:push("sub")
    c:push(operando2)
    c:push(operando1)
    s:list()
    m:list()
    c:list()

    -- Desempilhando operandos de C e empilhando em S
    s:push(c:pop(1))
    s:push(c:pop(1))
    s:list()
    m:list()
    c:list()

    operando2 = s:pop(1)
    operando1 = s:pop(1)

    resultado = resolverExpressoes(operando1) + resolverExpressoes(operando2)

    return resultado

  elseif string.sub(elemento, 0 , 3) == "mul" then
    -- Separando operandos
    operando1 = string.sub(elemento, 5, identificarVirgula(elemento)[1])
    operando2 = string.sub(elemento, identificarVirgula(elemento)[1] + 2 , string.len(elemento)-1)

    -- Empilhando em C como pósfixada
    c:push("mul")
    c:push(operando2)
    c:push(operando1)
    s:list()
    m:list()
    c:list()

    -- Desempilhando operandos de C e empilhando em S
    s:push(c:pop(1))
    s:push(c:pop(1))
    s:list()
    m:list()
    c:list()

    operando2 = s:pop(1)
    operando1 = s:pop(1)

    print("Operando2", operando2)
    print("Operando1", operando1)

    resultado = resolverExpressoes(operando1) * resolverExpressoes(operando2)

    return resultado
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


-- Essa função é responsável por 
function tratamentoExpressoes(s, m, c, naturais, operadores)
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


--v pertence a {a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z}
--n pertence aos Naturais

entrada = "add(add(4,0),add(5,6))"
print("Entrada...")
print(entrada)
c:push(entrada)

print("-------------------------------Tratando expressões-------------------------------")
-- Tratamento da expressões
tratamentoExpressoes(s, m, c)
print("Resposta final")
print("Pilha S")
s:list()
print("")
print("Pilha M")
m:list()
print("")
print("Pilha C")
c:list()
print("")



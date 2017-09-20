require "pilha" -- Incluindo implementação da pilha
local bintree = require "bintree" -- Importando implementação de árvore 

s = Stack:Create() -- Criando pilha para S
m = {} -- Criando vetor para M

-- Inicializando memória com valores 
m['a'] = 7
m['b'] = 21

c = Stack:Create() -- Criando pilha para C

function loadFromMemory(elemento, m)
    local e = elemento
    e = m[e]
    if e ~= nil then
      elemento = e
    end
    return elemento
end

function resolverExpressoes(s,m,c,ast)
  
  if ast ~= nil then
    local data = bintree.getData(ast)  

    if (tonumber(data) ~= nil) then
      num = tonumber(data)
      c:push(num)
      printSMC(s,m,c)
      return num
    elseif data == "add" then
      print("ADD")
      print("Expressão pósfixada em C")
      c:push("add")
      printSMC(s,m,c)
      resultado = resolverExpressoes(s,m,c, bintree.getLeft(ast)) + resolverExpressoes(s,m,c, bintree.getRight(ast))
      s:pop(1)
      s:push(resultado)
      c:pop(1)
      c:pop(1)
      c:pop(1)
      printSMC(s,m,c)
      return resultado

    elseif data == "sub" then
      print("SUB")
      print("Expressão pósfixada em C")
      c:push("sub")
      printSMC(s,m,c)
      resultado = resolverExpressoes(s,m,c, bintree.getLeft(ast)) - resolverExpressoes(s,m,c, bintree.getRight(ast))
      s:pop(1)
      s:push(resultado)
      c:pop(1)
      c:pop(1)
      c:pop(1)
      printSMC(s,m,c)
      return resultado
      
    elseif data == "mul" then
            print("MUL")
      print("Expressão pósfixada em C")
      c:push("mul")
      printSMC(s,m,c)
      resultado = resolverExpressoes(s,m,c, bintree.getLeft(ast)) * resolverExpressoes(s,m,c, bintree.getRight(ast))
      s:pop(1)
      s:push(resultado)
      c:pop(1)
      c:pop(1)
      c:pop(1)
      printSMC(s,m,c)
      return resultado
    end
  end
end

-- Função para impressão das pilhas SMC no formato de leitura
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

-- Declarando árvore 
--local ast = node("add",
--  node("add", node("10", nil, nil), node("2",nil,nil)),
 --    node("5", nil, nil))
local ast = node("mul", node("2",nil,nil), (node("add",node("3",nil,nil), node("1", nil, nil)) ) )
--local ast = node("add", node("2",nil,nil), node("3",nil,nil))

bintree.show(ast)

resolverExpressoes(s,m,c,ast)

print()
print("Resultado final: ")
printSMC(s,m,c)



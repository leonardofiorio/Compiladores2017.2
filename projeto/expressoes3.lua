require "pilha" -- Incluindo implementação da pilha
local tree = require "tree" -- Importando implementação de árvore 

s = Stack:Create() -- Criando pilha para S
m = {} -- Criando vetor para M

-- Inicializando memória com valores 
m['a'] = 7
m['b'] = 21

c = Stack:Create() -- Criando pilha para C

function resolverExpressoes(s,m,c,ast)
  
  if ast ~= nil then
    local data = getData(ast, m)

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
      resultado = resolverExpressoes(s,m,c, ast.children[1]) + resolverExpressoes(s,m,c, ast.children[2])
      s:pop(1)
      s:push(resultado)
      c:pop(3)
      printSMC(s,m,c)
      return resultado

    elseif data == "sub" then
      print("SUB")
      print("Expressão pósfixada em C")
      c:push("sub")
      printSMC(s,m,c)
      resultado = resolverExpressoes(s,m,c, ast.children[1]) - resolverExpressoes(s,m,c, ast.children[2])
      s:pop(1)
      s:push(resultado)
      c:pop(3)
      printSMC(s,m,c)
      return resultado
      
    elseif data == "mul" then
      print("MUL")
      print("Expressão pósfixada em C")
      c:push("mul")
      printSMC(s,m,c)
      resultado = resolverExpressoes(s,m,c, ast.children[1]) * resolverExpressoes(s,m,c, ast.children[2])
      s:pop(1)
      s:push(resultado)
      c:pop(3)
      printSMC(s,m,c)
      return resultado

  	elseif data == "eq" then
      print("EQ")
      print("Expressão pósfixada em C")
      c:push("eq")
      printSMC(s,m,c)
      resultado = getBoolean(resolverExpressoes(s,m,c, ast.children[1]) == resolverExpressoes(s,m,c, ast.children[2]))
      s:pop(1)
      s:push(resultado)
      c:pop(3)
      printSMC(s,m,c)
      return resultado

  	elseif data == "not" then
      print("NOT")
      print("Expressão pósfixada em C")
      c:push("not")
      printSMC(s,m,c)
      resultado = getNot(resolverExpressoes(s,m,c, ast.children[1], true))
      s:pop(1)
      s:push(resultado)
      c:pop(2)--dois pops?
      printSMC(s,m,c)
      return resultado

  	elseif data == "att" then --attribution
      print("ATT")
      print("Expressão pósfixada em C")
      c:push("att")
      printSMC(s,m,c)
      local var = ast.children[1].data
      c:push(var)
      m[var] = resolverExpressoes(s,m,c, ast.children[2])
      s:pop(1)
      c:pop(3)
      printSMC(s,m,c)
      return

    end
  end
end

function getData(node, m)
	local data = node.data
	local e = data
    e = m[e]
    if e ~= nil then
      data = e
    end
    return data
end

function getBoolean(b)
	if b then
		return "tt"
  	else
	    return "ff"
  	end
end

function getNot(b)
	if b == "tt" then
		return "ff"
	else
		return "tt"
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

-- local ast = node("mul", {
-- 		node("2",nil),
-- 		node("add", {
-- 			node("3",nil),
-- 			node("1",nil)
-- 			})
-- 	})

-- local ast = node("eq", {
-- 		node("2",nil),
-- 		node("3",nil)
-- 	})

-- local ast = node("not", {
-- 		node("eq", {
-- 			node("2",nil),
-- 			node("2",nil)
-- 		})
-- 	})

-- local ast = node("att", {
-- 		node("a",nil),
-- 		node("143",nil)
-- 	})

local ast = node("att", {
		node("a",nil),
		node("add", {
			node("a",nil),
			node("a",nil)
			})
	})

tree.show(ast)

resolverExpressoes(s,m,c,ast)

print()
print("Resultado final: ")
printSMC(s,m,c)


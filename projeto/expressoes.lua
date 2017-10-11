require "pilha" -- Incluindo implementação da pilha
local tree = require "tree" -- Importando implementação de árvore 
local lpeg = require"lpeg"

local boolVal = lpeg.S"tt" + lpeg.S"ff"

s = Stack:Create() -- Criando pilha para S
-- Criando vetor para M
m = {} 
loc = {}

loc = {1 , 5}

-- Inicializando memória com valores 
-- m['a'] = 7
-- m['b'] = 21
m['result'] = loc[1]
m['fat'] = loc[2]

c = Stack:Create() -- Criando pilha para C

function resolverExpressoes(s,m,c,ast)
  
  if ast ~= nil then
    local data = getData(ast, m)

    if (tonumber(data) ~= nil) then
      num = tonumber(data)
      c:push(num)
      printSMC(s,m,c)
      return num

  	elseif lpeg.match(boolVal, data) then
      c:push(data)
      printSMC(s,m,c)
      return data

    elseif data == "if" then
      commands_else = getString(ast.children[3])
      commands = getString(ast.children[2])

      c:push(commands_else)
      c:push("else")
      c:push(commands)
      c:push("then")

      conditional = getString(ast.children[1])

      c:push(conditional)
      c:push("if")
      printSMC(s,m,c)
      
      s:push(commands_else)
      s:push(commands)
      c:pop(6)
      c:push("if")
      c:push(conditional)
      c:pop(1)
      printSMC(s,m,c)

      resolverExpressoes(s,m,c, ast.children[1])
      
      t = s:pop(1)
      s:pop(1)
      s:pop(1)
      c:pop(1)
      if t == "tt" then 
        commands = resolverExpressoes(s,m,c, ast.children[2])
        return commands
      elseif t == "ff" then
        commands_else = resolverExpressoes(s,m,c, ast.children[3])
        return commands_else
      end

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
      --s:pop(1)
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

  	elseif data == "or" then
      print("OR")
      print("Expressão pósfixada em C")
      c:push("or")
      printSMC(s,m,c)
      local val1 = resolverExpressoes(s,m,c, ast.children[1])
      local val2 = resolverExpressoes(s,m,c, ast.children[2])
      resultado = getBoolean(toBool(val1) or toBool(val2))
      s:pop(1)
      s:push(resultado)
      if(val1) then
      	c:pop(2)
      else
      	c:pop(3)
      end
      printSMC(s,m,c)
      return resultado

    elseif data == ";" then
      for _,child in ipairs(ast.children) do
        resolverExpressoes(s,m,c, child)
      end

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

function toBool(b)
	if b == "tt" then
		return true
	elseif b == "ff" then
		return false
	else
		return b
	end
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

function getString(ast)
  local s = ""
  if ast ~=nil then
    if (ast.data == "add") or (ast.data == "sub") or (ast.data == "mul") or 
      (ast.data == "eq") or (ast.data == "att") or (ast.data == "or") or (ast.data == "and")then
      if ast.children ~= nil then
        s = s .. "(" .. getString(ast.children[1]).. " " ..ast.data .. " " .. getString(ast.children[2]) .. ")"
      else
        s = ast.data
      end
      return s
    elseif ast.data == "not" then
       s = s .. "not " .. getString(ast.children[1])
    else
      return ast.data
    end
  end
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

-- local ast = node("att", {
-- 		node("a",nil),
-- 		node("add", {
-- 			node("a",nil),
-- 			node("a",nil)
-- 			})
-- 	})

-- local ast = node("or", {
-- 		node("ff",nil),
-- 		node("eq", {
-- 			node("a",nil),
-- 			node("8",nil)
-- 			})
-- 	})

local ast = node("att", {
  node("z", nil),   
  node("if", {
      node("eq", {
        node("1", nil),
        node("2", nil)
      }),
      node("add",{
        node("1", nil),
        node("2", nil)
      }),
      node("add",{
        node("2", nil),
        node("3", nil)
      }),
  })
})

tree.show(ast)

resolverExpressoes(s,m,c,ast)

-- print()
-- print("Resultado final: ")
-- printSMC(s,m,c)



require "pilha" -- Incluindo implementação da pilha
local tree = require "tree" -- Importando implementação de árvore 
local lpeg = require"lpeg"

s = Stack:Create() -- Criando pilha para S

e = {} 

m = {}

c = Stack:Create() -- Criando pilha para C

o = ""

require "loc"
require "abs"


function resolverExpressoes(e,s,m,c,o,ast)
  
  if ast ~= nil then
    local data = getData(ast, e)

    print(data)

    if (tonumber(data) ~= nil) then
      num = tonumber(data)
      c:push(num)
      printSMC(e,s,m,c,o)
      return num
    -- elseif Loc:isLoc(data) then
    --   return data.value

  	elseif data == "tt" or data == "ff" then
      s:push(data)
      printSMC(e,s,m,c,o)
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
      printSMC(e,s,m,c,o)
      
      s:push(commands_else)
      s:push(commands)
      c:pop(6)
      c:push("if")
      c:push(conditional)
      c:pop(1)
      printSMC(e,s,m,c,o)

      resolverExpressoes(e,s,m,c,o,ast.children[1])
      
      t = s:pop(1)
      s:pop(1)
      s:pop(1)
      c:pop(1)
      
      if t == "tt" then 
        commands = resolverExpressoes(e,s,m,c,o, ast.children[2])
        return commands
      elseif t == "ff" then
        commands_else = resolverExpressoes(e,s,m,c,o, ast.children[3])
        return commands_else
      end

    elseif data == "Set" then
      print("ATT")
      --print("Expressão pósfixada em C")
      c:push("att")
      printSMC(e,s,m,c,o)

      --aux = e[ast.children[1].data]
      -- Com parser:
      aux = e[ast.children[1].children[1].children[1].data]

      if Loc:isLoc(aux) == false then
        print("Error!!!")
        return
      end

      flag = false
      for i,v in pairs(e) do
        if i == ast.children[1].children[1].children[1].data then
          flag = true
        end
      end

      if flag then
        local var = ast.children[1].children[1].children[1].data
        c:push(var)
        size = table.maxn(m)
        resultado = resolverExpressoes(e,s,m,c,o,ast.children[2])
        --obj = Loc:new(size+1, resultado)
        obj = e[var]
        obj:setValue(resultado)
        s:pop(1)
        c:pop(3)

        printSMC(e,s,m,c,o)
      else
        print("---- Error!!! ----")
      end
      return
  	elseif data == "or" then
      print("OR")
      --print("Expressão pósfixada em C")
      c:push("or")
      printSMC(e,s,m,c,o)
      local val1 = resolverExpressoes(e,s,m,c,o, ast.children[1])
      local val2 = resolverExpressoes(e,s,m,c,o, ast.children[2])
      resultado = getBoolean(toBool(val1) or toBool(val2))
      s:pop(1)
      s:push(resultado)
      if(val1) then
      	c:pop(2)
      else
      	c:pop(3)
      end
      printSMC(e,s,m,c,o)
      return resultado
    elseif data== "ExpList" or data=="Number" then
      return resolverExpressoes(e,s,m,c,o, ast.children[1])
    elseif data == "Op" then
      if ast.children[1].data == "==" then
        print("EQ")
        --print("Expressão pósfixada em C")
        c:push("eq")
        printSMC(e,s,m,c,o)
        resultado = getBoolean(resolverExpressoes(e,s,m,c,o, ast.children[2]) == resolverExpressoes(e,s,m,c,o, ast.children[3]))
        --s:pop(1)
        s:push(resultado)
        c:pop(3)
        printSMC(e,s,m,c,o)
        return resultado
      elseif ast.children[1].data == "+" then
        --print("Expressão pósfixada em C")
        c:push("add")
        printSMC(e,s,m,c,o)
        val1 = resolverExpressoes(e,s,m,c,o,ast.children[2])
        val2 = resolverExpressoes(e,s,m,c,o, ast.children[3])

        --print(val1)
        --print(val2)

        resultado = val1+val2

        s:pop(1)
        s:push(resultado)
        c:pop(3)
        printSMC(e,s,m,c,o)
        s:pop(1)
        return resultado
      elseif ast.children[1].data == "-" then
              print("SUB")
      --print("Expressão pósfixada em C")
        c:push("sub")
        printSMC(e,s,m,c,o)
        resultado = resolverExpressoes(e,s,m,c,o, ast.children[2]) - resolverExpressoes(e,s,m,c,o, ast.children[3])
        s:pop(1)
        s:push(resultado)
        c:pop(3)
        printSMC(e,s,m,c,o)
        return resultado
      elseif ast.children[1].data == "*" then
        print("MUL")
        --print("Expressão pósfixada em C")
        c:push("mul")
        printSMC(e,s,m,c,o)
        resultado = resolverExpressoes(e,s,m,c,o, ast.children[2]) * resolverExpressoes(e,s,m,c,o, ast.children[3])
        s:pop(1)
        s:push(resultado)
        c:pop(3)
        printSMC(e,s,m,c,o)
        return resultado
      elseif ast.children[1].data == "Not" then
        print("NOT")
      --print("Expressão pósfixada em C")
        c:push("not")
        printSMC(e,s,m,c,o)
        resultado = getNot(resolverExpressoes(e,s,m,c,o, ast.children[2], true))
        s:pop(1)
        s:push(resultado)
        c:pop(2)
        printSMC(e,s,m,c,o)
        return resultado
      end
    elseif data == "Id" then
      return resolverExpressoes(e,s,m,c,o, ast.children[1])
    elseif data == "Paren" then
      return resolverExpressoes(e,s,m,c,o, ast.children[1])
    elseif data == "Number" then
      return resolverExpressoes(e,s,m,c,o, ast.children[1])
    elseif data == ";" then
      for _,child in ipairs(ast.children) do
        resolverExpressoes(e,s,m,c,o, child)
      end
    end
  end
end

function getData(node, e)
	local data = node.data
	local exp = data
    exp = e[exp]
    if exp ~= nil then
      data = exp:getValue()
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
function printSMC(e, s, m, c, o)
	local smc = "< "
  stack = Stack:Create()
  -- E
	for i, v in pairs(e) do
    if v ~= nil then
      if type(v) == "number" then
        smc = smc.."["..i.."]".."=".. e[i] .." "
      elseif Loc:isLoc(v) then
        smc = smc.."["..i.."]".."=".. e[i]:getId() .." "
      elseif Abs:isAbs(v) then
        smc = smc.."["..i.."]".."=abs( "..", " .. e[i].seq.data ..") "       
      end
    end
  end
  smc = smc.."E, "
  -- S
  for i,v in pairs(s._et) do
    stack:push(v)
  end
	element = stack:pop(1)
	while element ~= nil do
		smc = smc..element.." "
		element = stack:pop(1)
	end
	smc = smc.."S, "
  -- M
  for i=1, table.maxn(m) do
    if m[i] ~= nil then
      if Loc:isLoc(m[i]) then
        smc = smc.."loc("..m[i]:getId()..")".."=>".. m[i]:getValue() .." "
      end
    end
  end

	smc = smc.."M, "
	for i,v in pairs(c._et) do
    stack:push(v)
  end
  -- C
  element = stack:pop(1)
  while element ~= nil do
    smc = smc..element.." "
    element = stack:pop(1)
   end
	smc = smc .. "C, "
  if o then
    smc = smc .. o
  end
  smc = smc .. " O >\n"
	print(smc)
end

function getString(ast)
  local s = ""
  if ast ~=nil then
    if (ast.data == "add") or (ast.data == "sub") or (ast.data == "mul") or 
      (ast.data == "eq") or (ast.data == "att") or (ast.data == "or") or (ast.data == "and") then
      if ast.children ~= nil then
        s = s .. "(" .. getString(ast.children[1]).. " " ..ast.data .. " " .. getString(ast.children[2]) .. ")"
      else
        s = ast.data
      end
      return s
    elseif ast.data == "not" then
       return s .. "not " .. getString(ast.children[1])
    elseif ast.data == "Var" then
      return s .. "(var " .. getString(ast.children[1]) ..  "="  .. getString(ast.children[2]).. ") "
    elseif ast.data == "NameList" then
      return getString(ast.children[1]) 
    elseif ast.data == "Id" then
      return getString(ast.children[1]) 
    elseif ast.data == "ExpList" then
      return getString(ast.children[1])
    elseif ast.data == "Number" then
      return getString(ast.children[1])
    elseif ast.data == "Set" then
      return s .. getString(ast.children[1]) .. "=" .. getString(ast.children[2])
    elseif ast.data == "VarList" then
      return getString(ast.children[1])
    elseif ast.data == "Op" then
      if ast.children[1].data == "+" then
        return getString(ast.children[2]) .. "+" .. getString(ast.children[3])
      elseif ast.children[1].data == "==" then
        return getString(ast.children[2]) .. "==" .. getString(ast.children[3])
      elseif ast.children[1].data == "*" then
        return getString(ast.children[2]) .. "*" .. getString(ast.children[3])
      end
    elseif ast.data == "Block" then
      local s
      for _,child in pairs(ast.children) do
        s = s .. getString(child)
      end
      return s
    else
      return ast.data
    end
  end
end




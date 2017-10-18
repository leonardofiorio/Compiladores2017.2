expressoes = require "expressoes"
tree = require "tree"
lpeg = require"lpeg"

local exp = lpeg.S"add" + lpeg.S"sub" + lpeg.S"mul" + lpeg.S"eq" + lpeg.S"not" + lpeg.S"att" + lpeg.S"or"

function resolverComandos(e,s,m,c, ast)
	local data
	if ast ~= nil then
		data = getData(ast, m)
	else
		data = c:pop(1)
	end

	print("DATA: ", data)

	if lpeg.match(exp, data) then
		s:pop(1)
		return resolverExpressoes(e,s,m,c, ast)

	elseif data == "var" then
		c:push("var")
		size = table.maxn(m)
		val = resolverExpressoes(e,s,m,c, ast.children[2])
		c:push(val)
		m[size+1] = val
		e[ast.children[1].data] = size+1
		c:pop(3)
		return
	elseif data == "while" then
		conditional = getString(ast.children[1])
		commands = getString(ast.children[2])

		print("Resolvendo while")
		-- Empilhando while em C
		print("Empilhando while em C")
		c:push(commands)
		c:push("do")
		c:push(conditional)
		c:push("while")
		printSMC(e,s,m,c)

		-- Desempilhando de C e empilhando em S
		print("Desempilhando de C e empilhando em S")
		c:pop(4)
		s:push(commands)
		s:push(conditional)
		c:push(data)
		c:push(conditional)
		printSMC(e,s,m,c)

		-- Condicional do while
		c:pop(1)
		resolverComandos(s,m,c,ast.children[1])

		if s:pop(1) == "tt" then
			-- Bloco de comandos
			resolverComandos(s,m,c, ast.children[2])
			printSMC(e,s,m,c)

			c:pop(1)
			c:push(commands)
			c:push("do")
			c:push(conditional)
			c:push("while")
			c:push(commands)
			c:pop(5)
			s:pop(1)
			print("Reexecutando")
			resolverComandos(s,m,c, ast)
			printSMC(e,s,m,c,nil)
			return
		else 
			c:pop(1)
			return 
		end 
		return
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
		printSMC(e,s,m,c)
		
		s:push(commands_else)
		s:push(commands)
		c:pop(6)
		c:push("if")
		c:push(conditional)
		c:pop(1)
		printSMC(e,s,m,c)

		resolverExpressoes(e,s,m,c, ast.children[1])
		

		t = s:pop(1)
		s:pop(1)
		s:pop(1)
		c:pop(1)
		if t == "tt" then 
			commands = resolverComandos(e,s,m,c, ast.children[2])
		elseif t == "ff" then
			commands_else = resolverComandos(e,s,m,c, ast.children[3])
		end
	elseif data == ";" then
	  print(";")
      for _,child in ipairs(ast.children) do
        resolverComandos(e,s,m,c, child)
      end
	end
end




expressoes = require "expressoes"
tree = require "tree"


function resolverComandos(s,m,c, ast)
	local data
	if ast ~= nil then
		data = getData(ast, m)
	else
		data = c:pop(1).data
	end

	if data == "add" or data == "sub" or data == "mul" or data == "eq" or data == "not" 
		or data == "att" or data == "or" or data=="and" then
		s:pop(1)
		return resolverExpressoes(s,m,c, ast)

	elseif data == "while" then
		conditional = resolverComandos(s,m,c,ast.children[1])
		commands = resolverComandos(s,m,c,ast.children[2])

		print("Resolvendo while")
		-- Empilhando while em C
		print("Empilhando while em C")
		c:push(commands)
		c:push("do")
		c:push(conditional)
		c:push("while")
		printSMC(s,m,c)

		-- Desempilhando de C e empilhando em S
		print("Desempilhando de C e empilhando em S")
		c:pop(1)
		c:pop(1)
		c:pop(1)
		c:pop(1)
		s:push(commands)
		s:push(conditional)
		c:push(data)
		c:push(conditional)
		printSMC(s,m,c)

		-- Condicional do while
		c:pop(1)
		resolverComandos(s,m,c,ast.children[1])

		if s:pop(1) == "tt" then
			-- Bloco de comandos
			resolverComandos(s,m,c, ast.children[2])
			c:pop(1)

			c:push(commands)
			c:push("do")
			c:push(conditional)
			c:push(data)
			c:push("while")
			c:push(commands)
			resolverComandos(s,m,c, nil)
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
			commands = resolverComandos(s,m,c, ast.children[2])
		elseif t == "ff" then
			commands_else = resolverComandos(s,m,c, ast.children[3])
		end
	end
end



-- while
-- local ast = node("while", {node("eq", {node("1", nil), node("1", nil)}), 
-- 		node("and", {node("tt", nil), node("tt", nil)})})

local ast = node("if", {node("eq", {node("1",nil), node("5",nil)}), 
	node("eq", {node("2",nil), node("2", nil)}), node("not", {node("ff", nil)})})
tree.show(ast)

resolverComandos(s, m, c, ast)
printSMC(s,m,c)

-- if
-- local ast = node(";", {node("<", {node("1", nil), node("2", nil)}), node("", ) , node("", )})
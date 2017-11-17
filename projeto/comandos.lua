expressoes = require "expressoes"
tree = require "tree"
lpeg = require"lpeg"
loc = require "loc"

local exp = lpeg.S"add" + lpeg.S"sub" + lpeg.S"mul" + lpeg.S"eq" + lpeg.S"not" + lpeg.S"att" + lpeg.S"or"+lpeg.S"Set"


function exitCommand(e,s,m,c,o,param)
	e = {}
	s = Stack:Create()
	m = {}
	c = Stack:Create()
	o = param
	printSMC(e,s,m,c,o)
end

function resolverComandos(e,s,m,c,o, ast)
	local data
	if ast ~= nil then
		data = getData(ast, m)
	else
		data = c:pop(1)
	end

	if lpeg.match(exp, data) then
		s:pop(1)
		return resolverExpressoes(e,s,m,c,o, ast)

	elseif data == "Var" then
		c:push("var")
		size = table.maxn(m)
		val = resolverExpressoes(e,s,m,c,o, ast.children[2])
		str = getString(ast.children[2])
		c:push(str)
		obj = Loc:new(size+1,val)
		m[size+1] = obj
		e[ast.children[1].children[1].children[1].data] = obj
		c:pop(3)
		printSMC(e,s,m,c,o)
		return
	elseif data == "Const" then
		c:push("const") 
		val = resolverExpressoes(e,s,m,c,o, ast.children[2].children[1].children[1])
		c:push(val)
		e[ast.children[1].children[1].children[1].data] = val
		c:pop(3)
		printSMC(e,s,m,c,o)
		return
	elseif data == "while" then
		conditional = getString(ast.children[1].children[1])
		commands = getString(ast.children[2].children[1])

		print("Resolvendo while")
		-- Empilhando while em C
		print("Empilhando while em C")
		c:push(commands)
		c:push("do")
		c:push(conditional)
		c:push("while")
		printSMC(e,s,m,c,o)

		-- Desempilhando de C e empilhando em S
		print("Desempilhando de C e empilhando em S")
		c:pop(4)
		s:push(commands)
		s:push(conditional)
		c:push(data)
		c:push(conditional)
		printSMC(e,s,m,c,o)

		-- Condicional do while
		c:pop(1)
		resolverExpressoes(e,s,m,c,o,ast.children[1])

		copy_e = {}
		for i,v in pairs(e) do
			copy_e[i] = e[i]
		end 

		copy_m = {}
		for i, v in pairs(m) do 
			copy_m[i] = m[i]
		end

		if s:pop(1) == "tt" then
			-- Bloco de comandos
			resolverComandos(copy_e,s,copy_m,c,o, ast.children[2])
			printSMC(copy_e,s,copy_m,c)

			c:pop(1)
			c:push(commands)
			c:push("do")
			c:push(conditional)
			c:push("while")
			c:push(commands)
			c:pop(5)
			s:pop(1)
			resolverComandos(copy_e,s,copy_m,c,o, ast)
			printSMC(copy_e,s,copy_m,c)
		else 
			c:pop(1)
			s:pop(2)
			--print("O while terminou")	
		end 

		tam = table.maxn(m)
		for i=tam+1, table.maxn(copy_m),1 do
			m[i] = copy_m[i]
		end

		return
	elseif data == "if" then
		commands = getString(ast.children[2].children[1])

		local hasElse = false
		if ast.children[3] then
			hasElse =true
		end

		if hasElse then
			commands_else = getString(ast.children[3].children[1])
			c:push(commands_else)
			c:push("else")
		end
		c:push(commands)
		c:push("then")

		conditional = getString(ast.children[1].children[1])

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

		resolverExpressoes(e,s,m,c,o, ast.children[1])
		

		t = s:pop(1)
		s:pop(1)
		s:pop(1)
		c:pop(1)

		copy_e = {}
		for i,v in pairs(e) do
			copy_e[i] = e[i]
		end 

		copy_m = {}
		for i, v in pairs(m) do 
			copy_m[i] = m[i]
		end


		if t == "tt" then 
			commands = resolverComandos(copy_e,s,copy_m,c,o, ast.children[2])
		elseif t == "ff" and hasElse then
			commands_else = resolverComandos(copy_e,s,copy_m,c,o, ast.children[3])
		end

		tam = table.maxn(m)
		for i=tam+1, table.maxn(copy_m),1 do
			m[i] = copy_m[i]
		end

		--print("O If terminou")
	elseif ast.children[1].children[1].data == "print" then
		o = o .. resolverExpressoes(e,s,m,c,o, ast.children[2])
		c:pop(1)
		printSMC(e,s,m,c,o)
	elseif ast.children[1].children[1].data == "exit" then
		return exitCommand(e,s,m,c,o,resolverExpressoes(e,s,m,c,o,ast.children[2]))
	elseif data == ";" or data=="Block" then
	  print(";")
      for _,child in pairs(ast.children) do
        resolverComandos(e,s,m,c,o, child)
      end
	end
end




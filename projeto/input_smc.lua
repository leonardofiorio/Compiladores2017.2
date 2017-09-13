--require "expressoes"
--require "comandos"

function input(e)
	tmp = string.sub(e, 0, 3)
	if tmp == "exp" then
		print("Expressões")
		-- Fazer leitura da expressão
		input()
	elseif tmp == "cmd" then
		print("Comandos")
	elseif tmp == "add" then

	elseif tmp == "sub" then
		
	end
end

entrada = "cmd(sub(sub(5,1),2))"
input(entrada)


Este é um trabalho desenvolvido por Fernando da Rós e Leonardo Fiório Soares para ser apresentado a disciplina de Compiladores do professor Christiano Braga do curso de Ciência da Computação UFF 2017.2

O trabalho consiste no desenvolvimento de um compilador na linguagem de programação Lua para Linguagem L descrita no artigo:
	- Gordon Plotkin, A structural approach to operational semantics, The Journal of Logic and Algebraic Programming 60–61 (2004) 17–139


Dependências:
	- Linguagem Lua
	- Lpeg

Execução do projeto na versão atual:
	- Na pasta "projeto" executar o comando: export LUA_PATH='parser/lib/?.lua;parser/examples/?.lua;?.lua'
	- Ainda na pasta projeto, executar comando: lua parser/bin/luafish.lua " código aqui "
		Ex: lua parser/bin/luafish.lua "var result = 1; var fat = 5; while not(fat==0) do result = result * fat; fat = fat - 1; end"
	
	



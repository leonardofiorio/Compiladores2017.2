-- Incluindo implementação da pilha
require "pilha"

-- ------------------------- Funções para resolver SMC-------------------------
-- Pilha auxiliar para guardar números naturais
naturais = Stack:Create()
--Pilha auxiliar para guardar operadores
operadores = Stack:Create()


function tratamentoComandos(s, m, c)

  print("Pilha S")
  s:list()
  print("")
  print("Pilha M")
  m:list()
  print("")
  print("Pilha C")
  c:list()
  print("")
  print("------------------")

  tmp = c:pop(1)
  b = Stack:Create()
  auxc = Stack:Create()
  auxc_linha = Stack:Create()

  if tmp == "if" then
  	--Lendo b
  	tmp = c:pop(1)
  	while tmp ~= "then" do
  		b:push(tmp)
  		tmp = c:pop(1)
  	end

  	-- Lendo c
  	tmp = c:pop(1)
  	while (tmp ~= "else") and (tmp~="end") do
  		auxc:push(tmp) 
  		tmp = c:pop(1)
	end

  	-- Lendo c'
  	tmp = c:pop(1)
  	if tmp == "else" then
  		tmp = c:pop(1)
  		while tmp ~= "end" do
  			b:push(tmp)
  			tmp = c:pop(1)
  		end
  	end
  end

  -- Resolver execução do if



  print("b")
  b:list()
  print("")
  print("c")
  auxc:list()
  print("")
  print("c_linha")
  auxc_linha:list()
end



-- Essa função retorna valor boolean para identificar se valor passado como parâmetro
-- é uma operação aceita pela linguagem ou outro componente da linguagem


-------------------------------------------------------------------------------
s = Stack:Create()
m = Stack:Create()
c = Stack:Create()

entrada = {"if", 3, ">" , 2, "then", "print('c')", "else", "print('c_linha')", "end"}
tamanho_entrada = table.maxn(entrada)

i = tamanho_entrada
while i > 0 do
  c:push(entrada[i])
  i=i-1 
end

print("Entrada...")
c:list()

print("-------------------------------Tratando expressões-------------------------------")
-- Tratamento da expressões
tratamentoComandos(s,m,c)

print("Resposta final")


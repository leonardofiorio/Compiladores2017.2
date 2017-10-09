 -- Funções para SMC






-- -------------------------------- SMC ---------------------------------------

s = Stack:Create()
m = Stack:Create()
--m = {}
--m['a'] = 7
c = Stack:Create()


entrada = {"if" }
-- entrada = {"while", 1, "<", 3, "do", "a", "=", "a", "+", "1", "end"}

--m = Stack:Create()
m = {}
m['a'] = 7
m['b'] = 10
c = Stack:Create()

tamanho_entrada = table.maxn(entrada)

i = tamanho_entrada
while i > 0 do
  c:push(entrada[i])
  i=i-1 
end

print("Entrada...")
c:list()


tratamentoComandos(s, m, c)
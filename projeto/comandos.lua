require "pilha"
require "expressoes"
local m = require"lpeg"

local any = m.P(1)
local space = m.S" \t\n"^0
local digit = m.S"0123456789"
local upper = m.S"ABCDEFGHIJKLMNOPQRSTUVWXYZ"
local lower = m.S"abcdefghijklmnopqrstuvwxyz"
local letter = m.S"" + upper + lower
local alpha = letter + digit + m.R()


-- ------------------------- Funções para resolver SMC-------------------------
auxexpressao= Stack:Create()
cond = Stack:Create()

function tratamentoComandos(s, m, c)
  -- Para tratamento de while
  tmp = c:pop(1)
  print(tmp)
  local cond = Stack:Create()
  local comandos = Stack:Create()

  if tmp == "while" then
    s_while = Stack:Create()
    m_while = Stack:Create()
    nat = Stack:Create()
    op = Stack:Create()


    print("Pegar Condição")
    -- Pilha para separar a expressão de condição
    copia_condicao_c = Stack:Create()
    tmp_exp = c:pop(1)
    while tmp_exp ~= "do" and tmp_exp ~= nil do
      cond:push(tmp_exp)
      auxexpressao:push(tmp_exp)
      copia_condicao_c:push(tmp_exp)
      tmp_exp = c:pop(1)
    end
    cond:list()


    print("Pegar bloco comandos while")
    copia_comandos_s = Stack:Create()
    copia_comandos_c = Stack:Create()
    tmp_cmd = c:pop(1)
    while tmp_cmd ~= "end" and tmp_cmd ~= nil do
      copia_comandos_s:push(tmp_cmd)
      copia_comandos_c:push(tmp_cmd)
      comandos:push(tmp_cmd)
      tmp_cmd = c:pop(1)
    end
    comandos:list()

    -- Passando bloco de comandos para S
    tmp_cmd = comandos:pop(1)
    while tmp_cmd ~= nil do
      s:push(tmp_cmd)
      tmp_cmd = comandos:pop(1)
    end


    print("Expressão a ser verificada")
    auxexpressao:list()
    print("Tratamento de Expressões")
    tratamentoExpressoes(s_while,m_while, auxexpressao,nat, op)

    print("Saiu do tratamento de Expressões")
    s_while:list()

    -- Passando expressão para S
    tmp_exp = cond:pop(1)
    while tmp_exp ~= nil do
      s:push(tmp_exp)
      tmp_exp = cond:pop(1)
    end

    s:push(s_while:pop(1))

    if s:pop(1) == "tt" then
      -- Remontando while
      print("Remontando While")

      c:push("end")
      tmp_cmd = copia_comandos_c:pop(1)
      while tmp_cmd ~= "end" and tmp_cmd ~= nil do
        c:push(tmp_cmd)
        tmp_cmd = copia_comandos_c:pop(1)
      end
      
      c:push("do")

      tmp_cmd = copia_condicao_c:pop(1)
      while tmp_cmd ~= nil do
        c:push(tmp_cmd)
        tmp_cmd = copia_condicao_c:pop(1)
      end

      c:push("while")

      tmp_cmd = copia_comandos_s:pop(1)
      while tmp_cmd ~= nil do
        c:push(tmp_cmd)
        tmp_cmd = copia_comandos_s:pop(1)
      end


      c:list()
    else
      while tmp_exp ~= "end" do
        
      end
    end

  elseif tmp == "if" then
  	
  elseif tmp == "" then
    print('end');
  end
end

 
-- -------------------------------- SMC ---------------------------------------

s = Stack:Create()
--m = Stack:Create()
m = {}
m['a'] = 7
c = Stack:Create()


entrada = {"while", 8, "<", 10, "do", "print(a)", "a", "=", "a", "+", "1", "end"}


tamanho_entrada = table.maxn(entrada)

i = tamanho_entrada
while i > 0 do
  c:push(entrada[i])
  i=i-1 
end

print("Entrada...")
c:list()


tratamentoComandos(s, m, c)
c:list()

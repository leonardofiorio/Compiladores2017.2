-- -------------------------Implementação de pilha-------------------------
 -- Pilha usando tabela, use <table>:push(value) and <table>:pop()

-- Global
Stack = {}

-- Create a Table with stack functions
-- Criar uma tabela com funções de pilha
function Stack:Create()

  -- stack table
  local t = {}
  -- entry table
  t._et = {}

  -- push a value on to the stack
  function t:push(...)
    if ... then
      local targs = {...}
      -- add values
      for _,v in ipairs(targs) do
        table.insert(self._et, v)
      end
    end
  end

  -- pop a value from the stack
  function t:pop(num)

    -- get num values from stack
    local num = num or 1

    -- return table
    local entries = {}

    -- get values into entries
    for i = 1, num do
      -- get last entry
      if #self._et ~= 0 then
        table.insert(entries, self._et[#self._et])
        -- remove last value
        table.remove(self._et)
      else
      	return nil
        --break
      end
    end
    -- return unpacked entries
    return unpack(entries)
  end

  -- get entries
  function t:getn()
    return #self._et
  end

  -- list values
  function t:list()
  	print("=>Base da pilha<=")
    for i,v in pairs(self._et) do
      print(i,v)
    end
    print("=>Topo da pilha<=")
  end
  return t
end

-- ------------------------- Funções para resolver SMC-------------------------


function tratamentoComandos(s, m, c)
  -- Para tratamento de while
  tmp = c:pop(1)

  if tmp == "while" then
    cond = pegarCondicao(s, m, c)
    if cond ~= nil then
      print("ok")
      for _, x in ipairs(cond) do
        print(x)
      end
      --considerando que primeiro venha a variavel e depois a contatante a < 10
      local a = m[cond[1]]
      local simbolo = cond[2]
      local constante = cond[3]
      if simbolo == "==" then
      elseif simbolo == "~=" then
      elseif simbolo == "<" then
        while a < tonumber(constante) do
          print(a)
          m[cond[1]] = m[cond[1]] + 1
          a = m[cond[1]]
        end
      elseif simbolo == "<=" then
      elseif simbolo == ">" then
      elseif simbolo == ">=" then                
      end
    else
      print("Condição inválida.")
    end
  elseif tmp == "if" then
  	
  elseif tmp == "" then
    print('end');
  end
print(tmp)

end

function pegarCondicao(s, m, c)
  cond = {}
  local value = c:pop(1)
  while value ~= "do" do
    if value == nil then
      return nil
    end
    table.insert(cond, value)
    value = c:pop(1)
  end
  return cond
end

 
-- -------------------------------- SMC ---------------------------------------

s = Stack:Create()
--m = Stack:Create()
m = {}
m['a'] = -1
c = Stack:Create()


entrada = {"while", "a", "<", "10", "do", "print(a)", "a", "=", "a", "+", "1", "end"}


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

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
  tmp = s:pop(1)

  if tmp == "while" then

  elseif tmp == "" then

  end

end

 
-- -------------------------------- SMC ---------------------------------------

s = Stack:Create()
m = Stack:Create()
c = Stack:Create()


entrada = {"while", "a < 10", "do", "print(a)", "end"}


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

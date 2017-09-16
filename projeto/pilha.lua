-- -------------------------Implementação de pilha-------------------------
 -- Pilha usando tabela, funções <table>:push(value) and <table>:pop()

-- Global
Stack = {}

-- Criar uma tabela com funções de pilha
function Stack:Create()

  -- tabela pilha
  local t = {}
  t._et = {}

  -- Entrando com valores na pilha
  function t:push(...)
    if ... then
      local targs = {...}
      -- Adicionando valores à tabela interna
      for _,v in ipairs(targs) do
        table.insert(self._et, v)
      end
    end
  end

  -- Removendo valores da pilha
  function t:pop(num)

    -- Quantidade de valores a serem removidos  
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

  -- Pegando ítem
  function t:getn()
    return #self._et
  end

  -- Imprimindo valores
  function t:list()
    invert = Stack:Create()
    for i,v in pairs(self._et) do
      invert:push(v)
    end
    local stack = "< "
    top = invert:pop(1)
    while top ~=nil do
      stack = stack..top.." "
      top = invert:pop(1)
    end
      -- print(i,v)
    print(stack..">")
  end
  return t
end

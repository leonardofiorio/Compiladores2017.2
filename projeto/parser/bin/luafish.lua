-- luafish.lua
-- This is a front-end to the LuaFish macro processor.
--
-- Example usage:
--    export LUA_PATH='lib/?.lua;examples/?.lua;?.lua'
--    lua bin/luafish.lua examples/type_usage2.lua
-- or
--    lua bin/luafish.lua "code"

local i = 0
function printAST(ast)
  -- ts[#ts+1] = 'tag=' .. string.format("%q", self.tag)
  
  for key,value in ipairs(ast) do
    print(i)
    i = i+1
    -- print(key)
    if type(value) == "number" then
      value = tostring(value)
    end
    if value.tag then
      print(value.tag)
    end
    if type(value) ~= "table" then
      print(value)
      print("\n")
    elseif value and type(value) == "table" then
      printAST(value)
    end
  end
  -- print("\n\n")
  -- ast = string.gsub(tostring(ast), "{", "{\n")
  -- ast = string.gsub(tostring(ast), "}", "}\n")
  -- print(ast)
  
  -- for key,value in ipairs(ast) do --each ';' determines 1 key
  --   print(value)
  -- end
  -- print(ast[1][2][1][3])
end

local macro = require 'luafish.macro'

macro.addloader()

local is_file = false
local start = 1
while true do
  local v = select(start, ...)
  if not(v and v:find '-' == 1 and #v > 1) then
    break
  end
  if v == '-file' then
    is_file = true
  else
    error('unrecognized option ' .. v)
  end
  start = start + 1
end
local code = select(start, ...)

local Parser = require 'luafish.parser'
local p = Parser()
print(p:parse{code, is_file})
printAST(p:parse{code, is_file})


-- luafish.lua
-- This is a front-end to the LuaFish macro processor.
--
-- Example usage:
--    export LUA_PATH='lib/?.lua;examples/?.lua;?.lua'
--    lua bin/luafish.lua examples/type_usage2.lua

function printAST(ast)
  print("\n\n")
  for key,value in ipairs(ast) do --each ';' determines 1 key
    print(key)
    print(value)
  end
end

-- function printAST(node, level)
--     if level == nil then
--         level = 0
--     end
--     if node ~= nil then
--         print(string.rep(" ", level) .. "Node[" .. node.data .. "]")
--         if(node.children ~= nil) then
--           for _, child in ipairs(node.children) do
--             Tree.show(child, level + 2)
--           end
--         end
--     end
-- end

local macro = require 'luafish.macro'

macro.addloader()

local is_show_ast = false
local start = 1
while true do
  local v = select(start, ...)
  if not(v and v:find '-' == 1 and #v > 1) then
    break
  end
  if v == '-a' then
    is_show_ast = true
  else
    error('unrecognized option ' .. v)
  end
  start = start + 1
end
local filename = select(start, ...)

if is_show_ast then
  local Parser = require 'luafish.parser'
  local p = Parser()
  print(p:parse{filename})
  printAST(p:parse{filename})
else
  local f = assert(macro.loadfile(filename))
  return f(select(2, ...)) -- possibly improve arg handling
end


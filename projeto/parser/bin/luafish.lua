local tree = require "luafish.tree"
local comandos = require "comandos"
local macro = require 'luafish.macro'
macro.addloader()

--    EXEMPLO OF USAGE ON PROJECT DIRECTORY: 
--    export LUA_PATH='parser/lib/?.lua;parser/examples/?.lua;?.lua'
--    lua parser/bin/luafish.lua "code"

function buildAST(ast, currentNode)
  for key,value in ipairs(ast) do
    if type(value) == "number" then
      value = tostring(value)
    end
    if value.tag then
      addChild(currentNode, node(value.tag, nil))
    end
    if type(value) ~= "table" then
      addChild(currentNode, node(value, nil))
    elseif value and type(value) == "table" then
      buildAST(value, currentNode.children[#currentNode.children])
    end
  end
end

local is_file = false
local start = 1
-- while true do
--   local v = select(start, ...)
--   if not(v and v:find '-' == 1 and #v > 1) then
--     break
--   end
--   if v == '-file' then
--     is_file = true
--   else
--     error('unrecognized option ' .. v)
--   end
--   start = start + 1
-- end
local code = select(start, ...)

local Parser = require 'luafish.parser'
local p = Parser()
local parsed = p:parse{code, is_file}
print(parsed)
ast = node(";",nil)
buildAST(parsed, ast)
tree.show(ast)
resolverComandos(e,s,m,c,ast)
printSMC(e,s,m,c)
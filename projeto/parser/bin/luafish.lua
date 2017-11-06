local tree = require "luafish.tree"
local comandos = require "comandos"

--    EXEMPLO OF USAGE ON PROJECT DIRECTORY: 
--    export LUA_PATH='parser/lib/?.lua;parser/examples/?.lua;?.lua'
--    lua parser/bin/luafish.lua "code"

local i = 0
function printAST(ast, currentNode)
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
      addChild(currentNode, node(value.tag, nil))
    end
    if type(value) ~= "table" then
      print(value)
      addChild(currentNode, node(value, nil))
      print("\n")
    elseif value and type(value) == "table" then
      printAST(value, currentNode.children[#currentNode.children])
    end
    tree.show(currentNode)
  end
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
--print(p:parse{code, is_file})
retorno = node(";",nil)
printAST(p:parse{code, is_file}, retorno)
resolverComandos(e,s,m,c,retorno)
printSMC(e,s,m,c)
local bintree = require "bintree"

-- local op1 = bintree.new("33", nil, nil)
-- local op2 = bintree.new("7", nil, nil)

local function node(name, left, right)
  return bintree.new(name, left, right)
end

local ast = node("add", 
  node("33", nil, nil), 
  node("7", nil, nil)
  )
-- ast3:addRight(ast)
bintree.show(ast)

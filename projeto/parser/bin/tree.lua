
local Tree = {}
Tree.__index = Tree


function Tree.new(data, children) --children {}
   local node = {
       data = data,
       children = children or {},
   }
   return setmetatable(node,Bintree)
end

function node(data, children)
  return Tree.new(data, children)
end

function addChild(tree, child)
  table.insert(tree.children, child)
end

function Tree.show(node, level)
    if level == nil then
        level = 0
    end

    if node ~= nil then
        print(string.rep(" ", level) .. "Node[" .. node.data .. "]")
        if(node.children ~= nil) then
          for _, child in ipairs(node.children) do
            Tree.show(child, level + 2)
          end
        end
    end
end

return Tree
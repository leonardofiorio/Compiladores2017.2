Abs = {}
Abs.__index = Loc

function Abs:new(id, node)
	l = {}
	setmetatable(l, Loc)
	l.id = id
	l.node = node
	l.type = 'ABS'
	return l
end

function Abs:getNode()
   return self.node
end

function Abs:getId()
	return self.id
end

function Abs:setNode(node)
	self.value = value
end

function Abs:isAbs(obj)
	if obj.type == "ABS" then
		return true
	end
	return false
end

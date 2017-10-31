Loc = {}
Loc.__index = Loc

function Loc:new(id, value)
	l = {}
	setmetatable(l, Loc)
	l.id = id
	l.value = value
	return l
end

function Loc:getValue()
   return self.value
end

function Loc:getId()
	return self.id
end

function Loc:isLoc(obj)
	if tonumber(obj) == nil then
		return true
	end
	return false
end

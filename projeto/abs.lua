Abs = {}
Abs.__index = Loc

function Abs:new(param, seq)
	l = {}
	setmetatable(l, Loc)
	l.param = param
	l.seq = seq
	l.type = 'ABS'
	return l
end

function Abs:getParam()
   return self.param
end

function Abs:getSeq()
	return self.seq
end

function Abs:setParam(param)
	self.param = param
end

function Abs:setSeq(seq)
	self.seq = seq
end

function Abs:isAbs(obj)
	if obj.type == "ABS" then
		return true
	end
	return false
end

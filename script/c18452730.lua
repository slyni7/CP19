--환희의 야수
local m=18452736
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddModuleProcedure(c,nil,nil,1,5,nil)
end
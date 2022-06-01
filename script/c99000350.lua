--아홉 생명의 여우
local m=99000350
local cm=_G["c"..m]
function cm.initial_effect(c)
	--order summon
	aux.AddOrderProcedure(c,"R",nil,cm.ordfilter1,cm.ordfilter2)
	c:EnableReviveLimit()
end
cm.CardType_Order=true
function cm.ordfilter1(c)
	return c:IsType(TYPE_MONSTER)
end
function cm.ordfilter2(c)
	return c:IsType(TYPE_MONSTER)
end
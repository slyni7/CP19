--의식
local m=18453335
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddRitualProcEqual2(c,cm.pfil1)
end
function cm.pfil1(c)
	return c:IsType(TYPE_RITUAL)
end

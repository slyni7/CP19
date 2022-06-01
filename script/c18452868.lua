--±Ã±ØÀÇ ´©¸¥ ´«ÀÇ Åä·æ
local m=18452868
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcCodeRep(c,18452865,3,true,true)
end
cm.material_setcode="´©¸¥ ´«"
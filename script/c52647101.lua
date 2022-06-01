--큐빅 라비
local m=52647101
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddSquareProcedure(c)
end
cm.square_mana={ATTRIBUTE_WIND,ATTRIBUTE_WIND,ATTRIBUTE_WIND,ATTRIBUTE_WIND}
cm.custom_type=CUSTOMTYPE_SQUARE
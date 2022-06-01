--큐빅 웨일
local m=52647102
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddSquareProcedure(c)
end
cm.square_mana={ATTRIBUTE_EARTH,ATTRIBUTE_EARTH,ATTRIBUTE_EARTH,ATTRIBUTE_EARTH}
cm.custom_type=CUSTOMTYPE_SQUARE
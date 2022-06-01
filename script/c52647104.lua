--큐빅 호넷
local m=52647104
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddSquareProcedure(c)
end
cm.square_mana={ATTRIBUTE_FIRE,ATTRIBUTE_FIRE,ATTRIBUTE_FIRE,ATTRIBUTE_FIRE}
cm.custom_type=CUSTOMTYPE_SQUARE
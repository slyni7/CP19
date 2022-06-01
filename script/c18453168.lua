--서울 사이버 드래곤
local m=18453168
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddSquareProcedure(c)
end
cm.square_mana={}
cm.custom_type=CUSTOMTYPE_SQUARE
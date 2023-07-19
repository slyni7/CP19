--데몬 소환을 데몬 소환
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddSkullProcedure(c,aux.FilterBoolFunction(Card.IsCode,70781052),nil,nil)
end
s.custom_type=CUSTOMTYPE_SKULL
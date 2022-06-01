--PBH-여천사 홀리 엔젤
function c112401214.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcMixRep(c,true,true,c112401214.ffilter,1,99,aux.FilterBoolFunction(Card.IsFusionSetCard,0xee5))
end
function c112401214.ffilter(c,fc,sumtype,tp)
	return c:IsType(TYPE_MONSTER,fc,sumtype,tp)
end
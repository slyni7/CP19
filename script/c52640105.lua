--필리플렉터 마인드 디스오더
local m=52640105
local cm=_G["c"..m]
function c52640105.initial_effect(c)
	--오더 소환
	aux.AddOrderProcedure(c,"R",nil,aux.FilterBoolFunction(Card.IsLevelAbove,1),cm.ofil1,cm.ofil1,cm.ofil1)
	c:EnableReviveLimit()
end
cm.CardType_Order=true
function cm.ofil1(c)
	local seq=c:GetSequence()
	local tc=Duel.GetFieldCard(tp,LOCATION_MZONE,seq-1)
	return tc:GetLevel()>0 and 2*tc:GetLevel()==c:GetLevel()
end

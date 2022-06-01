--이대로는 무엇도 사랑하고 싶지 않아
local m=18453050
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddOrderProcedure(c,">",cm.pfun1,aux.TRUE,aux.TRUE)
	local e1=MakeEff(c,"Qo","M")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetHintTiming(TIMING_MAIN_END)
	e1:SetCountLimit(1,m)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)
end
function cm.pfun1(g)
	local st=cm.square_mana
	return aux.IsFitSquare(g,st)
end
cm.square_mana={ATTRIBUTE_DARK,ATTRIBUTE_FIRE}
cm.custom_type=CUSTOMTYPE_SQUARE
cm.CardType_Order=true
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.GetCurrentPhase()&(PHASE_MAIN1+PHASE_MAIN2)>0
end
function cm.tfil1(c,e,tp)
	return c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(tp) and chkc:IsLoc("G") and cm.tfil1(chkc,e,tp)
	end
	if chk==0 then
		return Duel.GetLocCount(tp,"M")>0 and Duel.IETarget(cm.tfil1,tp,"G",0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.STarget(tp,cm.tfil1,tp,"G",0,1,1,nil,e,tp)
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"EG")
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE) then
		if c:IsRelateToEffect(e) then
			local e1=MakeEff(c,"F","M")
			e1:SetCode(EFFECT_MUST_BE_OMATERIAL)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(1,0)
			e1:SetReset(RESET_CHAIN)
			c:RegisterEffect(e1)
			local e2=e1:Clone()
			tc:RegisterEffect(e2)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SMCard(tp,Card.IsOrderSummonable,tp,"E",0,0,1,nil)
			local oc=g:GetFirst()
			if oc then
				Duel.SpecialSummonRule(tp,oc)
			end
			e1:Reset()
			e2:Reset()
		end
	end
end
--질투의 지명자
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"Qo","H")
	e1:SetCode(EVENT_CHAINING)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"F","M")
	e2:SetCode(EFFECT_PUBLIC)
	e2:SetTR("H","H")
	c:RegisterEffect(e2)
end
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	local ex,cg,ct,cp,cv=Duel.GetOperationInfo(ev,CATEGORY_ANNOUNCE)
	return rp==tp and ex and (cv&ANNOUNCE_CARD+ANNOUNCE_CARD_FILTER)~=0
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocCount(tp,"M")>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.ofil1(c,code)
	return c:IsCode(code) and c:IsAbleToDeck()
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local ex,cg,ct,cp,cv=Duel.GetOperationInfo(ev,CATEGORY_ANNOUNCE)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
		local ac=Duel.AnnounceCard(tp)
		Duel.ChangeTargetParam(ev,ac)
		local g=aux.SideDeck[tp]
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:FilterSelect(tp,s.ofil1,0,1,nil,ac)
		if #sg>0 then
			Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
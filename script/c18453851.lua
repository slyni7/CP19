--폭주학익진
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SEARCH)
	e1:SetCL(1,id,EFFECT_COUNT_CODE_OATH)
	WriteEff(e1,1,"O")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"Qo","F")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCL(1)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
end
s.listed_names={30914564}
function s.tfil1(c)
	return c:IsCode(30914564) and c:IsAbleToHand()
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SMCard(tp,s.tfil1,tp,"D",0,0,1,nil):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function s.tfil2(c)
	return c:IsCode(30914564) and c:IsFaceup()
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(s.tfil2,tp,"O",0,1,nil)
	end
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GMGroup(s.tfil2,tp,"O",0,nil)
	local tc=g:GetFirst()
	while tc do
		Duel.RaiseSingleEvent(tc,EVENT_SPSUMMON_SUCCESS,e,REASON_EFFECT,tp,tp,0)
		tc=g:GetNext()
	end
	Duel.RaiseEvent(g,EVENT_SPSUMMON_SUCCESS,e,REASON_EFFECT,tp,tp,0)
end
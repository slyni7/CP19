--아마테라스는 지금 저지불가야
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"A")
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetCL(1,id,EFFECT_COUNT_CODE_OATH)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(Card.IsAbleToHand,tp,"G","G",1,nil)
	end
	Duel.SetChainLimit(aux.FALSE)
end
function s.ofil2(c)
	return c:IsSetCard("저지불가") and (c:IsSummonable(true,nil) or c:IsMSetable(true,nil) or c:IsSpecialSummonable())
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SMCard(tp,Card.IsAbleToHand,tp,"G","G",1,1,nil)
	local tc=g:GetFirst()
	if not tc then
		return
	end
	Duel.HintSelection(g)
	if Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 then
		local c=e:GetHandler()
		local e1=MakeEff(c,"F")
		e1:SetCode(EFFECT_DISABLE)
		e1:SetTR("O","O")
		e1:SetTarget(s.otar21)
		e1:SetLabel(tc:GetOriginalCodeRule())
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
		local e2=MakeEff(c,"FC")
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetCondition(s.ocon22)
		e2:SetOperation(s.oop22)
		e2:SetLabel(tc:GetOriginalCodeRule())
		e2:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e2,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SMCard(tp,s.ofil2,tp,"HE",0,0,1,nil)
		local sc=sg:GetFirst()
		if sc then
			if sc:IsSpecialSummonable() and (not (sc:IsSummonable(true,nil) or sc:IsMSetable(true,nil))
				or Duel.SelectYesNo(tp,aux.Stringid(id,0))) then
				Duel.SpecialSummonRule(tp,sc)
			else
				if sc:IsSummonable(true,nil) and (not sc:IsMSetable(true,nil) 
					or Duel.SelectPosition(tp,sc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) then
					Duel.Summon(tp,sc,true,nil)
				else
					Duel.MSet(tp,sc,true,nil)
				end
			end
		end
	end
end
function s.otar21(e,c)
	local code=e:GetLabel()
	local code1,code2=c:GetOriginalCodeRule()
	return code1==code or code2==code
end
function s.ocon22(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabel()
	local code1,code2=re:GetHandler():GetOriginalCodeRule()
	return (code1==code or code2==code)
end
function s.oop22(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	Duel.NegateEffect(ev)
end

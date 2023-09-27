--엑스클루드 카드
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetCL(1,id,EFFECT_COUNT_CODE_OATH)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
end
s.listed_names={CARD_CARD_EJECTOR}
function s.tfil1(c)
	return (c:IsCode(CARD_CARD_EJECTOR) or aux.IsCodeListed(c,CARD_CARD_EJECTOR))
		and c:IsAbleToHand()
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(s.tfil1,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,s.tfil1,tp,"D",0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	if Duel.IsPlayerAffectedByEffect(tp,id) then
		return
	end
	local e1=MakeEff(c,"F")
	e1:SetCode(id)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTR(1,0)
	Duel.RegisterEffect(e1,tp)
	local e2=MakeEff(c,"FC")
	e2:SetCode(EVENT_REMOVE)
	e2:SetCondition(s.ocon12)
	e2:SetOperation(s.oop12)
	Duel.RegisterEffect(e2,tp)
end
function s.onfil12(c,tp)
	return c:GetReasonPlayer()==tp and c:IsReason(REASON_EFFECT) and c:GetReasonEffect():GetHandler():IsCode(CARD_CARD_EJECTOR)
end
function s.ocon12(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(s.onfil12,nil,tp)
	return #g>0
end
function s.oop12(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=eg:Filter(s.onfil12,nil,tp)
	Duel.Hint(HINT_CARD,0,id)
	Duel.HintSelection(g)
	local tc=g:GetFirst()
	while tc do
		local code=tc:GetOriginalCodeRule()
		local e1=MakeEff(c,"F")
		e1:SetCode(EFFECT_DISABLE)
		e1:SetTR("O","O")
		e1:SetLabel(code)
		e1:SetTarget(s.ootar121)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=MakeEff(c,"FC")
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetLabel(code)
		e2:SetCondition(s.oocon122)
		e2:SetOperation(s.ooop122)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
		e3:SetTR("M","M")
		Duel.RegisterEffect(e3,tp)
		tc=g:GetNext()
	end
end
function s.ootar121(e,c)
	return c:IsOriginalCodeRule(e:GetLabel())
end
function s.oocon122(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rc:IsOriginalCodeRule(e:GetLabel())
end
function s.ooop122(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end

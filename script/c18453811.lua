--시클루드 카드
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetCL(1,id,EFFECT_COUNT_CODE_OATH)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"S")
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e2)
end
s.listed_names={CARD_CARD_EJECTOR}
function s.tfil11(c)
	return c:IsCode(CARD_CARD_EJECTOR) and c:IsAbleToHand()
end
function s.tfil12(c)
	return c:IsSpell() and aux.IsCodeListed(c,CARD_CARD_EJECTOR) and c:IsAbleToHand()
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IETarget(s.tfil11,tp,"G",0,1,nil) and Duel.IETarget(s.tfil12,tp,"G",0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.STarget(tp,s.tfil11,tp,"G",0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g2=Duel.STarget(tp,s.tfil12,tp,"G",0,1,1,nil)
	g1:Merge(g2)
	Duel.SOI(0,CATEGORY_TOHAND,g1,2,0,0)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetTargetCards(e)
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
	e2:SetCode(EVENT_BATTLED)
	e2:SetCondition(s.ocon12)
	e2:SetOperation(s.oop12)
	Duel.RegisterEffect(e2,tp)
end
function s.onfil12(c,tp)
	return c:IsControler(tp) and c:IsCode(CARD_CARD_EJECTOR)
end
function s.ocon12(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local a=Duel.GetAttacker()
	local t=Duel.GetAttackTarget()
	local g=Group.FromCards(a,t)
	return g:IsExists(s.onfil12,1,nil,tp)
end
function s.oop12(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	local g=Group.FromCards(a,d)
	local rg=g:Filter(Card.IsRelateToBattle,nil)
	if #rg>0 and Duel.SelectYesNo(tp,aux.Stringid(18453811,0)) then
		Duel.Hint(HINT_CARD,0,18453811)
		Duel.HintSelection(rg)
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
	end
end

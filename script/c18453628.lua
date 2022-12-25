--첫 번째 계절: 봄
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	local e1=MakeEff(c,"Qo","M")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetCL(1)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"STo")
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCategory(CATEGORY_REMOVE)
	WriteEff(e2,2,"NTO")
	c:RegisterEffect(e2)
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return false
	end
	if chk==0 then
		return Duel.IETarget(Card.IsAbleToHand,tp,"G",0,1,nil) and Duel.IETarget(Card.IsAbleToHand,tp,0,"O",1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g1=Duel.STarget(tp,Card.IsAbleToHand,tp,"G",0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g2=Duel.STarget(tp,Card.IsAbleToHand,tp,0,"O",1,1,nil)
	g1:Merge(g2)
	Duel.SOI(0,CATEGORY_TOHAND,g2,2,0,0)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetCards(e)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_RITUAL)
end
function s.tfil2(c)
	return c:IsSetCard("계절") and c:IsAbleToRemove() and not c:IsCode(id)
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(s.tfil2,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_REMOVE,nil,1,tp,"D")
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SMCard(tp,s.tfil2,tp,"D",0,1,1,nil)
	if #g>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
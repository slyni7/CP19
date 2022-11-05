--설치동물 우드척
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_DUEL)
	e1:SetCondition(s.con1)
	e1:SetTarget(s.tg2)
	e1:SetOperation(s.op2)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetCountLimit(1,{id,1},EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.tg1)
	e1:SetOperation(s.op1)
	c:RegisterEffect(e1)
	if not s.global_check then
		s.global_check=true
		s[0]=0
		s[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetCondition(s.gcon1)
		ge1:SetOperation(s.gop1)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_CHAIN_NEGATED)
		ge2:SetCondition(s.gcon1)
		ge2:SetOperation(s.gop2)
		Duel.RegisterEffect(ge2,0)
	end
end
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetTurnCount()==9 or Duel.GetTurnCount()==10) and Duel.GetTurnPlayer()==tp
end
function s.tfilter1(c)
	return c:IsSetCard("설치동물") and c:IsAbleToHand() and not c:IsCode(id) and (c:IsFaceup() or not c:IsLocation(LOCATION_REMOVED))
end
function s.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.tfilter1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.tfilter1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if g:GetCount()<1 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:Select(tp,1,1,nil)
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sg)
end
function s.gcon1(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return rc:IsSetCard("설치동물") and loc&LOCATION_ONFIELD==0 and not rc:IsCode(id)
end
function s.gop1(e,tp,eg,ep,ev,re,r,rp)
	s[rp]=s[rp]+1
end
function s.gop2(e,tp,eg,ep,ev,re,r,rp)
	s[rp]=s[rp]-1
end
function s.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return s[tp]>0 and Duel.IsPlayerCanDraw(tp,s[tp])
	end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,s[tp])
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,s[tp],REASON_EFFECT)
end
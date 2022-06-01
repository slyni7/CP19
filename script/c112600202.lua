--루나틱션+(플래닛) 어스
function c112600202.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c112600202.matfilter,1,1)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--link limit
	local e30=Effect.CreateEffect(c)
	e30:SetType(EFFECT_TYPE_SINGLE)
	e30:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e30:SetValue(c112600202.synlimit)
	e30:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e30:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e30)
	--search p
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetDescription(aux.Stringid(112600202,2))
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1,112600202)
	e3:SetCost(c112600202.thcost)
	e3:SetTarget(c112600202.thtg)
	e3:SetOperation(c112600202.thop)
	c:RegisterEffect(e3)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(112600202,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCountLimit(1,112600203)
	e1:SetCondition(c112600202.drcon)
	e1:SetTarget(c112600202.drtg)
	e1:SetOperation(c112600202.drop)
	c:RegisterEffect(e1)
	--pendulum set
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(112600202,1))
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTarget(c112600202.rettg)
	e6:SetOperation(c112600202.retop)
	c:RegisterEffect(e6)
end
function c112600202.synlimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0xe8b)
end
function c112600202.matfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsLevelBelow(4)
end
function c112600202.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xe8b) and c:IsDiscardable()
end
function c112600202.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c112600202.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,c112600202.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c112600202.thfilter(c)
	return c:IsType(TYPE_MONSTER) and not c:IsSetCard(0xe8b) and c:IsAbleToHand()
end
function c112600202.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c112600202.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c112600202.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c112600202.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c112600202.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c112600202.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c112600202.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c112600202.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then
      return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)
   end
end
function c112600202.retop(e,tp,eg,ep,ev,re,r,rp)
   local c=e:GetHandler()
   if not c:IsRelateToEffect(e) then
      return
   end
   if Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) then
      Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
   end
end
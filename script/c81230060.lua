--야에 마을의 비극
--카드군 번호: 0xcbc
function c81230060.initial_effect(c)
	
	c:EnableCounterPermit(0xcbc)
	
	--효과처리
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,81230060+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c81230060.tg1)
	e1:SetOperation(c81230060.op1)
	c:RegisterEffect(e1)
	
	--드로우
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81230060,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,81230061)
	e2:SetCost(c81230060.co2)
	e2:SetTarget(c81230060.tg2)
	e2:SetOperation(c81230060.op2)
	c:RegisterEffect(e2)
	
	--파괴 회피
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTarget(c81230060.tg3)
	c:RegisterEffect(e3)
end

--효과처리
function c81230060.filter0(c)
	return c:IsAbleToHand() and c:IsSetCard(0xcbc) and c:IsType(TYPE_MONSTER)
end
function c81230060.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81230060.filter0,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c81230060.op1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c81230060.filter0,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

--드로우
function c81230060.filter1(c)
	return c:IsAbleToRemoveAsCost() and c:IsSetCard(0xcbc)
end
function c81230060.co2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81230060.filter1,tp,LOCATION_GRAVE,0,1,nil)
	end
	local f_ct=Duel.GetFieldGroupCount(tp,0x01,0)
	local ct=math.max(1,f_ct*3)
	if f_ct<1 then ct=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c81230060.filter1,tp,LOCATION_GRAVE,0,1,ct,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabel(#g)
end
function c81230060.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local val=e:GetLabel()
	local d=math.floor(val/3)
	if chk==0 then
		return Duel.IsPlayerCanDraw(tp,d)
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(d)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,d)
end

function c81230060.op2(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end

--파괴 회피
function c81230060.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return rp==1-tp and e:GetHandler():IsCanRemoveCounter(tp,0xcbc,1,REASON_COST)
	end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		c:RemoveCounter(tp,0xcbc,1,REASON_EFFECT)
		return true
	else
		return false
	end
end

--아르카나 포스 IX-더 허밋
function c82710004.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCategory(CATEGORY_COIN+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetTarget(c82710004.tar1)	
	e1:SetOperation(c82710004.op1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SPSUMMON_PROC)
	e4:SetRange(LOCATION_HAND)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCondition(c82710004.con4)
	c:RegisterEffect(e4)
end
c82710004.toss_coin=true
function c82710004.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function c82710004.ofil1(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand() and aux.IsArcanaListed(c)
end
function c82710004.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then
		return
	end
	local res=0
	if c:IsHasEffect(73206827) then
		res=1-Duel.SelectOption(tp,60,61)
	else
		res=Duel.TossCoin(tp,1)
	end
	c82710004.arcanareg(c,res)
	if res==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c82710004.ofil1,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c82710004.arcanareg(c,coin)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetCondition(c82710004.acon1)
	e1:SetTarget(c82710004.atar1)
	e1:SetOperation(c82710004.aop1)
	c:RegisterEffect(e1)
	c:RegisterFlagEffect(36690018,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,coin,63-coin)
end
function c82710004.acon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffectLabel(36690018)==0
end
function c82710004.atfil1(c)
	return c:IsSetCard(0x5) and c:IsType(TYPE_MONSTER)
end
function c82710004.atar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c82710004.atfil1,tp,LOCATION_HAND,0,1,nil) and Duel.IsPlayerCanDraw(tp,2)
	end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c82710004.aop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c82710004.atfil1,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
	end
	Duel.Draw(tp,2,REASON_EFFECT)
end
function c82710004.nfil4(c)
	return c:IsFacedown() or not c:IsSetCard(0x5)
end
function c82710004.con4(e,c)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and not Duel.IsExistingMatchingCard(c82710004.nfil4,tp,LOCATION_MZONE,0,1,nil)
end
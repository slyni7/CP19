--아르카나 포스 XVII-더 스타
function c82710013.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCategory(CATEGORY_COIN)
	e1:SetTarget(c82710013.tar1)	
	e1:SetOperation(c82710013.op1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_SUMMON_PROC)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetDescription(aux.Stringid(82710013,0))
	e4:SetCondition(c82710013.con4)
	e4:SetOperation(c82710013.op4)
	c:RegisterEffect(e4)
end
c82710013.toss_coin=true
function c82710013.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function c82710013.ofil1(c)
	return c:IsSetCard(0x5) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:IsAbleToGrave()
end
function c82710013.op1(e,tp,eg,ep,ev,re,r,rp)
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
	c82710013.arcanareg(c,res)
	if res==1 then
		local g=Duel.GetMatchingGroup(c82710013.ofil1,tp,LOCATION_DECK,0,nil)
		if g:GetClassCount(Card.GetCode)>2 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
			local sg1=g:Select(tp,1,1,nil)
			local tc1=sg1:GetFirst()
			g:Remove(Card.IsCode,nil,tc1:GetCode())
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
			local sg2=g:Select(tp,1,1,nil)
			local tc2=sg2:GetFirst()
			g:Remove(Card.IsCode,nil,tc2:GetCode())
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
			local sg3=g:Select(tp,1,1,nil)
			sg1:Merge(sg2)
			sg1:Merge(sg3)
			Duel.ConfirmCards(1-tp,sg1)
			Duel.ShuffleDeck(tp)
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
			local tg=sg1:Select(1-tp,1,1,nil)
			local tc=tg:GetFirst()
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			sg1:Sub(tg)
			Duel.SendtoGrave(sg1,REASON_EFFECT)
		end
	end
end
function c82710013.arcanareg(c,coin)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetCondition(c82710013.acon1)
	e1:SetTarget(c82710013.atar1)
	e1:SetOperation(c82710013.aop1)
	c:RegisterEffect(e1)
	c:RegisterFlagEffect(36690018,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,coin,63-coin)
end
function c82710013.acon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffectLabel(36690018)~=0 or ep==tp or c:IsStatus(STATUS_BATTLE_DESTROYED) or not Duel.IsChainNegatable(ev) then
		return false
	end
	return re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c82710013.atar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
end
function c82710013.aop1(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.NegateActivation(ev) and rc:IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c82710013.con4(e,c,minc)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	return minc==0 and c:IsLevelAbove(5) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c82710013.op4(e,tp,eg,ep,ev,re,r,rp,c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetReset(RESET_EVENT+0xff0000)
	e1:SetValue(1800)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CHANGE_LEVEL)
	e3:SetValue(4)
	c:RegisterEffect(e3)
end
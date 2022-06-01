--몽실몽실 어택
--카드군 번호: 0xfe1
local m=112401236
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.actg)
	c:RegisterEffect(e1)
	--전투 데미지
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e2:SetRange(0x08)
	e2:SetTargetRange(1,0)
	e2:SetCondition(cm.cn1)
	c:RegisterEffect(e2)
	--직접 공격
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DIRECT_ATTACK)
	e3:SetRange(0x08)
	e3:SetTargetRange(0x04,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xfe1))
	c:RegisterEffect(e3)
	--받는 데미지가 배가 된다
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CHANGE_DAMAGE)
	e4:SetRange(0x08)
	e4:SetTargetRange(0,1)
	e4:SetCondition(cm.cn3)
	e4:SetValue(cm.va3)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e5:SetRange(0x08)
	e5:SetTargetRange(0x04,0)
	e5:SetCondition(cm.cn3)
	e5:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xfe1))
	e5:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE))
	c:RegisterEffect(e5)
	--Activate in the opponent's turn
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,1))
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_NEGATE)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_HAND+LOCATION_DECK)
	e6:SetTarget(cm.actg)
	e6:SetOperation(cm.acop)
	c:RegisterEffect(e6)
	--inactivatable
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_CANNOT_INACTIVATE)
	e7:SetRange(LOCATION_SZONE)
	e7:SetValue(cm.effectfilter)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EFFECT_CANNOT_DISEFFECT)
	c:RegisterEffect(e8)
	local e9=e7:Clone()
	e9:SetCode(EFFECT_FLAG_CANNOT_NEGATE)
	c:RegisterEffect(e9)
	local e10=e7:Clone()
	e10:SetCode(EFFECT_FLAG_CARD_TARGET)
	c:RegisterEffect(e10)
end
function cm.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:IsHasType(EFFECT_TYPE_QUICK_O) then
		Duel.SetChainLimit(aux.FALSE)
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(aux.FALSE)
	end
end
function cm.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		Duel.RaiseEvent(c,EVENT_CHAIN_SOLVED,c:GetActivateEffect(),0,tp,tp,Duel.GetCurrentChain())
	end
end
--전투 데미지
function cm.nfil0(c)
	return c:IsFaceup() and (c:GetLevel()==1 or c:GetRank()==1 or c:GetLink()==1)
end
function cm.cn1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(cm.nfil0,e:GetHandlerPlayer(),0x04,0,nil)>=1
end
--데미지가 배가 된다
function cm.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xfe1)
end
function cm.cn3(e)
	return Duel.GetMatchingGroupCount(cm.filter,e:GetHandlerPlayer(),0x0c,0x0c,nil)>=4
end
function cm.va3(e,re,val,r,rp)
	if r&REASON_EFFECT~=0 then
		local rc=re:GetHandler()
		if rc:IsSetCard(0xfe1) then
			return val*2
		end
	end
	return val
end
function cm.effectfilter(e,ct)
	local p=e:GetHandler():GetControler()
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	return p==tp and te:GetHandler():IsSetCard(0xfe1) and bit.band(loc,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_REMOVED+LOCATION_ONFIELD+LOCATION_OVERLAY)~=0
end
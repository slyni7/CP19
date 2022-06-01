--몽실몽실 메이커
local m=112401239
local cm=_G["c"..m]
function c112401239.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--book make
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetCode(EFFECT_ADD_SETCODE)
	e2:SetValue(0xfe1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e2:SetCode(EFFECT_CHANGE_LEVEL)
	e2:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e2:SetCode(EFFECT_CHANGE_RANK)
	e2:SetValue(1)
	c:RegisterEffect(e4)
	local e5=e2:Clone()
	e2:SetCode(EFFECT_CHANGE_LINK)
	e2:SetValue(1)
	c:RegisterEffect(e5)
	local e6=e2:Clone()
	e2:SetCode(EFFECT_SET_ATTACK_FINAL)
	e2:SetValue(0)
	c:RegisterEffect(e6)
	local e7=e2:Clone()
	e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
	e2:SetValue(0)
	c:RegisterEffect(e7)
	--DAMAGE
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(112401239,1))
	e8:SetCategory(CATEGORY_DAMAGE)
	e8:SetRange(LOCATION_FZONE)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e8:SetCode(EVENT_BATTLE_START)
	e8:SetCondition(cm.damcon)
	e8:SetOperation(cm.damop)
	c:RegisterEffect(e8)
	--Activate in the opponent's turn
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(m,1))
	e9:SetType(EFFECT_TYPE_QUICK_O)
	e9:SetCode(EVENT_FREE_CHAIN)
	e9:SetRange(LOCATION_HAND+LOCATION_DECK)
	e9:SetTarget(cm.actg)
	e9:SetOperation(cm.acop)
	c:RegisterEffect(e9)
	--adjust
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e10:SetCode(EVENT_ADJUST)
	e10:SetRange(LOCATION_FZONE)
	e10:SetOperation(cm.adjustop)
	c:RegisterEffect(e10)
	--cannot activate
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_FIELD)
	e11:SetCode(EFFECT_CANNOT_ACTIVATE)
	e11:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e11:SetRange(LOCATION_FZONE)
	e11:SetTargetRange(1,1)
	e11:SetLabel(0)
	e11:SetValue(cm.actlimit)
	c:RegisterEffect(e11)
	e10:SetLabelObject(e11)
end
function cm.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttackTarget()==nil
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
   local a=Duel.GetAttacker()
   local p=1-a:GetControler()
   Duel.Damage(p,a:GetBaseAttack(),REASON_EFFECT)
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
		Duel.MoveToField(c,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		Duel.RaiseEvent(c,EVENT_CHAIN_SOLVED,c:GetActivateEffect(),0,tp,tp,Duel.GetCurrentChain())
	end
end
function cm.actlimit(e,te,tp)
	if not te:IsHasType(EFFECT_TYPE_ACTIVATE) or not te:IsActiveType(TYPE_SPELL) then return false end
	if tp==e:GetHandlerPlayer() then return e:GetLabel()==1
	else return e:GetLabel()==2 end
end
function cm.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER)
end
function cm.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local b2=Duel.IsExistingMatchingCard(cm.filter,tp,0,LOCATION_MZONE,1,nil)
	local te=e:GetLabelObject()
	if not b2 then te:SetLabel(2)
	else te:SetLabel(0) end
end
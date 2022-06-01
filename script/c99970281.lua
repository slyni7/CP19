--VIRTUAL YOUTUBER: KIZUNA AI
local m=99970281
local cm=_G["c"..m]
function cm.initial_effect(c)

	--소환 제약
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.FALSE)
	c:RegisterEffect(e0)
	
	--소환 조건
	local evtuber=Effect.CreateEffect(c)
	evtuber:SetType(EFFECT_TYPE_FIELD)
	evtuber:SetCode(EFFECT_SPSUMMON_PROC)
	evtuber:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	evtuber:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	evtuber:SetCondition(cm.spcon)
	evtuber:SetOperation(cm.spop)
	evtuber:SetCountLimit(1,m)
	c:RegisterEffect(evtuber)

	--효과 내성
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.immcon)
	e1:SetValue(cm.efilter)
	c:RegisterEffect(e1)
	
	--무효 + 제외
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_ACTIVATING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(cm.disop)
	c:RegisterEffect(e2)
	
	--강제 회수
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_ADJUST)
	e3:SetCondition(cm.tdcon)
	e3:SetOperation(cm.tdop)
	c:RegisterEffect(e3)

	--회수
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetTarget(cm.tg)
	e4:SetOperation(cm.op)
	c:RegisterEffect(e4)
	
end

--소환 조건
function cm.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.GetFieldGroupCount(c:GetControler(),LOCATION_ONFIELD,0)==0
		and	Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_ONFIELD)<=4
		and	Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_ONFIELD)>0
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_DECK,0,3,nil)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<3 then return end
    local g=Duel.GetDecktopGroup(tp,3)
    Duel.DisableShuffleCheck()
    Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end

--효과 내성
function cm.immfilter(c)
	return c:IsFacedown()
end
function cm.immcon(e,c)
	return Duel.IsExistingMatchingCard(cm.immfilter,e:GetHandler():GetControler(),LOCATION_REMOVED,LOCATION_REMOVED,1,nil)
end
function cm.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end

--무효 + 제외
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if rc:IsSetCard(0xe05) or not rc:IsType(TYPE_SPELL) or re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	if Duel.NegateActivation(ev)~=0 and rc:IsRelateToEffect(re) then
		Duel.Remove(rc,POS_FACEDOWN,REASON_EFFECT)
	end
end

--강제 회수
function cm.tdcon(e,c)
	return not Duel.IsExistingMatchingCard(cm.immfilter,e:GetHandler():GetControler(),LOCATION_REMOVED,LOCATION_REMOVED,1,nil)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,e:GetHandler():GetCode())
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
end

--회수
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and cm.immfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.immfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
	local g=Duel.SelectTarget(tp,cm.immfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=tg:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_RETURN)
		local tc=sg:GetFirst()
		if tc:IsType(TYPE_MONSTER) then
			Duel.Recover(tp,tc:GetAttack(),REASON_EFFECT)
		end
	end
end

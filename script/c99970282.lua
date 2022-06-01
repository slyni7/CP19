--VIRTUAL YOUTUBER: KAGUYA LUNA
local m=99970282
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
	evtuber:SetRange(LOCATION_HAND)
	evtuber:SetCondition(cm.spcon)
	evtuber:SetOperation(cm.spop)
	c:RegisterEffect(evtuber)
	
	--효과 내성
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(cm.efilter)
	c:RegisterEffect(e1)
	
	--수비력 증가
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(cm.defval)
	c:RegisterEffect(e2)
	
	--패 공개 + 효과 발동 불가
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_PUBLIC)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,1)
	e4:SetValue(cm.aclimit)
	c:RegisterEffect(e4)
	
	--수비 공격
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,0))
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetCost(YuL.discard(1,1))
	e6:SetOperation(cm.datop)
	c:RegisterEffect(e6)
	
	--상대가 처음으로 발동한 카드 종류 체크
	if not cm.global_check then
		cm.global_check={}
		cm[0]=0
		cm[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(cm.clear)
		Duel.RegisterEffect(ge2,0)
	end
end

--상대가 처음으로 발동한 카드 종류 체크
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	if cm[rp]==0 then
		cm[rp]=re:GetActiveType()&0x7
	end
end
function cm.clear(e,tp,eg,ep,ev,re,r,rp)
	cm[0]=0
	cm[1]=0
end

--소환 조건
function cm.spcfilter(c)
	return not c:IsPublic()
end
function cm.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.GetFieldGroupCount(c:GetControler(),LOCATION_HAND,0)>=5
		and Duel.IsExistingMatchingCard(cm.spcfilter,c:GetControler(),LOCATION_HAND,0,4,e:GetHandler())
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	if not Duel.IsExistingMatchingCard(cm.spcfilter,tp,LOCATION_HAND,0,4,e:GetHandler()) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,cm.spcfilter,tp,LOCATION_HAND,0,4,4,e:GetHandler())
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end

--효과 내성
function cm.efilter(e,te)
	local tp=e:GetOwnerPlayer()
	return te:GetHandlerPlayer()~=tp and cm[1-tp]>0 and te:IsActiveType(cm[1-tp])
end

--수비력 증가
function cm.deffilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsPublic()
end
function cm.defval(e,c)
	return Duel.GetMatchingGroupCount(cm.deffilter,c:GetControler(),LOCATION_HAND,LOCATION_HAND,nil)*600
end

--발동 불가
function cm.xfilter(c)
	return c:IsPublic() and c:IsType(TYPE_MONSTER) and not c:IsSetCard(0xe05)
end
function cm.aclimit(e,re,tp)
	local rc=re:GetHandler()
	local rp=rc:GetControler()
	if Duel.GetMatchingGroupCount(cm.xfilter,rp,LOCATION_HAND,0,nil)>0 then
		local g=Duel.GetMatchingGroup(cm.xfilter,rp,LOCATION_HAND,0,nil)
		local tg=g:GetMinGroup(Card.GetAttack)
		return tg:IsContains(rc) and re:IsActiveType(TYPE_MONSTER) and not rc:IsImmuneToEffect(e)
	else
		return false
	end
end

--수비 공격
function cm.datop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DEFENSE_ATTACK)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end

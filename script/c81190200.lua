--IJN(사쿠라 엠파이어) 쇼카쿠
--카드군 번호: 0xcb6
local m=81190200
local cm=_G["c"..m]
function cm.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,true,true,aux.FilterBoolFunction(Card.IsFusionSetCard,0xcb6),aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_FIRE))

	--효과 내성
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.cn1)
	e1:SetValue(aux.indoval)
	c:RegisterEffect(e1)
	
	--내성 부여
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.cn2)
	e2:SetTarget(cm.tg2)
	e2:SetValue(cm.va2)
	c:RegisterEffect(e2)
	local g=Group.CreateGroup()
	g:KeepAlive()
	e2:SetLabelObject(g)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(cm.va3)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	
	--스탯
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_BATTLED)
	e4:SetCountLimit(1)
	e4:SetCondition(cm.cn4)
	e4:SetTarget(cm.tg4)
	e4:SetOperation(cm.op4)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetLabelObject(e4)
	c:RegisterEffect(e5)
end

--효과 파괴내성
function cm.cn1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end

--내성 부여
function cm.count(c)
	return c:IsType(TYPE_SPIRIT) and c:IsSetCard(0xcb6)
end
function cm.va3(e,c)
	e:GetLabelObject():SetLabel(c:GetMaterial():FilterCount(cm.count,nil))
end

function cm.cn2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabel()>0
end
function cm.tfil0(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
	and c:IsType(TYPE_FUSION) and c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:GetFlagEffect(m)==0
	and not c:IsCode(m)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return eg:IsExists(cm.tfil0,1,nil,tp)
	end
	local g=eg:Filter(cm.tfil0,nil,tp)
	local tc=g:GetFirst()
	while tc do
		tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,0))
		tc=g:GetNext()
	end
	e:GetLabelObject():Clear()
	e:GetLabelObject():Merge(g)
	return true
end
function cm.va2(e,c)
	local g=e:GetLabelObject()
	return g:IsContains(c)
end

--스탯
function cm.cn4(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabel()>0
end
function cm.tfil1(c)
	return c:IsFaceup() and c:IsType(TYPE_FUSION)
end
function cm.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.tfil1,tp,LOCATION_MZONE,0,1,nil)
	end
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.tfil1,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(800)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end

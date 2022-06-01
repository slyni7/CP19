--IJN(사쿠라 엠파이어) 즈이카쿠
--카드군 번호: 0xcb6
local m=81190190
local cm=_G["c"..m]
function cm.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,true,true,aux.FilterBoolFunction(Card.IsFusionSetCard,0xcb6),aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE))

	--공격력 상승
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLE_CONFIRM)
	e1:SetCondition(cm.cn1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	
	--대상 선택불가
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCondition(cm.cn2)
	e2:SetValue(cm.va2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(cm.va3)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetCondition(cm.cn4)
	e4:SetTarget(cm.tg4)
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetLabelObject(e4)
	c:RegisterEffect(e5)
	
	--퍼미션
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_TODECK)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e6:SetCode(EVENT_CHAINING)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetCondition(cm.cn6)
	e6:SetTarget(cm.tg6)
	e6:SetOperation(cm.op6)
	c:RegisterEffect(e6)
	local e7=e3:Clone()
	e7:SetLabelObject(e6)
	c:RegisterEffect(e7)
end

--공격력 상승
function cm.cn1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and bc and bc:IsRelateToBattle() and c:IsSummonType(SUMMON_TYPE_FUSION)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if c:IsFaceup() and c:IsRelateToBattle() and bc:IsRelateToBattle() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end

--대상 선택불가
function cm.count(c)
	return c:IsType(TYPE_SPIRIT) and c:IsSetCard(0xcb6)
end
function cm.va3(e,c)
	e:GetLabelObject():SetLabel(c:GetMaterial():FilterCount(cm.count,nil))
end

function cm.cn2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabel()>0
end
function cm.va2(e,c)
	return c:IsFaceup() and c:IsType(TYPE_FUSION) and not c:IsCode(m)
end
function cm.cn4(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabel()>0
end
function cm.tg4(e,c)
	return c:IsType(TYPE_FUSION) and not c:IsCode(m)
end

--퍼미션
function cm.cn6(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ep~=tp and Duel.IsChainNegatable(ev) and ph>PHASE_MAIN1 and ph<PHASE_MAIN2
	and e:GetLabel()>0
end
function cm.tfil0(c)
	return c:IsAbleToDeck() and c:IsType(TYPE_SPIRIT) and c:IsFaceup()
end
function cm.tg6(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.tfil0,tp,0x20,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,0x20)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function cm.op6(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)~=0 then
		local g=Duel.GetMatchingGroup(cm.tfil0,tp,0x20,0,nil)
		if #g>0 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local sg=g:Select(tp,1,1,nil)
			Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
		end
	end
end

--HMS(로열 네이비) 아크 로열
function c81200120.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddSynchroMixProcedure(c,c81200120.mat,nil,nil,aux.NonTuner(Card.IsSetCard,0xcb7),1,99)
	
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81200120,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,81200120)
	e1:SetCondition(c81200120.cn1)
	e1:SetTarget(c81200120.tg1)
	e1:SetOperation(c81200120.op1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c81200120.cn2)
	c:RegisterEffect(e2)
	
	--material
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_CONFIRM)
	e3:SetCondition(c81200120.cn3)
	e3:SetOperation(c81200120.op3)
	c:RegisterEffect(e3)
	
end

--material
function c81200120.mat(c)
	return c:IsType(TYPE_TUNER) or c:IsCode(81200020)
end

--remove
function c81200120.cn1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c81200120.cfilter(c,tp)
	return c:GetSummonPlayer()==tp and c:IsPreviousLocation(LOCATION_EXTRA)
end
function c81200120.cn2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c81200120.cfilter,1,nil,1-tp)
end

function c81200120.filter1(c)
	return c:IsAbleToRemove() and c:IsType(TYPE_MONSTER)
end
function c81200120.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81200120.filter1,tp,0,0x1c,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,0x1c)
end
function c81200120.op1(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c81200120.filter1,tp,0,LOCATION_MZONE,nil)
	local g2=Duel.GetMatchingGroup(c81200120.filter1,tp,0,LOCATION_GRAVE,nil)
	local sg=Group.CreateGroup()
	if g1:GetCount()>0 and ( g2:GetCount()>0 or Duel.SelectYesNo(tp,aux.Stringid(81200120,1)) ) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.HintSelection(sg1)
		sg:Merge(sg1)
	end
	if g2:GetCount()>0 and ( sg:GetCount()==0 or Duel.SelectYesNo(tp,aux.Stringid(81200120,2)) ) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg2=g2:Select(tp,1,1,nil)
		Duel.HintSelection(sg2)
		sg:Merge(sg2)
	end
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
end

--atk
function c81200120.cn3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and bc and bc:IsFaceup() and bc:IsType(TYPE_EFFECT) and not bc:IsType(TYPE_SPIRIT)
end
function c81200120.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if c:IsFaceup() and c:IsRelateToBattle() and bc:IsFaceup() and bc:IsRelateToBattle() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-1000)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE_CAL)
		bc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		bc:RegisterEffect(e2)
		if bc:IsType(TYPE_EFFECT) and not bc:IsDisabled() then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE)
			e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE_CAL)
			bc:RegisterEffect(e3)
			local e4=e3:Clone()
			e4:SetCode(EFFECT_DISABLE_EFFECT)
			bc:RegisterEffect(e4)
		end
	end
end



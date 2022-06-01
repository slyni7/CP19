--아더월드의 역병의사
function c76859825.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,3,c76859825.lcheck)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCondition(c76859825.con1)
	e1:SetOperation(c76859825.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,76859825)
	e2:SetTarget(c76859825.tar2)
	e2:SetOperation(c76859825.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c76859825.tar3)
	e3:SetValue(-300)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetCategory(CATEGORY_DISABLE)
	e5:SetCountLimit(1,76859825)
	e5:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
	e5:SetCondition(c76859825.con5)
	e5:SetTarget(c76859825.tar5)
	e5:SetOperation(c76859825.op5)
	c:RegisterEffect(e5)
end
function c76859825.lfil1(c)
	return c:IsLinkSetCard(0x2cb) and c:IsAttribute(ATTRIBUTE_DARK)
end

function c76859825.lcheck(g,lc)
	return g:IsExists(c76859825.lfil1,1,nil)
end


function c76859825.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(c:GetSummonType(),SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end
function c76859825.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(c76859825.tar11)
	Duel.RegisterEffect(e1,tp)
end
function c76859825.tar11(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsCode(76859825) and bit.band(sumtype,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end
function c76859825.tfil2(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:GetSummonPlayer()~=tp and c:IsControler(1-tp)
end
function c76859825.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local seq=c:GetSequence()
	if seq>4 then
		seq=seq*2-9
	end
	if chk==0 then
		return eg:FilterCount(c76859825.tfil2,nil,tp)==1 and Duel.CheckLocation(1-tp,LOCATION_MZONE,4-seq)
	end
	local g=eg:Filter(c76859825.tfil2,nil,tp)
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c76859825.ofil2(c,e,tp)
	return c:IsLocation(LOCATION_MZONE) and c:GetSummonPlayer()~=tp and c:IsControler(1-tp) and c:IsRelateToEffect(e)
end
function c76859825.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	local seq=c:GetSequence()
	if seq>4 then
		seq=seq*2-9
	end
	local g=eg:Filter(c76859825.ofil2,nil,e,tp)
	if g:GetCount()==1 and Duel.CheckLocation(1-tp,LOCATION_MZONE,4-seq) then
		local tc=g:GetFirst()
		Duel.MoveSequence(tc,4-seq)
	end
end
function c76859825.tar3(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c) and c:IsControler(1-e:GetHandlerPlayer())
end
function c76859825.con5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLinkState()
end
function c76859825.tfil5(c)
	return c:IsFaceup() and not c:IsDisabled()
end
function c76859825.tar5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c76859825.tfil5,tp,0,LOCATION_MZONE,1,nil)
	end
	local g=Duel.GetMatchingGroup(c76859825.tfil5,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c76859825.op5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,c76859825.tfil5,tp,0,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end
function c76859825.sumlimit(e,c)
	return c:IsType(TYPE_LINK)
end
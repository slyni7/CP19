--네파시아 타천사
function c47550011.initial_effect(c)

	local e99=Effect.CreateEffect(c)
	e99:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e99:SetCode(EVENT_SPSUMMON_SUCCESS)
	e99:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e99:SetCondition(c47550011.con1)
	e99:SetOperation(c47550011.op1)
	c:RegisterEffect(e99)

	--link summon
	aux.AddLinkProcedure(c,nil,2,3,c47550011.lcheck)
	c:EnableReviveLimit()

	--attribute dark
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e0:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e0:SetCondition(c47550011.eqcon)
	e0:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e0)

	--light:indestructionbyeffect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCondition(c47550011.ndcon)
	e1:SetTarget(c47550011.ndtar)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(300)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)   

	--dark:remove
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1)
	e4:SetCost(c47550011.cacost)
	e4:SetCondition(c47550011.cacon)
	e4:SetTarget(c47550011.catg)
	e4:SetOperation(c47550011.caop)
	c:RegisterEffect(e4)

end

function c47550011.eqcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)<3
end

function c47550011.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x487)
end

function c47550011.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(c:GetSummonType(),SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end
function c47550011.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(c47550011.tar11)
	Duel.RegisterEffect(e1,tp)
end
function c47550011.tar11(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsCode(47550011) and bit.band(sumtype,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end


function c47550011.ndcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c47550011.ndtar(e,c)
	return (c:IsLinkState() and c:IsSetCard(0x487)) or c==e:GetHandler()
end



function c47550011.cfilter(c,g)
	return not c:IsStatus(STATUS_BATTLE_DESTROYED) and g:IsContains(c) and c:IsSetCard(0x487)
end
function c47550011.cacost(e,tp,eg,ep,ev,re,r,rp,chk)
	local lg=e:GetHandler():GetLinkedGroup()
	if chk==0 then return Duel.CheckReleaseGroup(tp,c47550011.cfilter,1,nil,lg) end
	local g=Duel.SelectReleaseGroup(tp,c47550011.cfilter,1,1,nil,lg)
	Duel.Release(g,REASON_COST)
end
function c47550011.cacon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsAttribute(ATTRIBUTE_DARK)
end


function c47550011.filter(c)
	return c:IsAbleToRemove()
end
function c47550011.catg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_GRAVE) and c47550011.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c47550011.filter,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c47550011.filter,tp,0,LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end

function c47550011.caop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_REMOVED) then
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
		e1:SetTarget(c47550011.distg)
		e1:SetLabel(tc:GetOriginalCode())
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetCondition(c47550011.discon)
		e2:SetOperation(c47550011.disop)
		e2:SetLabel(tc:GetOriginalCode())
		e2:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e2,tp)
	end
end

function c47550011.distg(e,c)
	local code=e:GetLabel()
	local code1,code2=c:GetOriginalCodeRule()
	return code1==code or code2==code
end
function c47550011.discon(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabel()
	local code1,code2=re:GetHandler():GetOriginalCodeRule()
	return code1==code or code2==code
end
function c47550011.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end









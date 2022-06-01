--QC Gluttony
function c81140070.initial_effect(c)

	c:EnableReviveLimit()
	
	--summon limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c81140070.cn)
	e1:SetTarget(c81140070.tg)
	e1:SetTargetRange(0,1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(c81140070.val)
	c:RegisterEffect(e2)
	
	--immune effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c81140070.val2)
	c:RegisterEffect(e3)
	
	--damage & draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(81140070,0))
	e4:SetCategory(CATEGORY_DAMAGE+CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c81140070.vcn)
	e4:SetTarget(c81140070.vtg)
	e4:SetOperation(c81140070.vop)
	c:RegisterEffect(e4)
end

--summon
function c81140070.cn(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL) and e:GetHandler():GetFlagEffect(81140070)~=0
end
function c81140070.tg(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLevelAbove(5) and c:IsLocation(LOCATION_EXTRA+LOCATION_HAND)
end

function c81140070.val(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsSetCard,1,nil,0xcb1) then
		c:RegisterFlagEffect(81140070,RESET_EVENT+0x6e0000,0,1)
	end
end

--immune
function c81140070.val2(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:IsActivated()
	and (te:GetOwner():IsType(TYPE_LINK) or te:GetOwner():IsType(TYPE_XYZ))
end

--draw
function c81140070.vcn(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end
function c81140070.vtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsPlayerCanDraw(tp,1)
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,1000)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c81140070.vop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Damage(p,d,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end

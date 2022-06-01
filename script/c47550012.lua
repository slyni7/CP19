--네파시아 타락자
function c47550012.initial_effect(c)
	local e99=Effect.CreateEffect(c)
	e99:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e99:SetCode(EVENT_SPSUMMON_SUCCESS)
	e99:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e99:SetCondition(c47550012.con1)
	e99:SetOperation(c47550012.op1)
	c:RegisterEffect(e99)

	--link summon
	aux.AddLinkProcedure(c,nil,2,3,c47550012.lcheck)
	c:EnableReviveLimit()

	--attribute dark
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e0:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e0:SetCondition(c47550012.eqcon)
	e0:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e0)

	--light:cannotrelease
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetCode(EFFECT_UNRELEASABLE_SUM)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCondition(c47550012.ndcon)
	e1:SetTarget(c47550012.ndtar)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e2)

	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCondition(c47550012.ndcon)
	e3:SetTarget(c47550012.ndtar)
	e3:SetValue(300)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)	


	--dark:takecontrol
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_CONTROL)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCountLimit(1)
	e5:SetCost(c47550012.ctcost)
	e5:SetCondition(c47550012.ctcon)
	e5:SetTarget(c47550012.cttg)
	e5:SetOperation(c47550012.ctop)
	c:RegisterEffect(e5)
end

function c47550012.eqcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)<3
end

function c47550012.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x487)
end

function c47550012.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(c:GetSummonType(),SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end
function c47550012.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(c47550012.tar11)
	Duel.RegisterEffect(e1,tp)
end
function c47550012.tar11(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsCode(47550012) and bit.band(sumtype,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end


function c47550012.ndcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c47550012.ndtar(e,c)
	return (c:IsLinkState() and c:IsSetCard(0x487)) or c==e:GetHandler()
end


function c47550012.cfilter(c,g)
	return not c:IsStatus(STATUS_BATTLE_DESTROYED) and g:IsContains(c) and c:IsSetCard(0x487)
end
function c47550012.ctcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local lg=e:GetHandler():GetLinkedGroup()
	if chk==0 then return Duel.CheckReleaseGroup(tp,c47550012.cfilter,1,nil,lg) end
	local g=Duel.SelectReleaseGroup(tp,c47550012.cfilter,1,1,nil,lg)
	Duel.Release(g,REASON_COST)
end

function c47550012.ctcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsAttribute(ATTRIBUTE_DARK)
end

function c47550012.ctfilter(c)
	return c:IsControlerCanBeChanged() and c:IsFaceup()
end
function c47550012.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c47550012.ctfilter.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c47550012.ctfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local 
	g=Duel.SelectTarget(tp,c47550012.ctfilter,tp,0,LOCATION_MZONE,1,1,nil)

	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end

function c47550012.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.GetControl(tc,tp,PHASE_END,1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_SETCODE)
		e1:SetValue(0x487)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
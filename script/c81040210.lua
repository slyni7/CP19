--Torpedo

function c81040210.initial_effect(c)

	--P
	aux.EnablePendulumAttribute(c)

	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,81040210)
	e2:SetCondition(c81040210.pscn)
	e2:SetTarget(c81040210.pstg)
	e2:SetOperation(c81040210.psop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTargetRange(1,0)
	e3:SetTarget(c81040210.pslm)
	c:RegisterEffect(e3)
	
	--M
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetTarget(c81040210.dstg)
	e4:SetOperation(c81040210.dsop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_DAMAGE)
	e5:SetRange(LOCATION_HAND)
	e5:SetCountLimit(1,81040211)
	e5:SetCondition(c81040210.spcn)
	e5:SetTarget(c81040210.sptg)
	e5:SetOperation(c81040210.spop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetRange(LOCATION_EXTRA)
	c:RegisterEffect(e6)
	
end

--summon limit
function c81040210.pslm(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0xca4)
end

--pendulum effect
function c81040210.pscn(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(nil,tp,LOCATION_PZONE,0,1,e:GetHandler())
end
function c81040210.filter(c)
	return c:IsSetCard(0xca4) and c:IsType(TYPE_PENDULUM) and not c:IsCode(81040210) and not c:IsForbidden()
end
function c81040210.pstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return e:GetHandler():IsDestructable()
		and Duel.IsExistingMatchingCard(c81040210.filter,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c81040210.psop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	if Duel.Destroy(c,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,c81040210.filter,tp,LOCATION_DECK,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
	end
end
	
--destroy
function c81040210.dstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsFaceup() and chkc:IsDestructable() and chkc:IsOnField()
	end
	if chk==0 then
		return Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_MZONE,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end

function c81040210.dsop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end

--sp
function c81040210.spcn(e,tp,eg,ep,ev,re,r,rp)
	return ( bit.band(r,REASON_BATTLE)>0 or bit.band(r,REASON_EFFECT)~=0 and re:GetHandler():IsSetCard(0xca4) )
	and ep==tp
end

function c81040210.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if c:IsLocation(LOCATION_EXTRA) then ft=Duel.GetLocationCountFromEx(tp,tp,nil,c) end
	if chk==0 then
		return ft>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,800)
end

function c81040210.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
	or ( c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)<=0 ) then
		return
	end
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)~=0 then
		Duel.Recover(tp,800,REASON_EFFECT)
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetReset(RESET_EVENT+0x47e0000)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1,true)
	end
end

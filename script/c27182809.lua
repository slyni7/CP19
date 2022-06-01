--스크립트리니티-리버티
function c27182809.initial_effect(c)
	c:EnableReviveLimit()
	c:SetUniqueOnField(1,0,27182809)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c27182809.val1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c27182809.con2)
	e2:SetOperation(c27182809.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(1,0)
	e3:SetTarget(c27182809.tg3)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_ADJUST)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCondition(c27182809.con5)
	e5:SetOperation(c27182809.op5)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_LEAVE_FIELD)
	e6:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e6:SetCategory(CATEGORY_TOHAND)
	e6:SetTarget(c27182809.tg6)
	e6:SetOperation(c27182809.op6)
	c:RegisterEffect(e6)
end
function c27182809.val1(e,se,sp,st)
	local c=e:GetHandler()
	return c:GetLocation()~=LOCATION_EXTRA
end
function c27182809.nfilter2(c,fc)
	return c:IsSetCard(0x2c2)
		and c:IsCanBeFusionMaterial(fc)
end
function c27182809.nfilter21(c,tp,g)
	return g:IsExists(c27182809.nfilter22,1,c,tp,c)
end
function c27182809.nfilter22(c,tp,mc)
	return Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,mc))>0
end
function c27182809.con2(e,c)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	if Duel.GetLocationCountFromEx then
		local rg=Duel.GetReleaseGroup(tp,true):Filter(c27182809.nfilter2,nil,c)
		return rg:IsExists(c27182809.nfilter21,1,nil,tp,rg)
	else
		return Duel.CheckReleaseGroupEx(tp,c27182809.nfilter2,2,nil,c)
			and (Duel.GetLocationCount(tp,LOCATION_MZONE)>0
				or Duel.CheckReleaseGroup(tp,c27182809.nfilter2,1,nil,c))
	end
end
function c27182809.op2(e,tp,eg,ep,ev,re,r,rp,c)
	if Duel.GetLocationCountFromEx then
		local rg=Duel.GetReleaseGroup(tp,true):Filter(c27182809.nfilter2,nil,c)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g1=rg:FilterSelect(tp,c27182809.nfilter21,1,1,nil,tp,rg)
		local mc=g1:GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g2=rg:FilterSelect(tp,c27182809.nfilter22,1,1,mc,tp,mc)
		g1:Merge(g2)
		c:SetMaterial(g1)
		Duel.Release(g1,REASON_COST+REASON_FUSION+REASON_MATERIAL)
	else
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then
			local g1=Duel.SelectReleaseGroup(tp,c27182809.nfilter2,1,1,nil,c)
			local g2=Duel.SelectReleaseGroupEx(tp,c27182809.nfilter2,1,1,g1:GetFirst(),c)
			g1:Merge(g2)
			Duel.Release(g1,REASON_COST+REASON_FUSION+REASON_MATERIAL)
		else
			local g=Duel.SelectReleaseGroupEx(tp,c27182809.nfilter2,2,2,nil,c)
			Duel.Release(g,REASON_COST+REASON_FUSION+REASON_MATERIAL)
		end
	end
end
function c27182809.tg3(e,c)
	return not c:IsSetCard(0x2c2)
end
function c27182809.nfilter5(c)
	return c:IsCode(27182801)
end
function c27182809.con5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c27182809.nfilter5,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
		and c:GetFlagEffect(27182809)==0
end
function c27182809.op5(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c27182809.nfilter5,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	local tc=g:GetFirst()
	local c=e:GetHandler()
	if tc and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_CARD,0,27182809)
		Duel.MoveToField(tc,tp,tp,LOCATION_MZONE,POS_FACEUP,true)
		c:RegisterFlagEffect(27182809,RESET_EVENT+0x1fe0000,0,0)
		Duel.RaiseSingleEvent(tc,27182801,e,REASON_EFFECT,tp,tp,0)
		Duel.RaiseEvent(tc,27182801,e,REASON_EFFECT,tp,tp,0)
	end
end
function c27182809.tfilter6(c)
	return c:IsSetCard(0x2c2)
		and (c:IsFaceup()
			or c:IsLocation(LOCATION_GRAVE))
		and c:IsAbleToHand()
end
function c27182809.tg6(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(tp)
			and chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED)
			and c27182809.tfilter6(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c27182809.tfilter6,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
	end
	local g=Duel.SelectTarget(tp,c27182809.tfilter6,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c27182809.op6(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
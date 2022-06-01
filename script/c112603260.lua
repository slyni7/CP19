--매지컬 디폴트 이클립스
local m=112603260
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--MAGICAL DEFAULT
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(cm.spcon1)
	e1:SetTarget(cm.sptg1)
	e1:SetOperation(cm.spop1)
	c:RegisterEffect(e1)
	--cannot target
	local e20=Effect.CreateEffect(c)
	e20:SetType(EFFECT_TYPE_SINGLE)
	e20:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e20:SetRange(LOCATION_MZONE)
	e20:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e20:SetValue(aux.tgoval)
	c:RegisterEffect(e20)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(aux.indoval)
	c:RegisterEffect(e3)
	--destroy
	local e21=Effect.CreateEffect(c)
	e21:SetDescription(aux.Stringid(m,1))
	e21:SetCategory(CATEGORY_DESTROY)
	e21:SetType(EFFECT_TYPE_IGNITION)
	e21:SetRange(LOCATION_MZONE)
	e21:SetCountLimit(1)
	e21:SetTarget(cm.destg)
	e21:SetOperation(cm.desop)
	c:RegisterEffect(e21)
	--material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
	--special summon
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(m,3))
	e10:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e10:SetType(EFFECT_TYPE_IGNITION)
	e10:SetRange(LOCATION_MZONE)
	e10:SetCountLimit(1)
	e10:SetCost(cm.cost20)
	e10:SetTarget(cm.targe2t)
	e10:SetOperation(cm.operati2on)
	c:RegisterEffect(e10)
	--EXTRA STAGE
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(m,4))
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e0:SetProperty(EFFECT_FLAG_DELAY)
	e0:SetCode(EVENT_BATTLE_DESTROYED)
	e0:SetCountLimit(1,m+EFFECT_COUNT_CODE_DUEL)
	e0:SetCost(cm.EXcost)
	e0:SetCondition(cm.EXcon)
	e0:SetTarget(cm.EXtg)
	e0:SetOperation(cm.EXop)
	c:RegisterEffect(e0)
end

--spsummon
function cm.cfilter11(c)
	return c:IsType(TYPE_FUSION) and c:IsAbleToRemoveAsCost()
end
function cm.cfilter12(c)
	return c:IsType(TYPE_SYNCHRO) and c:IsAbleToRemoveAsCost()
end
function cm.cfilter13(c)
	return c:IsType(TYPE_XYZ) and c:IsAbleToRemoveAsCost()
end
function cm.cfilter14(c)
	return c:IsType(TYPE_PENDULUM) and c:IsAbleToRemoveAsCost()
end
function cm.spcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter11+cm.cfilter12+cm.cfilter13+cm.cfilter14,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.cm.cfilter11+cm.cfilter12+cm.cfilter13+cm.cfilter14,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.cfilter01(c)
	return c:IsFaceup() and c:IsSetCard(0xe9e) and c:IsType(TYPE_FUSION)
end
function cm.cfilter02(c)
	return c:IsFaceup() and c:IsSetCard(0xe9e) and c:IsType(TYPE_SYNCHRO)
end
function cm.cfilter03(c)
	return c:IsFaceup() and c:IsSetCard(0xe9e) and c:IsType(TYPE_XYZ)
end
function cm.cfilter04(c)
	return c:IsFaceup() and c:IsSetCard(0xe9e) and c:IsType(TYPE_PENDULUM)
end
function cm.cfilterX(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK)
end
function cm.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.cfilterX,tp,LOCATION_GRAVE,0,1,nil) and Duel.GetLP(tp)<=4000
end
function cm.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end

--destroy
function cm.rmfilter(c)
	return c:IsAbleToRemoveAsCost()
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and cm.rmfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.rmfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,cm.rmfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,tp,LOCATION_GRAVE)
	local h=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,h,1,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)>0 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
end


--material
function cm.filter(c)
	return c:IsPosition(POS_FACEUP_ATTACK) and c:IsCanOverlay()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.filter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)
		and Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,Group.FromCards(tc))
	end
end

--special summon
function cm.cost20(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.filter2(c,e,tp,zone)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function cm.targe2t(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local zone=e:GetHandler():GetLinkedZone(tp)
		return zone~=0 and Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_HAND,0,1,nil,e,tp,zone)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function cm.operati2on(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetHandler():GetLinkedZone(tp)
	if zone==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_HAND,0,1,1,nil,e,tp,zone)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone)
	end
end

--EXTRA STAGE
function cm.EXcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,e:GetHandler())
	if chk==0 then return Duel.GetFlagEffect(tp,m)==0
		and g:GetCount()==g:FilterCount(Card.IsAbleToRemoveAsCost,nil) end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SSET)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
end
function cm.EXcon(e,c)
	return Duel.GetLP(tp)<=3000
end
function cm.EXtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,m+1,0xe9e,0x5806101,3500,0,4,RACE_FAIRY+RACE_CYBERSE,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function cm.EXop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,m+1,0xe9e,0x5806101,3500,0,4,RACE_FAIRY+RACE_CYBERSE,ATTRIBUTE_LIGHT) then
		local token=Duel.CreateToken(tp,m+1)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
end
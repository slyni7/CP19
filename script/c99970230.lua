--성흔사도 <닫힌 하늘>
local m=99970230
local cm=_G["c"..m]
function cm.initial_effect(c)

	--엑시즈 소환
	RevLim(c)
	aux.AddXyzProcedure(c,aux.FBF(Card.IsSetCard,0xe00),1,2)

	--엑시즈 레벨	
	local e0=MakeEff(c,"S")
	e0:SetCode(EFFECT_XYZ_LEVEL)
	e0:SetCondition(cm.xlvcon)
	e0:SetValue(1)
	c:RegisterEffect(e0)
	
	--소재 추가
	local e1=MakeEff(c,"I","M")
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetCost(spinel.rmovcost(1))
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	
	--파괴 내성 부여
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetProperty(EFFECT_TYPE_XMATERIAL+EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(cm.reptg)
	e2:SetCondition(cm.repcon)
	c:RegisterEffect(e2)
	
end

--엑시즈 레벨	
function cm.xlvcon(e)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_LIGHT)
end

--소재 추가
function cm.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xe00) and c:IsType(TYPE_XYZ)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,0,1,nil) 
		and Duel.GetMatchingGroupCount(Card.IsSetCard,tp,LOCATION_GRAVE,0,nil,0xe00)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local g=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_GRAVE,0,nil,0xe00)
	if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) and #g>0 then
		local sg=g:Select(tp,1,1,nil)
		Duel.Overlay(tc,sg)
	end
end

--파괴 내성 부여
function cm.repcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSetCard(0xe00) and c:IsType(TYPE_XYZ)
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
		and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	if Duel.SelectEffectYesNo(tp,c,96) then
		c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
		return true
	else return false end
end

--파이어워크 위렌
local m=99970165
local cm=_G["c"..m]
function cm.initial_effect(c)
	
	--융합 소환
	RevLim(c)
	aux.AddFusionProcFunRep(c,cm.ffilter,2,true)
	
		--융합 제한
		YuL.ExLimit(c)
		YuL.NoMat(c,"F")
		
		--융합 소재
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SPSUMMON_PROC)
		e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
		e1:SetRange(LOCATION_EXTRA)
		e1:SetCondition(cm.sprcon)
		e1:SetOperation(cm.sprop)
		c:RegisterEffect(e1)

	--데미지
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,m)
	e2:SetCost(YuL.discard(1,1))
	e2:SetTarget(YuL.damtg(1,700))
	e2:SetOperation(YuL.damop)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	c:RegisterEffect(e2)
	
	--샐비지
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetCondition(cm.thcon)
	e3:SetTarget(cm.thtg)
	e3:SetOperation(cm.thop)
	c:RegisterEffect(e3)
	
	--파괴 보호
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(cm.desreptg)
	e4:SetOperation(cm.desrepop)
	c:RegisterEffect(e4)

end

cm.material_setcode=0xd3d

--융합 소환
function cm.ffilter(c)
	return c:IsFusionSetCard(0xd3d)
end
function cm.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(cm.sprfilter1,tp,LOCATION_MZONE,0,1,nil,tp,c)
end
function cm.sprfilter1(c,tp,fc)
	return c:IsFusionSetCard(0xd3d) and c:IsAbleToGraveAsCost() and c:IsCanBeFusionMaterial(fc)
		and Duel.IsExistingMatchingCard(cm.sprfilter2,tp,LOCATION_MZONE,0,1,c,tp,fc,c)
end
function cm.sprfilter2(c,tp,fc,mc)
	return c:IsFusionSetCard(0xd3d) and c:IsAbleToGraveAsCost() and c:IsCanBeFusionMaterial(fc)
		and Duel.GetLocationCountFromEx(tp,tp,g)>0
end
function cm.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,cm.sprfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(tp,cm.sprfilter2,tp,LOCATION_MZONE,0,1,1,g1:GetFirst(),tp,c,g1:GetFirst())
	g1:Merge(g2)
	Duel.SendtoGrave(g1,REASON_COST)
end

--샐비지
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return r&REASON_EFFECT~=0 and ep~=tp
end
function cm.thfilter(c)
	return (c:IsSetCard(0xd3d) or c:IsCode(46130346,73134081,19523799,46918794,33767325)) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,cm.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end

--파괴 보호
function cm.desrepfilter(c)
	return c:IsCode(46130346,73134081,19523799,46918794,33767325) and c:IsAbleToDeck()
end
function cm.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE) and c:IsReason(REASON_EFFECT) 
		and Duel.IsExistingMatchingCard(cm.desrepfilter,tp,LOCATION_GRAVE,0,1,nil) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function cm.desrepop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.desrepfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT+REASON_REPLACE)
end

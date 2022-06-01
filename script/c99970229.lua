--성흔사도 <잃지 않은 믿음>
local m=99970229
local cm=_G["c"..m]
function cm.initial_effect(c)

	--특수 소환 + 묘지
	local e1=MakeEff(c,"Qo","HG")
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCL(1,m)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	
	--컨트롤
	local e2=MakeEff(c,"Qo","M")
	e2:SetCategory(CATEGORY_CONTROL)
	e2:SetProperty(EFFECT_TYPE_XMATERIAL)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(Duel.IsMainPhase)
	e2:SetCL(1)
	WriteEff(e2,2,"CTO")
	c:RegisterEffect(e2)
	
end

--특수 소환 + 묘지
function cm.tar1fil(c)
	return c:IsFaceup() and c:IsSetCard(0xe00) and c:IsAttribute(ATT_D)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and cm.tar1fil(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingTarget(cm.tar1fil,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,cm.tar1fil,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0
		and tc and tc:IsRelateToEffect(e) then
		Duel.BreakEffect()
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end

--컨트롤
function cm.cfil2(c)
	return c:IsAbleToDeckAsCost() and c:IsSetCard(0xe00) and c:IsAttribute(ATT_L)
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetMatchingGroup(cm.cfil2,tp,LSTN("G"),0,nil)
	mg:Merge(e:GetHandler():GetOverlayGroup():Filter(cm.cfil2,nil))
	if chk==0 then return #mg>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=mg:Select(tp,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(Card.IsAbleToChangeControler,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToChangeControler,tp,0,LOCATION_MZONE,1,1,nil)
	if #g>0 then
		Duel.GetControl(g,tp)
	end
end

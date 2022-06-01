--찬란하게 빛나는 보석의 파편
local m=99000338
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.tdtg)
	e2:SetOperation(cm.tdop)
	c:RegisterEffect(e2)
end
function cm.spfilter(c)
	return c:IsAttackAbove(1) and c:IsDestructable()
end
function cm.fselect(g,tp,atk)
	Duel.SetSelectedCard(g)
	return g:CheckWithSumGreater(Card.GetAttack,atk) and aux.mzctcheck(g,tp)
end
function cm.fselect2(g,tp,atk,oc)
	Duel.SetSelectedCard(g)
	return g:CheckWithSumGreater(Card.GetAttack,atk) and Duel.GetLocationCountFromEx(tp,tp,g,oc)>0
end
function cm.filter(c,e,tp)
	if not c:IsSetCard(0x1c14) then return false end
	local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,c)
	local res=nil
	if c:IsLocation(LOCATION_HAND) or c:IsLocation(LOCATION_GRAVE) then
		if bit.band(c:GetType(),0x81)~=0x81 or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL+0xc14,tp,true,true) then return false end
		res=g:CheckSubGroup(cm.fselect,1,g:GetCount(),tp,c:GetAttack())
	elseif c:IsLocation(LOCATION_EXTRA) then
		if bit.band(c:GetType(),0x10000001)~=0x10000001 or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_ORDER+0xc14,tp,true,true) then return false end
		res=g:CheckSubGroup(cm.fselect2,1,g:GetCount(),tp,c:GetAttack(),c)
	end
	return res
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_OMATERIAL)
		and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_OMATERIAL) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=tg:GetFirst()
	if tc then
		local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,tc)
		local sg=nil
		local smtype=0xc14
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		if tc:IsLocation(LOCATION_HAND) or tc:IsLocation(LOCATION_GRAVE) then
			sg=g:SelectSubGroup(tp,cm.fselect,false,1,g:GetCount(),tp,tc:GetAttack())
			smtype=smtype+SUMMON_TYPE_RITUAL
		elseif tc:IsLocation(LOCATION_EXTRA) then
			sg=g:SelectSubGroup(tp,cm.fselect2,false,1,g:GetCount(),tp,tc:GetAttack(),tc)
			smtype=smtype+SUMMON_TYPE_ORDER
		end
		Duel.Destroy(sg,REASON_EFFECT)
		tc:SetMaterial(nil)
		Duel.SpecialSummon(tc,smtype,tp,tp,true,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function cm.tdfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xc14) and c:IsAbleToDeck()
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.tdfilter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return e:GetHandler():IsAbleToDeck()
		and Duel.IsExistingTarget(cm.tdfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,cm.tdfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		local g=Group.FromCards(c,tc)
		if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)==0 then return end
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
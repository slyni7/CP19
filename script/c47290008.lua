--타임글래스 드리머
local m=47290008
local cm=_G["c"..m]

function cm.initial_effect(c)

	--link summon
	aux.AddLinkProcedure(c,cm.matfilter,1,1)
	c:EnableReviveLimit()

	--self remove+
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.srtg)
	e1:SetOperation(cm.srop)
	c:RegisterEffect(e1)

	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCountLimit(1,m+1)
	e2:SetCost(cm.sscost)
	e2:SetTarget(cm.sstg)
	e2:SetOperation(cm.ssop)
	c:RegisterEffect(e2)

end

function cm.matfilter(c)
	return c:IsLinkSetCard(0x429) and not c:IsLinkType(TYPE_LINK)
end



function cm.ordfil(c)
	return (c:IsSpecialSummonable(SUMMON_TYPE_ORDER) 
	or c:IsSpecialSummonable(SUMMON_TYPE_ORDER_L) or c:IsSpecialSummonable(SUMMON_TYPE_ORDER_R)) 
	and c:IsSetCard(0x429)
end

function cm.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() or Duel.IsExistingMatchingCard(cm.ordfil,tp,LOCATION_EXTRA,0,1,nil) end

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)

	if Duel.IsExistingMatchingCard(cm.ordfil,tp,LOCATION_EXTRA,0,1,nil) and e:GetHandler():IsAbleToRemove() then
		op=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))
	elseif Duel.IsExistingMatchingCard(cm.ordfil,tp,LOCATION_EXTRA,0,1,nil) then
		op=Duel.SelectOption(tp,aux.Stringid(m,1)) 
	else 
		op=Duel.SelectOption(tp,aux.Stringid(m,0))
	end

	e:SetLabel(op)

	if op==0 then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
	else
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)

	end
end

function cm.srop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if c:IsRelateToEffect(e) and c:IsControler(tp) then
		if e:GetLabel()==0 then
			Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
		else
			local mg=Duel.GetMatchingGroup(cm.ordfil,tp,0x40,0,nil)
			if #mg>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sg=mg:Select(tp,1,1,nil)
				local tc=sg:GetFirst()
				Duel.SpecialSummonRule(tp,tc,tc:GetSummonType())
			end
		end
	end
end



function cm.cfilter(c)
	return c:IsSetCard(0x429) and c:IsAbleToDeckAsCost() and c:IsFaceup()
end

function cm.sscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_REMOVED,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_REMOVED,0,1,1,e:GetHandler())
	Duel.SendtoDeck(g,nil,1,REASON_COST)
end

function cm.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

function cm.ssop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
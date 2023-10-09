--[ Eternalia ¡Ä ]
local s,id=GetID()
function s.initial_effect(c)

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(s.tar1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetLabelObject(e1)
	e2:SetCondition(aux.PersistentTgCon)
	e2:SetOperation(s.perop)
	c:RegisterEffect(e2)
	
	local e4=MakeEff(c,"Qo","S")
	e4:SetD(id,0)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCL(1,id)
	WriteEff(e4,2,"CTO")
	c:RegisterEffect(e4)
	
	local e3=Effect.CreateEffect(c)
	e3:SetD(id,1)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCost(s.cost3)
	e3:SetOperation(s.op3)
	c:RegisterEffect(e3)
	
end

function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(nil,0,LOCATION_MZONE,LOCATION_MZONE,2,nil) end
	local g=Duel.SelectTarget(tp,nil,0,LOCATION_MZONE,LOCATION_MZONE,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,#g,0,0)
end	
function s.perop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	for tc in tg:Iter() do
		if c:IsRelateToEffect(re) and tc and tc:IsFaceup() and tc:IsRelateToEffect(re) then
			c:SetCardTarget(tc)
			c:CreateRelation(tc,RESET_EVENT+RESETS_STANDARD)
		end
	end
end
function s.spfil(c,e,tp)
	return c:IsSetCard(0x6d6e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function s.fil2(c,tc)
	return c:GetType()==TYPE_TRAP+TYPE_CONTINUOUS and c:IsHasCardTarget(tc)
end
function s.fil22(c,ft,tp)
	return c:IsReleasable() and (ft>0 or (c:GetSequence()<5 and c:IsControler(tp))) and (c:IsFaceup() or c:IsControler(tp))
		and Duel.IsExistingMatchingCard(s.fil2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,c)
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return Duel.IsExistingMatchingCard(s.fil22,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,ft,tp)
		and Duel.IsExistingMatchingCard(s.spfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	local g=Duel.GetMatchingGroup(s.fil22,tp,LOCATION_MZONE,LOCATION_MZONE,nil,ft,tp)
	local pg=Duel.GetMatchingGroup(s.spfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	local max=5
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then max=1 end
	local rg=aux.SelectUnselectGroup(g,e,tp,1,max,nil,1,tp,HINTMSG_RELEASE,nil,nil,true)
	if #rg>0 then
		Duel.Release(rg,REASON_COST)
		local og=Duel.GetOperatedGroup()
		og:KeepAlive()
		e:SetLabelObject(og)
	end
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local rg=e:GetLabelObject()
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,#rg,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local rg=e:GetLabelObject()
	local codes=rg:GetClass(Card.GetCode)
	local g=Duel.GetMatchingGroup(s.spfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	local ct=math.min(#rg,Duel.GetLocationCount(tp,LOCATION_MZONE))
	if #g>0 and ct>0 then
		if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ct=1 end
		local sg=aux.SelectUnselectGroup(g,e,tp,ct,ct,nil,1,tp,HINTMSG_SPSUMMON)
		if #sg>0 then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	rg:DeleteGroup()
end

function s.cfilter3(c)
	return c:GetType()==TYPE_TRAP+TYPE_CONTINUOUS and c:IsAbleToDeckAsCost()
end
function s.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter3,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,s.cfilter3,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
	e:SetLabel(g:GetFirst():GetCode())
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(e:GetLabel())
	c:RegisterEffect(e1)
end



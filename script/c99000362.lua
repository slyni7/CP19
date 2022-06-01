--FROZENORB@SPELL
local m=99000362
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,99000355)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.filter(c)
	return (c:IsSetCard(0xc23) or c:IsCode(99000355)) and c:IsFaceup()
end
function cm.spfilter(c,e,tp,code)
	return c:IsSetCard(0xc23) and not c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function cm.thfilter(c)
	return c:IsSetCard(0xc13) and c:IsType(TYPE_SPELL)
		and c:IsAbleToHand() and not c:IsCode(m)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0x1015,1)
		tc=g:GetNext()
	end
	local tc=Duel.GetFirstTarget()
	local g1=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_DECK,0,nil,e,tp,tc:GetCode())
	local g2=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil)
	local off=1
	local ops={}
	local opval={}
	ops[off]=aux.Stringid(m,0)
	opval[off-1]=0
	off=off+1
	if Duel.GetMZoneCount(tp)>0 and #g1>0 then
		ops[off]=aux.Stringid(m,1)
		opval[off-1]=1
		off=off+1
	end
	if #g2>0 then
		ops[off]=aux.Stringid(m,2)
		opval[off-1]=2
		off=off+1
	end
	local op=0
	if #ops>1 then
		op=Duel.SelectOption(tp,table.unpack(ops))
	end
	local sel=opval[op]
	if sel==1 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg1=g1:Select(tp,1,1,nil)
		local sc1=sg1:GetFirst()
		if sc1 then
			Duel.SpecialSummon(sc1,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	if sel==2 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg2=g2:Select(tp,1,1,nil)
		local sc2=sg2:GetFirst()
		if sc2 then
			Duel.SendtoHand(sc2,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sc2)
		end
	end
end
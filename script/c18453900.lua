--vingt et un ~neige~
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e1:SetCondition(s.con1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"A")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCL(1,id,EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"F","S")
	e3:SetCode(id)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTR(1,0)
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"Qo","S")
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	WriteEff(e4,4,"CTO")
	c:RegisterEffect(e4)
end
function s.nfil1(c)
	return c:IsCode(18453890) and c:IsFaceup()
end
function s.con1(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IEMCard(s.nfil1,tp,"O",0,1,nil)
end
function s.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToDeckAsCost()
	end
	Duel.SendtoDeck(c,nil,2,REASON_COST)
end
function s.filter1(c,e,tp,eg,ep,ev,re,r,rp)
	if c:IsCode(id) then
		return
	end
	local te=c:CheckActivateEffect(false,false,false)
	if c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard("vingt et un") and te then
		return true
	end
	return false
end
function s.tar4(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then
		return Duel.IsExistingTarget(s.filter1,tp,LOCATION_GRAVE,0,1,e:GetHandler(),e,tp,eg,ep,ev,re,r,rp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.filter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp)
end
function s.op4(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) then return end
	local tpe=tc:GetType()
	local te=tc:GetActivateEffect()
	local tg=te:GetTarget()
	local co=te:GetCost()
	local op=te:GetOperation()
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	Duel.ClearTargetCard()
	if (tpe&TYPE_EQUIP+TYPE_CONTINUOUS)~=0 or tc:IsHasEffect(EFFECT_REMAIN_FIELD) then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	elseif (tpe&TYPE_FIELD)~=0 then
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
	end
	tc:CreateEffectRelation(te)
	if co then co(te,tp,eg,ep,ev,re,r,rp,1) end
	if tg then
		tg(te,tp,eg,ep,ev,re,r,rp,1)
	end
	Duel.BreakEffect()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local etc=g:GetFirst()
	for etc in aux.Next(g) do
		etc:CreateEffectRelation(te)
	end
	if op then
		op(te,tp,eg,ep,ev,re,r,rp)
	end
	tc:ReleaseEffectRelation(te)
	etc=g:GetFirst()
	for etc in aux.Next(g) do
		etc:ReleaseEffectRelation(te)
	end
end

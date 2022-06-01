--[Forest]
local m=99970501
local cm=_G["c"..m]
function cm.initial_effect(c)

	--발동
	YuL.Activate(c)
	local ea=Effect.CreateEffect(c)
	ea:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	ea:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ea:SetCode(EVENT_PREDRAW)
	ea:SetRange(LOCATION_DECK)
	ea:SetCL(1,m+YuL.D)
	ea:SetCondition(cm.actcon)
	ea:SetOperation(cm.actop)
	c:RegisterEffect(ea)
	
	--효과 내성
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_FZONE)
	e1:SetValue(cm.efilter)
	c:RegisterEffect(e1)
	
	--공격력 증가
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xe0c))
	e2:SetValue(cm.atkval)
	c:RegisterEffect(e2)
	
	--서치
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PREDRAW)
	e3:SetRange(LOCATION_FZONE)
	WriteEff(e3,3,"NCTO")
	c:RegisterEffect(e3)
	
	--도와줘요 드래곤 님!
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCode(EVENT_ADJUST)
	e4:SetCondition(cm.spcon)
	e4:SetOperation(cm.spop)
	e4:SetCL(1)
	c:RegisterEffect(e4)
	
end

--발동
function cm.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=36
end
function cm.actop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler()
	if tc then
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,5)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		local tep=tc:GetControler()
		Duel.RaiseEvent(tc,EVENT_CHAIN_SOLVED,tc:GetActivateEffect(),0,tp,tp,Duel.GetCurrentChain())
	end
end

--효과 내성
function cm.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end

--공격력 증가
function cm.atkval(e,c)
	return Duel.GetCounter(e:GetHandlerPlayer(),1,0,0x1052)*100
end

--서치
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function cm.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x1052,4,REASON_COST)
		or (Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 and Duel.GetDrawCount(tp)>0) end
	if e:GetHandler():IsCanRemoveCounter(tp,0x1052,4,REASON_COST)
		and (not (Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 and Duel.GetDrawCount(tp)>0)
		or Duel.SelectYesNo(tp,aux.Stringid(m,0))) then
		e:SetLabel(1)
		e:GetHandler():RemoveCounter(tp,0x1052,4,REASON_COST)
	elseif Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 and Duel.GetDrawCount(tp)>0 then
		e:SetLabel(0)
	end
end
function cm.thfilter(c)
    return c:IsSetCard(0xe0c) and c:IsAbleToHand()
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	local dt=Duel.GetDrawCount(tp)
	if e:GetLabel()==0 and dt~=0 then
		_replace_count=0
		_replace_max=dt
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_DRAW_COUNT)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_DRAW)
		e1:SetValue(0)
		Duel.RegisterEffect(e1,tp)
	end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if e:GetLabel()==0 then _replace_count=_replace_count+1 end
	if (e:GetLabel()==1 or (e:GetLabel()==0 and _replace_count<=_replace_max)) and g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end

--도와줘요 드래곤 님!
function cm.spfilter(c,e,tp)
	return c:IsCode(99970502) and (c:IsLocation(LSTN("DHG")) or c:IsFaceup())
		and c:IsCanBeSpecialSummoned(e,0,tp,true,true,POS_FACEUP)
end
function cm.spcon(e,c)
	return Duel.GetLP(e:GetHandlerPlayer())<=2000 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LSTN("DHGR"),0,1,nil,e,tp)
		and e:GetHandler():GetCounter(0x1052)>=20
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_CARD,0,m)
	local g=Duel.GetMatchingGroup(cm.spfilter,tp,LSTN("DHGR"),0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		e:GetHandler():RemoveCounter(tp,0x1052,20,REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
	end
end

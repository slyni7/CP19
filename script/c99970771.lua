--[ Fake Spirit ]
local m=99970771
local cm=_G["c"..m]
function cm.initial_effect(c)

	--소환 조건
	RevLim(c)
	c:SetUniqueOnField(1,0,m)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(0)
	c:RegisterEffect(e0)
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetCode(EFFECT_SPSUMMON_PROC)
	e9:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e9:SetRange(LOCATION_HAND+LOCATION_DECK)
	e9:SetCondition(cm.con9)
	c:RegisterEffect(e9)
	
	--공수 증가
	local e1=MakeEff(c,"S","M")
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(cm.val1)
	e1:SetLabel(3)
	e1:SetCondition(cm.conE)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	
	--파괴
	local e3=MakeEff(c,"FC","M")
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetCode(EVENT_ADJUST)
	e3:SetCondition(cm.con3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
	
	--효과 내성
	local e4=MakeEff(c,"S","M")
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetLabel(9)
	e4:SetCondition(cm.conE)
	e4:SetValue(cm.efilter)
	c:RegisterEffect(e4)
	
	--회수 + 세트
	local e6=MakeEff(c,"FTf","M")
	e6:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e6:SetCode(EVENT_PHASE+PHASE_END)
	e6:SetCL(1)
	e6:SetCondition(YuL.turn(1))
	WriteEff(e6,6,"TO")
	c:RegisterEffect(e6)

end

--소환 조건
function cm.countfil(c)
	return c:IsFaceup() and c:IsSetCard(0x6d6d)
end
function cm.con9(e,c)
	if c==nil then return true end
	local g=Duel.GetMatchingGroup(cm.countfil,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,nil)
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and g:GetClassCount(Card.GetCode)>=3
end

--공수 증가
function cm.conE(e)
	local g=Duel.GetMatchingGroup(cm.countfil,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,e:GetHandler())
	return g:GetClassCount(Card.GetCode)>=e:GetLabel()
end
function cm.val1(e,c)
	local g=Duel.GetMatchingGroup(cm.countfil,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,e:GetHandler())
	return g:GetClassCount(Card.GetCode)*300
end

--파괴
function cm.op3fil(c,e)
	local g=Duel.GetMatchingGroup(cm.countfil,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,e:GetHandler())
	return c:IsFaceup() and c:IsAttackBelow(#g*300)
end
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.countfil,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,e:GetHandler())
	local dg=Duel.GetMatchingGroup(cm.op3fil,e:GetHandlerPlayer(),0,LOCATION_MZONE,nil,e)
	return g:GetClassCount(Card.GetCode)>=6 and #dg~=e:GetLabel()
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	for i=1,64 do
		local g=Duel.GetMatchingGroup(cm.op3fil,tp,0,LOCATION_MZONE,nil,e)
		if #g>0 then
			Duel.Hint(HINT_CARD,0,m)
			Duel.Destroy(g,REASON_EFFECT)
		else
			return
		end
	end
	e:SetLabel(Duel.GetMatchingGroup(cm.op3fil,tp,0,LOCATION_MZONE,nil,e):GetCount())
	Duel.Readjust()
end
	
--효과 내성
function cm.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end

--회수 + 세트
function cm.tar6(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.op6fil(c,e,tp)
	if not c:IsSetCard(0x6d6d) then return end
	if c:IsType(TYPE_MONSTER) then 
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
	elseif c:IsType(TYPE_SPELL+TYPE_TRAP) then 
		return (c:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0) and c:IsSSetable()
	end
	return false
end
function cm.op6(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() and c:IsAbleToDeck()
		and Duel.SendtoDeck(c,nil,2,REASON_EFFECT)~=0 then
		local tc=Duel.SelectMatchingCard(tp,cm.op6fil,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
		if tc:IsType(TYPE_MONSTER) then
			if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)>0 then
		end
		elseif tc:IsType(TYPE_SPELL+TYPE_TRAP) then
			if tc:IsType(TYPE_FIELD) then
				local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
				if fc then
					Duel.SendtoGrave(fc,REASON_RULE)
				end
			end
			if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
				Duel.SSet(tp,tc)
			end
		end
	end
end

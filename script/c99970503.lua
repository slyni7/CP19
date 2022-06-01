--[Forest]
local m=99970503
local cm=_G["c"..m]
function cm.initial_effect(c)

	--카운터
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(spinel.delay)
	WriteEff(e1,1,"TO")
	e1:SetCL(1,m)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	
	--바운스
	local e3=MakeEff(c,"FTo","M")
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetCL(1)
	WriteEff(e3,3,"TO")
	c:RegisterEffect(e3)
	
	--카운터2
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_COUNTER)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(spinel.delay)
	WriteEff(e4,4,"CTO")
	c:RegisterEffect(e4)
	
end

--카운터
function cm.ctfil(c)
	return c:IsFaceup() and c:IsSetCard(0xe0c) and c:IsType(YuL.ST)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.ctfil,tp,LOCATION_ONFIELD,0,1,nil) end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.ctfil,tp,LOCATION_ONFIELD,0,nil)
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0x1052,2,REASON_EFFECT)
		tc=g:GetNext()
	end
end

--바운스
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LSTN("M"),LSTN("M"),1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LSTN("M"),LSTN("M"),nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LSTN("M"),LSTN("M"),1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end

--카운터2
function cm.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x1052,1,REASON_COST) end
	local mx=Duel.GetCounter(tp,1,0,0x1052)
	if mx>4 then mx=4 end
	local cnt={}
	local a=1
	for i=1,mx do
		cnt[a]=i
		a=a+1
	end
	local ct=Duel.AnnounceNumber(tp,table.unpack(cnt))
	Duel.RemoveCounter(tp,1,0,0x1052,ct,REASON_COST)
	e:SetLabel(ct+1)
end
function cm.filter(c)
	return c:IsFaceup() and c:IsCode(99970501)
end
function cm.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_ONFIELD,0,1,nil) end
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_ONFIELD,0,nil)
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0x1052,e:GetLabel(),REASON_EFFECT)
		tc=g:GetNext()
	end
end

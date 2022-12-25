--칠색의 지명자
local s,id=GetID()
function s.initial_effect(c)
	Xyz.AddProcedure(c,nil,4,2)
	c:EnableReviveLimit()
	local e1=MakeEff(c,"FC","M")
	e1:SetCode(EVENT_ADJUST)
	WriteEff(e1,1,"O")
	c:RegisterEffect(e1)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,0))
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetHintTiming(TIMINGS_CHECK_MONSTER+TIMING_BATTLE_START+TIMING_MAIN_END)
	e5:SetCountLimit(1)
	e5:SetCost(s.cost)
	e5:SetTarget(s.target)
	e5:SetOperation(s.operation)
	c:RegisterEffect(e5,false,REGISTER_FLAG_DETACH_XMAT)
end
function s.ofil1(c)
	return c:IsSetCard("지명자") and c:IsMonster() and not c:IsCode(id)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local og=c:GetOverlayGroup()
	local dg=og:Filter(s.ofil1,nil)
	local dc=dg:GetFirst()
	while dc do
		c:CopyEffect(dc:GetOriginalCode(),RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0)
		dc=dg:GetNext()
	end
	if c:GetFlagEffect(id)==0 then
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,0)
		Duel.RaiseSingleEvent(c,EVENT_SPSUMMON_SUCCESS,re,r,rp,ep,ev)
	end
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function s.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard("지명자") and c:IsAbleToGraveAsCost()
		and c:CheckActivateEffect(false,true,true)~=nil
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST)
			and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,true,true)
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end

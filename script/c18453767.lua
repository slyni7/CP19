--중요한 건 꺾이지 않는 마음
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"Qo","H")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DISABLE)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
end
function s.cfil1(c)
	return c:IsRace(RACE_ZOMBIE) and c:IsDiscardable()
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsDiscardable()
	end
	local g=Group.CreateGroup()
	if true then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		g=Duel.SMCard(tp,s.cfil1,tp,"H",0,0,1,c)
	end
	g:AddCard(c)
	e:SetLabel(#g)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function s.tfil1(c)
	return (c:IsLoc("OGR") and c:IsFaceup()) or (c:IsLoc("HE") and c:IsStatus(STATUS_CHAINING))
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(s.tfil1,tp,0,"HEOGR",1,nil)
	end
	if e:GetLabel()==2 then
		e:SetCategory(CATEGORY_TODECK+CATEGORY_DISABLE)
		Duel.SOI(0,CATEGORY_TODECK,nil,1,tp,"HEOGR")
	else
		e:SetCategory(0)
	end
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,0)
	local g=Duel.SMCard(tp,s.tfil1,tp,0,"HEOGR",1,1,nil)
	local tc=g:GetFirst()
	if tc then
		local e1=MakeEff(c,"F")
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetTR(0xff,0)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabel(tc:GetOriginalCodeRule())
		e1:SetValue(s.oval11)
		Duel.RegisterEffect(e1,tp)
		if e:GetLabel()==2 then
			if Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)>0 then
				local e2=MakeEff(c,"F")
				e2:SetCode(EFFECT_DISABLE)
				e2:SetTR(0,"O")
				e2:SetTarget(s.otar12)
				e2:SetLabel(tc:GetOriginalCodeRule())
				e2:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e2,tp)
				local e3=MakeEff(c,"FC")
				e3:SetCode(EVENT_CHAIN_SOLVING)
				e3:SetCondition(s.ocon13)
				e3:SetOperation(s.oop13)
				e3:SetLabel(tc:GetOriginalCodeRule())
				e3:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e3,tp)
			end
		end
	end
end
function s.oval11(e,te)
	local code=e:GetLabel()
	local tc=te:GetHandler()
	local code1,code2=tc:GetOriginalCodeRule()
	return (code1==code or code2==code) and e:GetHandlerPlayer()~=te:GetOwnerPlayer()
end
function s.otar12(e,c)
	local code=e:GetLabel()
	local code1,code2=c:GetOriginalCodeRule()
	return code1==code or code2==code
end
function s.ocon13(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabel()
	local code1,code2=re:GetHandler():GetOriginalCodeRule()
	return (code1==code or code2==code) and e:GetHandlerPlayer()~=te:GetOwnerPlayer()
end
function s.oop13(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	Duel.NegateEffect(ev)
end

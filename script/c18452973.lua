--인티저 E
local m=18452973
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(m,ACTIVITY_SPSUMMON,cm.afil1)
end
function cm.afil1(c)
	return c:IsSetCard(0x2dd)
end
function cm.cfil1(c)
	return c:IsSetCard(0x2dd) and c:IsFaceup() and not c:IsCode(m)
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetCustomActivityCount(m,tp,ACTIVITY_SPSUMMON)<1
			and Duel.IEMCard(cm.cfil1,tp,"R",0,1,nil)
	end
	local e1=MakeEff(c,"F")
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTR(1,0)
	e1:SetTarget(cm.ctar11)
	Duel.RegisterEffect(e1,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SMCard(tp,cm.cfil1,tp,"R",0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST+REASON_RETURN)
end
function cm.ctar11(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x2dd)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GMGroup(aux.disfilter1,tp,0,"M",nil)
	if chk==0 then
		return #g>0
	end
	Duel.SOI(0,CATEGORY_DISABLE,g,1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SMCard(tp,aux.disfilter1,tp,0,"M",1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=MakeEff(c,"S")
		e1:SetCode(EFFECT_DISABLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
	end
end
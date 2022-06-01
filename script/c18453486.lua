--액세스 권한 최대
local m=18453486
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCL(1,m+EFFECT_COUNT_CODE_OATH+EFFECT_COUNT_CODE_DUEL)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(m,ACTIVITY_SPSUMMON,cm.afil1)
end
function cm.afil1(c)
	return c:GetSummonLocation()~=LOCATION_EXTRA
end
function cm.cfil1(c)
	return c:IsType(TYPE_LINK) and c:IsAbleToGraveAsCost()
end
function cm.cfun1(g,e,tp)
	return g:GetClassCount(Card.GetOriginalAttribute)==4
		and Duel.IEMCard(cm.tfil1,tp,"E",0,1,g,e,tp)
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GMGroup(cm.cfil1,tp,"E",0,nil)
	if chk==0 then
		return Duel.GetCustomActivityCount(m,tp,ACTIVITY_SPSUMMON)<1
			and g:CheckSubGroup(cm.cfun1,4,4,e,tp)
	end
	local e1=MakeEff(c,"F")
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTR(1,0)
	e1:SetLabelObject(e)
	e1:SetTarget(cm.ctar11)
	Duel.RegisterEffect(e1,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:SelectSubGroup(tp,cm.cfun1,false,4,4,e,tp)
	Duel.SendtoGrave(sg,REASON_COST)
end
function cm.ctar11(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLoc("E") and se~=e:GetLabelObject()
end
function cm.tfil1(c,e,tp)
	return c:IsCode(86066372) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil1,tp,"E",0,1,nil,e,tp)
			and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(aux.FALSE)
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"E")
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SMCard(tp,cm.tfil1,tp,"E",0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		if tc then
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			local e1=MakeEff(c,"S")
			e1:SetCode(EFFECT_SET_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(5300)
			tc:RegisterEffect(e1)
			Duel.SpecialSummonComplete()
			local e2=MakeEff(c,"FC")
			e2:SetCode(EVENT_SPSUMMON_SUCCESS)
			e2:SetLabelObject(tc)
			e2:SetOperation(cm.oop12)
			Duel.RegisterEffect(e2,tp)
			local e3=MakeEff(c,"FC")
			e3:SetCode(EVENT_CHAIN_END)
			e3:SetLabelObject(e2)
			e3:SetOperation(cm.oop13)
			Duel.RegisterEffect(e3,tp)
		end
	end
	if TYPE_ACCESS then
		local e4=MakeEff(c,"F")
		e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
		e4:SetTR(1,0)
		e4:SetTarget(cm.otar14)
		Duel.RegisterEffect(e4,tp)
	end
end
function cm.oop12(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsContains(e:GetLabelObject()) then
		e:SetLabel(1)
		e:Reset()
	else
		e:SetLabel(0)
	end
end
function cm.oop13(e,tp,eg,ep,ev,re,r,rp)
	if Duel.CheckEvent(EVENT_SPSUMMON_SUCCESS) and e:GetLabelObject():GetLabel()==1 then
		Duel.SetChainLimitTillChainEnd(aux.FALSE)
	end
	e:Reset()
end
function cm.otar14(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsType(TYPE_ACCESS)
end
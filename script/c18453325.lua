--엔젤 스피릿츠
local m=18453325
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"I","H")
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.cost1)
	e1:SetTarget(cm.tar1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"I","M")
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetCountLimit(1,m+1)
	e2:SetCost(cm.cost2)
	e2:SetTarget(cm.tar2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
end
function cm.cfil1(c)
	return c:IsLevelAbove(6) and c:IsRace(RACE_FAIRY) and c:IsReleasable()
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.cfil1,tp,"D",0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SMCard(tp,cm.cfil1,tp,"D",0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST+REASON_RELEASE)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocCount(tp,"M")>0
	local b2=true
	if chk==0 then
		return b1 or b2
	end
	local s=0
	if b1 and not b2 then
		s=Duel.SelectOption(tp,aux.Stringid(m,0))
	elseif not b1 and b2 then
		s=Duel.SelectOption(tp,aux.Stringid(m,1))+1
	elseif b1 and b2 then
		s=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))
	end
	e:SetLabel(s)
	if s==0 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	else
		e:SetCategory(0)
	end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==0 and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
	if e:GetLabel()==1 and c:IsRelateToEffect(e)
		and Duel.SendtoGrave(c,REASON_EFFECT+REASON_DISCARD)>0 then
		--not fully implemented
		local e1=MakeEff(c,"F")
		e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
		e1:SetTR("G",0)
		e1:SetTarget(cm.otar11)
		e1:SetValue(1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=MakeEff(c,"F","G")
		e2:SetCode(EFFECT_SPSUMMON_PROC_G)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e2:SetLabelObject(e1)
		e2:SetCondition(cm.ocon12)
		e2:SetOperation(cm.oop12)
		local e3=MakeEff(c,"FG")
		e3:SetTR("G",0)
		e3:SetReset(RESET_PHASE+PHASE_END)
		e3:SetTarget(cm.otar13)
		e3:SetLabelObject(e2)
		Duel.RegisterEffect(e3)
	end
end
function cm.otar11(e,c)
	return c:IsRace(RACE_FAIRY) and c:IsLevelAbove(5)
end
function cm.ocon12(e,c,og)
	if c==nil then
		return true
	end
	local se=e:GetLabelObject()
	local eset={c:IsHasEffect(EFFECT_EXTRA_SUMMON_COUNT)}
	local res=false
	for _,te in ipairs(eset) do
		if se==te then
			res=true
			break
		end
	end
	if res then
		return c:IsSummonable(false,nil)
	end
	return false
end
function cm.oop12(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
	Duel.Summon(tp,c,false,nil)
end
function cm.otar13(e,c)
	local te=e:GetLabelObject()
	local se=te:GetLabelObject()
	local eset={c:IsHasEffect(EFFECT_EXTRA_SUMMON_COUNT)}
	for _,ce in ipairs(eset) do
		if se==ce then
			return true
		end
	end
	return false
end
function cm.cfil2(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHandAsCost()
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.cfil2,tp,"O",0,1,nil)
	end
	local ct=1
	if Duel.IsPlayerCanDraw(tp,2) then
		ct=2
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SMCard(tp,cm.cfil2,tp,"O",0,1,ct,nil)
	e:SetLabel(Duel.SendtoHand(g,nil,REASON_COST))
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsPlayerCanDraw(tp,1)
	end
	local ct=e:GetLabel()
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end

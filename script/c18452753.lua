--¸á¶ûÈ¦¸¯: Å¸¶ôÃµ»ç ³¶¸¸°í¾çÀÌ
local m=18452753
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,m)
	local e1=MakeEff(c,"Qo","HG")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"STo")
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCategory(CATEGORY_TOGRAVE)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"FC","M")
	e3:SetCode(EVENT_CHAIN_SOLVING)
	WriteEff(e3,3,"O")
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"FC","M")
	e4:SetCode(EVENT_SUMMON)
	WriteEff(e4,4,"O")
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e5)
	if not cm.glo_chk then
		cm.glo_chk=true
		cm[0]=false
		local ge1=MakeEff(c,"F")
		ge1:SetCode(EFFECT_ACTIVATE_COST)
		ge1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		ge1:SetTR(1,1)
		ge1:SetOperation(cm.gop1)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EFFECT_SUMMON_COST)
		Duel.RegisterEffect(ge2,0)
		local ge3=ge1:Clone()
		ge3:SetCode(EFFECT_SPSUMMON_COST)
		Duel.RegisterEffect(ge3,0)
	end
end
function cm.gop1(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckPhaseActivity() and Duel.GetCurrentPhase()&(PHASE_MAIN1+PHASE_MAIN2)>0 then
		cm[0]=true
	elseif Duel.GetCurrentChain()<2 or Duel.GetCurrentPhase()&(PHASE_MAIN1+PHASE_MAIN2)<1 then
		cm[0]=false
	end
end
function cm.cfil1(c)
	return c:IsSetCard(0x2d3) and c:IsReleasable()
end
function cm.cfun11(sg,tp)
	return Duel.GetMZoneCount(tp,sg,tp)>0
		and sg:GetClassCount(cm.cfun12)==#sg
end
function cm.cfun12(c)
	return c:GetType()&0x7
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GMGroup(cm.cfil1,tp,"O",0,nil)
	if chk==0 then
		return g:CheckSubGroup(cm.cfun11,2,2,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=g:SelectSubGroup(tp,cm.cfun11,false,2,2,tp)
	Duel.Release(sg,REASON_COST)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local e1=MakeEff(c,"S")
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1,true)
	end
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMToGraveCard(Card.IsSetCard,tp,"D",0,1,m,0x2d3)
	end
	Duel.SOI(0,CATEGORY_TOGRAVE,nil,1,tp,"D")
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SMToGraveCard(tp,Card.IsSetCard,tp,"D",0,1,1,m,0x2d3)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	if ep~=tp and cm[0] and Duel.GetCurrentChain()<2 then
		Duel.Hint(HINT_CARD,0,m)
		if Duel.NegateActivation(ev) then
			Duel.Destroy(eg,REASON_EFFECT)
		end
	end
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	if ep~=tp and cm[0] then
		Duel.Hint(HINT_CARD,0,m)
		Duel.NegateSummon(eg)
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
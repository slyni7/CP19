--헤븐 다크사이트 -유진-
local m=18452843
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"Qo","H")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCountLimit(1,m)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"Qo","HM")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCountLimit(1,m+1)
	WriteEff(e2,2,"CO")
	c:RegisterEffect(e2)
	if not cm.global_check then
		cm.global_check=true
		cm[0]={}
		cm[1]={}
		for i=0,1 do
			cm[i][PHASE_DRAW]=0
			cm[i][PHASE_STANDBY]=0
			cm[i][PHASE_MAIN1]=0
			cm[i][PHASE_BATTLE]=0
			cm[i][PHASE_MAIN2]=0
			cm[i][PHASE_END]=0
		end
		local ge1=MakeEff(c,"FC")
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(cm.gop1)
		Duel.RegisterEffect(ge1,0)
		local ge2=MakeEff(c,"FC")
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(cm.gop2)
		Duel.RegisterEffect(ge2,0)
	end
end
function cm.gop1(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	if ph>PHASE_MAIN1 and ph<PHASE_MAIN2 then
		ph=PHASE_BATTLE
	end
	local tc=eg:GetFirst()
	while tc do
		if tc:IsReason(REASON_COST) and tc:IsPreviousLocation(LSTN("H")) and not tc:IsCode(m) then
			local p=tc:GetPreviousControler()
			cm[p][ph]=cm[p][ph]+1
		end
		tc=eg:GetNext()
	end
end
function cm.gop2(e,tp,eg,ep,ev,re,r,rp)
	for i=0,1 do
		cm[i][PHASE_DRAW]=0
		cm[i][PHASE_STANDBY]=0
		cm[i][PHASE_MAIN1]=0
		cm[i][PHASE_BATTLE]=0
		cm[i][PHASE_MAIN2]=0
		cm[i][PHASE_END]=0
	end
end
function cm.cfil1(c)
	return c:IsAttack(0) and c:IsType(TYPE_TUNER) and c:IsDiscardable()
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsDiscardable() and Duel.IEMCard(cm.cfil1,tp,"H",0,1,c)
	end
	local g=Duel.SMCard(tp,cm.cfil1,tp,"H",0,1,1,c)
	g:AddCard(c)
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.tfil1(c,e,tp)
	return c:IsAttack(0) and c:IsType(TYPE_TUNER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(m)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocCount(tp,"M")>0 and Duel.IEMCard(cm.tfil1,tp,"D",0,1,nil,e,tp)
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"D")
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocCount(tp,"M")<1 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SMCard(tp,cm.tfil1,tp,"D",0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.cfil2(c)
	return c:IsAttack(0) and c:IsType(TYPE_TUNER) and c:IsAbleToRemoveAsCost()
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IEMCard(cm.cfil2,tp,"G",0,1,nil)
			and ((c:IsLoc("H") and c:IsDiscardable()) or (c:IsLoc("M") and c:IsReleasable()))
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SMCard(tp,cm.cfil2,tp,"G",0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	if c:IsLoc("H") then
		Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
	elseif c:IsLoc("M") then
		Duel.Release(c,REASON_COST)
	end
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=MakeEff(c,"FC")
	e1:SetCode(EVENT_PHASE_START+PHASE_STANDBY)
	e1:SetLabel(PHASE_DRAW)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetOperation(cm.oop21)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_PHASE_START+PHASE_MAIN1)
	e2:SetLabel(PHASE_STANDBY)
	Duel.RegisterEffect(e2,tp)
	local e3=e1:Clone()
	e3:SetCode(EVENT_PHASE_START+PHASE_BATTLE)
	e3:SetLabel(PHASE_MAIN1)
	Duel.RegisterEffect(e3,tp)
	local e4=e1:Clone()
	e4:SetCode(EVENT_PHASE_START+PHASE_MAIN2)
	e4:SetLabel(PHASE_BATTLE)
	Duel.RegisterEffect(e4,tp)
	local e5=e1:Clone()
	e5:SetCode(EVENT_PHASE_START+PHASE_END)
	e5:SetLabel(PHASE_MAIN2)
	Duel.RegisterEffect(e5,tp)
	local e6=e1:Clone()
	e6:SetCode(EVENT_TURN_END)
	e6:SetLabel(PHASE_END)
	e6:SetReset(RESET_PHASE+PHASE_DRAW,2)
	Duel.RegisterEffect(e6,tp)
end
function cm.oop21(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==PHASE_MAIN2 and cm[tp][PHASE_MAIN1]>0 then
		Duel.Hint(HINT_CARD,0,m)
		Duel.Draw(tp,cm[tp][PHASE_MAIN1],REASON_EFFECT)
		cm[tp][PHASE_MAIN1]=0
	end
	if cm[tp][e:GetLabel()]>0 then
		Duel.Hint(HINT_CARD,0,m)
		Duel.Draw(tp,cm[tp][e:GetLabel()],REASON_EFFECT)
		cm[tp][e:GetLabel()]=0
	end
end
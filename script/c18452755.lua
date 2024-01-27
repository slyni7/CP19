--¸á¶ûÈ¦¸¯: Ãµ»ç¸¦ ¸¸³µ¾î
local m=18452755
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	if not cm.glo_chk then
		cm.glo_chk=true
		cm[0]=0
		cm[1]=0
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
	local tc=eg:GetFirst()
	while tc do
		local p=tc:GetControler()
		if tc:IsSetCard(0x2d3) then
			if tc:IsType(TYPE_MONSTER) then
				cm[p]=cm[p]|TYPE_MONSTER
			elseif tc:IsType(TYPE_SPELL) then
				cm[p]=cm[p]|TYPE_SPELL
			elseif tc:IsType(TYPE_TRAP) then
				cm[p]=cm[p]|TYPE_TRAP
			end
		end
		tc=eg:GetNext()
	end
end
function cm.gop2(e,tp,eg,ep,ev,re,r,rp)
	cm[0]=0
	cm[1]=0
end
function cm.cfil1(c,tp)
	local typ=c:GetType()&0x7
	return c:IsSetCard(0x2d3) and c:IsAbleToGraveAsCost() and not c:IsType(cm[tp])
		and Duel.IEMToHandCard(cm.tfil1,tp,"D",0,1,nil,cm[tp]|typ)
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.CheckPhaseActivity() then
			e:SetLabel(0)
		else
			e:SetLabel(100)
		end
		return Duel.IEMToGraveCard(cm.cfil1,tp,"D",0,1,nil,tp)
	end
	local g=Duel.SMToGraveCard(tp,cm.cfil1,tp,"D",0,1,1,nil,tp)
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.tfil1(c,typ)
	return c:IsSetCard(0x2d3) and c:IsAbleToHand() and not c:IsType(typ)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMToHandCard(cm.tfil1,tp,"D",0,1,nil,cm[tp])
	end
	local loc="D"
	if e:GetLabel()==100 then
		loc="DG"
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,loc)
end
function cm.ofil1(c)
	local te=c:GetActivateEffect()
	return c:IsSetCard(0x2d3) and c:IsAbleToHand() and c:IsType(TYPE_SPELL+TYPE_TRAP)
		and te and not te:IsHasCategory(CATEGORY_SEARCH)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SMAToHandCard(tp,cm.tfil1,tp,"D",0,1,1,nil,cm[tp])
	if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,g)
		local tg=Duel.GMGroup(cm.ofil1,tp,"G",0,nil)
		if e:GetLabel()==100 and #tg>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=tg:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
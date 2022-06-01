--¸á¶ûÈ¦¸¯: ³¶¸¸°í¾çÀÌ ¸®ÇÁ·¹ÀÎ
local m=18452754
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,cm.pfil1,2,2)
	local e1=MakeEff(c,"STo")
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"FC","M")
	e2:SetCode(EVENT_CHAIN_SOLVED)
	WriteEff(e2,2,"NO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"S","M")
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetValue(cm.val3)
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"Qo","G")
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	WriteEff(e4,4,"NCTO")
	c:RegisterEffect(e4)
	if not cm.glo_chk then
		cm.glo_chk=true
		cm[0]=nil
		local ge1=MakeEff(c,"F")
		ge1:SetCode(EFFECT_ACTIVATE_COST)
		ge1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		ge1:SetTR(1,1)
		ge1:SetCost(cm.gcost1)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.gcost1(e,te,tp)
	if not Duel.CheckPhaseActivity() and Duel.GetCurrentPhase()&(PHASE_MAIN1+PHASE_MAIN2)>0 then
		cm[0]=te
	elseif Duel.GetCurrentChain()<2 or Duel.GetCurrentPhase()&(PHASE_MAIN1+PHASE_MAIN2)<1 then
		cm[0]=nil
	end
	return true
end
function cm.pfil1(c)
	return c:IsLevelAbove(7) and c:IsLinkSetCard(0x2d4)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMToHandST(Card.IsSetCard,tp,"D",0,1,nil,0x2d3)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"DG")
end
function cm.ofil1(c)
	local te=c:GetActivateEffect()
	return c:IsSetCard(0x2d3) and c:IsAbleToHand() and c:IsType(TYPE_SPELL+TYPE_TRAP)
		and te and not te:IsHasCategory(CATEGORY_SEARCH)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SMAToHandST(tp,Card.IsSetCard,tp,"D",0,1,1,nil,0x2d3)
	if #g>0 and Duel.SendtoHand(g,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,g)
		local tg=Duel.GMGroup(cm.ofil1,tp,"G",0,nil)
		if #tg>0 and Duel.SelectYesNo(tp,16*m) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=tg:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rc:IsSetCard(0x2d3)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:GetAttack()<3100 then
		Duel.Hint(HINT_CARD,0,m)
		local e1=MakeEff(c,"S")
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		e1:SetValue(100)
		c:RegisterEffect(e1)
		Duel.Recover(tp,100,REASON_EFFECT)
	end
end
function cm.val3(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te~=cm[0]
end
function cm.con4(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph>PHASE_MAIN1 and ph<PHASE_MAIN2
end
function cm.cfil41(c)
	return c:IsSetCard(0x2d4) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
		and c:IsAbleToDeckAsCost()
end
function cm.cfil42(c)
	return c:IsSetCard(0x2d3) and c:IsType(TYPE_SPELL) and c:IsFaceup()
		and c:IsAbleToDeckAsCost()
end
function cm.cfil43(c)
	return c:IsSetCard("¹ÙÀÌ·¯½º") and c:IsType(TYPE_TRAP) and c:IsFaceup()
		and c:IsAbleToDeckAsCost()
end
function cm.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.cfil41,tp,"R",0,1,nil)
			and Duel.IEMCard(cm.cfil42,tp,"R",0,1,nil)
			and Duel.IEMCard(cm.cfil43,tp,"R",0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SMCard(tp,cm.cfil41,tp,"R",0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g2=Duel.SMCard(tp,cm.cfil42,tp,"R",0,1,1,nil)
	g1:Merge(g2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g3=Duel.SMCard(tp,cm.cfil43,tp,"R",0,1,1,nil)
	g1:Merge(g3)
	Duel.SendtoDeck(g1,nil,2,REASON_COST)
end
function cm.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocCount(tp,"M")>0
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
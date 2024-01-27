--모노크로니클 크로니클
local m=76859522
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"I","F")
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e2:SetD(m,1)
	WriteEff(e2,2,"CTO")
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetD(m,2)
	WriteEff(e3,3,"NC")
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"F","F")
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTR(1,0)
	e4:SetCondition(cm.con4)
	e4:SetValue(cm.val4)
	c:RegisterEffect(e4)
	local e5=MakeEff(c,"STo")
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e5:SetCategory(CATEGORY_DRAW)
	WriteEff(e5,5,"TO")
	c:RegisterEffect(e5)
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 and not Duel.CheckPhaseActivity()
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SOI(0,CATEGORY_TOGRAVE,nil,1,tp,"D")
end
function cm.ofil1(c)
	return c:IsSetCard(0x2c6) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	if Duel.IEMCard(cm.ofil1,tp,"D",0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,00)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SMCard(tp,cm.ofil1,tp,"D",0,1,1,nil)
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:GetFlagEffect(m)<1
	end
	c:RegisterFlagEffect(m,RESET_EVENT+0x1ec0000+RESET_PHASE+PHASE_END,0,1)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local dg=Duel.GMGroup(nil,tp,"M",0,nil)
	if chk==0 then
		return Duel.IESpSumTarget(Card.IsSetCard,tp,"G",0,1,nil,{e,tp},0x2c6) and 
			(Duel.GetLocCount(tp,"M")>0 or (Duel.GetMZoneCount(tp,dg,tp)>0 and
				not (Duel.IsPlayerAffectedByEffect(tp,76859511) and Duel.GetFlagEffect(tp,76859511)<1)))
	end
	Duel.SOI(0,CATEGORY_DESTROY,dg,#dg,0,0)
	local sg=Duel.SSpSumTarget(tp,Card.IsSetCard,tp,"G",0,1,1,nil,{e,tp},0x2c6)
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,sg,1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	local dg=Duel.GMGroup(nil,tp,"M",0,g)
	if #dg>0 then
		if Duel.IsPlayerAffectedByEffect(tp,76859511) and
			Duel.GetFlagEffect(tp,76859511)<1 then
			Duel.Hint(HINT_CARD,0,76859511)
			Duel.RegisterFlagEffect(tp,76859511,RESET_PHASE+PHASE_END,0,1)
		else
			Duel.Destroy(dg,REASON_EFFECT)
		end
	end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,76859518)
end
function cm.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:GetFlagEffect(m)<1 and Duel.GetFlagEffect(tp,76859518)<1
	end
	c:RegisterFlagEffect(m,RESET_EVENT+0x1ec0000+RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(HINT_CARD,0,76859518)
	Duel.RegisterFlagEffect(tp,76859518,RESET_PHASE+PHASE_END,0,1)
end
function cm.con4(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetTurnPlayer()==tp
end
function cm.val4(e,re,tp)
	return re:GetActivateLocation()==LSTN("H") and re:IsActiveType(TYPE_MONSTER)
end

function cm.tar5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetFieldGroupCount(tp,LSTN("D"),0)>0 and Duel.IsPlayerCanDraw(tp)
	end
end
function cm.ofil5(c)
	return c:IsSetCard(0x2c6) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.op5(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LSTN("D"),0)<1 then
		return
	end
	Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	if tc:IsSetCard(0x2c6) and tc:IsType(TYPE_MONSTER) then
		if Duel.IsPlayerCanDraw(tp,1) then
			Duel.DisableShuffleCheck()
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
		local sg=Duel.SMCard(tp,cm.ofil5,tp,"D",0,1,1,nil)
		local sc=sg:GetFirst()
		if sc then
			Duel.ShuffleDeck(tp)
			Duel.MoveSequence(sc,0)
			Duel.ConfirmDecktop(tp,1)
		end
	end
end
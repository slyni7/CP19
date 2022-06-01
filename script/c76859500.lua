--모노크로니클
local m=76859500
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	WriteEff(e1,1,"O")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"I","F")
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e2:SetDescription(16*m+1)
	WriteEff(e2,2,"CTO")
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetDescription(16*m+2)
	WriteEff(e3,3,"NC")
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"FTo","F")
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCategory(CATEGORY_DRAW)
	WriteEff(e4,4,"NCTO")
	c:RegisterEffect(e4)
	local e5=MakeEff(c,"STo")
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e5:SetCategory(CATEGORY_TOHAND)
	WriteEff(e5,5,"TO")
	c:RegisterEffect(e5)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	if Duel.IEMToHandMon(Card.IsSetCard,tp,"D",0,1,nil,0x2c6) and Duel.SelectYesNo(tp,16*m) then
		local g=Duel.SMAToHandMon(tp,Card.IsSetCard,tp,"D",0,1,1,nil,0x2c6)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
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
	if chk==0 then
		return Duel.IEMSpSumCard(Card.IsSetCard,tp,"H",0,1,nil,{e,tp},0x2c6) and
			Duel.GetLocCount(tp,"M")>0
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"H")
	local g=Duel.GMGroup(nil,tp,"M",0,nil)
	Duel.SOI(0,CATEGORY_DESTROY,g,#g,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	if Duel.GetLocCount(tp,"M")<1 then
		return
	end
	local g=Duel.SMSpSumCard(tp,Card.IsSetCard,tp,"H",0,1,1,nil,{e,tp},0x2c6)
	if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) then
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
function cm.nfil4(c,tp)
	return c:IsPreviousSetCard(0x2c6) and c:IsPreviousLocation(LSTN("M")) and
		c:GetPreviousControler()==tp
end
function cm.con4(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(cm.nfil4,nil,tp)
	return rp~=tp and ct>0
end
function cm.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsReleasable()
	end
	Duel.Release(c,REASON_COST)
end
function cm.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=eg:FilterCount(cm.nfil4,nil,tp)
	if chk==0 then
		e:SetLabel(ct)
		return Duel.IsPlayerCanDraw(tp,ct)
	end
	Duel.SOI(0,CATEGORY_DRAW,nil,0,tp,e:GetLabel())
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,e:GetLabel(),REASON_EFFECT)
end
function cm.tfil5(c)
	return c:IsSetCard(0x2c6) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and
		(c:IsLoc("G") or c:IsFaceup())
end
function cm.tar5(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(tp) and chkc:IsLoc("GR") and cm.tfil5(chkc)
	end
	if chk==0 then
		return Duel.IETarget(cm.tfil5,tp,"GR",0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.STarget(tp,cm.tfil5,tp,"GR",0,1,1,nil)
	Duel.SOI(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.op5(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
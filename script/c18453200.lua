--Arom@ G@rden
local m=18453200
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_RECOVER+CATEGORY_TOHAND+CATEGORY_SEARCH)
	WriteEff(e1,1,"CO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"S","F")
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetValue(cm.val2)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"Qo","F")
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_RECOVER+CATEGORY_SPECIAL_SUMMON+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e3:SetD(m,2)
	e3:SetCL(1,m)
	WriteEff(e3,3,"NTO")
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"Qo","F")
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCategory(CATEGORY_TODECK)
	e4:SetD(m,3)
	e4:SetCL(1,m+1)
	WriteEff(e4,3,"N")
	WriteEff(e4,4,"TO")
	c:RegisterEffect(e4)
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return true
	end
	c:SetStatus(STATUS_EFFECT_ENABLED,true)
	c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,0)
end
function cm.ofil1(c,e,tp)
	return c:IsSetCard(0x2e6) and c:IsLevelBelow(4) and (c:IsAbleToHand() or
		(c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocCount(tp,"M")>0 and Duel.GetFieldGroupCount(tp,LSTN("M"),0)==0))
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,cm.ofil1,tp,"D",0,0,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		if tc:IsAbleToHand() and (not tc:IsCanBeSpecialSummoned(e,0,tp,false,false) or Duel.GetLocCount(tp,"M")<1
			or Duel.GetFieldGroupCount(tp,LSTN("M"),0)>0
			or Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))==0) then
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
			local rec=(tc:GetLevel()+tc:GetRank()+tc:GetLink())*100
			Duel.Recover(tp,rec,REASON_EFFECT)
		else
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
			local rec=(tc:GetLevel()+tc:GetRank()+tc:GetLink())*100
			Duel.Recover(tp,rec,REASON_EFFECT)
		end
	end
end
function cm.val2(e,re)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	return c~=rc and re:IsHasCategory(CATEGORY_RECOVER)
end
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(m)==0
end
function cm.tfil3(c,e,tp)
	return c:IsSetCard(0x2e6) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLoc("G") and chkc:IsControler(tp) and cm.tfil3(chkc,e,tp)
	end
	if chk==0 then
		return Duel.GetLocCount(tp,"M")>0 and Duel.IETarget(cm.tfil3,tp,"G",0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.STarget(tp,cm.tfil3,tp,"G",0,1,1,nil,e,tp)
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
		local rec=(tc:GetLevel()+tc:GetRank()+tc:GetLink())*100
		local e1=MakeEff(c,"F")
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetTR("M",0)
		e1:SetValue(rec)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		Duel.RegisterEffect(e2,tp)
		Duel.Recover(tp,rec,REASON_EFFECT)
	end
end
function cm.tfil4(c,tp)
	local val=c:GetLevel()+c:GetRank()+c:GetLink()
	local g=Duel.GMGroup(Card.IsAbleToDeck,tp,"HOGR",0,c)
	return c:IsSetCard(0x2e6) and c:IsFaceup() and c:IsAbleToDeck() and #g>=val
end
function cm.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil4,tp,"M",0,1,nil,tp)
	end
	Duel.SOI(0,CATEGORY_TODECK,2,nil,tp,"HOGR")
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SMCard(tp,cm.tfil4,tp,"M",0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		local val=tc:GetLevel()+tc:GetRank()+tc:GetLink()
		if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local rg=Duel.SMCard(tp,Card.IsAbleToDeck,tp,"HOGR",0,val,val,nil)
			if #rg>0 then
				Duel.SendtoDeck(rg,nil,2,REASON_EFFECT)
			end
		end
	end
end
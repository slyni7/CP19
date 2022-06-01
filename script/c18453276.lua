--플라나 델리아
local m=18453276
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FBF(Card.IsSetCard,0x2eb),2,2)
	local e1=MakeEff(c,"Qo","M")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetCL(1)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"STo")
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:CheckRemoveOverlayCard(tp,1,REASON_COST)
	end
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.tfil1(c,tp)
	return (c:IsSetCard(0x2eb) or c:IsControler(1-tp)) and c:IsAbleToHand()
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLoc("GM") and cm.tfil1(chkc,tp)
	end
	if chk==0 then
		return Duel.IsExistingTarget(cm.tfil1,tp,"G","M",1,nil,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.STarget(tp,cm.tfil1,tp,"G","M",1,1,nil,tp)
	Duel.SOI(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local faceup=tc:IsFaceup() or tc:IsLoc("G")
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		if faceup then
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end
function cm.tfil2(c,e,tp)
	return c:IsSetCard(0x2eb) and c:IsType(TYPE_MONSTER) and c:GetLevel()>0 and c:IsCanBeEffectTarget(e)
		and (c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) or c:IsAbleToDeck())
end
function cm.tfun2(g,e,tp)
	return g:GetSum(Card.GetLevel)<=8 and g:IsExists(Card.IsCanBeSpecialSummoned,2,nil,e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return false
	end
	local g=Duel.GMGroup(cm.tfil2,tp,"G",0,nil,e,tp)
	if chk==0 then
		return g:CheckSubGroup(cm.tfun2,2,3,e,tp) and Duel.GetLocCount(tp,"M")>1
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=g:SelectSubGroup(tp,cm.tfun2,false,2,3,e,tp)
	Duel.SetTargetCard(tg)
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,tg,2,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocCount(tp,"M")<1 then
		return
	end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g<2 then
		return
	end
	local sg=g:Filter(Card.IsCanBeSpecialSummoned,nil,e,0,tp,false,false)
	if #sg<2 then
		return
	end
	if #sg>2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		sg=sg:Select(tp,2,2,nil)
	end
	g:Sub(sg)
	sg:KeepAlive()
	local e1=MakeEff(c,"FC")
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetLabelObject(sg)
	e1:SetOperation(cm.oop21)
	Duel.RegisterEffect(e1,tp)
	local e2=MakeEff(c,"FC")
	e2:SetCode(EVENT_CHAIN_END)
	e2:SetLabelObject(e1)
	e2:SetOperation(cm.oop22)
	Duel.RegisterEffect(e2,tp)
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
	local fid=c:GetFieldID()
	local tc=sg:GetFirst()
	while tc do
		tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		tc=sg:GetNext()
	end
	local e3=MakeEff(c,"FC")
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetLabel(fid)
	e3:SetLabelObject(sg)
	e3:SetCondition(cm.ocon23)
	e3:SetOperation(cm.oop23)
	Duel.RegisterEffect(e3,tp)
end
function cm.oop21(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Clone()
	local sg=e:GetLabelObject()
	if #(g-sg)~=#eg then
		e:SetLabel(1)
		e:Reset()
	else
		e:SetLabel(0)
	end
end
function cm.oop22(e,tp,eg,ep,ev,re,r,rp)
	if Duel.CheckEvent(EVENT_SPSUMMON_SUCCESS) and e:GetLabelObject():GetLabel()==1 then
		Duel.SetChainLimitTillChainEnd(cm.clim1)
	end
	e:Reset()
end
function cm.clim1(e,ep,tp)
	return ep==tp
end
function cm.onfil23(c,fid)
	return c:GetFlagEffectLabel(m)==fid
end
function cm.ocon23(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local sg=e:GetLabelObject()
	local fid=e:GetLabel()
	if sg:FilterCount(cm.onfil23,nil,fid)<2 then
		e:Reset()
		return false
	end
	return sg:IsContains(rc) and rc:GetFlagEffectLabel(m)==fid
end
function cm.oop23(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local fid=e:GetLabel()
	local sg=e:GetLabelObject()
	local e1=MakeEff(c,"FC")
	e1:SetCode(EVENT_CHAIN_END)
	e1:SetLabel(fid)
	e1:SetLabelObject(sg)
	e1:SetCondition(cm.oocon231)
	e1:SetOperation(cm.ooop231)
	Duel.RegisterEffect(e1,tp)
end
function cm.oocon231(e,tp,eg,ep,ev,re,r,rp)
	local sg=e:GetLabelObject()
	local fid=e:GetLabel()
	return sg:FilterCount(cm.onfil23,nil,fid)==2
end
function cm.ooofil231(c,mg)
	return c:IsXyzSummonable(mg,2,2) and c:IsSetCard(0x2eb)
end
function cm.ooop231(e,tp,eg,ep,ev,re,r,rp)
	local sg=e:GetLabelObject()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SMCard(tp,cm.ooofil231,tp,"E",0,0,1,nil,sg)
	local tc=g:GetFirst()
	if tc then
		Duel.XyzSummon(tp,tc,sg)
		e:Reset()
	end
end
--플라나 아스테리아
local m=18453272
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FBF(Card.IsSetCard,0x2eb),32,2)
	local e1=MakeEff(c,"Qo","M")
	e1:SetCode(EVENT_FREE_CHAIN)
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
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsPlayerCanDraw(tp,3) and Duel.GetFlagEffect(tp,m)<1
	local g=Duel.GMGroup(Card.IsType,tp,0,"O",nil,TYPE_SPELL+TYPE_TRAP)
	local b2=#g>0 and Duel.GetFlagEffect(tp,m+1)<1
	local b3=Duel.IETarget(Card.IsControlerCanBeChanged,tp,0,"M",1,nil) and Duel.GetFlagEffect(tp,m+2)<1
	local b4=Duel.IEMCard(Card.IsAbleToDeck,tp,0,"H",1,nil) and Duel.GetFlagEffect(tp,m+3)<1
	if chk==0 then
		return b1 or b2 or b3 or b4
	end
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(m,0)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(m,1)
		opval[off-1]=2
		off=off+1
	end
	if b3 then
		ops[off]=aux.Stringid(m,2)
		opval[off-1]=3
		off=off+1
	end
	if b4 then
		ops[off]=aux.Stringid(m,3)
		opval[off-1]=4
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
	e:SetLabel(sel)
	if sel==1 then
		e:SetProperty(0)
		e:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
		Duel.SOI(0,CATEGORY_DRAW,nil,0,tp,3)
		Duel.SOI(0,CATEGORY_HANDES,nil,0,tp,2)
	elseif sel==2 then
		e:SetProperty(0)
		e:SetCategory(CATEGORY_DESTROY)
		Duel.SOI(0,CATEGORY_DESTROY,g,#g,0,0)
	elseif sel==3 then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e:SetCategory(CATEGORY_CONTROL)
		local tg=Duel.STarget(tp,Card.IsControlerCanBeChanged,tp,0,"M",1,1,nil)
		Duel.SOI(0,CATEGORY_CONTROL,tg,1,0,0)
	else
		e:SetProperty(0)
		e:SetCategory(CATEGORY_TODECK)
		Duel.SOI(0,CATEGORY_TODECK,nil,1,1-tp,"H")
	end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local sel=e:GetLabel()
	if sel==1 then
		if Duel.GetFlagEffect(tp,m)>0 then
			return
		end
		if Duel.Draw(tp,3,REASON_EFFECT)>0 then
			Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
			local g=Duel.SMCard(tp,aux.TRUE,tp,"H",0,2,2,nil)
			Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
		end
	elseif sel==2 then
		if Duel.GetFlagEffect(tp,m+1)>0 then
			return
		end
		local g=Duel.GMGroup(Card.IsType,tp,0,"O",nil,TYPE_SPELL+TYPE_TRAP)
		if Duel.Destroy(g,REASON_EFFECT)>0 then
			Duel.RegisterFlagEffect(tp,m+1,RESET_PHASE+PHASE_END,0,1)
		end
	elseif sel==3 then
		if Duel.GetFlagEffect(tp,m+2)>0 then
			return
		end
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) and Duel.GetControl(tc,tp) then
			Duel.RegisterFlagEffect(tp,m+2,RESET_PHASE+PHASE_END,0,1)
		end
	else
		if Duel.GetFlagEffect(tp,m+3)>0 then
			return
		end
		local g=Duel.GetFieldGroup(tp,0,LSTN("H"))
		if g:GetCount()>0 then
			Duel.ConfirmCards(tp,g)
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
			local sg=g:FilterSelect(tp,Card.IsAbleToDeck,1,1,nil)
			Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
			Duel.ShuffleHand(1-tp)
			Duel.RegisterFlagEffect(tp,m+3,RESET_PHASE+PHASE_END,0,1)
		end
	end
end
function cm.tfil2(c,e,tp)
	return c:IsSetCard(0x2eb) and c:IsType(TYPE_MONSTER) and c:GetLevel()>0 and c:IsCanBeEffectTarget(e)
		and (c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) or c:IsAbleToDeck())
end
function cm.tfun2(g,e,tp)
	return g:GetSum(Card.GetLevel)<=64 and g:IsExists(Card.IsCanBeSpecialSummoned,2,nil,e,0,tp,false,false,POS_FACEUP_DEFENSE)
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
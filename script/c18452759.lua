--∏·∂˚»¶∏Ø: π„«œ¥√ ∞°µÊ æ»∞Ì ΩÕæÓø‰
local m=18452759
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	WriteEff(e1,1,"CO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"I","S")
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCountLimit(1)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"FTo","S")
	e3:SetCode(EVENT_PHASE+PHASE_END)
	WriteEff(e3,3,"CTO")
	c:RegisterEffect(e3)
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.CheckPhaseActivity() then
			e:SetLabel(0)
		else
			e:SetLabel(100)
		end
		return true
	end
end
function cm.ofil1(c,e,tp)
	local ct=(c:IsLoc("D") or e:GetLabel()==100) and 2 or 1
	local dct=c:IsLoc("D") and 1 or 0
	return c:IsSetCard(0x2d3) and c:IsAbleToGrave() and Duel.IsPlayerCanDraw(tp,ct) and
		Duel.GetFieldGroupCount(tp,LSTN("D"),0)>=ct+dct and not c:IsCode(m)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	local g=Duel.GMGroup(cm.ofil1,tp,"HD",0,nil,e,tp)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Select(tp,1,1,nil)
		local tc=sg:GetFirst()
		local ct=(tc:IsLoc("H") or e:GetLabel()==100) and 2 or 1
		Duel.SendtoGrave(tc,REASON_EFFECT)
		Duel.Draw(tp,ct,REASON_EFFECT)
	end
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return c:IsControrler(tp) and c:IsLoc("G") and c:IsSetCard(0x2d4) and
			c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	if chk==0 then
		return Duel.IESpSumTarget(Card.IsSetCard,tp,"G",0,1,nil,{e,tp},0x2d4) and
			Duel.GetLocCount(tp,"M")>0
	end
	local g=Duel.SSpSumTarget(tp,Card.IsSetCard,tp,"G",0,1,1,nil,{e,tp},0x2d4)
	Duel.SOI(0,CATEGORY_SPECIAL_SUMON,g,1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.cfil31(c,tp)
	return c:IsSetCard(0x2d4) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
		and Duel.IEMCard(cm.cfil32,tp,"G",0,1,nil,tp,c)
end
function cm.cfil32(c,tp,mc)
	return c:IsSetCard(0x2d3) and c:IsType(TYPE_SPELL) and c:IsAbleToRemoveAsCost()
		and Duel.IEMCard(cm.cfil33,tp,"G",0,1,nil,tp,mc,c)
end
function cm.cfil33(c,tp,mc,sc)
	return c:IsSetCard("πŸ¿Ã∑ØΩ∫") and c:IsType(TYPE_TRAP) and c:IsAbleToRemoveAsCost()
end
function cm.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	e:SetLabel(100)
	if chk==0 then
		return c:IsAbleToGraveAsCost() and
			Duel.IEMCard(cm.cfil31,tp,"G",0,1,nil,tp)
	end
	Duel.SendtoGrave(c,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local mg=Duel.SMCard(tp,cm.cfil31,tp,"G",0,1,1,nil,tp)
	local mc=mg:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=Duel.SMCard(tp,cm.cfil32,tp,"G",0,1,1,nil,tp,mc)
	local sc=sg:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tg=Duel.SMCard(tp,cm.cfil33,tp,"G",0,1,1,nil,tp,mc,sc)
	local tc=tg:GetFirst()
	local rg=Group.FromCards(mc,sc,tc)
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
	local te=tc:GetActivateEffect()
	e:SetLabelObject(te)
	te:SetLabel(7)
	rg:KeepAlive()
	te:SetLabelObject(rg)
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then
			return false
		end
		e:SetLabel(0)
		return true
	end
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local op=te:GetOperation()
	if op then
		op(te,tp,eg,ep,ev,re,r,rp)
	end
end
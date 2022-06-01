--큐빅 리졸브
local m=52647109
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
end
function cm.tfil11(c)
	return c:IsSetCard(0x5ff) and c:IsAbleToHand()
end
function cm.tfil12(c,e,tp)
	return c:IsCustomType(CUSTOMTYPE_SQUARE) and c:IsType(TYPE_NORMAL) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.tfil13(c)
	return c:IsCustomType(CUSTOMTYPE_SQUARE) and c:IsType(TYPE_NORMAL) and c:IsAbleToHand()
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IEMCard(cm.tfil11,tp,"D",0,1,nil)
	local b2=Duel.GetLocCount(tp,"M")>0 and Duel.IEMCard(cm.tfil12,tp,"D",0,1,nil,e,tp)
	local b3=Duel.IEMCard(cm.tfil13,tp,"G",0,1,nil)
	if chk==0 then
		return b1 or b2 or b3
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
	if off==1 then
		return
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	e:SetLabel(opval[op])
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SMCard(tp,cm.tfil11,tp,"D",0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	elseif op==2 then
		if Duel.GetLocCount(tp,"M")>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SMCard(tp,cm.tfil12,tp,"D",0,1,1,nil,e,tp)
			if #g>0 then
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	elseif op==3 then
		local g=Duel.GMGroup(cm.tfil13,tp,"G",0,nil)
		if #g>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,3)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
--举府胶 焊捞靛
local m=18453152
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,18453151)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"A")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	WriteEff(e2,2,"NTO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"I","S")
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetCountLimit(1,m)
	WriteEff(e3,3,"CTO")
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"I","G")
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCategory(CATEGORY_TODECK)
	e4:SetCountLimit(1,m+1)
	WriteEff(e4,4,"CTO")
	c:RegisterEffect(e4)
end
function cm.nfil2(c)
	return c:IsCode(m) and c:IsFaceup()
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IEMCard(cm.nfil2,tp,"O",0,1,nil)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return #Duel.GMGroup(aux.TRUE,tp,"H",0,c)>0 and Duel.IsPlayerCanDraw(tp,1)
	end
	Duel.SOI(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SOI(0,CATEGORY_TODECK,nil,1,tp,"H")
end
function cm.ofil2(c)
	return c:IsSetCard("举府胶") and c:IsCustomType(CUSTOMTYPE_SQUARE) and c:IsFaceup() and c:IsHasExactSquareMana(0x0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetFieldGroupCount(tp,LSTN("H"),0)
	if ct<1 then
		return
	end
	local t={}
	for i=1,ct do
		if Duel.IsPlayerCanDraw(tp,i) then
			table.insert(t,i)
		end
	end
	if #t<1 then
		return
	end
	local ac=0
	if #t==1 then
		ac=t[1]
	else
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,0))
		ac=Duel.AnnounceNumber(tp,table.unpack(t))
	end
	local dct=Duel.Draw(tp,ac,REASON_EFFECT)
	if dct>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local dg=Duel.SMCard(tp,Card.IsAbleToDeck,tp,"H",0,dct,dct,nil)
		if #dg>0 and Duel.SendtoDeck(dg,nil,2,REASON_EFFECT)>0 then
			Duel.BreakEffect()
			Duel.ShuffleDeck(tp)
			local tg=Duel.GMGroup(cm.ofil2,tp,"M",0,nil)
			if #tg>0 and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
				local sg=tg:Select(tp,1,1,nil)
				local sc=sg:GetFirst()
				Duel.BreakEffect()
				local e1=MakeEff(c,"S")
				e1:SetCode(EFFECT_SQUARE_MANA_DECLINE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetValue(cm.oval21)
				sc:RegisterEffect(e1)
				Duel.Draw(tp,1,REASON_EFFECT)
			end
		end
	end
end
function cm.oval21(e,c)
	return 0x0
end
function cm.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToGraveAsCost()
	end
	Duel.SendtoGrave(c,REASON_COST)
end
function cm.tfil31(c)
	return c:IsSetCard("举府胶")
end
function cm.tfil32(c)
	return c:IsCode(18453151)
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		local exg=Duel.GMGroup(Auxiliary.RitualExtraFilter,tp,"G",0,nil,cm.tfil31)
		return Duel.IEMCard(Auxiliary.RitualUltimateFilter,tp,"HGR",0,1,nil,cm.tfil32,e,tp,mg,exg,Card.GetLevel,"Greater",true)
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"HGR")
	Duel.SOI(0,CATEGORY_REMOVE,nil,0,tp,"G")
end
function cm.ofil3(c)
	return c:IsSetCard("举府胶") and c:IsCustomType(CUSTOMTYPE_SQUARE) and c:IsFaceup()
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=Duel.GetRitualMaterial(tp)
	local exg=Duel.GMGroup(Auxiliary.RitualExtraFilter,tp,"G",0,nil,cm.tfil31)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SMCard(tp,Auxiliary.RitualUltimateFilter,tp,"HGR",0,1,1,nil,filter,e,tp,mg,exg,Card.GetLevel,"Greater")
	local tc=tg:GetFirst()
	if tc then
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if exg then
			mg:Merge(exg)
		end
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local lv=tc:GetLevel()
		Auxiliary.GCheckAdditional=Auxiliary.RitualCheckAdditional(tc,lv,"Greater")
		local mat=mg:SelectSubGroup(tp,Auxiliary.RitualCheck,false,1,lv,tp,tc,lv,"Greater")
		Auxiliary.GCheckAdditional=nil
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
		local sg=Duel.GMGroup(cm.ofil3,tp,"M",0,nil)
		local sc=sg:GetFirst()
		if sc then
			Duel.BreakEffect()
		end
		while sc do
			local e1=MakeEff(c,"S")
			e1:SetCode(EFFECT_EXTRA_SQUARE_MANA)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(cm.oval21)
			sc:RegisterEffect(e1)
			sc=sg:GetNext()
		end
	end
end
function cm.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToRemoveAsCost()
	end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
	c:CreateEffectRelation(e)
end
function cm.tfil4(c)
	return c:IsSetCard("举府胶") and c:IsType(TYPE_SPELL) and c:IsAbleToDeck() and (c:IsLoc("G") or c:IsFaceup()) and not c:IsCode(m)
end
function cm.tar4(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GMGroup(cm.tfil4,tp,"GR",0,nil)
	if chkc then
		return chkc:IsControler(tp) and chkc:IsLoc("GR") and cm.tfil4(chkc)
	end
	if chk==0 then
		return #g>0 and Duel.IsPlayerCanDraw(tp,1)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,4)
	Duel.SetTargetCard(sg)
	Duel.SOI(0,CATEGORY_TODECK,sg,#sg,0,0)
	Duel.SOI(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g>0 and Duel.SendtoDeck(g,nil,2,REASON_EFFECT)>0 then
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
	if c:IsRelateToEffect(e) then
		local e1=MakeEff(c,"FC","R")
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD,2)
		e1:SetCountLimit(1)
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetCondition(cm.ocon41)
		e1:SetOperation(cm.oop41)
		c:RegisterEffect(e1)
	end
end
function cm.ocon41(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetLocCount(tp,"S")>0 and c:IsSSetable() and Duel.GetTurnCount()~=e:GetLabel()
end
function cm.oop41(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.SSet(tp,c)
end
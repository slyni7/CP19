--이상물질(아이딜 매터) 「청체」
local s,id=GetID()
function s.initial_effect(c)
	if not s.global_check then
		s.global_check=true
		aux.RegisterIdealMatter(c,id)
	end
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,s.pfil1,aux.TRUE,2,2)
	c:SetUniqueOnField(1,0,id)
	local e1=MakeEff(c,"Qo","M")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DISABLE+CATEGORY_TODECK)
	e1:SetCL(1)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
end
function s.pfil1(c,xc)
	return c:IsLevelBelow(5)
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:CheckRemoveOverlayCard(tp,1,REASON_COST)
	end
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.tfil11(c,e,tp)
	return c:IsSetCard("이상물질(아이딜 매터)") and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and (c:IsFaceup() or c:IsLoc("G")) and c:IsCanBeEffectTarget(e)
end
function s.tfil12(c)
	local chain_related=false
	local cc=Duel.GetCurrentChain()
	for i=1,cc do
		local ce=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
		local ec=ce:GetHandler()
		if ec==c and c:IsRelateToEffect(ce) then
			chain_related=true
		end
	end
	return ((c:IsLoc("H") and chain_related)
		or (c:IsLoc("E") and chain_related and c:IsFaceup())
		or (c:IsOnField() and c:IsFaceup())
		or c:IsLoc("G") or (c:IsLoc("R") and c:IsFaceup()))
		and (c:IsAbleToDeck() or c:IsNegatable())
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(tp) and chkc:IsLoc("GR") and s.tfil11(chkc,e,tp)
	end
	local g1=Duel.GMGroup(s.tfil11,tp,"GR",0,nil,e,tp)
	local g2=Duel.GMGroup(s.tfil12,tp,0,"HEOGR",nil)
	if chk==0 then
		return (#g1>0 and Duel.GetLocCount(tp,"M")>0) or #g2>0
	end
	local op=Duel.SelectEffect(tp,
		{(#g1>0 and Duel.GetLocCount(tp,"M")>0),aux.Stringid(id,0)},
		{#g2>0,aux.Stringid(id,1)})
	e:SetLabel(op)
	if op==1 then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g1:Select(tp,1,1,nil)
		Duel.SetTargetCard(sg)
		Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,sg,1,0,0)
	elseif op==2 then
		e:SetProperty(0)
		e:SetCategory(CATEGORY_TODECK+CATEGORY_DISABLE)
		Duel.SOI(0,CATEGORY_TODECK,nil,1,1-tp,"HEOGR")
	end
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==1 then
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	elseif op==2 then
		local c=e:GetHandler()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SMCard(tp,s.tfil12,tp,0,"HEOGR",1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
			local code=tc:GetOriginalCodeRule()
			local e1=MakeEff(c,"F")
			e1:SetCode(EFFECT_DISABLE)
			e1:SetTR(0,"O")
			e1:SetLabel(code)
			e1:SetTarget(s.otar11)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
			local e2=MakeEff(c,"FC")
			e2:SetCode(EVENT_CHAIN_SOLVING)
			e2:SetLabel(code)
			e2:SetCondition(s.ocon12)
			e2:SetOperation(s.oop12)
			e2:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e2,tp)
			local e3=e1:Clone()
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetTR(0,"M")
			Duel.RegisterEffect(e3,tp)
		end
	end
end
function s.otar11(e,c)
	return c:IsOriginalCodeRule(e:GetLabel())
end
function s.ocon12(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rc:IsOriginalCodeRule(e:GetLabel()) and rp~=tp
end
function s.oop12(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
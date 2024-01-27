--이상물질(아이딜 매터) 「청락」
local s,id=GetID()
function s.initial_effect(c)
	if not s.global_check then
		s.global_check=true
		aux.RegisterIdealMatter(c,id)
	end
	c:EnableReviveLimit()
	Link.AddProcedure(c,nil,2,2)
	c:SetUniqueOnField(1,0,id)
	local e1=MakeEff(c,"STo")
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCategory(CATEGORY_TODECK)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"Qo","M")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_DISABLE)
	WriteEff(e2,2,"CTO")
	c:RegisterEffect(e2)
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(1-tp) and chkc:IsLocation(LSTN("OGR")) and chkc:IsAbleToDeck()
	end
	if chk==0 then
		return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,0,LSTN("OGR"),1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,0,LSTN("OGR"),1,1,nil)
	Duel.SOI(0,CATEGORY_TODECK,g,1,0,0)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsReleasable()
	end
	Duel.Release(c,REASON_COST)
end
function s.tfil2(c)
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
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(s.tfil2,tp,0,"HEOGR",1,nil)
	end
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_NEGATE)
	local g=Duel.SMCard(tp,s.tfil2,tp,0,"HEOGR",1,1,nil)
	local tc=g:GetFirst()
	if tc then
		local code=tc:GetOriginalCodeRule()
		local e1=MakeEff(c,"F")
		e1:SetCode(EFFECT_DISABLE)
		e1:SetTR(0,"O")
		e1:SetLabel(code)
		e1:SetTarget(s.otar21)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=MakeEff(c,"FC")
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetLabel(code)
		e2:SetCondition(s.ocon22)
		e2:SetOperation(s.oop22)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
		e3:SetTR(0,"M")
		Duel.RegisterEffect(e3,tp)
	end
end
function s.otar21(e,c)
	return c:IsOriginalCodeRule(e:GetLabel())
end
function s.ocon22(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rc:IsOriginalCodeRule(e:GetLabel()) and rp~=tp
end
function s.oop22(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
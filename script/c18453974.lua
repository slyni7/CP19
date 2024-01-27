--이상물질(아이딜 매터) 「청광」
local s,id=GetID()
function s.initial_effect(c)
	if not s.global_check then
		s.global_check=true
		aux.RegisterIdealMatter(c,id)
	end
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_CHAINING)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_TODECK)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)
end
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE))
end
function s.tfil1(c)
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
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IEMCard(s.tfil1,tp,0,"HEOGR",1,nil)
	end
	Duel.SOI(0,CATEGORY_TODECK,nil,1,1-tp,"HEOGR")
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SMCard(tp,s.tfil1,tp,0,"HEOGR",1,1,nil)
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
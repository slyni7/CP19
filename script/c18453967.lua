--이상물질(아이딜 매터) 「청하」
local s,id=GetID()
function s.initial_effect(c)
	if not s.global_check then
		s.global_check=true
		aux.RegisterIdealMatter(c,id)
	end
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_DISABLE)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
end
function s.tfil1(c)
	return ((c:IsOnField() and c:IsFaceup())
		or c:IsLoc("G") or (c:IsLoc("R") and c:IsFaceup()))
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(1-tp) and chkc:IsLocation(LSTN("OGR")) and s.tfil1(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(s.tfil1,tp,0,LSTN("OGR"),1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_NEGATE)
	local g=Duel.SelectTarget(tp,s.tfil1,tp,0,LSTN("OGR"),1,1,nil)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
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
--선악을 초월하여
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"F","H")
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(s.con1)
	e1:SetOperation(s.op1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"I","M")
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_NO_TURN_RESET)
	e2:SetCategory(CATEGORY_DEFCHANGE)
	e2:SetCL(1)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
end
function s.nfil1(c)
	return c:IsSetCard("초월하여") and c:IsMonster() and c:IsAbleToGraveAsCost() and not c:IsCode(id)
end
function s.con1(e,c)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	return Duel.GetFieldGroupCount(tp,LSTN("M"),0)==0 and Duel.GetLocCount(tp,"M")>0
		and Duel.IEMCard(s.nfil1,tp,"D",0,1,nil)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SMCard(tp,s.nfil1,tp,"D",0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function s.tfil2(c)
	return c:IsSetCard("초월하여") and c:IsFaceup()
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chk:IsLoc("M") and chkc:IsControler(tp) and s.tfil2(chkc)
	end
	if chk==0 then
		return Duel.IETarget(s.tfil2,tp,"M",0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.STarget(tp,s.tfil2,tp,"M",0,1,1,nil)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=MakeEff(c,"S")
		e1:SetCode(EFFECT_SET_DEFENSE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(0)
		tc:RegisterEffect(e1)
	end
end
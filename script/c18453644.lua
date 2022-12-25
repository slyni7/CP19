--문명을 초월하여
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	local e1=MakeEff(c,"F","G")
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.con1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"I","M")
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_NO_TURN_RESET)
	e2:SetCategory(CATEGORY_DEFCHANGE)
	e2:SetCL(1)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"S")
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e3)
end
function s.nfil1(c)
	return c:IsSetCard("초월하여") and c:IsFaceup() and not c:IsCode(id)
end
function s.con1(e,c)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	return Duel.GetLocCount(tp,"M")>0 and Duel.IEMCard(s.nfil1,tp,"M",0,1,nil)
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
		local def=tc:GetDefense()
		local val
		if def>=1000 then
			val=def-1000
		else
			val=def+1000
		end
		local e1=MakeEff(c,"S")
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(val)
		tc:RegisterEffect(e1)
	end
end
--가변기수 러너드래곤
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetD(id,0)
	e1:SetCondition(s.con1)
	e1:SetOperation(s.op1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_PROC)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"Qo","M")
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCL(1)
	WriteEff(e3,3,"TO")
	c:RegisterEffect(e3)
end
function s.con1(e,c,minc)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	return minc==0 and c:GetLevel()>4 and Duel.GetLocCount(tp,"M")>0
end
function s.op1(e,tp,eg,ep,ev,re,r,rp,c)
	local e1=MakeEff(c,"S","M")
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE-RESET_TOFIELD)
	e1:SetValue(700)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	e2:SetValue(500)
	c:RegisterEffect(e2)
end
function s.tfil3(c)
	return c:IsFaceup() and c:IsSetCard("가변기수")
		and c:GetTextAttack()==c:GetBaseAttack()*2 and c:GetTextDefense()==c:GetBaseDefense()*2
end
function s.tar3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLoc("M") and chkc:IsControler(tp) and s.tfil3(chkc)
	end
	if chk==0 then
		return Duel.IETarget(s.tfil3,tp,"M",0,1,nil)
	end
	Duel.STarget(tp,s.tfil3,tp,"M",0,1,1,nil)
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsImmuneToEffect(e) then
		local e1=MakeEff(c,"S")
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(tc:GetTextAttack()*2)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_BASE_DEFENSE)
		e2:SetValue(tc:GetTextDefense()*2)
		tc:RegisterEffect(e2)
		local e3=MakeEff(c,"FC","M")
		e3:SetCode(EVENT_PHASE+PHASE_END)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e3:SetCL(1)
		e3:SetOperation(s.oop33)
		c:RegisterEffect(e3)
	end
end
function s.oop33(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Destroy(c,REASON_EFFECT)
end
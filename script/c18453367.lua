--가변기수 화나드래곤
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
	local e3=MakeEff(c,"I","M")
	e3:SetCategory(CATEGORY_SEARCH)
	e3:SetCL(1,id)
	WriteEff(e3,3,"CTO")
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(id,ACTIVITY_SPSUMMON,s.afil1)
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
	e1:SetValue(1300)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	e2:SetValue(1500)
	c:RegisterEffect(e2)
end
function s.afil1(c)
	return c:IsLevelAbove(7) or c:IsRankAbove(7)
end
function s.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.CheckLPCost(tp,1500) and Duel.GetCustomActivityCount(id,tp,ACTIVITY_SPSUMMON)==0
	end
	Duel.PayLPCost(tp,1500)
	local e1=MakeEff(c,"F")
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTR(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(s.ctar31)
	Duel.RegisterEffect(e1,tp)
end
function s.ctar31(e,c)
	return not c:IsLevelAbove(7) and not c:IsRankAbove(7)
end
function s.tfil3(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function s.tar3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then
		return c:GetTextAttack()==c:GetBaseAttack() and c:GetTextDefense()==c:GetBaseDefense()
			and Duel.IEMCard(s.tfil3,tp,"D",0,3,nil)
	end
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then
		return
	end
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(1300)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	e2:SetValue(1500)
	c:RegisterEffect(e2)
	Duel.BreakEffect()
	local g=Duel.GMGroup(s.tfil3,tp,"D",0,nil)
	if #g<3 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg=g:Select(tp,3,3,nil)
	Duel.ConfirmCards(1-tp,sg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=sg:Select(1-tp,1,1,nil)
	Duel.SendtoHand(tg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tg)
end
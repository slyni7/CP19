--코인비터 체인소우
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"FTo","H")
	e1:SetCode(EVENT_TOSS_COIN)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"F","M")
	e2:SetCode(EFFECT_COINBEAT_EFFECT)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetOperation(s.op2)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"FTf","M")
	e3:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e3:SetCategory(CATEGORY_COIN+CATEGORY_RECOVER+CATEGORY_DRAW)
	e3:SetCL(1)
	WriteEff(e3,3,"NTO")
	c:RegisterEffect(e3)
end
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocCount(tp,"M")>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.ofil2(c)
	return c:IsAttackPos() and c:IsCanChangePosition()
end
function s.op2(e,tp)
	local result=true
	local g=Duel.GMGroup(s.ofil2,tp,"M",0,nil)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
		local sg=g:Select(tp,1,1,nil)
		local prop=e:GetProperty()
		e:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		Duel.ChangePosition(sg,POS_FACEUP_DEFENSE)
		e:SetProperty(prop)
	else
		result=false
	end
	return result
end
function s.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.IsTurnPlayer(tp) and c:GetAttackedCount()>0
end
function s.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	local res=Duel.CallCoin(tp)
	if res then
		Duel.Draw(tp,1,REASON_EFFECT)
	else
		Duel.Recover(tp,1000,REASON_EFFECT)
	end
	res=Duel.CallCoin(1-tp)
	if res then
		Duel.Draw(1-tp,1,REASON_EFFECT)
	else
		Duel.Recover(1-tp,1000,REASON_EFFECT)
	end
end
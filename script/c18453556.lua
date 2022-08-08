--쇼팽 에튀드 10-12 혁명
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e1:SetCondition(s.con1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"A")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DRAW)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
end
function s.con1(e)
	local c=e:GetHandler()
	return c:IsPublic()
end
function s.tfil2(c)
	return c:IsRace(RACE_INSECT) and c:IsFaceup()
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(tp) and chkc:IsLoc("M") and s.tfil2(chkc)
	end
	if chk==0 then
		return Duel.IETarget(s.tfil2,tp,"M",0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.STarget(tp,s.tfil2,tp,"M",0,1,1,nil)
	Duel.SPOI(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetTurnCount()
	if not Duel.FractionDraw(tp,{ct,3},REASON_EFFECT) then
		return
	end
	Duel.BreakEffect()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() then
		return
	end
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetValue(tc:GetAttack()*2)
	tc:RegisterEffect(e1)
	local e2=MakeEff(c,"S")
	e2:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e2:SetValue(HALF_DAMAGE)
	tc:RegisterEffect(e2)
	tc:RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD&~(RESET_LEAVE|RESET_TODECK|RESET_TEMP_REMOVE|RESET_REMOVE|RESET_TOGRAVE)+RESET_PHASE+PHASE_END,0,1)
	local e3=MakeEff(c,"FC")
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetLabelObject(tc)
	e3:SetReset(RESET_PHASE+PHASE_END)
	e3:SetCondition(s.ocon23)
	e3:SetOperation(s.oop23)
	Duel.RegisterEffect(e3,tp)
end
function s.ocon23(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return eg:IsContains(tc) and tc:GetFlagEffect(id)~=0
end
function s.oop23(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local bc=tc:GetBattleTarget()
	if bc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocCount(tp,"M")>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.SpecialSummon(bc,0,tp,tp,false,false,POS_FACEUP)
	end
end

--가변기수 스나드래곤
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Xyz.AddProcedure(c,nil,7,2,s.pfil1,aux.Stringid(id,0),2,s.pop1)
	local e1=MakeEff(c,"I","M")
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	WriteEff(e1,1,"NCTO")
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	WriteEff(e2,2,"N")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"FTf","M")
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_DISABLE)
	WriteEff(e3,3,"NCTO")
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
end
function s.pfil1(c,tp,lc)
	return c:IsFaceup() and c:IsSetCard("가변기수") and c:IsSummonType(SUMMON_TYPE_NORMAL)
end
function s.pop1(e,tp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetFlagEffect(tp,id)==0
	end
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
	local e1=MakeEff(c,"S","M")
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE-RESET_TOFIELD)
	e1:SetValue(1400)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	e2:SetValue(1400)
	c:RegisterEffect(e2)
	return true
end
function s.nfil1(c)
	return c:IsSetCard("가변기수") and c:IsType(TYPE_MONSTER)
end
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:GetOverlayGroup():IsExists(s.nfil1,1,nil)
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:CheckRemoveOverlayCard(tp,1,REASON_COST) and c:GetFlagEffect(id)==0
	end
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
	c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function s.tfil1(c,e,tp)
	return c:IsSetCard("가변기수") and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IEMCard(s.tfil1,tp,"D",0,1,nil,e,tp) and Duel.GetLocCount(tp,"M")>0
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"D")
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocCount(tp,"M")<1 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SMCard(tp,s.tfil1,tp,"D",0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=MakeEff(c,"S","M")
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		e1:SetValue(tc:GetTextAttack()/2)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_BASE_DEFENSE)
		e2:SetValue(tc:GetTextDefense()/2)
		tc:RegisterEffect(e2)
		Duel.SpecialSummonComplete()
	end
end
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetOverlayGroup():IsExists(s.nfil1,1,nil)
end
function s.nfil3(c,tp)
	return c:IsFaceup() and c:IsSetCard("가변기수") and c:IsControler(tp)
end
function s.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return eg:IsExists(s.nfil3,1,nil,tp) and c:GetOverlayGroup():IsExists(s.nfil1,1,nil)
end
function s.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:GetFlagEffect(id+1)==0 and Duel.GetFlagEffect(tp,id+1)==0
	end
	c:RegisterFlagEffect(id+1,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	Duel.RegisterFlagEffect(tp,id+1,RESET_CHAIN,0,1)
end
function s.tfil3(c,g)
	return c:IsFaceup() and c:IsSetCard("가변기수") and g:IsContains(c)
		and c:GetTextAttack()==c:GetBaseAttack()*2 and c:GetTextDefense()==c:GetBaseDefense()*2
end
function s.tar3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLoc("M") and chkc:IsControler(tp) and s.tfil3(chkc,eg)
	end
	if chk==0 then
		return Duel.IETarget(s.tfil3,tp,"M",0,1,nil,eg)
	end
	Duel.Hint(HINT_SELECMTSG,tp,HINTMSG_FACEUP)
	Duel.STarget(tp,s.tfil3,tp,"M",0,1,1,nil,eg)
end
function s.ofil3(c,atk)
	return c:IsFaceup() and not c:IsDisabled() and c:IsType(TYPE_EFFECT) and c:GetAttack()<atk
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:GetOverlayGroup():IsExists(s.nfil1,1,nil) then
		return
	end
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) or tc:IsFacedown() then
		return
	end
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(tc:GetTextAttack())
	tc:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	e2:SetValue(tc:GetTextDefense())
	tc:RegisterEffect(e2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SMCard(tp,s.ofil3,tp,"M","M",0,1,nil,tc:GetAttack())
	local sc=g:GetFirst()
	if sc then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e3=MakeEff(c,"S")
		e3:SetCode(EFFECT_DISABLE)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		sc:RegisterEffect(e3)
		local e4=MakeEff(c,"S")
		e4:SetCode(EFFECT_DISABLE_EFFECT)
		e4:SetValue(RESET_TURN_SET)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		sc:RegisterEffect(e4)
	end
end
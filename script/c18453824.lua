--Kyrie Eleison
local s,id=GetID()
function s.initial_effect(c)
	local e0=MakeEff(c,"FC","HG")
	e0:SetCode(EFFECT_KYRIE_ELEISON)
	c:RegisterEffect(e0)
	local e1=MakeEff(c,"S","HG")
	e1:SetCode(EFFECT_KYRIE_ELEISON)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"S")
	e2:SetCode(EFFECT_DEFENSE_ATTACK)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"SC")
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	WriteEff(e3,3,"O")
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"S")
	e4:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e4)
	local e5=MakeEff(c,"S")
	e5:SetCode(EFFECT_EXTRA_ATTACK)
	e5:SetValue(2)
	c:RegisterEffect(e5)
	local e6=MakeEff(c,"S","M")
	e6:SetCode(EFFECT_UPDATE_ATTACK)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetValue(1850)
	c:RegisterEffect(e6)
	local e7=MakeEff(c,"S","M")
	e7:SetCode(EFFECT_UPDATE_DEFENSE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetValue(1450)
	c:RegisterEffect(e7)
	local e8=MakeEff(c,"SC","H")
	e8:SetCode(EFFECT_SEND_REPLACE)
	e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e8:SetTarget(s.tar8)
	c:RegisterEffect(e8)
	local e9=MakeEff(c,"SC","M")
	e9:SetCode(EFFECT_SEND_REPLACE)
	e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e9:SetTarget(s.tar9)
	c:RegisterEffect(e9)
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsLoc("H") then
		Duel.ConfirmCards(1-tp,c)
		local e1=MakeEff(c,"S")
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
		c:RegisterEffect(e1)
	end
end
function s.tar8(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocCount(tp,"M")>0
	end
	if Duel.SelectEffectYesNo(tp,c,96) then
		Duel.MoveToField(c,tp,tp,LSTN("M"),POS_FACEUP,true)
		return true
	else
		return false
	end
end
function s.tfil91(c,e,tp)
	local handler=e:GetHandler()
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsReleasableByEffect(e) and not c:IsImmuneToEffect(e)
		and not c:IsReason(REASON_REPLACE)
		and (c:IsFaceup() or c:IsControler(tp))
		and Duel.IEMCard(s.tfil92,tp,"MD","M",1,Group.FromCards(c,handler),e,tp)
end
function s.tfil92(c,e,tp)
	return c:IsRace(RACE_FAIRY) and c:IsReleasableByEffect(e) and not c:IsImmuneToEffect(e)
		and not c:IsReason(REASON_REPLACE)
		and (c:IsFaceup() or c:IsControler(tp))
end
function s.tar9(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IEMCard(s.tfil91,tp,"MD","M",1,c,e,tp)
	end
	if Duel.SelectEffectYesNo(tp,c,96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g1=Duel.SMCard(tp,s.tfil91,tp,"MD","M",1,1,c,e,tp)
		local tc=g1:GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g2=Duel.SMCard(tp,s.tfil92,tp,"MD","M",1,1,Group.FromCards(c,tc),e,tp)
		g1:Merge(g2)
		Duel.SendtoGrave(g1,REASON_RELEASE+REASON_EFFECT+REASON_REPLACE)
		return true
	else
		return false
	end
end
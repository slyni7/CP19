--레이트 블루문
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCL(1,id,EFFECT_COUNT_CODE_OATH)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocCount(tp,"M")>0
			and Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,0x11,1850,1000,4,RACE_SPELLCASTER,ATTRIBUTE_WATER)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocCount(tp,"M")<1 then
		return
	end
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,0x11,1850,1000,4,RACE_SPELLCASTER,ATTRIBUTE_WATER) then
		c:AddMonsterAttribute(TYPE_NORMAL)
		Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP)
		local e1=MakeEff(c,"S","M")
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(4)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_BASE_ATTACK)
		e2:SetValue(1850)
		c:RegisterEffect(e2)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_SET_BASE_DEFENSE)
		e3:SetValue(1000)
		c:RegisterEffect(e3)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_CHANGE_RACE)
		e4:SetValue(RACE_SPELLCASTER)
		c:RegisterEffect(e4)
		local e5=e1:Clone()
		e5:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e5:SetValue(ATTRIBUTE_WATER)
		c:RegisterEffect(e5)
		Duel.SpecialSummonComplete()
	end
	local token=Duel.CreateToken(tp,id)
	local e1=MakeEff(token,"Qo")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetReset(RESET_PHASE+PHASE_END,3)
	e1:SetCL(1,id)
	e1:SetLabel(Duel.GetTurnCount())
	e1:SetCost(s.ocost11)
	Duel.RegisterEffect(e1,tp)
end
function s.ocfil11(c,tp)
	return Duel.GetMZoneCount(tp,c,tp,LOCATION_REASON_CONTROL)>0
		and Duel.IETarget(aux.FaceupFilter(Card.IsControlerCanBeChanged,true),tp,0,"M",1,c)
		and c:IsSetCard("레이트 블루")
end
function s.ocost11(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.GetFlagEffect(tp,id-20000)==0
		and Duel.IEMCard(s.otfil11,tp,"D",0,1,nil)
	local b2=Duel.GetFlagEffect(tp,id-10000)==0
		and Duel.CheckReleaseGroupCost(tp,s.ocfil11,1,false,nil,nil,tp)
	if chk==0 then
		return (Duel.GetTurnCount()~=e:GetLabel() or Duel.IsPlayerAffectedByEffect(tp,18453867))
			and (b1 or b2)
	end
	if Duel.GetTurnCount()==e:GetLabel() then
		local te=Duel.IsPlayerAffectedByeffect(tp,18453867)
		local tc=te:GetHandler()
		tc:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	end
	local op=Duel.SelectEffect(tp,
		{b1,aux.Stringid(id,0)},
		{b2,aux.Stringid(id,1)})
	if op==1 then
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,0))
		Duel.RegisterFlagEffect(tp,id-20000,RESET_PHASE+PHASE_END,0,2)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e:SetCategory(CATEGORY_CONTROL)
		local rg=Duel.SelectReleaseGroupCost(tp,s.ocfil11,1,1,false,nil,nil,tp)
		Duel.Release(rg,REASON_COST)
		e:SetTarget(s.otar11)
		e:SetOperation(s.oop11)
	elseif op==2 then
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,1))
		Duel.RegisterFlagEffect(tp,id-10000,RESET_PHASE+PHASE_END,0,1)
		e:SetProperty(0)
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e:SetTarget(s.otar12)
		e:SetOperation(s.oop12)
	else
		e:SetCategory(0)
		e:SetProperty(0)
		e:SetTarget(s.otar13)
		e:SetOperation(s.oop13)
	end
end
function s.otfil11(c)
	return c:IsSetCard("레이트 블루머") and c:IsAbleToGrave() and not c:IsCode(id)
end
function s.oop11(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.GetControl(tc,tp,PHASE_END,1) and tc:IsFaceup() then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=MakeEff(c,"S")
		e1:SetCode(EFFECT_DISABLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=MakeEff(c,"S")
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		local e3=MakeEff(c,"S")
		e3:SetCode(EFFECT_SET_ATTACK)
		e3:SetValue(1850)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)
		local e4=MakeEff(c,"S")
		e4:SetCode(EFFECT_CHANGE_CODE)
		e4:SetValue(18453865)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e4)
	end
end
function s.otfil12(c)
	return c:IsSetCard("레이트 블루머") and c:IsLinkSummonable()
end
function s.oop12(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GMGroup(s.otfil12,tp,"E",0,nil)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=g:Select(tp,1,1,nil)
		Duel.LinkSummon(tp,tg:GetFirst())
	end
end
function s.oop13(e,tp,eg,ep,ev,re,r,rp)
end
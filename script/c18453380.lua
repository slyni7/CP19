--스노윙 치킨
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCondition(s.con1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"A")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"Qo","G")
	e3:SetCode(EVENT_FREE_CHAIN)
	WriteEff(e3,3,"CO")
	c:RegisterEffect(e3)
end
function s.con1(e)
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	return Duel.IEMCard(aux.TRUE,tp,0,"O",1,nil) and not Duel.IEMCard(aux.TRUE,tp,"O",0,1,c)
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocCount(tp,"M")>0 and e:IsHasType(EFFECT_TYPE_ACTIVATE) 
			and Duel.IsPlayerCanSpecialSummonMonster(tp,id,0x0,0x21,0,3000,10,RACE_WINGEDBEAST,ATTRIBUTE_WATER)
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocCount(tp,"M")<=0 then
		return
	end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,id,0x0,0x21,0,3000,10,RACE_WINGEDBEAST,ATTRIBUTE_WATER) then
		c:AddMonsterAttribute(TYPE_NORMAL)
		Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP_DEFENSE)
		local e1=MakeEff(c,"F","M")
		e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
		e1:SetTR("M",0)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetTarget(s.otar21)
		e1:SetValue(aux.tgoval)
		c:RegisterEffect(e1)
		c:AddMonsterAttributeComplete()
		Duel.SpecialSummonComplete()
	end
end
function s.otar21(e,c)
	return c:GetCode()~=id
end
function s.cfil3(c,tp)
	if Duel.GetLocCount(tp,"S")>0 then
		return c:IsSetCard("치킨") and c:IsFaceup() and c:IsAbleToGraveAsCost() and not c:IsCode(id)
	else
		return c:IsLoc("S") and c:GetSequence()<5
			and c:IsSetCard("치킨") and c:IsFaceup() and c:IsAbleToGraveAsCost() and not c:IsCode(id)
	end
end
function s.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsSSetable(true) and Duel.IEMCard(s.cfil3,tp,"O",0,1,nil,tp) and Duel.GetLocCount(tp,"S")>=0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SMCard(tp,s.cfil3,tp,"O",0,1,1,nil,tp)
	Duel.SendtoGrave(g,REASON_COST)
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SSet(tp,c)
	end
end
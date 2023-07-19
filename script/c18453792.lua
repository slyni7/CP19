--인디펜던트 바디
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddDelightProcedure(c,s.pfil1,1,1)
	local e1=MakeEff(c,"F","M")
	e1:SetCode(EFFECT_ADD_TYPE)
	e1:SetTR("M","M")
	e1:SetTarget(s.tar1)
	e1:SetValue(TYPE_NORMAL)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"F","M")
	e2:SetCode(EFFECT_REMOVE_TYPE)
	e2:SetTR("M","M")
	e2:SetTarget(s.tar1)
	e2:SetValue(TYPE_EFFECT)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"F","M")
	e3:SetCode(EFFECT_SPSUMMON_COST)
	e3:SetTR(0xff,0xff)
	e3:SetCost(s.cost3)
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"F","M")
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTR(1,1)
	e4:SetTarget(s.tar4)
	c:RegisterEffect(e4)
	local e5=MakeEff(c,"FC","M")
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	WriteEff(e5,5,"O")
	c:RegisterEffect(e5)
	local e6=MakeEff(c,"FC","M")
	e6:SetCode(EVENT_SPSUMMON)
	WriteEff(e6,6,"O")
	c:RegisterEffect(e6)
	local e7=MakeEff(c,"FC","M")
	e7:SetCode(EVENT_SPSUMMON_NEGATED)
	WriteEff(e7,7,"O")
	c:RegisterEffect(e7)
end
s.custom_type=CUSTOMTYPE_DELIGHT
function s.pfil1(c)
	local tp=c:GetControler()
	return c:IsSummonType(SUMMON_TYPE_NORMAL) and not Duel.IEMCard(nil,tp,"M",0,1,c) and c:IsLoc("M")
end
function s.tar1(e,c)
	local mg=c:GetMaterial()
	return mg:IsExists(Card.IsOriginalType,1,nil,TYPE_NORMAL)
end
function s.vfil3(c)
	return c:IsType(TYPE_NORMAL) or c:IsSummonType(SUMMON_TYPE_NORMAL)
end
function s.cost3(e,c,tp)
	local sp=c:GetControler()
	local ec=e:GetHandler()
	local g=Duel.GMGroup(s.vfil3,sp,"M",0,nil)
	return ec:GetFlagEffect(id+sp)<#g
end
function s.tar4(e,c,tp)
	local ec=e:GetHandler()
	local g=Duel.GMGroup(s.vfil3,tp,"M",0,nil)
	return ec:GetFlagEffect(id+tp)>=#g
end
function s.op5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not eg:IsContains(c) and ((re and re:IsHasType(EFFECT_TYPE_ACTIONS)) or Duel.GetCurrentChain()>0) then
		c:RegisterFlagEffect(id+ep,RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD,0,1)
	end
end
function s.op6(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetCurrentChain()==0 then
		c:RegisterFlagEffect(id+ep,RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD,0,1)
	end
end
function s.op7(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:ResetFlagEffect(id+ep)
end
--데몬 소환승 프리스트
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddSkullProcedure(c,s.pfil1,aux.FilterBoolFunction(Card.IsLevel,4),nil)
	local e1=MakeEff(c,"FC","M")
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	WriteEff(e1,1,"NO")
	c:RegisterEffect(e1)
end
s.custom_type=CUSTOMTYPE_SKULL
function s.pfil1(c)
	return c:IsSetCard(0x45) and c:IsLevel(4) and c:IsType(TYPE_NORMAL)
end
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_SKULL) and eg:IsContains(c)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=eg:GetFirst()
	while tc do
		local e1=MakeEff(c,"S")
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=eg:GetNext()
	end
end
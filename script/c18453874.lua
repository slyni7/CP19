--¸ÞÄ« ÇåÅÍ ¿À·ÎÄ¡
local s,id=GetID()
function s.initial_effect(c)
	Xyz.AddProcedure(c,nil,4,2,s.pfil1,aux.Stringid(id,0),2,s.pop1)
	c:EnableReviveLimit()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCondition(s.effcon)
	c:RegisterEffect(e2)
	--summon success
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(s.effcon2)
	e3:SetOperation(s.spsumsuc)
	c:RegisterEffect(e3)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(aux.dxmcostgen(1,1,s.slwc))
	e2:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then
			return not Duel.IsPlayerAffectedByEffect(tp,id)
		end
	end)
	e2:SetOperation(s.op2)
	c:RegisterEffect(e2)
end
function s.pfil1(c,tp,lc)
	return c:IsFaceup() and c:IsSetCard("¸ÞÄ« ÇåÅÍ")
end
function s.pop1(e,tp,chk)
	if chk==0 then
		return Duel.GetFlagEffect(tp,id)==0
	end
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
	return true
end
function s.effcon(e)
	local c=e:GetHandler()
	return c:GetSummonType()==SUMMON_TYPE_XYZ
		and c:GetOverlayGroup():IsExists(Card.IsAttack,1,nil,1850)
end
function s.effcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetSummonType()==SUMMON_TYPE_XYZ
		and c:GetOverlayGroup():IsExists(Card.IsAttack,1,nil,1850)
end
function s.spsumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimitTillChainEnd(aux.FALSE)
end
function s.slwc(e,og)
	if og:GetFirst():IsSetCard("¸ÞÄ« ÇåÅÍ") then
		Duel.SetChainLimit(aux.FALSE)
	end
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=MakeEff(c,"F")
	e1:SetCode(id)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTR(1,0)
	Duel.RegisterEffect(e1,tp)
	local e2=MakeEff(c,"FC")
	e2:SetCode(EVENT_ADJUST)
	e2:SetLabel(0)
	e2:SetOperation(s.oop22)
	Duel.RegisterEffect(e2,tp)
end
function s.oop22(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==1850 then
		e:Reset()
	end
	if Duel.GetLocCount(tp,"M")>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,7359741,0,0x11,1850,800,4,RACE_MACHINE,ATTRIBUTE_DARK) then
		local token=Duel.CreateToken(tp,7359741)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP_ATTACK)
		e:SetLabel(e:GetLabel()+1)
	end
	
end
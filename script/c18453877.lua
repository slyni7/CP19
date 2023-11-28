--신천지의 푸른 들판
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"F","HG")
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCL(1,id)
	e1:SetCondition(s.con1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"F","M")
	e2:SetCode(id)
	e2:SetTR("M","M")
	c:RegisterEffect(e2)
	if not s.global_check then
		s.global_check=true
		local ge1=MakeEff(c,"FC")
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(s.gop1)
		Duel.RegisterEffect(e1,0)
	end
end
function s.gop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		local tatk=tc:GetTextAttack()
		local tre=tc:GetReasonEffect()
		if tc:IsReason(REASON_COST) and tre and tre:IsActivated() then
			local trc=tre:GetHandler()
			if (tc:GetPreviousAttributeOnField()&ATTRIBUTE_LIGHT>0
				or (tc:GetPreviousLocation()&LOCATION_ONFIELD==0 and tc:GetOriginalAttribute()&ATTRIBUTE_LIGHT>0))
				and trc and trc:IsLoc("M") and trc:IsSummonType(SUMMON_TYPE_SPECIAL) and tatk>0 then
				local e1=Effect.CreateEffect(tc)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(CARD_NEW_HEAVEN_AND_EARTH)
				e1:SetRange(LOCATION_MZONE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
				e1:SetCondition(function(e)
					local c=e:GetHandler()
					return c:IsHasEffect(id)
				end)
				e1:SetValue(tatk)
				trc:RegisterEffect(e1)
			end
		end
		tc=eg:GetNext()
	end
end
function s.nfil1(c)
	return c:IsFaceup() and c:IsCode(CARD_NEW_HEAVEN_AND_EARTH)
end
function s.con1(e,c)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	return Duel.GetLocCount(tp,"M")>0 and Duel.IEMCard(s.nfil1,tp,"O",0,1,nil)
end
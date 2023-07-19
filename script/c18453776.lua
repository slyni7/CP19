--We still are made of greed
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetHintTiming(TIMING_END_PHASE)
	WriteEff(e1,1,"O")
	c:RegisterEffect(e1)
	aux.GlobalCheck(s,function()
		s[0]=0
		s[1]=0
		aux.AddValuesReset(function()
			s[0]=0
			s[1]=0
		end)
		local ge1=MakeEff(c,"FC")
		ge1:SetCode(EVENT_BE_CUSTOM_MATERIAL)
		ge1:SetOperation(s.gop1)
		Duel.RegisterEffect(ge1,0)
	end)
end
function s.gop1(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		local pl=tc:GetPreviousLocation()
		if pl==LOCATION_MZONE and tc:IsReason(REASON_RELEASE+REASON_MATERIAL) and r&CUSTOMREASON_SKULL==CUSTOMREASON_SKULL then
			local p=tc:GetReasonPlayer()
			s[p]=s[p]+1
		end
	end
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=MakeEff(c,"FC")
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetOperation(s.oop11)
	Duel.RegisterEffect(e1,tp)
end
function s.oop11(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	Duel.Draw(tp,s[tp],REASON_EFFECT)
end

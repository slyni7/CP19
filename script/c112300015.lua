--비상하는 희망의 투혼
function c112300015.initial_effect(c)
	--Activate
	local e1=aux.AddRitualProcEqual2(c,c112300015.filter,nil,nil,c112300015.mfilter)
	e1:SetCountLimit(1,112300015+EFFECT_COUNT_CODE_OATH)
end
function c112300015.filter(c)
	return c:IsSetCard(0xc2a)
end
function c112300015.mfilter(c)
	return c:IsRace(RACE_PSYCHO)
end
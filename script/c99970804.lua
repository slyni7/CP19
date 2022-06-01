--[ YUGIOH ]
local m=99970804
local cm=_G["c"..m]
function cm.initial_effect(c)

	--융합 소환
	RevLim(c)
	aux.AddFusionProcFunRep(c,cm.ffilter,3,true)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(cm.hspcon)
	e2:SetTarget(cm.hspop)
	c:RegisterEffect(e2)

	--"유희"
	local e0=MakeEff(c,"FC","E")
	e0:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e0:SetCode(EVENT_ADJUST)
	WriteEff(e0,0,"O")
	c:RegisterEffect(e0)
	local e9=MakeEff(c,"F","M")
	e9:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e9:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e9:SetTargetRange(0,1)
	e9:SetTarget(cm.sumlimit)
	c:RegisterEffect(e9)
	local e10=e9:Clone()
	e10:SetCode(EFFECT_CANNOT_SUMMON)
	c:RegisterEffect(e10)
	local e11=e9:Clone()
	e11:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	c:RegisterEffect(e11)
	
end

--융합 소환
function cm.ffilter(c)
	return c:IsLevelBelow(6)
end
function cm.hspcon(e,c)
	if c==nil then return true end
	local tp=e:GetHandlerPlayer()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function cm.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local d1,d2,d3=Duel.TossDice(tp,3)
	local ct=d1+d2+d3
	if ct>=10 then Duel.SetLP(1-tp,Duel.GetLP(1-tp)-ct*400)
	else return true end
	return false
end

--"유희"
function cm.op0(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(m,1))then
		Duel.Hint(HINT_CARD,0,m)
		local nope=true
		while nope do
			nope=false
			local num=Duel.AnnounceNumber(tp,table.unpack({1,2,3,4,5,6}))
			local d1,d2,d3,d4,d5=Duel.TossDice(1-tp,5)
			if num~=d1 or num~=d2 or num~=d3 or num~=d4 or num~=d5 then nope=true end
		end
		Duel.SetLP(tp,Duel.GetLP(tp)-1000)
	end
end
function cm.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	if sumpos and bit.band(sumpos,POS_FACEDOWN)>0 then return false end
	return true
end

--[ YUGIOH ]
local m=99970801
local cm=_G["c"..m]
function cm.initial_effect(c)

	--융합 소환
	RevLim(c)
	aux.AddFusionProcFun2(c,aux.FBF(Card.IsFusionType,TYPE_EFFECT),cm.ffilter2,true)
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
	e2:SetOperation(cm.hspop)
	c:RegisterEffect(e2)
	
	--"유희"
	local e0=MakeEff(c,"FC","E")
	e0:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e0:SetCode(EVENT_ADJUST)
	WriteEff(e0,0,"O")
	c:RegisterEffect(e0)
	local e9=MakeEff(c,"FC","M")
	e9:SetCode(EVENT_CHAIN_ACTIVATING)
	WriteEff(e9,9,"O")
	c:RegisterEffect(e9)
	
end

--융합 소환
function cm.ffilter2(c)
	return c:IsFaceup() and c:IsDisabled()
end
function cm.hspcon(e,c)
	if c==nil then return true end
	local tp=e:GetHandlerPlayer()
	return Duel.GetLocationCount(1-tp,LOCATION_MZONE,PLAYER_NONE,0)+Duel.GetLocationCount(1-tp,LOCATION_SZONE,PLAYER_NONE,0)>0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function cm.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	e1:SetOperation(cm.disop)
	e1:SetReset(0)
	Duel.RegisterEffect(e1,tp)
end
function cm.disop(e,tp)
	local c=Duel.GetLocationCount(1-tp,LOCATION_MZONE,PLAYER_NONE,0)+Duel.GetLocationCount(1-tp,LOCATION_SZONE,PLAYER_NONE,0)
	local dis1=Duel.SelectDisableField(tp,1,0,LOCATION_ONFIELD,0)
	if c>1 and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
		local dis2=Duel.SelectDisableField(tp,1,0,LOCATION_ONFIELD,dis1)
		dis1=(dis1|dis2)
		if c>2 and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
			local dis3=Duel.SelectDisableField(tp,1,0,LOCATION_ONFIELD,dis1)
			dis1=(dis1|dis3)
			if c>3 and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
				local dis4=Duel.SelectDisableField(tp,1,0,LOCATION_ONFIELD,dis1)
				dis1=(dis1|dis4)
				if c>4 and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
					local dis5=Duel.SelectDisableField(tp,1,0,LOCATION_ONFIELD,dis1)
					dis1=(dis1|dis5)
				end
			end
		end
	end
	return dis1
end

--"유희"
function cm.op0(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(m,1))then
		Duel.Hint(HINT_CARD,0,m)
		for i=1,50000 do
			Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(m,2))
		end
		Duel.SetLP(tp,Duel.GetLP(tp)-1000)
	end
end
function cm.op9(e,tp,eg,ep,ev,re,r,rp)
	if rp~=tp and (re:IsActiveType(TYPE_MONSTER)) or ((re:GetActiveType()==TYPE_SPELL or re:GetActiveType()==TYPE_TRAP)
		and re:IsHasType(EFFECT_TYPE_ACTIVATE)) then
		Duel.ChangeChainOperation(ev,cm.repop)
	end
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
end
--[ YUGIOH ]
local m=99970806
local cm=_G["c"..m]
function cm.initial_effect(c)

	--융합 소환
	RevLim(c)
	aux.AddFusionProcFunRep(c,cm.ffilter,2,true)
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
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EVENT_ADJUST)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(cm.winop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)

end

--융합 소환
function cm.ffilter(c)
	return c:IsLocation(LOCATION_DECK+LOCATION_EXTRA)
end
function cm.hspfil(c)
	return c:GetPreviousLocation()==LOCATION_DECK and c:IsAbleToDeckAsCost()
end
function cm.hspcon(e,c)
	if c==nil then return true end
	local tp=e:GetHandlerPlayer()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.hspfil,tp,0,LSTN("RG"),1,nil)
end
function cm.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(cm.hspfil,tp,0,LSTN("RG"),nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local dg=g:Select(tp,1,#g,nil)
	Duel.SendtoDeck(dg,nil,2,REASON_EFFECT)
end

--"유희"
function cm.op0(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,1-tp,LOCATION_DECK,0,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.Hint(HINT_CARD,0,m)
		for i=1,500 do
			g:Select(1-tp,#g,#g,nil)
		end
		Duel.SetLP(tp,Duel.GetLP(tp)-1000)
	end
end
function cm.winop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLP(1-tp)<=2000 then
		Duel.Win(tp,0x61)--"유희의 왕: 선택"의 효과로 승리했습니다...
	end
end

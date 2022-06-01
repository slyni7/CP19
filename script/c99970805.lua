--[ YUGIOH ]
local m=99970805
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
	e2:SetTarget(cm.hspop)
	c:RegisterEffect(e2)
	
	--"유희"
	local e0=MakeEff(c,"FC","E")
	e0:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e0:SetCode(EVENT_ADJUST)
	WriteEff(e0,0,"O")
	c:RegisterEffect(e0)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_ACTIVATE_COST)
	e8:SetRange(LOCATION_MZONE)
	e8:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e8:SetTargetRange(0,1)
	e8:SetCost(cm.costchk)
	e8:SetOperation(cm.costop)
	c:RegisterEffect(e8)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SUMMON_COST)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_ALL)
	e3:SetCost(cm.costchk)
	e3:SetOperation(cm.costop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_SPSUMMON_COST)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_MSET_COST)
	c:RegisterEffect(e5)
	local e6=e3:Clone()
	e6:SetCode(EFFECT_SSET_COST)
	c:RegisterEffect(e6)
	local e9=e3:Clone()
	e9:SetCode(EFFECT_ATTACK_COST)
	c:RegisterEffect(e9)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(m)
	e7:SetRange(LOCATION_MZONE)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetTargetRange(0,1)
	c:RegisterEffect(e7)

end

--융합 소환
function cm.filter(c,code)
	return c:IsFaceup() and c:IsCode(code)
end
function cm.ffilter(c)
	return not Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_ONFIELD,0,1,nil,c:GetCode())
end
function cm.hspcon(e,c)
	if c==nil then return true end
	local tp=e:GetHandlerPlayer()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function cm.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac=Duel.AnnounceCard(tp)
	if Duel.GetMatchingGroupCount(cm.filter,tp,LOCATION_ONFIELD,0,nil,ac)>0 then Duel.SetLP(1-tp,Duel.GetLP(1-tp)-2000)
	else return true end
	return false
end

--"유희"
function cm.op0(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(m,1))then
		Duel.Hint(HINT_CARD,0,m)
		local nope=true
		local g=Group.CreateGroup()
		local ac=0
		while nope do
			for i=1,12 do
				cm.announce_filter={TYPE_MONSTER,OPCODE_ISTYPE,TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT,OPCODE_AND}
				ac=Duel.AnnounceCard(1-tp,table.unpack(cm.announce_filter))
				g:AddCard(Duel.CreateToken(tp,ac))
			end
			if g:GetClassCount(Card.GetLevel)==12 and g:GetClassCount(Card.GetRace)==12
				and g:GetClassCount(Card.GetAttack)==12 and g:GetClassCount(Card.GetDefense)==12 then
				nope=false
			end
		end
		Duel.SetLP(tp,Duel.GetLP(tp)-1000)
	end
end
function cm.costchk(e,te_or_c,tp)
	local ct=#{Duel.GetPlayerEffect(tp,m)}
	return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_ONFIELD,0,ct,nil)
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end

--[ YUGIOH ]
local m=99970802
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
	local e9=MakeEff(c,"FC","M")
	e9:SetCode(EVENT_TO_GRAVE)
	WriteEff(e9,9,"NO")
	c:RegisterEffect(e9)
	
end

--융합 소환
function cm.ffilter(c)
	return c:GetAttack()%10~=0
end
function cm.hspcon(e,c)
	if c==nil then return true end
	local tp=e:GetHandlerPlayer()
	return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function cm.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local g2=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	Duel.ConfirmCards(tp,g1)
	Duel.ConfirmCards(1-tp,g2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local sg1=g1:Select(tp,1,1,nil)
	local c1=(sg1:GetFirst():GetType()&0x7)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_DISCARD)
	local sg2=g2:Select(1-tp,1,1,nil)
	local c2=(sg2:GetFirst():GetType()&0x7)
	sg1:Merge(sg2)
	Duel.SendtoGrave(sg1,REASON_COST+REASON_DISCARD)
	Duel.ShuffleHand(tp)
	Duel.ShuffleHand(1-tp)
	if c1==c2 then return true end
	return false
end

--"유희"
function cm.op0(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(m,1))then
		Duel.Hint(HINT_CARD,0,m)
		local sg=Group.CreateGroup()
		local ran=YuL.random(1,100)
		for i=1,100 do
			local token=Duel.CreateToken(tp,3027001)
			if i==ran then sg:AddCard(Duel.CreateToken(tp,34694160))
				else sg:AddCard(token)
			end
		end
		Duel.ConfirmCards(1-tp,sg:Filter(Card.IsCode,nil,3027001))
		Duel.ConfirmCards(1-tp,sg:Filter(Card.IsCode,nil,34694160))
		local rg=sg:Select(1-tp,1,1,nil)
		local code=rg:GetFirst():GetCode()
		Duel.Hint(HINT_CARD,0,code)
		if code==34694160 then Duel.SetLP(tp,Duel.GetLP(tp)-1000)
			else Duel.SetLP(1-tp,Duel.GetLP(1-tp)-2000)
		end
	end
end
function cm.con9(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsControler,1,nil,1-tp)
end
function cm.op9(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(1-tp,Duel.GetLP(1-tp)-YuL.random(1,2000))
end

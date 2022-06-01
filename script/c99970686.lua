--[ hololive Gamers ]
local m=99970686
local cm=_G["c"..m]
function cm.initial_effect(c)

	--토큰1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)
	
	--토큰2
	local e2=MakeEff(c,"Qo","G")
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCost(aux.bfgcost)
	WriteEff(e2,2,"N")
	WriteEff(e2,1,"TO")
	c:RegisterEffect(e2)
	
end

--토큰
function cm.con1fil(c)
	return c:IsFaceup() and c:IsCode(m-5)
end
function cm.con1(e)
	return Duel.IsExistingMatchingCard(cm.con1fil,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,m+1,0,TYPES_TOKEN,3000,3000,8,RACE_BEASTWARRIOR,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsPlayerCanSpecialSummonMonster(tp,m+1,0,TYPES_TOKEN,3000,3000,8,RACE_BEASTWARRIOR,ATTRIBUTE_DARK) then
		local token=Duel.CreateToken(tp,m+1)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return eg and eg:GetFirst():IsControler(1-tp) and Duel.GetAttackTarget()==nil
		and Duel.IsExistingMatchingCard(cm.con1fil,tp,LOCATION_ONFIELD,0,1,nil)
end

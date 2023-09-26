--[ Episode# ]
local s,id=GetID()
function s.initial_effect(c)

	YuL.Activate(c)
	
	--1
	local e2=MakeEff(c,"FTo","S")
	e2:SetD(id,0)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCL(1)
	WriteEff(e2,2,"NTO")
	c:RegisterEffect(e2)
	
	--2
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(s.sucop)
	c:RegisterEffect(e1)
	local e4=e1:Clone()
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e4)

	--3
	local e3=MakeEff(c,"I","G")
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetCondition(aux.exccon)
	WriteEff(e3,3,"CTO")
	c:RegisterEffect(e3)

end

--1
function s.con2fil(c,tp)
	return c:IsSetCard(0x5d6e) and c:IsControler(tp) and c:IsSummonType(SUMMON_TYPE_XYZ)
end
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.con2fil,1,nil,tp)
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end

--2
function s.sucfilter(c,tp)
	return c:IsSetCard(0x5d6e) and c:IsControler(tp)
end
function s.sucop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(s.sucfilter,1,nil,tp) then
		Duel.SetChainLimitTillChainEnd(s.chainlm)
	end
end
function s.chainlm(e,rp,tp)
	return tp==rp
end

--3
function s.cost3fil(c)
	return c:IsType(TYPE_XYZ) and c:IsAbleToRemoveAsCost() and c:IsSetCard(0x5d6e)
end
function s.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cost3fil,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.cost3fil,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function s.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsSSetable() then
		Duel.SSet(tp,c)
	end
end

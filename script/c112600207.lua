--루나틱션 행성정렬(그랜드 크로스)
function c112600207.initial_effect(c)
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c112600207.cost2)
	e1:SetTarget(c112600207.damtg)
	e1:SetOperation(c112600207.damop)
	c:RegisterEffect(e1)
	if not c112600207.global_check then
		c112600207.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ATTACK_ANNOUNCE)
		ge1:SetOperation(c112600207.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c112600207.cfilter(c)
	return c:IsSetCard(0x1e8b) and c:IsAbleToRemoveAsCost() and (c:IsLocation(LOCATION_EXTRA) and c:IsFaceup() or c:IsLocation(LOCATION_ONFIELD))
end
function c112600207.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c112600207.cfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,nil)
	if chk==0 then return g:GetClassCount(Card.GetCode)>=7 end
	local rg=Group.CreateGroup()
	for i=1,7 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		if tc then
			rg:AddCard(tc)
			g:Remove(Card.IsCode,nil,tc:GetCode())
		end
	end
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
end
function c112600207.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(7000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,7000)
end
function c112600207.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c112600207.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if tc:IsSetCard(0xe8b) then
		Duel.RegisterFlagEffect(tc:GetControler(),112600207,RESET_PHASE+PHASE_END,0,1)
	end
end
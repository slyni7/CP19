--뱀피어스 루나스피어
--카드군 번호: 0xc98
function c81259080.initial_effect(c)

	--발동시
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c81259080.co1)
	e1:SetTarget(c81259080.tg1)
	e1:SetOperation(c81259080.op1)
	c:RegisterEffect(e1)
	
	--묘지 유발즉시
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_RECOVER+CATEGORY_REMOVE+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(0x10)
	e2:SetCountLimit(1,81259080)
	e2:SetCondition(c81259080.cn2)
	e2:SetTarget(c81259080.tg2)
	e2:SetOperation(c81259080.op2)
	c:RegisterEffect(e2)
end

--발동시
function c81259080.co1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.CheckLPCost(tp,500)
	end
	Duel.PayLPCost(tp,500)
end
function c81259080.tfil0(c)
	return c:IsAbleToGrave() and c:IsSetCard(0xc98) and c:IsType(TYPE_MONSTER)
end
function c81259080.spfil0(c,e,tp)
	return c:IsSetCard(0xc98) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
	and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c81259080.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c81259080.tfil0,tp,0x01,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c81259080.spfil0,tp,0x10,0,1,nil,e,tp)
	if chk==0 then
		return b1 or b2
	end
	local s=0
	if b1 and not b2 then
		s=Duel.SelectOption(tp,aux.Stringid(81259080,2))
	end
	if not b1 and b2 then
		s=Duel.SelectOption(tp,aux.Stringid(81259080,3))+1
	end
	if b1 and b2 then
		s=Duel.SelectOption(tp,aux.Stringid(81259080,2),aux.Stringid(81259080,3))
	end
	e:SetLabel(s)
	if s==0 then
		e:SetCategory(CATEGORY_TOGRAVE)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,0x01)
	else
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x10)
	end
end
function c81259080.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=Duel.GetMatchingGroup(c81259080.tfil0,tp,0x01,0,nil)
	local b2=Duel.GetMatchingGroup(c81259080.spfil0,tp,0x10,0,nil,e,tp)
	if e:GetLabel()==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg1=b1:Select(tp,1,1,nil)
		if #sg1>0 then
			Duel.SendtoGrave(sg1,REASON_EFFECT)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg2=b2:Select(tp,1,1,nil)
		if #sg2>0 then
			Duel.SpecialSummon(sg2,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end

--묘지 유발즉시
function c81259080.cn2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=e:GetHandlerPlayer()
end
function c81259080.cfil0(c)
	return c:IsReleasable() and c:IsSetCard(0xc98) and c:IsType(TYPE_MONSTER)
end
function c81259080.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81259080.cfil0,tp,LOCATION_MZONE,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rg=Duel.SelectMatchingCard(tp,c81259080.cfil0,tp,LOCATION_MZONE,0,1,1,nil)
	local rc=Duel.SendtoGrave(rg,REASON_COST)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(rg:GetFirst():GetBaseAttack())
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rg:GetFirst():GetBaseAttack())
end
function c81259080.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	local p,lp=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Remove(c,POS_FACEUP,REASON_EFFECT) and Duel.Recover(p,lp,REASON_EFFECT)>999  then
		local d=math.floor((lp)/1000)
		if d>0 and Duel.IsPlayerCanDraw(tp,d) and Duel.SelectYesNo(tp,aux.Stringid(81259080,0)) then
			Duel.Draw(tp,d,REASON_EFFECT)
		end
	end
end

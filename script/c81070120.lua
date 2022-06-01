--프리스틴 비트

function c81070120.initial_effect(c)

	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,8170120+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c81070120.spop)
	c:RegisterEffect(e1)
	
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81070120,2))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c81070120.drco)
	e2:SetTarget(c81070120.drtg)
	e2:SetOperation(c81070120.drop)
	c:RegisterEffect(e2)
end

--activate
function c81070120.spopfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	   and ( c:IsType(TYPE_MONSTER) and c:IsSetCard(0xcaa) )
end
function c81070120.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local loc=LOCATION_HAND+LOCATION_GRAVE
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g=Duel.GetMatchingGroup(c81070120.spopfilter,tp,loc,0,nil,e,tp)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(81070120,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP_ATTACK)
		local tc=sg:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
			e1:SetRange(LOCATION_MZONE)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			tc=sg:GetNext()
		end
	end
end
function c81070120.idvl(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end

--draw
function c81070120.drcofilter(c)
	return ( c:IsLocation(LOCATION_HAND) or c:IsFaceup() )
	   and c:IsAbleToGraveAsCost() and c:IsSetCard(0xcaa)
end
function c81070120.drco(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local loc=LOCATION_HAND+LOCATION_ONFIELD
	if chk==0 then return
				Duel.IsExistingMatchingCard(c81070120.drcofilter,tp,loc,0,1,c)
			end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c81070120.drcofilter,tp,loc,0,1,1,c)
	Duel.SendtoGrave(g,REASON_COST)
end

function c81070120.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return
				Duel.IsPlayerCanDraw(tp,1)
			end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end

function c81070120.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end

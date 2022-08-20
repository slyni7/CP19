--CytusII BM(Black Market) Lv.15 iL
function c112600036.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c112600036.matfilter,4,2)
	c:EnableReviveLimit()
	--special summon
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetCondition(c112600036.regcon)
	e0:SetTarget(c112600036.target1)
	e0:SetOperation(c112600036.op)
	c:RegisterEffect(e0)
	--activate from hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xe7f))
	e3:SetTargetRange(LOCATION_HAND,0)
	c:RegisterEffect(e3)
	--A:sp summon
	local ea1=Effect.CreateEffect(c)
	ea1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	ea1:SetType(EFFECT_TYPE_IGNITION)
	ea1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	ea1:SetRange(LOCATION_MZONE)
	ea1:SetDescription(aux.Stringid(112600036,1))
	ea1:SetCountLimit(2,EFFECT_COUNT_CODE_SINGLE)
	ea1:SetCost(c112600036.cost)
	ea1:SetTarget(c112600036.target)
	ea1:SetOperation(c112600036.operation)
	c:RegisterEffect(ea1)
	--A:remove
	local ea2=Effect.CreateEffect(c)
	ea2:SetCategory(CATEGORY_TOGRAVE)
	ea2:SetType(EFFECT_TYPE_IGNITION)
	ea2:SetDescription(aux.Stringid(112600036,2))
	ea2:SetRange(LOCATION_MZONE)
	ea2:SetCountLimit(2,EFFECT_COUNT_CODE_SINGLE)
	ea2:SetCost(c112600036.cost)
	ea2:SetTarget(c112600036.tgtg)
	ea2:SetOperation(c112600036.tgop)
	c:RegisterEffect(ea2)
	--A:draw
	local ea3=Effect.CreateEffect(c)
	ea3:SetCategory(CATEGORY_DRAW)
	ea3:SetDescription(aux.Stringid(112600036,3))
	ea3:SetType(EFFECT_TYPE_IGNITION)
	ea3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	ea3:SetRange(LOCATION_MZONE)
	ea3:SetCountLimit(2,EFFECT_COUNT_CODE_SINGLE)
	ea3:SetCost(c112600036.cost)
	ea3:SetTarget(c112600036.target0)
	ea3:SetOperation(c112600036.operation0)
	c:RegisterEffect(ea3)
end
function c112600036.matfilter(c)
	return c:IsSetCard(0x1e7e) or c:IsSetCard(0xe7f)
end
function c112600036.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c112600036.filter2(c,tp)
	return c:IsSetCard(0xe7f) and c:IsType(TYPE_SPELL) and c:GetActivateEffect():IsActivatable(tp)
end
function c112600036.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c112600036.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) end
end
function c112600036.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimit(aux.FALSE)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(112600036,0))
	local tc=Duel.SelectMatchingCard(tp,c112600036.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
	if tc then
        local tpe=tc:GetType()
		local te=tc:GetActivateEffect()
		local opt=0
		if te then
    	    local con=te:GetCondition()
			local co=te:GetCost()
			local tg=te:GetTarget()
			local op=te:GetOperation()
			Duel.ClearTargetCard()
			e:SetCategory(te:GetCategory())
			e:SetProperty(te:GetProperty())
			local aaa=LOCATION_SZONE
			if tc:IsType(TYPE_FIELD) then
				aaa=LOCATION_FZONE end
			if bit.band(tpe,TYPE_FIELD)~=0 then
				local of=Duel.GetFieldCard(tp,aaa,5)
				if of and Duel.Destroy(of,REASON_RULE)==0 then Duel.SendtoGrave(tc,REASON_RULE) end
			end
			Duel.MoveToField(tc,tp,tp,aaa,POS_FACEUP,true)
		    Duel.Hint(HINT_CARD,0,tc:GetCode())
			tc:CreateEffectRelation(te)
			if bit.band(tpe,TYPE_EQUIP+TYPE_CONTINUOUS+TYPE_FIELD)==0 then
				tc:CancelToGrave(false)
			end
			if co then co(te,tp,eg,ep,ev,re,r,rp,1) end
			if tg then tg(te,tp,eg,ep,ev,re,r,rp,1) end
			local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
			if g then
				local etc=g:GetFirst()
				while etc do
					etc:CreateEffectRelation(te)
					etc=g:GetNext()
				end
			end
			Duel.BreakEffect()
			if op then op(te,tp,eg,ep,ev,re,r,rp) end
			tc:ReleaseEffectRelation(te)
			if etc then
				etc=g:GetFirst()
				while etc do
					etc:ReleaseEffectRelation(te)
					etc=g:GetNext()
				end
			end
		end
	end
end
function c112600036.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c112600036.filter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xe7e) and not c:IsSetCard(0x1e7e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c112600036.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c112600036.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c112600036.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c112600036.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,2,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c112600036.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_MZONE)
end
function c112600036.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsType,1-tp,LOCATION_MZONE,0,nil,TYPE_MONSTER)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
		local sg=g:Select(1-tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.Remove(sg,POS_FACEDOWN,REASON_RULE)
	end
end

function c112600036.target0(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,3) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(3)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,3)
end
function c112600036.operation0(e,tp,eg,ep,ev,re,r,rp,chk)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
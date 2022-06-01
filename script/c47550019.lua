--네파시아 마투사
function c47550019.initial_effect(c)
	local e99=Effect.CreateEffect(c)
	e99:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e99:SetCode(EVENT_SPSUMMON_SUCCESS)
	e99:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e99:SetCondition(c47550019.con1)
	e99:SetOperation(c47550019.op1)
	c:RegisterEffect(e99)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,c47550019.lcheck)
	c:EnableReviveLimit()

	--attribute dark
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e0:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e0:SetCondition(c47550019.eqcon)
	e0:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e0)

	--light:special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c47550019.spcost)
	e1:SetCondition(c47550019.spcon)
	e1:SetTarget(c47550019.sptg)
	e1:SetOperation(c47550019.spop)
	c:RegisterEffect(e1)

	--dark:revive+destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(47550019,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,47550019)
	e2:SetCondition(c47550019.spcon2)
	e2:SetTarget(c47550019.sptg2)
	e2:SetOperation(c47550019.spop2)
	c:RegisterEffect(e2)


end

function c47550019.eqcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)<3
end

function c47550019.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x487)
end

function c47550019.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(c:GetSummonType(),SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end
function c47550019.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(c47550019.tar11)
	Duel.RegisterEffect(e1,tp)
end
function c47550019.tar11(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsCode(47550019) and bit.band(sumtype,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end


function c47550019.eqcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)<3
end

function c47550019.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c47550019.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsAttribute(ATTRIBUTE_LIGHT)
end

function c47550019.filter(c,e,tp)
	return c:IsSetCard(0x487) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function c47550019.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_GRAVE and chkc:GetControler()==tp and c47550019.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c47550019.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c47550019.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end

function c47550019.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(c47550016.filter,nil,e)
	if sg:GetCount()>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if sg:GetCount()>ft then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		sg=sg:Select(tp,ft,ft,nil)
	end

	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
end



function c47550019.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsAttribute(ATTRIBUTE_DARK) and Duel.IsExistingMatchingCard(c47550019.tdfilter,tp,LOCATION_REMOVED,0,1,nil) and Duel.IsExistingMatchingCard(nil,tp,LOCATION_FZONE,LOCATION_FZONE,1,nil)
end

function c47550019.tdfilter(c)
	return c:IsSetCard(0x487) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck() and c:IsFaceup()
end

function c47550019.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and c47550019.tdfilter(chkc) end

	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c47550019.tdfilter,tp,LOCATION_REMOVED,0,1,nil)
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
	end

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=Duel.SelectTarget(tp,c47550019.tdfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,sg,1,tp,LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

function c47550019.spop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_DECK+LOCATION_EXTRA) and e:GetHandler():IsRelateToEffect(e) then
		local c=e:GetHandler()
		if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
			local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
			if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(47550019,0)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
				local dg=g:Select(tp,1,1,nil)
				Duel.HintSelection(dg)
				Duel.Destroy(dg,REASON_EFFECT)
			end
		end
	end
end
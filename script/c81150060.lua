--Melodevil Notes Amabille
function c81150060.initial_effect(c)

	--activation
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81150060,0))
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,81150060+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c81150060.cn)
	e1:SetTarget(c81150060.tg)
	e1:SetOperation(c81150060.op)
	c:RegisterEffect(e1)
	
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c81150060.vtg)
	e2:SetOperation(c81150060.vop)
	e2:SetValue(c81150060.val)
	c:RegisterEffect(e2)
end

--activate
function c81150060.cn(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	if Duel.GetTurnPlayer()==tp then
		return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
	else
		return (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)
	end
end

function c81150060.filter(c)
	return c:IsPosition(POS_FACEUP_ATTACK) and c:IsSetCard(0xcb2) and c:IsType(TYPE_MONSTER)
	and (not c:IsType(TYPE_LINK))
end
function c81150060.sfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	and c:IsSetCard(0xcb2)
end
function c81150060.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then
		return Duel.IsExistingTarget(c81150060.filter,tp,LOCATION_MZONE,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c81150060.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c81150060.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsLocation(LOCATION_MZONE)then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENSE) 
	end
	local loc=LOCATION_HAND+LOCATION_GRAVE
	local g=Duel.GetMatchingGroup(c81150060.sfilter,tp,loc,0,nil,e,tp)
	if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.SelectYesNo(tp,aux.Stringid(81150060,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end

--indes
function c81150060.filter2(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xcb2) and c:IsLocation(LOCATION_ONFIELD)
	and c:IsControler(tp) and not c:IsReason(REASON_REPLACE)
end
function c81150060.vtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return e:GetHandler():IsAbleToRemove() and aux.exccon(e)
		and eg:IsExists(c81150060.filter2,1,nil,tp)
	end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c81150060.val(e,c)
	return c81150060.filter2(c,e:GetHandlerPlayer())
end
function c81150060.vop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end

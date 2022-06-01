--승염의 지옥 까마귀

function c81040130.initial_effect(c)
	
	--synchro summon Procedure
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsAttribute,ATTRIBUTE_FIRE),1)
	
	--treat "Reiuji"
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_CODE)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetValue(81040000)
	c:RegisterEffect(e1)

	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81040130,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c81040130.dsco)
	e2:SetTarget(c81040130.dstg)
	e2:SetOperation(c81040130.dsop)
	c:RegisterEffect(e2)
	
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81040130,1))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,81040130)
	e3:SetCost(c81040130.spco)
	e3:SetTarget(c81040130.sptg)
	e3:SetOperation(c81040130.spop)
	c:RegisterEffect(e3)
	
end

--destroy
function c81040130.dscofilter(c)
	return c:IsSetCard(0xca4) and c:IsReleasable()
end
function c81040130.dsco(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=LOCATION_MZONE+LOCATION_HAND
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81040130.dscofilter,tp,loc,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c81040130.dscofilter,tp,loc,0,1,1,nil)
	Duel.Release(g,REASON_COST)
end

function c81040130.dstgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsDestructable() 
end
function c81040130.dstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField(1-tp) and c81040130.dstgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c81040130.dstgfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c81040130.dstgfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,0)
end

function c81040130.dsop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		local turn=Duel.GetTurnCount()*4
		local atk=tc:GetTextAttack()*0.02
		if atk<0 then atk=0 end
		local val=Duel.Damage(tp,atk*turn,REASON_EFFECT)
		if val>0 then
			Duel.BreakEffect()
			Duel.Damage(1-tp,val,REASON_EFFECT)
		end
	end
end

--special summon
function c81040130.spco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end

function c81040130.sptgfilter(c,e,tp,ft)
	return c:IsSetCard(0xca4) and c:IsLevelBelow(4) and c:IsType(TYPE_MONSTER)
	and ( c:IsAbleToHand() or ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) )
end
function c81040130.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return c:IsRelateToEffect(e)
					  and Duel.IsExistingMatchingCard(c81040130.sptgfilter,tp,LOCATION_DECK,0,1,nil,e,tp,ft)
					  end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end

function c81040130.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c81040130.sptgfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,ft)
	local tc=g:GetFirst()
	if tc then
		if ft>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and (not tc:IsAbleToHand() or Duel.SelectYesNo(tp,aux.Stringid(81040130,2))) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		else
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end

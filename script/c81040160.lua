--버라이어티 파이어

function c81040160.initial_effect(c)

	--Damage
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,81040160+EFFECT_COUNT_CODE_OATH)
	e2:SetTarget(c81040160.dmtg)
	e2:SetOperation(c81040160.dmop)
	c:RegisterEffect(e2)
	
	--Special Summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(c81040160.spco)
	e3:SetTarget(c81040160.sptg)
	e3:SetOperation(c81040160.spop)
	c:RegisterEffect(e3)
	
end

--Damage
function c81040160.dmtgfilter(c)
	return c:IsFaceup() and c:IsAbleToGrave()
	   and ( c:IsSetCard(0xca4) and c:IsType(TYPE_MONSTER) )
end
function c81040160.dmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return
				chkc:IsLocation(LOCATION_REMOVED)
			and chkc:IsControler(tp)
			and c81040160.dmtgfilter(chkc)
			end
	if chk==0 then return
				Duel.IsExistingTarget(c81040160.dmtgfilter,tp,LOCATION_REMOVED,0,1,nil)
			end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c81040160.dmtgfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_REMOVED)
end

function c81040160.dmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local atk=(600+tc:GetTextAttack())*0.02
		local turn=Duel.GetTurnCount()*3
		if atk<0 then atk=0 end
		local val=Duel.Damage(tp,atk*turn,REASON_EFFECT)
		if val>0 then
			Duel.Damage(1-tp,val,REASON_EFFECT)
			Duel.SendtoGrave(tc,REASON_EFFECT+REASON_RETURN)
		end
	end
end

--Special Summon
function c81040160.spco(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return
				c:IsAbleToRemoveAsCost()
			end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end

function c81040160.sptgfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	   and c:IsCode(81040000)
end
function c81040160.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return
				chkc:IsLocation(LOCATION_REMOVED)
			and chkc:IsControler(tp)
			and c81040160.sptgfilter(chkc,e,tp)
			end
	if chk==0 then return
				Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingTarget(c81040160.sptgfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp)
			end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c81040160.sptgfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end

function c81040160.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end

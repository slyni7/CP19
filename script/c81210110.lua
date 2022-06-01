--MNF 가스코뉴
--카드군 번호: 0xcba
function c81210110.initial_effect(c)

	aux.EnablePendulumAttribute(c)

	--plimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetRange(LOCATION_PZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c81210110.plimit)
	c:RegisterEffect(e2)
	
	--서치
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81210110,1))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1,81210110)
	e3:SetCondition(c81210110.cn3)
	e3:SetTarget(c81210110.tg3)
	e3:SetOperation(c81210110.op3)
	c:RegisterEffect(e3)
	
	--특수소환
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(81210110,0))
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_HAND)
	e4:SetCountLimit(1,81210111)
	e4:SetTarget(c81210110.tg4)
	e4:SetOperation(c81210110.op4)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetRange(0x10)
	c:RegisterEffect(e5)
	
	--회수 or 특수 소환
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(81210110,1))
	e6:SetCategory(CATEGORY_TOHAND)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetCountLimit(1,81210112)
	e6:SetTarget(c81210110.tg6)
	e6:SetOperation(c81210110.op6)
	c:RegisterEffect(e6)
end

--plimit
function c81210110.plimit(e,c,sump,sumtype,sumpos,targetp)
	return not c:IsRace(RACE_MACHINE)
	and bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end

--서치
function c81210110.cfil0(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT)
	and bit.band(c:GetPreviousTypeOnField(),TYPE_PENDULUM)~=0
	and c:IsPreviousLocation(LOCATION_ONFIELD)
	and c:GetPreviousControler()==tp
end
function c81210110.cn3(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c81210110.cfil0,1,nil,tp)
end
function c81210110.tfil0(c)
	return c:IsAbleToHand() and c:IsType(TYPE_PENDULUM) and c:IsSetCard(0xcb9)
end
function c81210110.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return e:GetHandler():IsAbleToHand()
		and Duel.IsExistingMatchingCard(c81210110.tfil0,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c81210110.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c81210110.tfil0),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		g:AddCard(c)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

--특수 소환
function c81210110.tfil1(c)
	return c:IsFaceup() and c:IsSetCard(0xcb9)
end
function c81210110.tg4(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsOnField() and chkc:IsControler(tp) and c81210110.tfil1(chkc)
	end
	local c=e:GetHandler()
	local loc=LOCATION_ONFIELD
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft==0 then loc=LOCATION_MZONE end 
	if chk==0 then
		return ft>-1
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
		and Duel.IsExistingTarget(c81210110.tfil1,tp,loc,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c81210110.tfil1,tp,loc,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c81210110.op4(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end

--회수
function c81210110.tfil2(c)
	return c:IsAbleToHand() and c:IsType(TYPE_PENDULUM) and c:IsSetCard(0xcb9) and not c:IsCode(81210110) 
	and ( c:IsFaceup() or c:IsLocation(LOCATION_GRAVE) )
end
function c81210110.tg6(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81210110.tfil2,tp,0x10+0x40,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x10+0x40)
end
function c81210110.op6(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c81210110.tfil2,tp,0x10+0x40,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

--Standard-issue "Rabbit Rifle"
--카드군 번호: 0xca9
function c81060090.initial_effect(c)

	--equip spell
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c81060090.eqtg)
	e1:SetOperation(c81060090.eqop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetValue(c81060090.elva)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e3)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(c81060090.cn5)
	e5:SetOperation(c81060090.op5)
	c:RegisterEffect(e5)

	--Re Act
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(81060090,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCountLimit(1,81060090)
	e4:SetCondition(c81060090.rtcn)
	e4:SetTarget(c81060090.rttg)
	e4:SetOperation(c81060090.rtop)
	c:RegisterEffect(e4)
	
	--dump
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(81060090,1))
	e6:SetCategory(CATEGORY_TOGRAVE)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_GRAVE)
	e6:SetCost(c81060090.dmco)
	e6:SetTarget(c81060090.dmtg)
	e6:SetOperation(c81060090.dmop)
	c:RegisterEffect(e6)
	
end

--equip spell
function c81060090.eqtgfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xca7)
end
function c81060090.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(LOCATION_MZONE) and c81060090.eqtgfilter(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c81060090.eqtgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c81060090.eqtgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c81060090.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end

function c81060090.elva(e,c)
	return c:IsSetCard(0xca7)
end

--Re Act
function c81060090.rtcn(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_LOST_TARGET) and c:IsPreviousLocation(LOCATION_SZONE)
end

function c81060090.rttgfilter(c,e,tp)
	return c:IsSetCard(0xca7) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c81060090.rttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81060090.rttgfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,c,1,0,0)
end

function c81060090.rtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c81060090.rttgfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			local tc=g:GetFirst()
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_ATTACK)
			Duel.Equip(tp,c,tc)
		end
	end
end

--dump
function c81060090.dmco(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToRemoveAsCost() and c:IsLocation(LOCATION_GRAVE)
	end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end

function c81060090.dmtgfilter(c)
	return ( c:IsSetCard(0xca9) or c:IsSetCard(0xca7) ) and c:IsAbleToGrave() and not c:IsCode(81060090)
end
function c81060090.dmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81060090.dmtgfilter,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end

function c81060090.dmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c81060090.dmtgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end

--데미지 추가(refined 19.01.24)
function c81060090.cn5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler():GetEquipTarget()
	return ep~=tp and c==Duel.GetAttacker() and Duel.GetAttackTarget() and Duel.GetAttackTarget():IsDefensePos()
end
function c81060090.op5(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev*2)
end



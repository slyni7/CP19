--QC 컨플릭트
--카드군 번호: 0xcb1
function c81140130.initial_effect(c)

	c:EnableReviveLimit()
	
	--같은 속성의 몬스터를 묘지로 보낸다
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c81140130.cn1)
	e1:SetOperation(c81140130.op1)
	c:RegisterEffect(e1)
	--소환 제약
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c81140130.cn1)
	e2:SetTarget(c81140130.lm)
	e2:SetTargetRange(1,1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_SUMMON)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	c:RegisterEffect(e4)
	
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_MATERIAL_CHECK)
	e5:SetValue(c81140130.val)
	c:RegisterEffect(e5)

	--내성 부여
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(81140130,0))
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetCost(c81140130.co6)
	e6:SetOperation(c81140130.op6)
	c:RegisterEffect(e6)
	
	--뒷면 제외
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(81140130,1))
	e7:SetCategory(CATEGORY_REMOVE)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e7:SetCode(EVENT_TO_GRAVE)
	e7:SetCondition(c81140130.cn7)
	e7:SetTarget(c81140130.tg7)
	e7:SetOperation(c81140130.op7)
	c:RegisterEffect(e7)
end

--소재 확인
function c81140130.cn1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_RITUAL) and c:GetFlagEffect(81140130)~=0
end
function c81140130.val(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsSetCard,1,nil,0xcb1) then
		c:RegisterFlagEffect(81140130,RESET_EVENT+0x6e0000,0,1)
	end
end
function c81140130.filter0(c,rc)
	return c:IsFaceup() and c:IsAttribute(att)
end
function c81140130.lm(e,c,sump,sumtype,sumpos,targetp)
	if sumpos and bit.band(sumpos,POS_FACEDOWN)>0 then
		return false
	end
	local tp=sump
	if targetp then tp=targetp end
	return Duel.IsExistingMatchingCard(c81140130.filter0,tp,LOCATION_MZONE,0,1,nil,c:GetAttribute())
end
function c81140130.op1(e,tp,eg,ep,ev,re,r,rp)
	local ATTRIBUTE_ALL=ATTRIBUTE_EARTH+ATTRIBUTE_WATER+ATTRIBUTE_FIRE+ATTRIBUTE_WIND+ATTRIBUTE_LIGHT+ATTRIBUTE_DARK+ATTRIBUTE_DIVINE
	local ph=Duel.GetCurrentPhase()
	if ( ph==PHASE_DAMAGE and not Duel.IsDamageCalculated() ) or ph==PHASE_DAMAGE_CAL then
		return
	end
	local sg=Group.CreateGroup()
	for p=0,1 do
		local g=Duel.GetMatchingGroup(Card.IsFaceup,p,LOCATION_MZONE,0,nil)
		local att=1
		while bit.band(ATTRIBUTE_ALL,att)~=0 do
			local rg=g:Filter(Card.IsAttribute,nil,att)
			local rc=rg:GetCount()
			if rc>1 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local dg=rg:Select(p,rc-1,rc-1,nil)
				sg:Merge(dg)
			end
			att=att*2
		end
	end
	if sg:GetCount()>0 then
		Duel.SendtoGrave(sg,REASON_RULE)
		Duel.Readjust()
	end
end

--내성 부여
function c81140130.filter1(c)
	return c:IsAbleToRemoveAsCost() and c:IsType(TYPE_MONSTER)
end
function c81140130.co6(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81140130.filter1,tp,LOCATION_GRAVE,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c81140130.filter1,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c81140130.op6(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and not c:IsFacedown() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(c81140130.filter2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function c81140130.filter2(e,te)
	return te:GetOwner()~=e:GetOwner()
end

--제외
function c81140130.cn7(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c81140130.tg7(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsAbleToRemove()
	end
	if chk==0 then
		return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c81140130.op7(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
	end
end



function c81030200.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c81030200.mat,1,1)
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(81030200,4))
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e0:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetCountLimit(1,81030200)
	e0:SetCondition(c81030200.cn)
	e0:SetTarget(c81030200.tg)
	e0:SetOperation(c81030200.op)
	c:RegisterEffect(e0)
	local e1=e0:Clone()
	e1:SetDescription(aux.Stringid(81030200,5))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetTarget(c81030200.tg2)
	e1:SetOperation(c81030200.op2)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81030200,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,81030201)
	e2:SetTarget(c81030200.vtg)
	e2:SetOperation(c81030200.vop)
	c:RegisterEffect(e2)
end
--material
function c81030200.mat(c,scard,sumtype,tp)
	return c:IsLinkSetCard(0xca3) and c:IsSummonableCard(scard,sumtype,tp)
end

--summon
function c81030200.cn(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end

function c81030200.szfilter(c)
	return c:IsSetCard(0xca3) and c:IsType(TYPE_MONSTER)
end
function c81030200.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=LOCATION_HAND+LOCATION_GRAVE
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81030200.szfilter,tp,loc,0,1,e:GetHandler())
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	end
end
function c81030200.op(e,tp,eg,ep,ev,re,r,rp)
	local loc=LOCATION_HAND+LOCATION_GRAVE
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then 
		return 
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c81030200.szfilter,tp,loc,0,1,1,e:GetHandler())
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end

function c81030200.filter(c,e,tp,zone)
	return c:IsSetCard(0xca3) and c:IsType(TYPE_MONSTER) and c:IsLevelBelow(4)
	and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c81030200.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=LOCATION_HAND+LOCATION_GRAVE
	if chk==0 then
		local zone=e:GetHandler():GetLinkedZone(tp)
		return zone~=0 
		and Duel.IsExistingMatchingCard(c81030200.filter,tp,loc,0,1,nil,e,tp,zone)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,loc)
end
function c81030200.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local zone=c:GetLinkedZone(tp)
	local loc=LOCATION_HAND+LOCATION_GRAVE
	local g=Duel.SelectMatchingCard(tp,c81030200.filter,tp,loc,0,1,1,nil,e,tp,zone)
	if g:GetCount()>0 then  
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone)
	end
end

function c81030200.vtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and c:IsFaceup()
	end
	if chk==0 then
		return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_SZONE,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end

function c81030200.vop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end

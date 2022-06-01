--hyotan: hei

function c81030040.initial_effect(c)
	
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81030040,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCountLimit(1,81030040)
	e2:SetCondition(c81030040.spcn)
	c:RegisterEffect(e2)

	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81030040,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c81030040.deco)
	e3:SetTarget(c81030040.detg)
	e3:SetOperation(c81030040.deop)
	c:RegisterEffect(e3)
	
	--cannot be target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_SELECT_EFFECT_TARGET)
	e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e4:SetTargetRange(0,0xff)
	e4:SetRange(LOCATION_SZONE)
	e4:SetValue(c81030040.cntgvl)
	c:RegisterEffect(e4)
	
end

--special summon
function c81030040.spcnfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xca3)
		and c:IsType(TYPE_SPELL+TYPE_CONTINUOUS)
end
function c81030040.spcn(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
	local g=Duel.GetMatchingGroup(c81030040.spcnfilter,tp,LOCATION_SZONE,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	return ct>1
end

--destroy
function c81030040.decofilter(c)
	return c:IsDestructable() and c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c81030040.deco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81030040.decofilter,tp,LOCATION_SZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c81030040.decofilter,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.Destroy(g,REASON_COST)
end

function c81030040.detg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return 
				chkc:IsOnField() 
			and chkc:IsControler(1-tp)
			and chkc:IsDestructable()
			end
	if chk==0 then return 
				Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil)
			end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end

function c81030040.deop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end

--cannot be target
function c81030040.cntgvl(e,re,c)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsSetCard(0xca3)
end

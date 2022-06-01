--랜드 퍼커스

function c81070100.initial_effect(c)

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(c81070100.atcn)
	c:RegisterEffect(e0)
	
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,81070100)
	e2:SetCondition(c81070100.dscn)
	e2:SetCost(c81070100.dsco)
	e2:SetTarget(c81070100.dstg)
	e2:SetOperation(c81070100.dsop)
	c:RegisterEffect(e2)
	
	--position
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c81070100.pscn)
	e3:SetTarget(c81070100.pstg)
	e3:SetOperation(c81070100.psop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCondition(c81070100.pscn2)
	c:RegisterEffect(e4)
	
end
--activate
function c81070100.atcnfilter(c)
	return c:IsFaceup() 
	   and ( c:IsSetCard(0xcaa) and c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) )
end
function c81070100.atcn(e)
	local c=e:GetHandler()
	local tp=c:GetControler()
	return Duel.GetMatchingGroupCount(c81070100.atcnfilter,tp,LOCATION_ONFIELD,0,nil)==0
end
--destroy
function c81070100.dscnfilter(c)
	return c:IsFaceup() and c:IsCode(81070000)
end
function c81070100.dscn(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c81070100.dscnfilter,tp,LOCATION_MZONE,0,1,nil)
end

function c81070100.dscofilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0xcaa)
	   and c:IsAbleToGraveAsCost()
end
function c81070100.dsco(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=LOCATION_HAND+LOCATION_DECK
	if chk==0 then return
				Duel.IsExistingMatchingCard(c81070100.dscofilter,tp,loc,0,1,nil)
			end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c81070100.dscofilter,tp,loc,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end

function c81070100.dstgfilter(c)
	return c:IsFaceup() and c:IsDestructable()
end
function c81070100.dstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return
				chkc:IsOnField()
			and c81070100.dstgfilter(chkc)
			end
	if chk==0 then return
				Duel.IsExistingTarget(c81070100.dstgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c)
			end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c81070100.dstgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c81070100.dsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end

--position
function c81070100.pscn(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_COST) and re:IsHasType(0x7e0)
	   and re:GetHandler():IsSetCard(0xcaa)
end
function c81070100.pscn2(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and e:GetHandler():GetPreviousControler()==tp
end

function c81070100.pstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return
				chkc:IsLocation(LOCATION_MZONE)
			and chkc:IsControler(1-tp)
			end
	if chk==0 then return
				Duel.IsExistingTarget(nil,tp,0,LOCATION_MZONE,1,nil)
			end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end

function c81070100.psop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
	end
end

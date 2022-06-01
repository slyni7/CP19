--상격의 지옥 까마귀

function c81040070.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xca4),4,2)
	
	--treat "Reiuji"
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_CODE)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetValue(81040000)
	c:RegisterEffect(e1)
	
	--destroy + send to deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81040070,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c81040070.ddco)
	e2:SetTarget(c81040070.ddtg)
	e2:SetOperation(c81040070.ddop)
	c:RegisterEffect(e2)
	
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81040070,1))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCondition(c81040070.dmcn)
	e3:SetTarget(c81040070.dmtg)
	e3:SetOperation(c81040070.dmop)
	c:RegisterEffect(e3)
	
end

--destroy + send to deck
function c81040070.ddco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end

function c81040070.ddtgfilter(c)
	return c:IsSetCard(0xca4) and c:IsFaceup() and c:IsDestructable()
end
function c81040070.ddtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c81040070.ddtgfilter,tp,LOCATION_ONFIELD,0,1,nil)
					  and Duel.IsExistingTarget(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil) 
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,c81040070.ddtgfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	e:SetLabelObject(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g2=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g2,1,0,0)
end

function c81040070.ddop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local lc=tg:GetFirst()
	if lc==tc then lc=tg:GetNext() end
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0
		and lc:IsRelateToEffect(e) and lc:IsControler(1-tp) then
		Duel.SendtoDeck(lc,nil,2,REASON_EFFECT)
	end
end

--damage
function c81040070.dmcn(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY)
end

function c81040070.dmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,0)
end

function c81040070.dmop(e,tp,eg,ep,ev,re,r,rp)
	local turn=Duel.GetTurnCount()*5
	local atk=e:GetHandler():GetTextAttack()*0.01
	Duel.Damage(1-tp,atk*turn,REASON_EFFECT)
	Duel.Damage(tp,atk*turn,REASON_EFFECT)
end

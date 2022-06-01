--Comet: The Lantern of Causality
local m=99970332
local cm=_G["c"..m]
function cm.initial_effect(c)

	--엑시즈 소환
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_SPIRIT),1,2)

	--제외 / 탈취
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.rmtg)
	e1:SetOperation(cm.rmop)
	c:RegisterEffect(e1)
	
	--스피릿 보존
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPIRIT_MAYNOT_RETURN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(cm.xcon)
	c:RegisterEffect(e2)
	
	--공격력 증가
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_SPIRIT))
	e3:SetValue(cm.atkval)
	e3:SetCondition(cm.xcon)
	c:RegisterEffect(e3)
	
end

--제외 / 탈취
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	local ct=Duel.GetOperatedGroup():GetFirst()
	e:SetLabelObject(ct)
end
function cm.rmfilter(c)
	return c:IsAbleToRemove()
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and cm.rmfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.rmfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,cm.rmfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	if e:GetHandler():GetOverlayGroup():IsExists(Card.IsType,1,nil,TYPE_TRAP) then
		e:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND)
	end
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
		if e:GetHandler():GetOverlayGroup():IsExists(Card.IsType,1,nil,TYPE_TRAP)
			and tc:IsAbleToChangeControler() and tc:IsAbleToHand() then
			Duel.SendtoHand(tc,tp,REASON_EFFECT)
		end
	end
end

--스피릿 보존 + 공격력 증가
function cm.xcon(e)
	return e:GetHandler():GetOverlayCount()>0
end
function cm.atkval(e,c)
	return c:GetDefense()/2
end

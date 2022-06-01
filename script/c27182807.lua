--스크립트리니티-이퀄리티
function c27182807.initial_effect(c)
	c:EnableReviveLimit()
	c:SetUniqueOnField(1,0,27182807)
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsCode,27182801),c27182807.sfilter,1,99)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(27182801)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetOperation(c27182807.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c27182807.tg2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_ADJUST)
	e4:SetCondition(c27182807.con4)
	e4:SetOperation(c27182807.op4)
	c:RegisterEffect(e4)
	local ec=Effect.CreateEffect(c)
	ec:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	ec:SetCode(EVENT_LEAVE_FIELD)
	ec:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	ec:SetCategory(CATEGORY_TOHAND)
	ec:SetTarget(c27182807.tgc)
	ec:SetOperation(c27182807.opc)
	c:RegisterEffect(ec)
end
function c27182807.sfilter(c)
	return c:IsSetCard(0x2c2)
end
function c27182807.ofilter1(c)
	return c:IsCode(27182801)
end
function c27182807.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if eg:IsExists(c27182807.ofilter1,1,nil)
		and c:IsSynchroSummonable(nil)
		and Duel.SelectYesNo(tp,aux.Stringid(27182807,15)) then
		Duel.SynchroSummon(tp,c,nil)
	end
end
function c27182807.tg2(e,c)
	return not c:IsSetCard(0x2c2)
end
function c27182807.con4(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_HAND+LOCATION_ONFIELD,0)>5
		or Duel.GetFieldGroupCount(tp,0,LOCATION_HAND+LOCATION_ONFIELD)>5
end
function c27182807.op4(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,27182807)
	local g1=Group.CreateGroup()
	local g2=Group.CreateGroup()
	if Duel.GetFieldGroupCount(tp,LOCATION_HAND+LOCATION_ONFIELD,0)>5 then
		local ct1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
		if ct1>4 then
			g1=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,0)
			if ct1>5 then
				local hg1=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
				local sg1=hg1:RandomSelect(1-tp,ct1-5)
				g1:Merge(sg1)
			end
		else
			local fct1=Duel.GetFieldGroupCount(tp,LOCATION_HAND+LOCATION_ONFIELD,0)
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
			g1=Duel.SelectMatchingCard(1-tp,nil,tp,LOCATION_ONFIELD,0,fct1-5,fct1-5,nil)
		end
	end
	if Duel.GetFieldGroupCount(tp,0,LOCATION_HAND+LOCATION_ONFIELD)>5 then
		local ct2=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
		if ct2>4 then
			g2=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
			if ct2>5 then
				local hg2=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
				local sg2=hg2:RandomSelect(tp,ct2-5)
				g2:Merge(sg2)
			end
		else
			local fct2=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND+LOCATION_ONFIELD)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			g2=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,fct2-5,fct2-5,nil)
		end
	end
	g1:Merge(g2)
	Duel.SendtoGrave(g1,REASON_RULE)
end
function c27182807.tfilterc(c)
	return c:IsSetCard(0x2c2)
		and (c:IsFaceup()
			or c:IsLocation(LOCATION_GRAVE))
		and c:IsAbleToHand()
end
function c27182807.tgc(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(tp)
			and chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED)
			and c27182807.tfilterc(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c27182807.tfilterc,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c27182807.tfilterc,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c27182807.opc(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
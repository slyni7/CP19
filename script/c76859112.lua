--Angel Notes - µ¥Ä®ÄÚ¸¶´Ï
function c76859112.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetValue(c76859112.val1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(c76859112.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DESTROY)
	e3:SetCountLimit(1,76859112)
	e3:SetCondition(c76859112.con3)
	e3:SetTarget(c76859112.tg3)
	e3:SetOperation(c76859112.op3)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,1)
	e4:SetTarget(c76859112.tar4)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_SUMMON)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	c:RegisterEffect(e6)
end
c76859112[0]=0
c76859112[1]=0
function c76859112.val1(e,te)
	return e:GetHandler()~=te:GetOwner() and te:IsActiveType(TYPE_MONSTER)
end
function c76859112.ofunction2(g)
	local aat=0
	local tc=g:GetFirst()
	while tc do
		aat=bit.bor(aat,tc:GetAttribute())
		tc=g:GetNext()
	end
	return aat
end
function c76859112.ofilter2(c,at)
	return c:GetAttribute()==at
end
function c76859112.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(76859112)<1 then
		c76859112[0]=0
		c76859112[1]=0
		c:RegisterFlagEffect(76859112,RESET_EVENT+0x1fe0000,0,1)
	end
	local phase=Duel.GetCurrentPhase()
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
	local g1=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	local g2=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local c=e:GetHandler()
	if g1:GetCount()==0 then c76859112[tp]=0
	else
		local att=c76859112.ofunction2(g1)
		if bit.band(att,att-1)~=0 then
			if c76859112[tp]==0 or bit.band(c76859112[tp],att)==0 then
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(76859112,0))
				att=Duel.AnnounceAttribute(tp,1,att)
			else att=c76859112[tp] end
		end
		g1:Remove(c76859112.ofilter2,nil,att)
		c76859112[tp]=att
	end
	if g2:GetCount()==0 then c76859112[1-tp]=0
	else
		local att=c76859112.ofunction2(g2)
		if bit.band(att,att-1)~=0 then
			if c76859112[1-tp]==0 or bit.band(c76859112[1-tp],att)==0 then
				Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(76859112,0))
				att=Duel.AnnounceAttribute(1-tp,1,att)
			else att=c76859112[1-tp] end
		end
		g2:Remove(c76859112.ofilter2,nil,att)
		c76859112[1-tp]=att
	end
	g1:Merge(g2)
	if g1:GetCount()>0 then
		Duel.SendtoGrave(g1,REASON_RULE)
		Duel.Readjust()
	end
end
function c76859112.con3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c76859112.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c76859112.ofilter31(c)
	return c:IsSetCard(0x2c8) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsCode(76859112)
end
function c76859112.ofilter32(c)
	return c:IsSetCard(0x2c8) and c:IsType(TYPE_MONSTER) and not c:IsCode(76859112)
end
function c76859112.op3(e,tp,eg,ep,ev,re,r,rp)
	local can=aux.AngelNotesCantabileOperation(e,tp,eg,ep,ev,re,r,rp)
	if can then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c76859112.ofilter31,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	else
		if Duel.IsExistingMatchingCard(c76859112.ofilter32,tp,LOCATION_DECK,0,1,nil) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local dg=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
			if dg:GetCount()>0 then
				Duel.Destroy(dg,REASON_EFFECT)
			end
		end
	end
end
function c76859112.tar4(e,c,sump,sumtype,sumpos,targetp)
	if sumpos and bit.band(sumpos,POS_FACEDOWN)>0 then return false end
	local at=c76859112.ofunction2(Duel.GetMatchingGroup(Card.IsFaceup,targetp or sump,LOCATION_MZONE,0,nil))
	if at==0 then return false end
	return c:GetAttribute()~=at
end
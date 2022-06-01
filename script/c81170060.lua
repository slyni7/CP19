--USS 라피/리폼
function c81170060.initial_effect(c)

	c:EnableReviveLimit()
	
	--summon method
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c81170060.spn)
	e1:SetOperation(c81170060.spp)
	c:RegisterEffect(e1,false,2)
	
	--atk inc.
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81170060,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_CONFIRM)
	e2:SetCondition(c81170060.ecn)
	e2:SetCost(c81170060.eco)
	e2:SetOperation(c81170060.eop)
	c:RegisterEffect(e2)
	
	--salvage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81170060,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetCountLimit(1)
	e3:SetCondition(c81170060.vcn)
	e3:SetTarget(c81170060.vtg)
	e3:SetOperation(c81170060.vop)
	c:RegisterEffect(e3)
end

--summon method
function c81170060.mfilter(c,ft,tp)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsRace(RACE_MACHINE)
	and ( ft>0 or ( c:IsControler(tp) and c:GetSequence()<5 ) )
	and ( c:IsControler(tp) or c:IsFaceup() )
end
function c81170060.spn(e,c)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-1 and Duel.CheckReleaseGroup(tp,c81170060.mfilter,1,nil,ft,tp)
end
function c81170060.spp(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.SelectReleaseGroup(tp,c81170060.mfilter,1,1,nil,ft,tp)
	Duel.Release(g,REASON_COST)
end

--atk inc.
function c81170060.ecn(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and bc and bc:IsFaceup() and bc:IsRelateToBattle() 
end
function c81170060.eco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil)
	end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c81170060.eop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if c:IsFaceup() and c:IsRelateToBattle() and bc:IsFaceup() and bc:IsRelateToBattle() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1500)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE_CAL)
		c:RegisterEffect(e1)
	end
end

--salvage
function c81170060.vcn(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRelateToBattle() and c:GetBattleTarget():IsType(TYPE_MONSTER)
end
function c81170060.filter1(c)
	return c:IsAbleToHand() and c:IsSetCard(0xcb4) and c:IsFaceup()
end
function c81170060.vtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(tp) and c81170060.filter1(chkc)
	end
	local loc=LOCATION_REMOVED+LOCATION_GRAVE
	if chk==0 then
		return Duel.IsExistingTarget(c81170060.filter1,tp,loc,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c81170060.filter1,tp,loc,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c81170060.vop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end



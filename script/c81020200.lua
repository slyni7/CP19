--초목의 화수령
--카드군 번호: 0xca2
local m=81020200
local cm=_G["c"..m]
function cm.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,cm.mfilter0,1,1)
	aux.EnableChangeCode(c,81020080,0x04,cm.cn2A)
	
	--소환 유발
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.cn1)
	e1:SetCost(cm.co1)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	
	--지속 효과
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_INACTIVATE)
	e2:SetRange(0x04)
	e2:SetCondition(cm.cn2B)
	e2:SetValue(cm.va2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_DISEFFECT)
	c:RegisterEffect(e3)
	
	--코스트
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(m)
	e4:SetRange(0x04+0x10)
	e4:SetCountLimit(1,m+1)
	c:RegisterEffect(e4)
end

function cm.mfilter0(c)
	return c:IsLinkSetCard(0xca2) and not c:IsLinkType(TYPE_LINK)
end

--서치
function cm.cn1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.cfilter0(c)
	return c:IsAbleToGraveAsCost() and c:IsSetCard(0x46) and c:GetType()==TYPE_SPELL
end
function cm.co1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.cfilter0,tp,0x01+0x02,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter0,tp,0x01+0x02,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.tfilter0(c)
	return (c:IsCode(81020080) or c:IsCode(81020110)) and (c:IsAbleToHand() or not c:IsForbidden())
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.tfilter0,tp,0x01+0x10,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x01+0x10)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.tfilter0),tp,0x01+0x10,0,1,1,nil)
	if #g==0 then
		return
	end
	local tc=g:GetFirst()
	if tc then
		if tc:IsAbleToHand() and (not tc:IsType(TYPE_FIELD) or tc:IsForbidden() or Duel.SelectOption(tp,1190,1159)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			local fc=Duel.GetFieldCard(tp,0x100,0)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			Duel.MoveToField(tc,tp,tp,0x100,POS_FACEUP,true)
		end
	end
end

--지속 효과
function cm.nfilter0(c)
	return c:IsFaceup() and c:IsCode(81020080)
end
function cm.cn2A(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(cm.nfilter0,tp,0x100,0x100,1,nil)
end
function cm.cn2B(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.nfilter1,tp,0x100,0x100,1,nil)
end
function cm.va2(e,ct)
	local p=e:GetHandlerPlayer()
	local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return p==tp and te:IsHasType(EFFECT_TYPE_ACTIVATE) and te:GetActiveType()==TYPE_SPELL
	and te:GetHandler():IsSetCard(0xca2)
end

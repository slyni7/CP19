--저승의 꽃 - 저주의 색
--카드군 번호: 0xc85
local m=81247020
local cm=_G["c"..m]
function cm.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,2,cm.lchk)
	
	--드로우
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.cn1)
	e1:SetCost(cm.co1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)

	--제외 유발
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCountLimit(1,m+1)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
end

--링크 소재
function cm.mfil0(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0xc85)
end

--드로우
function cm.cn1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.cfil0(c,tp)
	return c:IsAbleToRemoveAsCost() and c:IsSetCard(0xc85)
	and Duel.IsExistingMatchingCard(cm.tfil0,tp,0x01+0x10,0,1,c)
end
function cm.tfil0(c)
	return c:IsSSetable() and c:IsType(0x4) and c:IsSetCard(0xc85)
end
function cm.nfil0(c)
	return c:IsFaceup() and c:IsSetCard(0xc85) and c:IsType(TYPE_FIELD)
end
function cm.co1(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=0x10
	if Duel.IsExistingMatchingCard(cm.nfil0,tp,0x100,0,1,nil) then loc=loc+0x40 end
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.cfil0,tp,loc,0,1,nil,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.cfil0,tp,loc,0,1,1,nil,tp)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.tfil0),tp,0x01+0x10,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SSet(tp,tc)
	end
end

--회수
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetCondition(cm.o2cn1)
	e1:SetOperation(cm.o2op1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.tfil1(c)
	return c:IsAbleToHand() and c:IsCode(81247000) and ( c:IsFaceup() or c:IsLocation(0x10) )
end
function cm.o2cn1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.tfil1,tp,0x10+0x20,0,1,nil)
end
function cm.o2op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.tfil1),tp,0x10+0x20,0,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end

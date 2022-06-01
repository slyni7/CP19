--木下闇の永蝶
--그림자의 영원접
--카드군 번호: 0xc88
local m=81239020
local cm=_G["c"..m]
function cm.initial_effect(c)

	--공통 트리거
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_RELEASE)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.cn1)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	
	--특수 소환
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(0x02)
	e2:SetCountLimit(1,m+1+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(cm.cn2)
	c:RegisterEffect(e2)
end

--공통 트리거
function cm.cn1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(0x10)
end
function cm.tfil0(c)
	return c:IsAbleToGrave() and c:IsSetCard(0xc88)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.tfil0,tp,0x01,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,0x01)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.tfil0,tp,0x01,0,1,1,nil)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end

--특수 소환
function cm.nfil0(c)
	return c:IsFacedown() or not c:IsSetCard(0xc88)
end
function cm.cn2(e,c)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,0x04)>0 and not Duel.IsExistingMatchingCard(cm.nfil0,tp,0x04,0,1,nil)
end

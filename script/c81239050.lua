--永蝶の鱗粉
--영원접의 인분
--카드군 번호: 0xc88
local m=81239050
local cm=_G["c"..m]
function cm.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_INSECT),5,2)
	
	--엑시즈 소환의 소재
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCode(EFFECT_XYZ_LEVEL)
	e1:SetRange(0x40)
	e1:SetTargetRange(0x04,0)
	e1:SetTarget(cm.tg1)
	e1:SetValue(cm.va1)
	c:RegisterEffect(e1)
	
	--파괴 내성
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(0x04)
	e2:SetCondition(cm.cn2)
	e2:SetValue(aux.inoval)
	c:RegisterEffect(e2)
	
	--특수 소환
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_RELEASE)
	e3:SetCountLimit(1,m)
	e3:SetCondition(cm.cn3)
	e3:SetTarget(cm.tg3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
	
	--덱 바운스
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(0x04)
	e4:SetCountLimit(1,m+1)
	e4:SetCost(cm.co4)
	e4:SetTarget(cm.tg4)
	e4:SetOperation(cm.op4)
	c:RegisterEffect(e4)
end

--엑시즈 소환의 소재
function cm.tg1(e,c)
	return c:IsLevelBelow(4) and c:IsSetCard(0xc88) 
end
function cm.va1(e,c,rc)
	local lv=c:GetLevel()
	if rc==e:GetHandler() then
		return 5
	else
		return lv
	end
end

--파괴 내성
function cm.nfil0(c)
	return c:GetLevel()~=5 and c:IsType(0x1)
end
function cm.cn2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(cm.nfil0,1,nil)
end

--특수 소환
function cm.cn3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(0x10) 
	and c:GetOverlayCount()>0 and c:IsPreviousLocation(0x04)
end
function cm.spfil0(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevelBelow(5) and c:IsSetCard(0xc88)
end
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,0x04)>0
		and Duel.IsExistingMatchingCard(cm.spfil0,tp,0x01+0x02+0x10,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x01+0x02+0x10)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfil0,tp,0x01+0x02+0x10,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

--덱 바운스
function cm.cfil0(c)
	return c:IsReleasable() and c:IsType(0x1) and c:IsSetCard(0xc88)
end
function cm.co4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.cfil0,tp,0x02+0x04,0,1,nil)
	end
	local ct=Duel.GetTargetCount(Card.IsAbleToDeck,tp,0,0x04,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,cm.cfil0,tp,0x02+0x04,0,1,ct,nil)
	local ect=Duel.Release(g,REASON_COST)
	e:SetLabel(ect)
end
function cm.tg4(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(0x04) and chkc:IsControler(1-tp) and chkc:IsAbleToDeck()
	end
	if chk==0 then
		return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,0,0x04,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,0,0x04,e:GetLabel(),e:GetLabel(),nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end

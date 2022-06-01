--상서로운 봄(뿌리 왕저)
--카드군 번호: 0xc89
local m=81242020
local cm=_G["c"..m]
function cm.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,aux.FilterBoolFunction(Card.IsLevel,4),cm.mfil0,2,2)
	
	--서치
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.cn1)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	
	--효과 무효
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(0x04)
	e2:SetCountLimit(1,m+1)
	e2:SetCondition(cm.cn2)
	e2:SetCost(cm.co2)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	
	--추가 소재
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_OVERLAY_RITUAL_MATERIAL)
	e3:SetRange(0x04)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end

--엑시즈 소재
function cm.mfil0(g)
	return g:IsExists(Card.IsSetCard,1,nil,0xc89)
end

--서치
function cm.cn1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function cm.tfil0(c)
	return c:IsAbleToHand() and c:IsType(TYPE_RITUAL) and ( c:IsType(0x2) or c:IsSetCard(0xc89) )
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.tfil0,tp,0x01+0x10,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x01+0x10)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.tfil0,tp,0x01+0x10,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

--효과 무효
function cm.nfil0(c,tp)
	return c:IsLocation(0x04) and c:IsControler(tp) and c:IsSetCard(0xc89) and c:IsType(TYPE_RITUAL)
end
function cm.cn2(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp or e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then
		return false
	end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
		return false
	end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsExists(cm.nfil0,1,nil,tp) and Duel.IsChainDisablable(ev)
end
function cm.co2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:CheckRemoveOverlayCard(tp,1,REASON_COST)
	end
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:IsRelateToEffect(e) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,0x10)
	end
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev)~=0 then
		local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,0x10,nil)
		if #g>0 and (not Duel.IsPlayerAffectedByEffect(tp,47355498)) and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local sg=g:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
		end
	end
end

--엑시즈 소재를 의식 소환에 사용한다
--function cm.tg3(e,c)
--	return e:GetHandler():GetOverlayGroup():IsContains(c)
--end

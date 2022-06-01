--OQA 브랜디시
--카드군 번호: 0xcad
local m=81100110
local cm=_G["c"..m]
function cm.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_EFFECT),2,2,cm.mat)
	
	--유발
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.cn1)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	
	--기동
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOEXTRA+CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m+1)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
end

--material
function cm.mat(g,lc)
	return g:IsExists(Card.IsSetCard,1,nil,0xcad)
end

--유발
function cm.cn1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.tfil0(c)
	return c:IsAbleToGrave() and c:IsSetCard(0xcad)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.tfil0,tp,0x01+0x02,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,0x01+0x02)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.tfil0,tp,0x01+0x02,0,1,1,nil)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end

--기동
function cm.tfil1(c)
	return c:IsAbleToExtra() and c:IsSetCard(0xcad) and c:IsType(TYPE_PENDULUM)
end
function cm.tfil2(c)
	return c:IsFaceup() and not c:IsDisabled() and not c:IsType(TYPE_NORMAL)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(tp) and cm.tfil0(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(cm.tfil1,tp,0x0c,0,1,nil)
		and Duel.IsExistingTarget(cm.tfil1,tp,0x10,0,1,nil)
		and Duel.IsExistingMatchingCard(cm.tfil2,tp,0,0x0c,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOEXTRA)
	local g1=Duel.SelectTarget(tp,cm.tfil1,tp,0x0c,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOEXTRA)
	local g2=Duel.SelectTarget(tp,cm.tfil1,tp,0x10,0,1,1,nil)
	g1:AddCard(g2)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,g1,2,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if tg and Duel.SendtoExtraP(tg,tp,REASON_EFFECT)==2 then
		local g=Duel.GetMatchingGroup(cm.tfil2,tp,0,0x0c,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
		local sg=g:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		local tc=sg:GetFirst()
		if tc then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			tc:RegisterEffect(e2)
		end
	end
end

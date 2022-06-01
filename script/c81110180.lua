--진벌 - 영원의 적
--카드군 번호: 0xcae
local m=81110180
local cm=_G["c"..m]
function cm.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,cm.mfil0,7,2,cm.xyzfil0,aux.Stringid(m,0),2,cm.xyzop)
	
	--효과 무효
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(0x04)
	e1:SetCountLimit(1)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	
	--엑시즈 소재로
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetRange(0x04)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.cn2)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	
	--엔드 페이즈시 소생
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
end

--엑시즈 소환
function cm.mfil0(c)
	return c:IsRace(RACE_WINDBEAST) and c:IsAttribute(ATTRIBUTE_FIRE)
end
function cm.xyzfil0(c)
	return c:IsFaceup() and c:IsSetCard(0xcae) and c:IsType(TYPE_SYNCHRO)
end
function cm.xyzop(e,tp,chk)
	if chk==0 then
		return Duel.GetFlagEffect(tp,m)==0
	end
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
end

--효과 무효
function cm.tfil0(c)
	return c:IsFaceup() and c:IsSetCard(0xcae)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsOnField() and chkc:IsControler(tp) and cm.tfil0(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(cm.tfil0,tp,0x0c,0,1,nil)
		and Duel.IsExistingMatchingCard(aux.disfilter1,tp,0,0x04,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,cm.tfil0,tp,0x0c,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local tg=Duel.GetMatchingGroup(aux.disfilter1,tp,0,0x04,nil)
	if tc:IsRelateToEffect(e) and #tg>0 and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
		local sg=tg:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		local tc2=sg:GetFirst()
		local c=e:GetHandler()
		while tc2 do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc2:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			tc2:RegisterEffect(e2)
			tc2=sg:GetNext()
		end
	end
end

--엑시즈 소재로 한다
function cm.nfil0(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousSetCard(0xcae)
	and c:GetPreviousControler()==tp and c:IsPreviousLocation(0x0c) and c:IsPreviousPosition(POS_FACEUP)
end
function cm.cn2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.nfil0,1,nil,tp)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsCanOverlay()
	end
	if chk==0 then
		return e:GetHandler():IsType(TYPE_XYZ)
		and Duel.IsExistingTarget(Card.IsCanOverlay,tp,0,0x0c,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	Duel.SelectTarget(tp,Card.IsCanOverlay,tp,0,0x0c,1,1,nil)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local og=tc:GetOverlayGroup()
		if #og>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,Group.FromCards(tc))
	end
end

--소생
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsReason(REASON_DESTROY) and c:IsPreviousLocation(0x0c) then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(m,3))
		e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1,m)
		e1:SetCost(cm.oco1)
		e1:SetTarget(cm.otg1)
		e1:SetOperation(cm.oop1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function cm.cfil0(c)
	return c:IsAbleToRemoveAsCost() and c:IsSetCard(0xcae)
end
function cm.cfil1(c)
	return c:IsAbleToRemoveAsCost() and c:IsSetCard(0xcae) and c:IsType(TYPE_SYNCHRO)
end
function cm.oco1(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(cm.cfil0,tp,0x10,0,2,nil)
	local b2=Duel.IsExistingMatchingCard(cm.cfil0,tp,0x10,0,1,nil)
	if chk==0 then
		return b1 or b2
	end
	if b1 and (not b2 or Duel.SelectYesNo(tp,aux.Stringid(m,4))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,cm.cfil0,tp,0x10,0,2,2,nil)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,cm.cfil1,tp,0x10,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
end
function cm.otg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
		and Duel.GetLocationCount(tp,0x04)>0
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.oop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsLocation(0x10) or Duel.GetLocationCount(tp,0x04)<=0 then
		return
	end
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end

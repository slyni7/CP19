--엔지니어 니토리-워터 드릴러
--카드군 번호: 0xc9e 0x1c9e
local m=81255020
local cm=_G["c"..m]
function cm.initial_effect(c)

	c:SetSPSummonOnce(m)
	c:EnableReviveLimit()
	aux.AddModuleProcedure(c,cm.mat0,nil,1,1,nil)
	
	--소환 공통
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	
	--유발
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCondition(cm.cn2)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	
	--고유
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE+CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cm.cn3)
	e3:SetCost(cm.co3)
	e3:SetTarget(cm.tg3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
	
end

--모듈 소환
function cm.mat0(c)
	return c:IsRace(RACE_AQUA) and not c:IsAttribute(ATTRIBUTE_EARTH)
end

--장착
function cm.tfil0(c,e,tp,ec)
	return c:IsSetCard(0x1c9e) and c:IsCanBeEffectTarget(e) 
	and c:CheckUniqueOnField(tp) and c:CheckEquipTarget(ec)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then
		return chkc:IsControler(tp) and chkc:IsLocation(0x10) and cm.tfil0(chkc,e,tp,ec)
	end
	if chk==0 then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then
			return false
		end
		return Duel.IsExistingMatchingCard(cm.tfil0,tp,0x10,0,1,nil,e,tp,c)
	end
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local g=Duel.GetMatchingGroup(cm.tfil0,tp,0x10,0,nil,e,tp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g1=g:SelectSubGroup(tp,aux.dncheck,false,1,math.min(ft,2))
	Duel.SetTargetCard(g1)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g1,#g1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if ft<#g then
		return
	end
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then
		return
	end
	local tc=g:GetFirst()
	while tc do
		Duel.Equip(tp,tc,c,true,true)
		tc=g:GetNext()
	end
	Duel.EquipComplete()
end

--리쿠르트
function cm.cn2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
	and ( c:IsReason(REASON_BATTLE) or ( rp==1-tp and c:IsReason(REASON_EFFECT) and c:GetPreviousControler()==tp ) )
end
function cm.spfil0(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0xc9e) and c:IsAttribute(ATTRIBUTE_WATER)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfil0,tp,0x02+0x10,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x02+0x10)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfil0,tp,0x02+0x10,0,1,1,nil,e,tp)
	if #g>0 then
		if not Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
			if Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
				Duel.BreakEffect()
				Duel.Draw(tp,1,REASON_EFFECT)
			end
		end
	end
end

--발동 무효
function cm.cn3(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and Duel.IsChainNegatable(ev)
end
function cm.co3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetFlagEffect(tp,m)==0
	end
	Duel.RegisterFlagEffect(tp,m,RESET_CHAIN,0,1)
end
function cm.tfil1(c,e)
	return c:IsType(TYPE_EQUIP) and c:IsAbleToGrave() and not c:IsImmuneToEffect(e)
end
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.tfil1,tp,0x0c,0,1,nil,e)
	end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsAbleToRemove() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,0x0c)
	end
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		if Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)~=0 then
			local g=Duel.GetMatchingGroup(cm.tfil1,tp,0x0c,0,nil,e)
			if #g>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local sg=g:Select(tp,1,1,nil)
				Duel.BreakEffect()
				Duel.HintSelection(sg)
				Duel.SendtoGrave(sg,REASON_EFFECT)
			end
		end
	end
end

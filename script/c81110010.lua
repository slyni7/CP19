--Guilty Smoke
function c81110010.initial_effect(c)

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetValue(c81110010.val)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81110010,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,81110010)
	e2:SetCondition(c81110010.cn)
	e2:SetTarget(c81110010.tg)
	e2:SetOperation(c81110010.op)
	e2:SetHintTiming(0,TIMING_MAIN_END)
	c:RegisterEffect(e2)
	--grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81110010,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(aux.exccon)
	e3:SetCost(c81110010.vco)
	e3:SetTarget(c81110010.vtg)
	e3:SetOperation(c81110010.vop)
	c:RegisterEffect(e3)
end

--atk
function c81110010.val(e,c)
	return Duel.GetTurnCount()*400
end

--remove
function c81110010.cn(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end

function c81110010.filter(c)
	return c:IsAbleToRemove() and c:IsFaceup()
end
function c81110010.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then
		return chkc:IsControler(1-tp) and c:IsOnField() and c81110010.filter(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c81110010.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c)
		and c:IsAbleToRemove()
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c81110010.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,c)
	g:AddCard(c)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,2,0,0)
end

function c81110010.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and c:IsLocation(0x04) and tc:IsRelateToEffect(e) and tc:IsLocation(0x04) then
		local g=Group.FromCards(c,tc)
		if Duel.Remove(g,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
			local og=Duel.GetOperatedGroup()
			local oc=og:GetFirst()
			while oc do
				if oc:IsControler(tp) then
					oc:RegisterFlagEffect(81110010,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
				else
					oc:RegisterFlagEffect(81110010,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
				end
				oc=og:GetNext()
			end
			og:KeepAlive()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetCountLimit(1)
			e1:SetCondition(c81110010.rcn)
			e1:SetOperation(c81110010.rop)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetLabelObject(og)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function c81110010.filter2(c)
	return c:GetFlagEffect(81110010)~=0
end
function c81110010.rcn(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp or Duel.GetTurnPlayer()~=tp
end
function c81110010.rop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local sg=g:Filter(c81110010.filter2,nil)
	if sg:GetCount()>1 and sg:GetClassCount(Card.GetPreviousControler)==1 then
		local ft=Duel.GetLocationCount(sg:GetFirst():GetPreviousControler(),LOCATION_MZONE)
		if ft==1 then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(81110010,2))
			local tc=sg:Select(tp,1,1,nil):GetFirst()
			Duel.ReturnToField(tc)
			sg:RemoveCard(tc)
		end
	end
	local tc=sg:GetFirst()
	while tc do
		Duel.ReturnToField(tc)
		tc=sg:GetNext()
	end
end

--grave
function c81110010.vcofilter(c)
	return c:IsDiscardable() and c:IsSetCard(0xcae)
end
function c81110010.vco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81110010.vcofilter,tp,LOCATION_HAND,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c81110010.vcofilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end

function c81110010.vtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end

function c81110010.vop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end

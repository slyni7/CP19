--슈우세츠

function c81030130.initial_effect(c)
	
	--summon method
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsAttribute,ATTRIBUTE_WATER),1)
	
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,81030130)
	e1:SetTarget(c81030130.dstg)
	e1:SetOperation(c81030130.dsop)
	c:RegisterEffect(e1)
	
	--status update
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81030130,2))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c81030130.sucn)
	e2:SetOperation(c81030130.suop)
	c:RegisterEffect(e2)
	
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81030130,3))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCondition(c81030130.spcn)
	e3:SetTarget(c81030130.sptg)
	e3:SetOperation(c81030130.spop)
	c:RegisterEffect(e3)
	
end

--destroy
function c81030130.dstgfilter(c)
	return c:IsDestructable() and c:IsFaceup()
end
function c81030130.dstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return
				Duel.IsExistingTarget(c81030130.dstgfilter,tp,LOCATION_SZONE,0,1,nil)
			and Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil)
			end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,c81030130.dstgfilter,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,1)
end

function c81030130.dsop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg~=2 then
		return
	end
	if tg and tg:IsRelateToEffect(e) then
		Duel.Destroy(tg,REASON_EFFECT)
		tg=Duel.GetOperatedGroup()
		local d1=0
		local d2=0
		local tc=tg:GetFirst()
		while tc do
			if tc then
				if tc:GetPreviousControler()==0 then
					d1=d1+1
				else
					d2=d2+1
				end
			end
			tc=tg:GetNext()
		end
			if d1>0 and Duel.SelectYesNo(0,aux.Stringid(81030130,1)) then
			Duel.Draw(0,d1,REASON_EFFECT)
		end
			if d2>0 and Duel.SelectYesNo(1,aux.Stringid(81030130,1)) then
			Duel.Draw(1,d2,REASON_EFFECT)
		end
	end
end

--status update
function c81030130.sucnfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT)
	   and c:IsSetCard(0xca3)
	   and c:GetPreviousControler()==tp
	   and c:IsPreviousLocation(LOCATION_SZONE)
	   and c:IsPreviousPosition(POS_FACEUP)
end
function c81030130.sucn(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c81030130.sucnfilter,1,nil,tp)
end

function c81030130.suop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c81030130.suopfilter)
	e1:SetValue(500)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c81030130.suopfilter(e,c)
	return c:IsSetCard(0xca3)
end

--special summon
function c81030130.spcn(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_BATTLE) or ( rp~=tp and c:IsReason(REASON_EFFECT) )
		and c:GetPreviousControler()==tp 
		and c:IsPreviousLocation(LOCATION_MZONE)
end

function c81030130.sptgfilter(c,e,tp)
	return c:IsSetCard(0xca3) and c:IsType(TYPE_MONSTER)
	   and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c81030130.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return
				chkc:IsLocation(LOCATION_GRAVE)
			and chkc:IsControler(tp)
			and c81030130.sptgfilter(chkc,e,tp)
			end
	if chk==0 then return
				Duel.IsExistingTarget(c81030130.sptgfilter,tp,LOCATION_GRAVE,0,1,c,e,tp)
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c81030130.sptgfilter,tp,LOCATION_GRAVE,0,1,1,c,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end

function c81030130.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end

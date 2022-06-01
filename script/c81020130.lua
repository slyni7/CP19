--se-re-

function c81020130.initial_effect(c)

	c:EnableReviveLimit()
	--mat
	aux.AddFusionProcMix(c,true,true,aux.FilterBoolFunction(c81020130.mat1),aux.FilterBoolFunction(c81020130.mat2))
	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	
	--salvage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81020130,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c81020130.thcn)
	e2:SetTarget(c81020130.thtg)
	e2:SetOperation(c81020130.thop)
	c:RegisterEffect(e2)

	--Actvation
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81020130,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,81020130)
	e3:SetCondition(c81020130.atcn)
	e3:SetCost(c81020130.atco)
	e3:SetTarget(c81020130.attg)
	e3:SetOperation(c81020130.atop)
	c:RegisterEffect(e3)
	
	--draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(81020130,2))
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c81020130.drcn)
	e4:SetTarget(c81020130.drtg)
	e4:SetOperation(c81020130.drop)
	c:RegisterEffect(e4)
	
end

--mat
function c81020130.mat1(c)
	return c:IsSetCard(0xca2) and c:IsType(TYPE_MONSTER)
end
function c81020130.mat2(c)
	return not c:IsAttribute(ATTRIBUTE_WIND) and c:IsType(TYPE_MONSTER)
end

--salvage
function c81020130.thcn(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end

function c81020130.thtgfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xca2) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c81020130.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81020130.thtgfilter,tp,LOCATION_REMOVED,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end

function c81020130.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c81020130.thtgfilter,tp,LOCATION_REMOVED,0,1,2,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
	
--Actvation
function c81020130.atcn(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()~=tp
end
function c81020130.atcofilter(c)
	return
		( c:IsSetCard(0xca2) and c:IsType(TYPE_SPELL) )
	and c:IsAbleToRemoveAsCost()
end
function c81020130.atco(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=LOCATION_HAND+LOCATION_GRAVE
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81020130.atcofilter,tp,loc,0,2,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c81020130.atcofilter,tp,loc,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c81020130.attgfilter(c)
	return ( c:IsSetCard(0xca2) and c:IsType(TYPE_SPELL) and c:IsFacedown() )
		and c:GetSequence()~=5
end
function c81020130.attg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(LOCATION_SZONE) and c81020130.attgfilter(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c81020130.attgfilter,tp,LOCATION_SZONE,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEDOWN)
	Duel.SelectTarget(tp,c81020130.attgfilter,tp,LOCATION_SZONE,0,1,1,nil)
end
function c81020130.atop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.ConfirmCards(tp,tc)
		if tc:IsType(TYPE_SPELL) then 
			local te=tc:GetActivateEffect()
			local tep=tc:GetControler()
			if not te then
				Duel.Destroy(tc,REASON_EFFECT)
			else
				local condition=te:GetCondition()
				local cost=te:GetCost()
				local target=te:GetTarget()
				local operation=te:GetOperation()
				if te:GetCode()==EVENT_FREE_CHAIN and te:IsActivatable(tep)
					and (not condition or condition(te,tep,eg,ep,ev,re,r,rp))
					and (not cost or cost(te,tep,eg,ep,ev,re,r,rp,0))
					and (not target or target(te,tep,eg,ep,ev,re,r,rp,0))
				then
					Duel.ClearTargetCard()
					e:SetProperty(te:GetProperty())
					Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
					Duel.ChangePosition(tc,POS_FACEUP)
					if tc:GetType()==TYPE_SPELL 
						then tc:CancelToGrave(false)
					end
					tc:CreateEffectRelation(te)
					if cost 
						then cost(te,tep,eg,ep,ev,re,r,rp,1)
					end
					if target
						then target(te,tep,eg,ep,ev,re,r,rp,1)
					end
					local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
					local tg=g:GetFirst()
					while tg do
						tg:CreateEffectRelation(te)
						tg=g:GetNext()
					end
					tc:SetStatus(STATUS_ACTIVATED,true)
					if operation
						then operation(te,tep,eg,ep,ev,re,r,rp)
					end
					tc:ReleaseEffectRelation(te)
					tg=g:GetFirst()
					while tg do
						tg:ReleaseEffectRelation(te)
						tg=g:GetNext()
					end
				else
					Duel.Destroy(tc,REASON_EFFECT)
				end
			end
		end
	end
end

--draw
function c81020130.drcn(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE)
	and c:GetReasonPlayer()==1-tp
	and bit.band(c:GetSummonType(),SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c81020130.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsPlayerCanDraw(tp,2)
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c81020130.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end


--[ D:011 ]
local s,id=GetID()
function s.initial_effect(c)

	YuL.Activate(c)
	
	local e2=MakeEff(c,"Qo","S")
	e2:SetD(id,0)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1,0,EFFECT_COUNT_CODE_CHAIN)
	e2:SetCondition(function(_,tp,_,_,_,_,_,rp) return rp==1-tp end)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)

	local e1=MakeEff(c,"Qo","S")
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCL(1)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	
end

function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(function(c) return c:IsFacedown() and not c:IsHasEffect(EFFECT_CANNOT_CHANGE_POSITION) end,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return #g>0 and not Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_FLIP_SUMMON) end
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_FLIP_SUMMON) then return end
	local flipg=Duel.GetMatchingGroup(function(c) return c:IsFacedown() and not c:IsHasEffect(EFFECT_CANNOT_CHANGE_POSITION) end,tp,LOCATION_MZONE,0,nil)
	if #flipg>0 then
		local flipcard=flipg:Select(tp,1,1,nil):GetFirst()
		Duel.ChangePosition(flipcard,POS_FACEUP_ATTACK)
		Duel.RaiseEvent(flipcard,EVENT_FLIP_SUMMON_SUCCESS,e,0,tp,tp,0)
		Duel.RaiseSingleEvent(flipcard,EVENT_FLIP_SUMMON_SUCCESS,e,0,tp,tp,0)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_SUMMON_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetValue(SUMMON_TYPE_FLIP)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD)
		flipcard:RegisterEffect(e1)
		if flipcard:IsSetCard(0xcd6e) then
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetCode(EFFECT_IMMUNE_EFFECT)
			e2:SetTargetRange(LOCATION_MZONE,0)
			e2:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_PENDULUM))
			e2:SetValue(s.efilter)
			e2:SetLabelObject(re)
			e2:SetReset(RESET_CHAIN)
			Duel.RegisterEffect(e2,tp)
		end
	end
end
function s.efilter(e,re)
	return re==e:GetLabelObject()
end

function s.filter(c)
	return c:IsFaceup() and c:IsCanTurnSet() and c:IsSetCard(0xcd6e)
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.filter(chkc) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,0,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.chkfilter(c,e)
	return c:IsRelateToEffect(e) and c:IsLocation(LOCATION_MZONE) and c:IsFaceup()
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(s.chkfilter,nil,e)
	if #g>0 then
		if Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)~=0 then
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end

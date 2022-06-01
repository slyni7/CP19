--다원마도서의 신판
function c27184644.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH)
	e2:SetCountLimit(1,27184644+EFFECT_COUNT_CODE_OATH)
	e2:SetOperation(c27184644.op2)
	c:RegisterEffect(e2)
end
function c27184644.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCondition(c27184644.con21)
	e1:SetOperation(c27184644.op21)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_NEGATED)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetCondition(c27184644.con21)
	e2:SetOperation(c27184644.op22)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1)
	e3:SetReset(RESET_PHASE+PHASE_END)
	e3:SetCondition(c27184644.con23)
	e3:SetOperation(c27184644.op23)
	Duel.RegisterEffect(e3,tp)
	e1:SetLabelObject(e3)
	e2:SetLabelObject(e3)
end
function c27184644.con21(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL)
end
function c27184644.op21(e,tp,eg,ep,ev,re,r,rp)
	local lo=e:GetLabelObject()
	local ct=lo:GetLabel()
	lo:SetLabel(ct+1)
end
function c27184644.op22(e,tp,eg,ep,ev,re,r,rp)
	local lo=e:GetLabelObject()
	local ct=lo:GetLabel()
	if ct<1 then
		ct=1
	end
	lo:SetLabel(ct-1)
end
function c27184644.con23(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabel()>0
end
function c27184644.ofilter231(c)
	return c:IsSetCard(0x306e) and c:GetCode()~=27184644 and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c27184644.ofilter232(c,e,tp,lv)
	return c:IsLevelBelow(lv) and c:IsRace(RACE_SPELLCASTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c27184644.op23(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,27184644)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c27184644.ofilter231,tp,LOCATION_DECK,0,1,e:GetLabel(),nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(c27184644.ofilter232,tp,LOCATION_DECK,0,1,nil,e,tp,g:GetCount())
			and Duel.SelectYesNo(tp,aux.Stringid(27184644,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=Duel.SelectMatchingCard(tp,c27184644.ofilter232,tp,LOCATION_DECK,0,1,1,nil,e,tp,g:GetCount())
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
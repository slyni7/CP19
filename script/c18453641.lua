--마녀의 지명자
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Link.AddProcedure(c,s.matfilter,1,1)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id)
	e3:SetCondition(s.spcon)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,1))
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,{id,1})
	e5:SetCondition(s.setcon)
	e5:SetTarget(s.settg)
	e5:SetOperation(s.setop)
	c:RegisterEffect(e5)
end
function s.matfilter(c,lc,sumtype,tp)
	return c:IsSetCard("지명자",lc,sumtype,tp) and not c:IsType(TYPE_LINK,lc,sumtype,tp)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rc:IsSetCard("지명자") and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function s.namefilter(c,cd)
	return c:IsCode(cd) and c:IsFaceup()
end
function s.spfilter(c,e,tp)
	return c:IsSetCard("지명자") and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and not Duel.IsExistingMatchingCard(s.namefilter,tp,LOCATION_ONFIELD,0,1,nil,c:GetCode())
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.setcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and re:IsActiveType(TYPE_MONSTER)
		and re:GetHandler():IsSetCard("지명자") and re:GetHandler()~=e:GetHandler()
end
function s.setfilter(c)
	return (c:IsSetCard("지명자") or c:IsSetCard("지명자")) and c:IsType(TYPE_SPELL+TYPE_TRAP) and (c:IsAbleToHand() or c:IsSSetable())
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and tc:IsSSetable() and (not tc:IsAbleToHand() or Duel.SelectYesNo(tp,aux.Stringid(id,1))) then
			Duel.SSet(tp,tc)
		else
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end

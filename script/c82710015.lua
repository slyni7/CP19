--운명의 예견
function c82710015.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SECIAL_SUMMON)
	e1:SetCondition(c82710015.con1)
	e1:SetTarget(c82710015.tar1)
	e1:SetOperation(c82710015.op1)
	c:RegisterEffect(e1)
	if not c82710015.glo_chk then
		c82710015.glo_chk=true
		c82710015[0]=true
		c82710015[1]=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_BATTLE_DESTROYING)
		ge1:SetOperation(c82710015.gop1)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c82710015.gop2)
		Duel.RegisterEffect(ge2,0)
	end
end
function c82710015.gop1(e,tp,eg,ep,ev,re,r,rp)
	c82710015[ep]=false
end
function c82710015.gop2(e,tp,eg,ep,ev,re,r,rp)
	c82710015[0]=true
	c82710015[1]=true
end
function c82710015.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN2 and c82710015[tp]
end
function c82710015.tfil1(c,e,tp)
	return c:IsSetCard(0x5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c82710015.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(c82710015.tfil1,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c82710015.op1(e,tp,eg,ep,ev,re,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c82710015.tfil1,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
--SSSS.PY-더 더블헬릭스
local s,id=GetID()
function s.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x22f2),2,2)
	--change name
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetValue(18453502)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	--e2:SetCountLimit(1,id)
	e2:SetCost(s.cost)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	if not GhostBelleTable then GhostBelleTable={} end
	table.insert(GhostBelleTable,e2)
end
s.listed_series={0x22f2}
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetFlagEffect(tp,id)==0
	end
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
end
function s.spfilter(c,e,tp,zone)
	return c:IsSetCard(0x22f2) and c:IsType(TYPE_MONSTER) and (c:IsAbleToHand() or (zone~=0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)))
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local zone=e:GetHandler():GetLinkedZone(tp)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp,zone) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	e:SetLabel(Duel.SelectOption(tp,70,71,72))
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ocode=c:GetOriginalCode()
	if ocode==SSSSGridmanCodes[id] and Duel.SelectEffectYesNo(tp,c,aux.Stringid(18453493,4)) then
		Duel.ResetFlagEffect(tp,id)
		local op=Duel.SelectOption(tp,aux.Stringid(ocode,0),aux.Stringid(ocode,1))
		if op==0 then
			Duel.RegisterFlagEffect(tp,ocode,RESET_PHASE+PHASE_END,0,1)
			local mt=_G["c"..ocode]
			local te=mt.eff_ct[c][1]
			local op=te:GetOperation()
			op(e,tp,eg,ep,ev,re,r,rp)
		elseif op==1 then
			Duel.RegisterFlagEffect(tp,ocode+1,RESET_PHASE+PHASE_END,0,1)
			local mt=_G["c"..ocode]
			local te=mt.eff_ct[c][3]
			local op=te:GetOperation()
			op(e,tp,eg,ep,ev,re,r,rp)
		end
		return
	end
	if Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)==0 then return end
	Duel.ConfirmDecktop(1-tp,1)
	local g=Duel.GetDecktopGroup(1-tp,1)
	local tc=g:GetFirst()
	local opt=e:GetLabel()
	if (opt==0 and tc:IsType(TYPE_MONSTER)) or (opt==1 and tc:IsType(TYPE_SPELL)) or (opt==2 and tc:IsType(TYPE_TRAP)) then
		local zone=e:GetHandler():GetLinkedZone(tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp,zone)
		local sc=sg:GetFirst()
		if sc then
			if zone~=0 then
				aux.ToHandOrElse(sc,tp,function(c)
						return sc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end,
						function(c)
						Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP,zone) end,
						aux.Stringid(id,1)
						)
			else
				Duel.SendtoHand(sc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sc)
			end
		end
	end
end
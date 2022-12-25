--고블리스 시무르그
local s,id=GetID()
function s.initial_effect(c)
	Link.AddProcedure(c,nil,2,2,s.pfun1)
	c:EnableReviveLimit()
	local e1=MakeEff(c,"STo")
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"F","M")
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetTR("M","M")
	e2:SetValue(aux.tgoval)
	e2:SetTarget(s.tar2)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"I","M")
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetCountLimit(1,id)
	WriteEff(e3,3,"TO")
	c:RegisterEffect(e3)
end
function s.pfun1(g,lc,sumtype,tp)
	return g:IsExists(Card.IsSetCard,1,nil,0x12d,lc,sumtype,tp)
end
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_LINK)
end
function s.tfil1(c,e,tp,zone)
	return c:IsRace(RACE_WINGEDBEAST) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,zone)
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local zone=c:GetLinkedZone(tp)
	if chk==0 then
		return Duel.GetLocCount(tp,"M")>0 and Duel.IEMCard(s.tfil1,tp,"H",0,1,nil,e,tp,zone) 
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocCount(tp,"M")<1 then
		return
	end
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	local zone=c:GetLinkedZone(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SMCard(tp,s.tfil1,tp,"H",0,1,1,nil,e,tp,zone)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone)
	end
end
function s.tar2(e,c)
	local ec=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	if ec:IsLinked() then
		local lg=ec:GetLinkedGroup()
		if c==ec then
			return true
		end
		if lg:IsContains(c) and c:IsSetCard(0x12d) then
			return true
		end
	end
	local mg=ec:GetMutualLinkedGroup()
	while #mg>0 do
		if mg:IsContains(c) and c:IsControler(tp) then
			return true
		end
		local tg=mg:Clone()
		mg=Group.CreateGroup()
		local tc=tg:GetFirst()
		while tc do
			local ug=tc:GetMutualLinkedGroup()
			mg:Merge(ug)
			tc=tg:GetNext()
		end
	end
	return false
end
function s.spfilter2(c,e,tp,lg)
	local att=c:GetAttribute()
	local satt=0
	if bit.band(att,ATTRIBUTE_FIRE)==ATTRIBUTE_FIRE then
		satt=satt+ATTRIBUTE_WATER
	end
	if bit.band(att,ATTRIBUTE_LIGHT)==ATTRIBUTE_LIGHT then
		satt=satt+ATTRIBUTE_DARK
	end
	if bit.band(att,ATTRIBUTE_WIND)==ATTRIBUTE_WIND then
		satt=satt+ATTRIBUTE_EARTH
	end
	if bit.band(att,ATTRIBUTE_WATER)==ATTRIBUTE_WATER then
		satt=satt+ATTRIBUTE_FIRE
	end
	if bit.band(att,ATTRIBUTE_EARTH)==ATTRIBUTE_EARTH then
		satt=satt+ATTRIBUTE_WIND
	end
	if bit.band(att,ATTRIBUTE_DARK)==ATTRIBUTE_DARK then
		satt=satt+ATTRIBUTE_LIGHT
	end
	return c:IsFaceup() and lg:IsContains(c) and Duel.IsExistingMatchingCard(s.spfilter3,tp,LOCATION_DECK,0,1,nil,e,tp,satt)
end
function s.spfilter3(c,e,tp,att)
	return c:IsAttribute(att) and c:IsSetCard(0x12d)
		and (c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) or c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp))
end
function s.tar3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local zone={}
	zone[0]=c:GetLinkedZone(0)
	zone[1]=c:GetLinkedZone(1)
	local lg=c:GetLinkedGroup()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.spfilter2(chkc,e,tp,lg) end
	if chk==0 then return (Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone[tp])>0
		or Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone[1-tp])>0)
		and Duel.IsExistingTarget(s.spfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp,lg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.spfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp,lg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not (c:IsRelateToEffect(e) or tc or tc:IsRelateToEffect(e)) or tc:IsFacedown() then return end
	local zone={}
	zone[0]=c:GetLinkedZone(0)
	zone[1]=c:GetLinkedZone(1)
	if Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone[tp])<=0
		and Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone[1-tp])<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local att=tc:GetAttribute()
	local satt=0
	if bit.band(att,ATTRIBUTE_FIRE)==ATTRIBUTE_FIRE then
		satt=satt+ATTRIBUTE_WATER
	end
	if bit.band(att,ATTRIBUTE_LIGHT)==ATTRIBUTE_LIGHT then
		satt=satt+ATTRIBUTE_DARK
	end
	if bit.band(att,ATTRIBUTE_WIND)==ATTRIBUTE_WIND then
		satt=satt+ATTRIBUTE_EARTH
	end
	if bit.band(att,ATTRIBUTE_WATER)==ATTRIBUTE_WATER then
		satt=satt+ATTRIBUTE_FIRE
	end
	if bit.band(att,ATTRIBUTE_EARTH)==ATTRIBUTE_EARTH then
		satt=satt+ATTRIBUTE_WIND
	end
	if bit.band(att,ATTRIBUTE_DARK)==ATTRIBUTE_DARK then
		satt=satt+ATTRIBUTE_LIGHT
	end
	local g=Duel.SelectMatchingCard(tp,s.spfilter3,tp,LOCATION_DECK,0,1,1,nil,e,tp,satt)
	local tc=g:GetFirst()
	if tc then
		local sump=tp
		if tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp,zone[1-tp])
			and (not tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone[tp]) or Duel.SelectYesNo(tp,aux.Stringid(id,2))) then
			sump=1-tp
		end
		Duel.SpecialSummon(tc,0,tp,sump,false,false,POS_FACEUP,zone[sump])
	end
end

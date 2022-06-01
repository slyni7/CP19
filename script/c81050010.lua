--흑곡의 닷거미

function c81050010.initial_effect(c)

	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c81050010.spcn)
	e2:SetOperation(c81050010.spop)
	c:RegisterEffect(e2)
	
	--control swap
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81050010,0))
	e3:SetCategory(CATEGORY_CONTROL)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,81050010)
	e3:SetTarget(c81050010.cwtg)
	e3:SetOperation(c81050010.cwop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_FLIP)
	c:RegisterEffect(e4)
	
	--salvage
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(81050010,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetCountLimit(1,81050010)
	e5:SetCondition(c81050010.svcn)
	e5:SetTarget(c81050010.svtg)
	e5:SetOperation(c81050010.svop)
	c:RegisterEffect(e5)
	
end

--special summon
function c81050010.spcnfilter(c)
	return ( c:IsLocation(LOCATION_HAND) or c:IsFaceup() ) and c:IsReleasable()
	   and c:IsRace(RACE_INSECT)
end
function c81050010.spcn(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.CheckReleaseGroupEx(tp,c81050010.spcnfilter,1,e:GetHandler(),c)
	 and ( Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		or Duel.CheckReleaseGroup(tp,c81050010.spcnfilter,1,e:GetHandler(),c) )
end

function c81050010.spop(e,tp,eg,ep,ev,re,r,rp,c)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then
		local g1=Duel.SelectReleaseGroup(tp,c81050010.spcnfilter,1,1,e:GetHandler(),c)
		Duel.Release(g1,REASON_MATERIAL)
	else
		local g=Duel.SelectReleaseGroupEx(tp,c81050010.spcnfilter,1,1,e:GetHandler(),c)
		Duel.Release(g,REASON_MATERIAL)
	end
end

--control swap
function c81050010.cwtgfilter(c)
	return c:IsFaceup() and c:IsControlerCanBeChanged()
end
function c81050010.cwtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return
				chkc:IsLocation(LOCATION_MZONE)
			and chkc:IsControler(1-tp)
			and c81050010.cwtgfilter(chkc)
			end
	if chk==0 then return 
				Duel.IsExistingTarget(c81050010.cwtgfilter,tp,0,LOCATION_MZONE,1,nil)
			end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c81050010.cwtgfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end

function c81050010.cwop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if not Duel.GetControl(tc,tp,PHASE_END,1) then
			if not tc:IsImmuneToEffect(e) and tc:IsAbleToChangeControler() then
				Duel.Destroy(tc,REASON_EFFECT)
			end
			return
		end
		local e1=Effect.CreateEffect(c)
		local reset=RESET_EVENT+0x1fc0000+RESET_PHASE+PHASE_END
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(reset)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		tc:RegisterEffect(e2)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_ADD_SETCODE)
		e3:SetValue(0xca6)
		tc:RegisterEffect(e3)
	end
end

--salvage
function c81050010.svcn(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end

function c81050010.svtgfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	 and ( c:IsSetCard(0xca6) and c:IsType(TYPE_MONSTER) )
	   and c:IsLevelBelow(5)
end
function c81050010.svtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return
				chkc:IsLocation(LOCATION_GRAVE)
			and chkc:IsControler(tp)
			and c81050010.svtgfilter(chkc,e,tp)
			end
	if chk==0 then return
				Duel.IsExistingTarget(c81050010.svtgfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
			end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c81050010.svtgfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end

function c81050010.svop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
end

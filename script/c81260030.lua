--펑크랙 기어 돌
--카드군 번호: 0xcbf
function c81260030.initial_effect(c)
	
	--특수소환
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetTargetRange(POS_FACEUP_ATTACK,0)
	e1:SetCondition(c81260030.mcn)
	c:RegisterEffect(e1)
	
	--덤핑
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81260030,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,81260030)
	e2:SetTarget(c81260030.tg2)
	e2:SetOperation(c81260030.op2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	
	--싱크로
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(81260030,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,81260031)
	e4:SetCondition(c81260030.cn4)
	e4:SetCost(aux.bfgcost)
	e4:SetTarget(c81260030.tg4)
	e4:SetOperation(c81260030.op4)
	c:RegisterEffect(e4)
end

--특수소환
function c81260030.mcn(e,c)
	if c==nil then
		return true
	end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
	and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE,0)>0
end

--덤핑
function c81260030.filter0(c)
	return c:IsAbleToGrave() and c:IsSetCard(0xcbf)
end
function c81260030.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81260030.filter0,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c81260030.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c81260030.filter0,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end

--싱크로
function c81260030.cn4(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()~=tp and ( ph==PHASE_MAIN1 or ph==PHASE_MAIN2 )
end
function c81260030.mfil0(c)
	return c:IsSetCard(0xcbf) and c:IsType(TYPE_MONSTER)
end
function c81260030.mfil1(c)
	return c:IsHasEffect(EFFECT_HAND_SYNCHRO) and c:IsType(TYPE_MONSTER)
end
function c81260030.mfil2(c,syn)
	local b1=true
	if c:IsHasEffect(EFFECT_HAND_SYNCHRO) then
		b1=Duel.CheckTunerMaterial(syn,c,nil,c81260030.mfil0,1,99)
	end
	return b1 and syn:IsSynchroSummonable(c)
end
function c81260030.sfilter(c,mg)
	return mg:IsExists(c81260030.mfil2,1,nil,c) and c:IsSetCard(0xcbf)
end
function c81260030.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetMatchingGroup(c81260030.mfil0,tp,LOCATION_MZONE,0,nil)
		local exg=Duel.GetMatchingGroup(c81260030.mfil1,tp,LOCATION_MZONE,0,nil)
		mg:Merge(exg)
		return Duel.IsExistingMatchingCard(c81260030.sfilter,tp,LOCATION_EXTRA,0,1,nil,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c81260030.op4(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(c81260030.mfil0,tp,LOCATION_MZONE,0,nil)
	local exg=Duel.GetMatchingGroup(c81260030.mfil1,tp,LOCATION_MZONE,0,nil)
	mg:Merge(exg)
	local g=Duel.GetMatchingGroup(c81260030.sfilter,tp,LOCATION_EXTRA,0,nil,mg)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local tg=mg:FilterSelect(tp,c81260030.mfil2,1,1,nil,sg:GetFirst())
		Duel.SynchroSummon(tp,sg:GetFirst(),tg:GetFirst())
	end
end



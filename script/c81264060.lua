--베노퀄리아 레티블
--카드군 번호: 0xc94

function c81264060.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c81264060.mfilter,1,1)
	
	--소재 제약
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e1:SetCondition(c81264060.cn1)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	
	--스탯 감소
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81264060,0))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,81264060)
	e2:SetCondition(c81264060.cn2)
	e2:SetTarget(c81264060.tg2)
	e2:SetOperation(c81264060.op2)
	c:RegisterEffect(e2)
	--프리체인
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCondition(c81264060.cn3)
	c:RegisterEffect(e3)
	
	--의식 소환
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(81264060,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetHintTiming(0,TIMING_MAIN_END+TIMING_BATTLE_START+TIMING_BATTLE_END)
	e4:SetCountLimit(1,81264060)
	e4:SetCondition(c81264060.cn4)
	e4:SetCost(aux.bfgcost)
	e4:SetTarget(c81264060.tg4)
	e4:SetOperation(c81264060.op4)
	c:RegisterEffect(e4)
end

--링크 소환
function c81264060.mfilter(c)
	return c:IsSetCard(0xc94) and not c:IsType(TYPE_LINK)
end

function c81264060.cn1(e)
	local c=e:GetHandler()
	return c:IsStatus(STATUS_SPSUMMON_TURN) and c:IsSummonType(SUMMON_TYPE_LINK)
end

--스탯 감소
function c81264060.cn2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>2
end
function c81264060.cn3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)<=2
end

function c81264060.filter1(c)
	return c:IsPosition(POS_FACEUP_ATTACK) and c:GetAttack()>0
end
function c81264060.dfilter0(c)
	return c:IsAbleToGrave() and c:IsSetCard(0xc94)
	and ( c:IsFaceup() or c:IsLocation(LOCATION_HAND) )
end
function c81264060.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(1-tp) and chkc:IsLocation(0x0c) and c81264060.filter1(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c81264060.filter1,tp,0,LOCATION_MZONE,1,nil)
		and Duel.IsExistingMatchingCard(c81264060.dfilter0,tp,0x02+0x0c,0,1,e:GetHandler())
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c81264060.filter1,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,0x02+0x0c)
end
function c81264060.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:GetAttack()>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c81264060.dfilter0,tp,0x02+0x0c,0,1,1,e:GetHandler())
		if g:GetCount()>0 then
			Duel.BreakEffect()
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end

--의식 소환
function c81264060.cn4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ph=Duel.GetCurrentPhase()
	return c:IsSummonType(SUMMON_TYPE_LINK) and Duel.GetTurnPlayer()~=tp
	and ( ph==PHASE_MAIN1 or ( ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE ) or ph==PHASE_MAIN2 )
end
function c81264060.filter2(c,e,tp)
	return c:GetType()&0x81==0x81 and c:IsSetCard(0xc94)
	and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false)
end
function c81264060.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81264060.filter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c81264060.op4(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c81264060.filter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP) then
		tc:CompleteProcedure()
	end
end
	
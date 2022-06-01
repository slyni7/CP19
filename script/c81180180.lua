--KMS(메탈 블러드) 비스마르크
--카드군 번호: 0xcb5
--티르피츠 관련 효과는 81180000[KMS 티르피츠]에서 SetCondition을 수정하여 작성

function c81180180.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,3,c81180180.mfilter0)
	
	--진영 버프
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCondition(c81180180.cn1)
	e1:SetTarget(c81180180.tg1)
	e1:SetValue(500)
	c:RegisterEffect(e1)
	
	--타점 2배
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81180180,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c81180180.cn2)
	e2:SetOperation(c81180180.op2)
	c:RegisterEffect(e2)
	
	--엑시즈 소환
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81180180,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,81180180)
	e3:SetCost(c81180180.co3)
	e3:SetTarget(c81180180.tg3)
	e3:SetOperation(c81180180.op3)
	c:RegisterEffect(e3)
end

--링크 소재
function c81180180.mfilter0(g,lc)
	return g:IsExists(Card.IsType,1,nil,TYPE_LINK)
end

--진영 버프
function c81180180.cn1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSequence()>4 and Duel.GetTurnPlayer()~=tp
end
function c81180180.tg1(e,c)
	return c:IsFaceup() and c:IsSetCard(0xcb5) and c:GetSequence()<=4
end

--타점 2배
function c81180180.cn2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and bc and bc:IsFaceup() and bc:IsRelateToBattle()
	and Duel.GetAttacker()==c
end
function c81180180.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToBattle() and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetValue(c:GetBaseAttack()*2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end

--엑시즈 소환
function c81180180.filter0(c)
	return c:IsAbleToRemoveAsCost() and c:IsSetCard(0xcb5) and c:IsType(TYPE_MONSTER)
end
function c81180180.co3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81180180.filter0,tp,LOCATION_GRAVE,0,1,nil)
	end
	Duel.Hint(HINT_SELCTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c81180180.filter0,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c81180180.tfilter(c,e,tp)
	local rk=c:GetRank()
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
	and Duel.IsExistingMatchingCard(c81180180.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,rk+1)
	and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
end
function c81180180.xyzfilter(c,e,tp,mc,rk)
	return c:IsRank(rk) and c:IsSetCard(0xcb5) and mc:IsCanBeXyzMaterial(c)
	and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c81180180.tg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then
		return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c81180180.tfilter(chkc,e,tp)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c81180180.tfilter,tp,LOCATION_MZONE,0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELCTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c81180180.tfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c81180180.op3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then
		return
	end
	if Duel.GetLocationCountFromEx(tp,tp,tc)<=0 or not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) then
		return
	end
	Duel.Hint(HINT_SELCTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c81180180.xyzfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetRank()+1)
	local sc=g:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end
	
	

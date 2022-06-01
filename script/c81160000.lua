--그림자무리의 개
function c81160000.initial_effect(c)

	--summon method
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81160000,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c81160000.cn)
	e1:SetOperation(c81160000.op)
	c:RegisterEffect(e1)
	
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81160000,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,81160000)
	e2:SetTarget(c81160000.tg)
	e2:SetOperation(c81160000.op)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end

--summon
function c81160000.cfilter(c)
	return c:GetSequence()<5
end
function c81160000.cn(e,c,minc)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	return minc==0 and c:GetLevel()>4 
	and not Duel.IsExistingMatchingCard(c81160000.cfilter,tp,LOCATION_MZONE,0,1,nil)
end

--spsummon
function c81160000.filter1(c,e,tp,lv,mc)
	return lv>0 and c:IsLevelBelow(4) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToRemove()
	and Duel.IsExistingMatchingCard(c81160000.exfilter,tp,0x40,0,1,nil,e,tp,lv+c:GetLevel(),mc)
end
function c81160000.exfilter(c,e,tp,lv,mc)
	return c:IsLevel(lv) and c:IsSetCard(0xcb3) and c:IsType(TYPE_SYNCHRO)
	and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c81160000.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then
		return chkc:IsControler(tp) and chkc:IsLocation(0x10) and c81160000.filter1(chkc,e,tp,c:GetLevel(),c)
	end
	if chk==0 then
		return not Duel.IsPlayerAffectedByEffect(e:GetHandlerPlayer(),69832741)
		and c:IsAbleToRemove()
		and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL)
		and Duel.IsExistingTarget(c81160000.filter1,tp,0x10,0,1,nil,e,tp,c:GetLevel(),c)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c81160000.filter1,tp,0x10,0,1,1,nil,e,tp,c:GetLevel(),c)
	g:AddCard(c)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,2,tp,0x10+0x0c)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x40)
end
function c81160000.op(e,tp,eg,ep,ev,re,r,rp)
	if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL) then
		return
	end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or not tc:IsRelateToEffect(e) or c:IsFacedown() then
		return
	end
	local lv=c:GetLevel()+tc:GetLevel()
	local g=Group.FromCards(c,tc)
	if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c81160000.exfilter,tp,0x40,0,1,1,nil,e,tp,lv,nil):GetFirst()
		if sg then
			Duel.SpecialSummon(sg,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
			sg:CompleteProcedure()
		end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetTargetRange(0x08,0)
		e1:SetCountLimit(1,81160001)
		e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xcb3))
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end

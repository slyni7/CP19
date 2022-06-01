--난항의 메탈 블러드
function c81180110.initial_effect(c)

	c:EnableCounterPermit(0xcb5)
	c:SetCounterLimit(0xcb5,5)
	
	--Activation
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	
	--count place
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(c81180110.op1)
	c:RegisterEffect(e2)
	
	--atk update
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xcb5))
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetValue(c81180110.va1)
	c:RegisterEffect(e3)
	local e6=e3:Clone()
	e6:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e6)
	
	--effect
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(81180110,0))
	e4:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,81180110)
	e4:SetCost(c81180110.co4)
	e4:SetTarget(c81180110.tg4)
	e4:SetOperation(c81180110.op4)
	c:RegisterEffect(e4)
	
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(81180110,2))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1,81180110)
	e5:SetCost(c81180110.co5)
	e5:SetTarget(c81180110.tg5)
	e5:SetOperation(c81180110.op5)
	c:RegisterEffect(e5)
	
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(81180110,1))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCountLimit(1,81180110)
	e6:SetCost(c81180110.co6)
	e6:SetTarget(c81180110.tg6)
	e6:SetOperation(c81180110.op6)
	c:RegisterEffect(e6)
end

--counter
function c81180110.filter1(c,tp)
	return c:GetPreviousControler()==tp	and c:IsSetCard(0xcb5)
end
function c81180110.op1(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c81180110.filter1,1,nil,tp) then
		e:GetHandler():AddCounter(0xcb5,1)
	end
end

function c81180110.va1(e,c)
	return e:GetHandler():GetCounter(0xcb5)*100
end

--effect
function c81180110.co4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsCanRemoveCounter(tp,1,0,0xcb5,1,REASON_COST)
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(81180110,0))
	Duel.RemoveCounter(tp,1,0,0xcb5,1,REASON_COST)
end
function c81180110.filter2(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0xcb5)
end
function c81180110.tg4(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(LOCATION_MZONE) and c81180110.filter2(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c81180110.filter2,tp,LOCATION_MZONE,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c81180110.filter2,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,g,1,0,300)
	Duel.SetOperationInfo(0,CATEGORY_DEFCHANGE,g,1,0,300)
end
function c81180110.op4(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then
		return
	end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(300)
		e1:SetReset(RESET_EVENT+0x1fe000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
	end
end


function c81180110.co5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsCanRemoveCounter(tp,1,0,0xcb5,4,REASON_COST)
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(81180110,2))
	Duel.RemoveCounter(tp,1,0,0xcb5,4,REASON_COST)
end
function c81180110.xfilter0(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0xcb5) and c:IsType(TYPE_XYZ)
	and Duel.GetLocationCountFromEx(tp,tp,c)>-1
	and Duel.IsExistingMatchingCard(c81180110.xfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,c:GetRank()+1)
end
function c81180110.xfilter1(c,e,tp,mc,rk)
	return c:GetRank()==rk and c:IsSetCard(0xcb5)
	and mc:IsCanBeXyzMaterial(c) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c81180110.tg5(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c81180110.xfilter0(chkc,e,tp)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c81180110.xfilter0,tp,LOCATION_MZONE,0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c81180110.xfilter0,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c81180110.op5(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then
		return
	end
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCountFromEx(tp,tp,tc)<=0 then
		return
	end
	if not tc or tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c81180110.xfilter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetRank()+1)
	local sc=g:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
	end
end


function c81180110.co6(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsCanRemoveCounter(tp,1,0,0xcb5,2,REASON_COST)
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(81180110,1))
	Duel.RemoveCounter(tp,1,0,0xcb5,2,REASON_COST)
end
function c81180110.filter4(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	and c:IsType(TYPE_MONSTER) and c:IsSetCard(0xcb5)
end
function c81180110.tg6(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c81180110.filter4,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c81180110.op6(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c81180110.filter4,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end



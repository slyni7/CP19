--owari

function c81080020.initial_effect(c)

	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c81080020.spcn)
	e1:SetOperation(c81080020.spop)
	c:RegisterEffect(e1)
	
	--effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_ATTACK)
	c:RegisterEffect(e3)
	
	--장착
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(81080020,0))
	e4:SetCategory(CATEGORY_EQUIP)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c81080020.cn4)
	e4:SetTarget(c81080020.tg4)
	e4:SetOperation(c81080020.op4)
	c:RegisterEffect(e4)
end

--special summon
function c81080020.spcn(e,c)
	if c==nil then 
		return true
	end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
	and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE,0)>0
	and Duel.GetCustomActivityCount(81080020,tp,ACTIVITY_SUMMON)==0
	and Duel.GetCustomActivityCount(81080020,tp,ACTIVITY_SPSUMMON)==0
end
function c81080020.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c81080020.lim)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	Duel.RegisterEffect(e2,tp)
end
function c81080020.lim(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xcab)
end

--equip
function c81080020.cn4(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2) or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)
end
function c81080020.tfil0(c,tp)
	return c:CheckUniqueOnField(tp) and not c:IsForbidden() and c:IsType(TYPE_MONSTER)
	and c:IsSetCard(0xcab)
end
function c81080020.tg4(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup()
	end
	if chk==0 then
		return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c81080020.tfil0,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c81080020.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or not tc:IsRelateToEffect(e) or tc:IsFacedown() then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local ec=Duel.SelectMatchingCard(tp,c81080020.tfil0,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
	if ec then
		Duel.Equip(tp,ec,tc)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetValue(c81080020.val)
		e1:SetLabelObject(tc)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		ec:RegisterEffect(e1)
	end
end
function c81080020.val(e,c)
	return c==e:GetLabelObject()
end



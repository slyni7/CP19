function c81040170.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddSynchroMixProcedure(c,aux.NonTuner(c81040170.mfilter),nil,nil,aux.Tuner(nil),1,99)

	--summon relation
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.synlimit)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	c:RegisterEffect(e2)

	--battle relation
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,1)
	e3:SetCondition(c81040170.cn)
	e3:SetValue(c81040170.val)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e4)
	
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCondition(c81040170.ecn)
	e5:SetOperation(c81040170.eop)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_MATERIAL_CHECK)
	e6:SetValue(c81040170.val2)
	e6:SetLabelObject(e5)
	c:RegisterEffect(e6)
	
	--effect
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(81040170,0))
	e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e7:SetCode(EVENT_LEAVE_FIELD)
	e7:SetCountLimit(1,81040170)
	e7:SetCondition(c81040170.cn)
	e7:SetTarget(c81040170.tg)
	e7:SetOperation(c81040170.op)
	c:RegisterEffect(e7)
end

--material
function c81040170.mfilter(c)
	return c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0xca4)
end

--battle relation
function c81040170.cn(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
function c81040170.val(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end

function c81040170.filter(c)
	return c:IsType(TYPE_TUNER)
end
function c81040170.val2(e,c)
	local g=c:GetMaterial()
	local ct=g:FilterCount(c81040170.filter,nil)
	e:GetLabelObject():SetLabel(ct)
end

function c81040170.ecn(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and e:GetLabel()>0
end
function c81040170.eop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabel()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	e1:SetValue(ct-1)
	c:RegisterEffect(e1)
end

--spsummon
function c81040170.cn(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end

function c81040170.tfil(c,e,tp)
	return c:IsSetCard(0xca4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c81040170.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(LOCATION_GRAVE) and c:IsControler(tp) and c81040170.tfil(chkc)
	end
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c81040170.tfil,tp,LOCATION_GRAVE,0,1,e:GetHandler(),e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c81040170.tfil,tp,LOCATION_GRAVE,0,1,1,e:GetHandler(),e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,LOCATION_GRAVE)
end

function c81040170.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
end

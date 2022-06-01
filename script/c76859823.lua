--�ƴ������� ��ȯ��
function c76859823.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c76859823.potg)
	e1:SetOperation(c76859823.poop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetCountLimit(1,76859823)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c76859823.con3)
	e3:SetTarget(c76859823.tar3)
	e3:SetOperation(c76859823.op3)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetCountLimit(1,76859824)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCost(c76859823.cost4)
	e4:SetCondition(c76859823.con4)
	e4:SetTarget(c76859823.tar4)
	e4:SetOperation(c76859823.op4)
	c:RegisterEffect(e4)
end
function c76859823.potg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return e:GetHandler():IsAttackPos() end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,e:GetHandler(),1,0,0)
end
function c76859823.poop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsAttackPos() and c:IsRelateToEffect(e) then
		Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
	end
end

function c76859823.afil1(c)
	return c:IsSetCard(0x2cb)
end
function c76859823.con3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>3
end
function c76859823.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c76859823.op3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then
		return
	end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c76859823.tar21(e,c)
	return not c:IsSetCard(0x2cb)
end
function c76859823.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetCustomActivityCount(76859823,tp,ACTIVITY_SPSUMMON)<1
	end
end
function c76859823.tar41(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x2cb)
end
function c76859823.nfil4(c)
	return c:GetSequence()<5 and (c:IsFacedown() or not c:IsSetCard(0x2cb))
end
function c76859823.nfil2(c)
	return c:GetSequence()<5 and (c:IsFacedown() or not c:IsSetCard(0x2cb))
end
function c76859823.con4(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c76859823.nfil2,tp,LOCATION_MZONE,0,1,nil)
end
function c76859823.tfil4(c,e,tp)
	return c:IsSetCard(0x2cb) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c76859823.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(c76859823.tfil4,tp,LOCATION_HAND,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c76859823.op4(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c76859823.tfil4,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
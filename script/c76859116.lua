--Angel Notes - ¸®Çã¼³
function c76859116.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCountLimit(1,76859116+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c76859116.con1)
	e1:SetTarget(c76859116.tg1)
	e1:SetOperation(c76859116.op1)
	c:RegisterEffect(e1)
end
function c76859116.nfilter1(c)
	return c:GetSequence()<5 and (c:IsFacedown() or not c:IsSetCard(0x2c8))
end
function c76859116.con1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c76859116.nfilter1,tp,LOCATION_MZONE,0,1,nil)
end
function c76859116.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsPlayerCanSpecialSummonMonster(tp,76859116,0x2c8,TYPE_MONSTER+TYPE_EFFECT+TYPE_TUNER,0,1200,2,RACE_FAIRY,ATTRIBUTE_LIGHT)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c76859116.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<1
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,76859116,0x2c8,TYPE_MONSTER+TYPE_EFFECT+TYPE_TUNER,0,1200,2,RACE_FAIRY,ATTRIBUTE_LIGHT) then
		return
	end
	c:AddMonsterAttribute(TYPE_EFFECT+TYPE_TUNER)
	Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+0xfe0000)
	e1:SetValue(c76859116.oval11)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SYNCHRO_LEVEL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetReset(RESET_EVENT+0xfe0000)
	e2:SetValue(c76859116.oval12)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetDescription(aux.Stringid(76859116,2))
	e3:SetReset(RESET_EVENT+0xfe0000+RESET_PHASE+PHASE_END)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e3:SetCountLimit(1)
	e3:SetTarget(c76859116.otg13)
	e3:SetOperation(c76859116.oop13)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_BE_MATERIAL)
	e4:SetReset(RESET_EVENT+0x120000)
	e4:SetCondition(c76859116.ocon14)
	e4:SetOperation(c76859116.oop14)
	c:RegisterEffect(e4)
	Duel.SpecialSummonComplete()
end
function c76859116.oval11(e,te)
	return e:GetHandler()~=te:GetOwner() and te:IsActiveType(TYPE_MONSTER)
end
function c76859116.oval12(e,c)
	local lv=e:GetHandler():GetLevel()
	return 3*0x10000+lv
end
function c76859116.otg13(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c76859116.oofilter131(c,e,tp)
	return c:IsSetCard(0x2c8) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c76859116.oofilter132(c)
	return c:IsSetCard(0x2c8) and c:IsType(TYPE_MONSTER)
end
function c76859116.oop13(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		g=Duel.SelectMatchingCard(tp,c76859116.oofilter131,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	end
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	else
		if Duel.IsExistingMatchingCard(c76859116.oofilter132,tp,LOCATION_DECK,0,1,nil) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local dg=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
			if dg:GetCount()>0 then
				Duel.Destroy(dg,REASON_EFFECT)
			end
		end
	end
end
function c76859116.ocon14(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	return r==REASON_SYNCHRO and rc:IsSetCard(0x2c8)
end
function c76859116.oop14(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetDescription(aux.Stringid(76859116,0))
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetDescription(aux.Stringid(76859116,1))
	rc:RegisterEffect(e2,true)
end
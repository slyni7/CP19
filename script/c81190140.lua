--IJN 아마기
--카드군 번호: 0xcb6
function c81190140.initial_effect(c)

	c:EnableReviveLimit()
	c:SetSPSummonOnce(81190140)
	aux.AddFusionProcMixRep(c,true,true,c81190140.fmat,2,99,aux.FilterBoolFunction(Card.IsFusionSetCard,0xcb6))
	
	--내성
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c81190140.cn1)
	e1:SetValue(c81190140.va1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(c81190140.va2)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	
	--파괴
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81190140,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c81190140.cn3)
	e3:SetTarget(c81190140.tg3)
	e3:SetOperation(c81190140.op3)
	c:RegisterEffect(e3)
end

--융합 소재
function c81190140.fmat(c,fc,sumtype,tp)
	return c:IsAttackBelow(3000,fc,sumtype,tp) and c:IsType(0x1,fc,sumtype,tp)
end

--내성
function c81190140.cn1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabel()>0 and e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c81190140.va1(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c81190140.cfilter(c)
	return c:IsType(TYPE_SPIRIT) and c:IsSetCard(0xcb6)
end
function c81190140.va2(e,c)
	e:GetLabelObject():SetLabel(c:GetMaterial():FilterCount(c81190140.cfilter,nil))
end

--파괴
function c81190140.cn3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c81190140.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,0,tp,LOCATION_ONFIELD)
end
function c81190140.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local ct=e:GetHandler():GetMaterialCount()
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,ct,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT,true)
	end
end
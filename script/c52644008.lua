--스타폴링
function c52644008.initial_effect(c)
	--특수소환 + 파괴
	local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetCost(c52644008.spcost)
	e1:SetTarget(c52644008.sptg)
	e1:SetOperation(c52644008.spop)
    c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_CONTROL)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetHintTiming(TIMING_BATTLE_PHASE,0x1e0+TIMING_BATTLE_PHASE)
    e2:SetCost(aux.bfgcost)
    e2:SetTarget(c52644008.chtg)
    e2:SetOperation(c52644008.chop)
    c:RegisterEffect(e2)
end
function c52644008.spfilter(c,e,tp)
	return c:IsSetCard(0x5f4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsPublic()
end
function c52644008.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c52644008.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c52644008.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	Duel.ConfirmCards(1-tp,g)
	local tc=g:GetFirst()
	tc:CreateEffectRelation(e)
	e:SetLabelObject(tc)
end
function c52644008.spcfilter(c)
	return c:IsCode(52644009) and c:IsFaceup()
end
function c52644008.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return (Duel.GetLocationCount(tp,LOCATION_MZONE)>0
				or (Duel.IsExistingMatchingCard(c52644008.spfilter,tp,LOCATION_ONFIELD,0,1,nil)
					and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0))
	end
	local dis=0
	if Duel.IsExistingMatchingCard(c52644008.spcfilter,tp,LOCATION_ONFIELD,0,1,nil) then
		dis=Duel.SelectDisableField(tp,1,LOCATION_MZONE,LOCATION_MZONE,0)
	else
		dis=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	end
	e:SetLabel(dis)
	if dis<2^16 then
		local seq=math.log(dis,2)
		Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(52644001,seq))
	else
		local seq=math.log(dis,2)-16
		Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(52644003,seq))
	end
end
function c52644008.spop(e,tp,eg,ep,ev,re,r,rp)
	local sc=e:GetLabelObject()
	if not sc:IsRelateToEffect(e) then
		return
	end
	local dis=e:GetLabel()
	local ss=0
	if e:GetLabel()>0xffff then
		ss=Duel.SpecialSummon(sc,0,tp,1-tp,false,false,POS_FACEUP,dis/0x10000)
	else
		ss=Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP,dis)
	end
	if ss>0 then
		local seq=sc:GetSequence()
		local p=sc:GetControler()
		local g=Group.CreateGroup()
		local tc=Duel.GetFieldCard(p,LOCATION_SZONE,seq)
		if tc then
			g:AddCard(tc)
		end
		if seq>0 then
			tc=Duel.GetFieldCard(p,LOCATION_MZONE,seq-1)
			if tc then
				g:AddCard(tc)
			end
		end
		if seq<4 then
			tc=Duel.GetFieldCard(p,LOCATION_MZONE,seq+1)
			if tc then
				g:AddCard(tc)
			end
		end
		if seq==1 then
			tc=Duel.GetFieldCard(p,LOCATION_MZONE,5)
			if tc then
				g:AddCard(tc)
			end
			tc=Duel.GetFieldCard(1-p,LOCATION_MZONE,6)
			if tc then
				g:AddCard(tc)
			end
		end
		if seq==3 then
			tc=Duel.GetFieldCard(p,LOCATION_MZONE,6)
			if tc then
				g:AddCard(tc)
			end
			tc=Duel.GetFieldCard(1-p,LOCATION_MZONE,5)
			if tc then
				g:AddCard(tc)
			end
		end
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c52644008.filter(c)
    return c:GetControler()~=c:GetOwner()
end
function c52644008.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c52644008.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function c52644008.chop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE)
    local tc=g:GetFirst()
    while tc do
        if not tc:IsImmuneToEffect(e) then
            tc:ResetEffect(EFFECT_SET_CONTROL,RESET_CODE)
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_SET_CONTROL)
            e1:SetValue(tc:GetOwner())
            e1:SetReset(RESET_EVENT+0xec0000)
            tc:RegisterEffect(e1)
        end
        tc=g:GetNext()
    end
end
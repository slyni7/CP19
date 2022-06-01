--��Ÿ�� Ǫ��
function c52644003.initial_effect(c)
	--��ũ ���� �Ұ�
	local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
    e1:SetValue(1)
    c:RegisterEffect(e1)
	--Ư����ȯ + �ı�
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e2:SetCountLimit(1,52644997)
	e2:SetTarget(c52644003.sptg)
	e2:SetOperation(c52644003.spop)
	c:RegisterEffect(e2)
	--���Ĺ��̿� �ϼ���
	local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetCountLimit(1)
	e3:SetTarget(c52644003.chtg)
	e3:SetOperation(c52644003.chop)
    c:RegisterEffect(e3)
	--�ϼ����̸� �ı� X
	local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCondition(c52644003.indcon)
    e4:SetValue(1)
    c:RegisterEffect(e4)
	--ȭ�����̸� �ı�
	local e5=Effect.CreateEffect(c)
    e5:SetCategory(CATEGORY_DESTROY)
    e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCountLimit(1,52644003)
	e5:SetCondition(c52644003.descon)
    e5:SetTarget(c52644003.destg)
    e5:SetOperation(c52644003.desop)
    c:RegisterEffect(e5)
	
end
function c52644003.spfilter(c)
	return c:IsCode(52644009) and c:IsFaceup()
end
function c52644003.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and (Duel.GetLocationCount(tp,LOCATION_MZONE)>0
				or (Duel.IsExistingMatchingCard(c52644003.spfilter,tp,LOCATION_ONFIELD,0,1,nil)
					and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0))
	end
	local dis=0
	if Duel.IsExistingMatchingCard(c52644003.spfilter,tp,LOCATION_ONFIELD,0,1,nil) then
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
function c52644003.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	local dis=e:GetLabel()
	local ss=0
	if e:GetLabel()>0xffff then
		ss=Duel.SpecialSummon(c,0,tp,1-tp,false,false,POS_FACEUP,dis/0x10000)
	else
		ss=Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP,dis)
	end
	if ss>0 then
		local seq=c:GetSequence()
		local p=c:GetControler()
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
function c52644003.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return not e:GetHandler():IsRace(RACE_ROCK) end
end
function c52644003.chop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsFaceup() and c:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CHANGE_RACE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
        e1:SetValue(RACE_ROCK)
        c:RegisterEffect(e1)
    end
end
function c52644003.indcon(e)
    return e:GetHandler():IsRace(RACE_ROCK)
end
function c52644003.descon(e)
	return e:GetHandler():IsRace(RACE_PYRO)
end
function c52644003.desfilter(c)
    return c:IsSetCard(0x5f4) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c52644003.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) end
    if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c52644003.desop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.Destroy(tc,REASON_EFFECT)
		local c=e:GetHandler()
		if c:IsFaceup() and c:IsRelateToEffect(e) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_RACE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(RACE_ROCK)
			c:RegisterEffect(e1)
		end
    end
end

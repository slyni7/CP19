--HMS(로열 네이비) 넵튠
function c81200080.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c81200080.mfilter1,2,2,c81200080.mfilter2)
	
	--status
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(aux.TRUE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(-400)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	
	--pierce
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_PIERCE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xcb7))
	e3:SetTargetRange(LOCATION_MZONE,0)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c81200080.cn4)
	e4:SetOperation(c81200080.op4)
	c:RegisterEffect(e4)
	
	--search
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(81200080,0))
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,81200080)
	e5:SetCondition(c81200080.cn5)
	e5:SetTarget(c81200080.tg5)
	e5:SetOperation(c81200080.op5)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_DESTROYED)
	e6:SetCondition(c81200080.cn6)
	c:RegisterEffect(e6)
end

--summon method
function c81200080.mfilter1(c,lc,sumtype,tp)
	return c:IsType(TYPE_EFFECT,lc,sumtype,tp) and c:IsRace(RACE_MACHINE,lc,sumtype,tp)
end
function c81200080.mfilter2(g,lc)
	return g:IsExists(Card.IsSetCard,1,nil,0xcb7)
end

--pierce
function c81200080.cn4(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return ep~=tp and tc:IsSetCard(0xcb7) and tc:GetBattleTarget()~=nil and tc:GetBattleTarget():IsDefensePos()
end
function c81200080.op4(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev*2)
end

--search
function c81200080.cfilter(c,ec)
	if c:IsSetCard(0xcb7) then
		if c:IsLocation(LOCATION_MZONE) then
			return ec:GetLinkedGroup():IsContains(c)
		else
			return bit.band(ec:GetLinkedGroup(c:GetPreviousControler()),bit.lshift(0x1,c:GetPreviousSequence()))~=0
		end
	end
end
function c81200080.cn5(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c81200080.cfilter,1,nil,e:GetHandler())
end
function c81200080.cn6(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetPreviousControler()==tp
	and ( c:IsReason(REASON_BATTLE) or ( rp~=tp and c:IsReason(REASON_EFFECT) )  )
end
function c81200080.filter1(c)
	return c:IsSSetable(true) and c:IsSetCard(0xcb8) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c81200080.tg5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c81200080.filter1,tp,LOCATION_DECK,0,1,nil)
	end
end
function c81200080.op5(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c81200080.filter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
	end
end



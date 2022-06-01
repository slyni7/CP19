--멜로디블 프레스트라토
function c81150110.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xcb2),1,1,c81150110.mat)
	
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_INDESTURCTABLE_BATTLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c81150110.cn)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTURCTABLE_EFFECT)
	e2:SetValue(aux.indoval)
	c:RegisterEffect(e2)
	
	--atk increase
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c81150110.val)
	c:RegisterEffect(e3)
	
	--extra attack
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(81150110,0))
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetCountLimit(1,81150110)
	e4:SetCondition(c81150110.ecn)
	e4:SetCost(c81150110.eco)
	e4:SetTarget(c81150110.etg)
	e4:SetOperation(c81150110.eop)
	c:RegisterEffect(e4)
	if c81150110.global_check then
		c81150110.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ATTACK_ANNOUNCE)
		ge1:SetOperation(c81150110.chkop)
		Duel.RegisterEffect(ge1,0)
	end
end

--material
function c81150110.mat(g,lc)
	return not g:IsExists(Card.IsType,1,nil,TYPE_LINK)
end

--indes
function c81150110.cn(e)
	return e:GetHandler():GetLinkedGroupCount()>0
end

--atk inc.
function c81150110.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0xcb2)
end
function c81150110.val(e,c)
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c81150110.filter1,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
	return g:GetClassCount(Card.GetCode)*200
end

--atk dec.
function c81150110.chkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if not tc:IsSetCard(0xcb2) then
		Duel.RegisterFlagEffect(tc:GetControler(),81150110,RESET_PHASE+PHASE_END,0,1)
	end
end
function c81150110.eco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetFlagEffect(tp,81150110)==0
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e1:SetTarget(c81150110.atg)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c81150110.atg(e,c)
	return not c:IsSetCard(0xcb2)
end

function c81150110.ecn(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetBattleTarget()
	return tc and tc:IsFaceup()
end
function c81150110.etg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then
		return true
	end
	e:GetHandler():GetBattleTarget():CreateEffectRelation(e)
end
function c81150110.eop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	if not tc:IsImmuneToEffect(e)	
	or (not c:IsRelateToEffect(e) or c:IsFacedown() )
	or (not tc:IsRelateToEffect(e) or tc:IsFacedown() ) then
		local atk=tc:GetBaseAttack()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		if c:IsFaceup() and c:IsRelateToEffect(e) and not c:IsImmuneToEffect(e) then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetValue(math.ceil(atk/2))
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e2)
			local e3=e2:Clone()
			e3:SetCode(EFFECT_EXTRA_ATTACK)
			e3:SetValue(1)
			c:RegisterEffect(e3)
		end
	end
end

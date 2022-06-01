--HMS(로열 네이비) 벨파스트
function c81200050.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddSynchroMixProcedure(c,c81200050.mat,nil,nil,aux.NonTuner(Card.IsSetCard,0xcb7),1,99)
	
	--status
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xcb7))
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetValue(300)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81200050,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,81200050+EFFECT_COUNT_CODE_SINGLE)
	e3:SetCost(c81200050.co3)
	e3:SetTarget(c81200050.tg3)
	e3:SetOperation(c81200050.op3)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetDescription(aux.Stringid(81200050,2))
	e4:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetTarget(c81200050.tg4)
	e4:SetOperation(c81200050.op4)
	c:RegisterEffect(e4)
	
end

--material
function c81200050.mat(c)
	return c:IsType(TYPE_TUNER) or c:IsCode(81200020)
end

--튜너대체
function c81200050.synval(e,c,sc)
	local lv=e:GetHandler():GetLink()
	if sc:IsCode(81200050) then 
		return lv
	else
		return 0
	end
end
function c81200050.syntar(e,c)
	return c:IsCode(81200160) and c:IsType(TYPE_LINK)
end

--indes
function c81200050.co3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.CheckLPCost(tp,500)
	end
	Duel.PayLPCost(tp,500)
end
function c81200050.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0xcb7)
end
function c81200050.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81200050.filter1,tp,LOCATION_MZONE,0,1,nil)
	end
end
function c81200050.op3(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c81200050.vtg)
	e1:SetValue(c81200050.vva)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
	local g=Group.CreateGroup()
	g:KeepAlive()
	e1:SetLabelObject(g)
end
function c81200050.vfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
	and c:IsSetCard(0xcb7) and ( c:IsReason(REASON_BATTLE) or c:IsReason(REASON_EFFECT) and rp~=tp )
	and c:GetFlagEffect(81200050)==0
end
function c81200050.vtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return eg:IsExists(c81200050.vfilter,1,nil,tp)
	end
	local g=eg:Filter(c81200050.vfilter,nil,tp)
	local tc=g:GetFirst()
	while tc do
		tc:RegisterFlagEffect(81200050,RESET_EVENT+0x1fc0000+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(81200050,0))
		tc=g:GetNext()
	end
	e:GetLabelObject():Clear()
	e:GetLabelObject():Merge(g)
	return true
end
function c81200050.vva(e,c)
	local g=e:GetLabelObject()
	return g:IsContains(c)
end

--increase
function c81200050.tg4(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c81200050.filter1(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c81200050.filter1,tp,LOCATION_MZONE,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c81200050.filter1,tp,LOCATION_MZONE,0,1,1,nil)
end
function c81200050.op4(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
	end
end
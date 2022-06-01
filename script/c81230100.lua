--요도 아카조메
--카드군 번호:0xcbc
function c81230100.initial_effect(c)

	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c81230100.tg1)
	e1:SetOperation(c81230100.op1)
	c:RegisterEffect(e1)

	--장착 효과
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e2)
	--진염행혼 장착 시 추가 효과
	local e3=e2:Clone()
	e3:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
	e3:SetCondition(c81230100.cn3)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(81230100,0))
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_DAMAGE_STEP_END)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,81230100)
	e4:SetCondition(c81230100.cn4)
	e4:SetTarget(c81230100.tg4)
	e4:SetOperation(c81230100.op4)
	c:RegisterEffect(e4)
	
		
	--공통 효과
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(81230100,1))
	e5:SetCategory(CATEGORY_COUNTER)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_REMOVE)
	e5:SetTarget(c81230100.tg5)
	e5:SetOperation(c81230100.op5)
	c:RegisterEffect(e5)
	--Equip limit
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_EQUIP_LIMIT)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetValue(c81230100.lm1)
	c:RegisterEffect(e6)
end

--발동
function c81230100.lm1(e,c)
	return c:IsSetCard(0xcbc)
end
function c81230100.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0xcbc)
end
function c81230100.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(LOCATION_MZONE) and c81230100.filter1(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c81230100.filter1,tp,LOCATION_MZONE,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c81230100.filter1,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c81230100.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end

--장착 효과
function c81230100.cn3(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	return ec and ec:GetOriginalCode()==81230010
end

function c81230100.cn4(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	return ec and ec:GetOriginalCode()==81230010
	and Duel.GetAttacker()==ec
end
function c81230100.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetCounter(0,1,0,0xcbc)
	if chk==0 then
		return ct>0
	end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*100)
end
function c81230100.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetCounter(0,1,0,0xcbc)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	if c:IsRelateToEffect(e) and ct>0 then
		Duel.Damage(p,ct*100,REASON_EFFECT)
	end
end

--공통 효과
function c81230100.filter0(c)
	return c:IsFaceup() and c:IsSetCard(0xcbc) and c:IsCanAddCounter(0xcbc,1)
end
function c81230100.tg5(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsOnField() and chkc:IsControler(tp) and c81230100.filter0(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c81230100.filter0,tp,LOCATION_ONFIELD,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,94)
	Duel.SelectTarget(tp,c81230100.filter0,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0xcbc)
end
function c81230100.op5(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		tc:AddCounter(0xcbc,1)
	end
end

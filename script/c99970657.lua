--[ hololive 3rd Gen ]
local m=99970657
local cm=_G["c"..m]
function cm.initial_effect(c)

	--장착
	YuL.Equip(c,nil,aux.FBF(Card.IsCode,99970654))
	
	--공격력 증가
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_EQUIP)
	e0:SetCode(EFFECT_UPDATE_ATTACK)
	e0:SetValue(2000)
	c:RegisterEffect(e0)
	
	--드로우
	local e1=MakeEff(c,"FTo","S")
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)

	--●파괴 대체
	local e03=Effect.CreateEffect(c)
	e03:SetType(EFFECT_TYPE_EQUIP+EFFECT_TYPE_CONTINUOUS)
	e03:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e03:SetCode(EFFECT_DESTROY_REPLACE)
	e03:SetTarget(cm.union_reptg)
	e03:SetOperation(cm.union_repop)
	c:RegisterEffect(e03)
	
end

--드로우
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and eg:GetFirst()==e:GetHandler():GetEquipTarget()
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end

--●파괴 대체
function cm.union_reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function cm.union_repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
end

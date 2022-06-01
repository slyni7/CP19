--클래식 메모리즈 - 린네
local m=76859930
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddXyzProcedure(c,nil,9,2,nil,nil,99)
	c:EnableReviveLimit()
	local e1=MakeEff(c,"Qo","M")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCL(1)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	--not fully implemented
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:CheckRemoveOverlayCard(tp,1,REASON_COST)
	end
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(Card.IsFaceup,tp,"M","M",1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
	local rc=Duel.AnnounceAttribute(tp,1,ATTRIBUTE_ALL)
	e:SetLabel(rc)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=MakeEff(c,"F")
	e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e1:SetTR("M","M")
	e1:SetValue(e:GetLabel())
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=MakeEff(c,"F")
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetTR(1,0)
	Duel.RegisterEffect(e2,tp)
	local e3=MakeEff(c,"FC")
	e3:SetCode(EVENT_CHAIN_ACTIVATING)
	e3:SetLabel(e:GetLabel())
	Duel.RegisterEffect(e3,tp)
	local e4=MakeEff(c,"FC")
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetLabel(e:GetLabel())
	Duel.RegisterEffect(e4,tp)
	e3:SetOperation(cm.oop13(e2,e4))
	e4:SetOperation(cm.oop14(e2,e3))
end
function cm.oop13(e1,e2)
	return function(e,tp,eg,ep,ev,re,r,rp)
		local rc=re:GetHandler()
		if rp==tp or not re:IsActiveType(TYPE_MONSTER) or not rc:IsAttribute(e:GetLabel()) then
			return
		end
		if Duel.NegateEffect(ev) then
			Duel.Hint(HINT_CARD,0,m)
			local rc=re:GetHandler()
			if rc:IsRelateToEffect(re) then
				Duel.Destroy(rc,REASON_EFFECT)
			end
			e1:Reset()
			e2:Reset()
			e:Reset()
		end
	end
end
function cm.oop14(e1,e2)
	return function(e,tp,eg,ep,ev,re,r,rp)
		if Duel.GetTurnPlayer()==tp then
			return
		end
		local ac=Duel.GetAttacker()
		if ac:IsAttribute(e:GetLabel()) and Duel.NegateAttack(ac) then
			Duel.Hint(HINT_CARD,0,m)
			Duel.Destroy(ac,REASON_EFFECT)
			e1:Reset()
			e2:Reset()
			e:Reset()
		end
	end
end
--클래식 메모리얼 - 메이코
local m=76859916
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e0=MakeEff(c,"SC")
	e0:SetCode(EVENT_TO_GRAVE)
	WriteEff(e0,0,"O")
	c:RegisterEffect(e0)
	local e1=MakeEff(c,"I","H")
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetCL(1)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"FTf","M")
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetCL(1)
	WriteEff(e2,1,"TO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"Qo","G")
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetCL(1)
	WriteEff(e3,3,"NCTO")
	c:RegisterEffect(e3)
end
function cm.op0(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsReason(REASON_COST) and re and re:IsActivated() and not c:IsReason(REASON_RETURN) then
		c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,0)
	end
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=c:IsDiscardable()
	local b2=not c:IsPublic()
	if chk==0 then
		return b1 or b2
	end
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(m,1)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(m,2)
		opval[off-1]=2
		off=off+1
	end
	if off==1 then
		return
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
	elseif opval[op]==2 then
		local e1=MakeEff(c,"S")
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SOI(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,1000,REASON_EFFECT)
end
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(m)>0
end
function cm.cfil3(c,tp)
	if c:IsLoc("H") then
		return c:IsDiscardable()
	elseif c:IsControler(1-tp) then
		return Duel.IsPlayerAffectedByEffect(tp,76859930) and c:IsReleasable()
	else
		return Duel.GetFlagEffect(tp,m)==0 and c:IsSetCard(0x2c0) and c:IsType(TYPE_MONSTER) and c:IsReleasable()
	end
end
function cm.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.cfil3,tp,"HD","M",1,nil,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SMCard(tp,cm.cfil3,tp,"HD","M",1,1,nil,tp)
	local tc=g:GetFirst()
	if tc:IsLoc("H") then
		Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
	elseif tc:IsControler(1-tp) then
		Duel.Release(g,REASON_COST)
	else
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
		Duel.SendtoGrave(g,REASON_COST+REASON_RELEASE)
	end
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToHand()
	end
	Duel.SOI(0,CATEGORY_RECOVER,nil,0,tp,1000)
	Duel.SOI(0,CATEGORY_TOHAND,c,1,0,0)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.Recover(tp,1000,REASON_EFFECT)>0 and c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
	local e1=MakeEff(c,"F")
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetTR(1,0)
	Duel.RegisterEffect(e1,tp)
	local e2=MakeEff(c,"FC")
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetLabelObject(e1)
	e2:SetOperation(cm.oop32)
	Duel.RegisterEffect(e2,tp)
end
function cm.oofil32(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x2c0) and c:IsControler(tp) and c:IsLoc("M")
end
function cm.oop32(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()==tp then
		return
	end
	local ac=Duel.GetAttacker()
	if Duel.NegateAttack(ac) then
		Duel.Hint(HINT_CARD,0,m)
		Duel.Recover(tp,ac:GetAttack(),REASON_EFFECT)
		local te=e:GetLabelObject()
		te:Reset()
		e:Reset()
	end
end
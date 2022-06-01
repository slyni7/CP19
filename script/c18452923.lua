--타비 네즈미
local m=18452923
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"Qo","H")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetCountLimit(1,m)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsDiscardable()
	end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return true
	end
	if chk==0 then
		return Duel.IETarget(aux.TRUE,tp,0,"G",1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.STarget(tp,aux.TRUE,tp,0,"G",1,1,nil)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local typ=tc:GetType()&0x7
		local e1=MakeEff(c,"FC")
		e1:SetCode(EVENT_CHAIN_END)
		e1:SetCountLimit(1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabel(typ)
		e1:SetOperation(cm.oop11)
		Duel.RegisterEffect(e1,tp)
		local e2=MakeEff(c,"FC")
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetCountLimit(1)
		e2:SetReset(RESET_PHASE+PHASE_END)
		e2:SetOperation(cm.oop12)
		e1:SetLabelObject(e2)
		Duel.RegisterEffect(e2,tp)
		local e3=MakeEff(c,"FC")
		e3:SetCode(m)
		e3:SetReset(RESET_PHASE+PHASE_END)
		e3:SetLabel(typ)
		e3:SetLabelObject(e2)
		e3:SetOperation(cm.oop13)
		Duel.RegisterEffect(e3,tp)
	end
end
function cm.oop11(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local typ=e:GetLabel()
	local te=e:GetLabelObject()
	local e1=MakeEff(c,"FC")
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetLabel(typ)
	e1:SetLabelObject(te)
	e1:SetOperation(cm.oop13)
	Duel.RegisterEffect(e1,tp)
end
function cm.oop12(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	if ct==0 then
		Duel.Recover(tp,1000,REASON_EFFECT)
	elseif ct>1 then
		Duel.SetLP(tp,Duel.GetLP(tp)-3000)
	end
end
function cm.oop13(e,tp,eg,ep,ev,re,r,rp)
	local typ=e:GetLabel()
	local te=e:GetLabelObject()
	local rtyp=re:GetActiveType()&0x7
	if typ&rtyp>0 and rp~=tp then
		Duel.Hint(HINT_CARD,0,m)
		if Duel.Draw(tp,1,REASON_EFFECT)>0 then
			local ct=te:GetLabel()
			te:SetLabel(ct+1)
		end
	end
end
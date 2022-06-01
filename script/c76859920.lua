--클래식 메모리얼 - 메구미
local m=76859920
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e0=MakeEff(c,"SC")
	e0:SetCode(EVENT_TO_GRAVE)
	WriteEff(e0,0,"O")
	c:RegisterEffect(e0)
	local e1=MakeEff(c,"I","H")
	e1:SetCategory(CATEGORY_DRAW)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"I","M")
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetCL(1)
	WriteEff(e2,2,"C")
	WriteEff(e2,1,"TO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"Qo","G")
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetCL(1)
	WriteEff(e3,3,"NC")
	WriteEff(e3,1,"TO")
	c:RegisterEffect(e3)
end
function cm.op0(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsReason(REASON_COST) and re and re:IsActivated() and not c:IsReason(REASON_RETURN) then
		c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,0)
	end
end
function cm.cfil1(c,tp)
	if c:IsLoc("H") then
		return c:IsDiscardable() and Duel.IsPlayerCanDraw(tp,2)
	elseif c:IsControler(1-tp) then
		return Duel.IsPlayerAffectedByEffect(tp,76859930) and c:IsReleasable()
	else
		return Duel.GetFlagEffect(tp,m)==0 and c:IsSetCard(0x2c0) and c:IsType(TYPE_MONSTER) and c:IsReleasable()
	end
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IEMCard(cm.cfil1,tp,"HD","M",1,c,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SMCard(tp,cm.cfil1,tp,"HD","M",1,1,c,tp)
	local tc=g:GetFirst()
	Duel.Release(c,REASON_COST)
	if tc:IsLoc("H") then
		e:SetLabel(1)
		Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
	elseif tc:IsControler(1-tp) then
		e:SetLabel(0)
		Duel.Release(g,REASON_COST)
	else
		e:SetLabel(0)
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
		Duel.SendtoGrave(g,REASON_COST+REASON_RELEASE)
	end
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsPlayerCanDraw(tp,1)
	end
	Duel.SOI(0,CATEGORY_DRAW,nil,0,tp,e:GetLabel()+1)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,e:GetLabel()+1,REASON_EFFECT)
end
function cm.cfil2(c,tp)
	if c:IsLoc("H") then
		return c:IsDiscardable() and Duel.IsPlayerCanDraw(tp,2)
	elseif c:IsControler(1-tp) then
		return Duel.IsPlayerAffectedByEffect(tp,76859930) and c:IsReleasable()
	else
		return Duel.GetFlagEffect(tp,m+1)==0 and c:IsSetCard(0x2c0) and c:IsType(TYPE_MONSTER) and c:IsReleasable()
	end
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.cfil2,tp,"HD","M",1,nil,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SMCard(tp,cm.cfil2,tp,"HD","M",1,1,nil,tp)
	local tc=g:GetFirst()
	if tc:IsLoc("H") then
		e:SetLabel(1)
		Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
	elseif tc:IsControler(1-tp) then
		e:SetLabel(0)
		Duel.Release(g,REASON_COST)
	else
		e:SetLabel(0)
		Duel.RegisterFlagEffect(tp,m+1,RESET_PHASE+PHASE_END,0,1)
		Duel.SendtoGrave(g,REASON_COST+REASON_RELEASE)
	end
end
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(m)>0
end
function cm.cfil3(c,tp)
	if c:IsLoc("H") then
		return c:IsDiscardable() and Duel.IsPlayerCanDraw(tp,2)
	elseif c:IsControler(1-tp) then
		return Duel.IsPlayerAffectedByEffect(tp,76859930) and c:IsReleasable()
	else
		return Duel.GetFlagEffect(tp,m+2)==0 and c:IsSetCard(0x2c0) and c:IsType(TYPE_MONSTER) and c:IsReleasable()
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
		e:SetLabel(1)
		Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
	elseif tc:IsControler(1-tp) then
		e:SetLabel(0)
		Duel.Release(g,REASON_COST)
	else
		e:SetLabel(0)
		Duel.RegisterFlagEffect(tp,m+2,RESET_PHASE+PHASE_END,0,1)
		Duel.SendtoGrave(g,REASON_COST+REASON_RELEASE)
	end
end
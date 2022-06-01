--멜랑홀릭: 마스커레이드 바이러스(시간은 잊어버리고 영원히)
local m=18452761
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_DESTROY)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"STo","G")
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
end
function cm.cfil11(c)
	return c:IsSetCard(0x2d4) and c:IsType(TYPE_MONSTER) and c:IsReleasable()
end
function cm.cfil12(c)
	return c:IsSetCard(0x2d3) and c:IsType(TYPE_SPELL) and
		(c:IsReleasable() or not c:IsOnField())
end
function cm.cfil13(c)
	return c:IsSetCard("바이러스") and c:IsType(TYPE_TRAP) and
		(c:IsReleasable() or not c:IsOnField())
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	local c=e:GetHandler()
	local tc=GlobalVirusRelease
	local g1=tc and Group.FromCards(tc) or Duel.GMGroup(cm.cfil11,tp,"HM",0,nil)
	local g2=Duel.GMGroup(cm.cfil12,tp,"HO",0,nil)
	local g3=Duel.GMGroup(cm.cfil13,tp,"HO",0,c)
	if chk==0 then
		return #g1>0 or #g2>0 or #g3>0
	end
	local typ=0
	local sg=Group.CreateGroup()
	if #g1>0 and ((#g2<1 and #g3<1) or Duel.SelectYesNo(tp,16*m+1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local rg=g1:Select(tp,1,1,nil)
		sg:Merge(rg)
		typ=typ|1
	end
	if #g2>0 and ((#sg<1 and #g3<1) or Duel.SelectYesNo(tp,16*m+2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local rg=g2:Select(tp,1,1,nil)
		sg:Merge(rg)
		typ=typ|2
	end
	if #g3>0 and (#sg<1 or Duel.SelectYesNo(tp,16*m+3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local rg=g3:Select(tp,1,1,nil)
		sg:Merge(rg)
		typ=typ|4
	end
	e:SetLabel(typ)
	sg:KeepAlive()
	e:SetLabelObject(sg)
	Duel.Release(sg,REASON_COST)
end
function cm.tfil1(c)
	return c:IsLoc("M") or c:IsFaceup()
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then
			return false
		end
		e:SetLabel(0)
		return true
	end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local typ=e:GetLabel()
	local sg=e:GetLabelObject()
	local ct=#sg
	local g
	while ct>0 do
		g=Duel.GetFieldGroup(tp,0,LSTN("HO"))
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=g:Select(tp,1,1,nil)
		local tc=sg:GetFirst()
		if not tc then
			break
		end
		if tc:IsFacedown() or tc:IsLoc("H") then
			Duel.ConfirmCards(tp,sg)
		end
		if tc:IsType(typ) then
			Duel.Destroy(sg,REASON_EFFECT)
		else
			break
		end
		ct=ct-1
	end
	local e1=MakeEff(c,"FC")
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_DRAW)
	e1:SetOperation(cm.oop11)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,ct)
	e1:SetLabel(typ)
	e1:SetLabelObject(sg)
	Duel.RegisterEffect(e1,tp)
	local e2=MakeEff(c,"FC")
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.ocon12)
	e2:SetOperation(cm.oop12)
	e2:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,ct)
	e2:SetLabelObject(e1)
	Duel.RegisterEffect(e2,tp)
	c:RegisterFlagEffect(1082946,RESET_PHASE+PHASE_END+RESET_OPPO_TURN,0,ct)
	cm[c]=e2
end
function cm.oop11(e,tp,eg,ep,ev,re,r,rp)
	local typ=e:GetLabel()
	local sg=e:GetLabelObject()
	local ct=#sg
	local g
	while ct>0 do
		g=Duel.GetFieldGroup(tp,0,LSTN("HO"))
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=g:Select(tp,1,1,nil)
		local tc=sg:GetFirst()
		if not tc then
			break
		end
		if tc:IsFacedown() or tc:IsLoc("H") then
			Duel.ConfirmCards(tp,sg)
		end
		if tc:IsType(typ) then
			Duel.Destroy(sg,REASON_EFFECT)
		else
			break
		end
		ct=ct-1
	end
end
function cm.ocon12(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function cm.oop12(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabel()
	ct=ct+1
	e:SetLabel(ct)
	c:SetTurnCounter(ct)
	if ct>2 then
		e:GetLabelObjet():Reset()
		e:GetOwner():ResetFlagEffect(1082946)
	end
end
function cm.tfil2(c)
	return c:IsSetCard(0x2d3) and (c:IsAbleToHand() or c:IsAbleToGrave()) and not c:IsCode(m)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil2,tp,"D",0,1,nil)
	end
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,cm.tfil2,tp,"D",0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		if not tc:IsAbleToGrave() or Duel.SelectYesNo(tp,16*m) then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		else
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end
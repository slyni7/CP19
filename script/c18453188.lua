--파이널 히어로 샤를로트
local m=18453188
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FBF(Card.IsLinkType,TYPE_EFFECT),2,2)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_RITUAL_LEVEL)
	e1:SetValue(cm.val1)
	local e2=MakeEff(c,"FG","M")
	e2:SetTR("M","M")
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"F","M")
	e3:SetCode(EFFECT_EXTRA_RITUAL_MATERIAL_CHARLOTTE)
	e3:SetTR(0,"M")
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"Qo","M")
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetCountLimit(1)
	WriteEff(e4,4,"CTO")
	c:RegisterEffect(e4)
end
function cm.val1(e,c)
	local lv=e:GetHandler():GetLevel()
	local clv=c:GetLevel()
	return lv*65536+clv
end
function cm.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(10000)
	return true
end
function cm.cfil4(c)
	return c:GetType()&TYPE_SPELL+TYPE_RITUAL==TYPE_SPELL+TYPE_RITUAL and c:IsAbleToGraveAsCost()
end
function cm.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=10000 then
			return false
		end
		e:SetLabel(0)
		return Duel.CheckLPCost(tp,2000) and Duel.IEMCard(cm.cfil4,tp,"D",0,1,nil)
	end
	e:SetLabel(0)
	Duel.PayLPCost(tp,2000)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SMCard(tp,cm.cfil4,tp,"D",0,1,1,nil)
	local tc=g:GetFirst()
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabelObject(tc)
end
function cm.ofil4(c)
	return c:GetType()&TYPE_MONSTER+TYPE_RITUAL==TYPE_MONSTER+TYPE_RITUAL and c:IsAbleToHand()
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=0
	local g=Duel.GMGroup(cm.ofil4,tp,"D",0,nil)
	local b1=#g>0
	if b1 and Duel.SelectYesNo(tp,aux.Stringid(m,00)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
		ct=ct+1
	end
	local tc=e:GetLabelObject()
	local b2=tc:CheckActivateEffect(false,true,false)
	if b2 and Duel.SelectYesNo(tp,aux.Stringid(m,01)) then
		local te,ceg,cep,cev,cre,cr,crp=tc:CheckActivateEffect(false,true,true)
		e:SetProperty(te:GetProperty())
		e:SetCategory(te:GetCategory())
		local tg=te:GetTarget()
		if tg then
			tg(e,tp,ceg,cep,cev,cre,cr,crp)
		end
		local op=te:GetOperation()
		if op then
			op(e,tp,ceg,cep,cev,cre,cr,crp)
		end
		ct=ct+1
	end
	if ct==2 then
		local e1=MakeEff(c,"F")
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTR(1,0)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
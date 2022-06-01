--에고사이트 에이트
local m=18453117
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"STo")
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"Qf","M")
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetCountLimit(1,m)
	WriteEff(e3,3,"NCTO")
	c:RegisterEffect(e3)
end
function cm.tfil11(c)
	return c:IsFaceup() and c:IsSetCard("에고사이트")
end
function cm.tfil12(c)
	return c:IsSetCard("에고사이트") and c:IsAbleToHand()
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local sel=0
	local ct=#Duel.GMGroup(cm.tfil11,tp,"M",0,c)
	local dg=Duel.GMGroup(aux.TRUE,tp,"M","M",nil)
	if ct>0 and #dg>0 then
		sel=sel+1
	end
	if Duel.IEMCard(cm.tfil12,tp,"D",0,1,nil) then
		sel=sel+2
	end
	if chk==0 then
		return sel>0
	end
	if sel==3 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,0))
		sel=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))+1
	elseif sel==1 then
		Duel.SelectOption(tp,aux.Stringid(m,1))
	else
		Duel.SelectOption(tp,aux.Stringid(m,2))
	end
	e:SetLabel(sel)
	if sel==1 then
		e:SetCategory(CATEGORY_DESTROY)
		Duel.SOI(0,CATEGORY_DESTROY,g,1,0,0)
	else
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
	end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sel=e:GetLabel()
	if sel==1 then
		local ct=#Duel.GMGroup(cm.tfil11,tp,"M",0,c)
		local g=Duel.GMGroup(aux.TRUE,tp,"M","M",nil)
		if ct>0 and #g>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local dg=g:Select(tp,1,ct,nil)
			Duel.HintSelection(dg)
			Duel.Destroy(dg,REASON_EFFECT)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SMCard(tp,cm.tfil12,tp,"D",0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and not rc:IsSetCard("에고사이트")
end
function cm.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToHandAsCost()
	end
	Duel.SendtoHand(c,nil,REASON_COST)
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SOI(0,CATEGORY_NEGATE,eg,1,0,0)
	local rc=re:GetHandler()
	if rc:IsRelateToEffect(re) and rc:IsDestructable() then
		Duel.SOI(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentChain()~=ev+1 then
		return
	end
	local rc=re:GetHandler()
	if Duel.NegateActivation(ev) and rc:IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
--헤븐 다크사이트 -미나-
local m=18452854
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,cm.pfil1,2,2)
	local e1=MakeEff(c,"S","M")
	e1:SetCode(m)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"F","M")
	e2:SetCode(EFFECT_SET_ATTACK_FINAL)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTargetRange(LSTN("M"),LSTN("M"))
	e2:SetValue(cm.val2)
	e2:SetTarget(cm.tar2)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"S","M")
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetValue(cm.val3)
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"STo")
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetCountLimit(1,m)
	WriteEff(e4,4,"TO")
	c:RegisterEffect(e4)
	if not cm.global_check then
		cm.global_check=true
		local ge1=MakeEff(c,"FC")
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(cm.gop1)
		Duel.RegisterEffect(ge1,0)
		local ge2=MakeEff(c,"FC")
		ge2:SetCode(EVENT_CHAIN_END)
		ge2:SetOperation(cm.gop2)
		Duel.RegisterEffect(ge2,0)
	end
end
function cm.gop1(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if (rc:IsStatus(STATUS_ACT_FROM_HAND) and re:IsHasType(EFFECT_TYPE_ACTIVATE))
		or (re:IsActiveType(TYPE_MONSTER) and rc:IsReason(REASON_COST) and rc:IsLoc("G") and rc:IsPreviousLocation("H")) then
		cm[ev]=true
	else
		cm[ev]=false
	end
end
function cm.gop2(e,tp,eg,ep,ev,re,r,rp)
	local i=1
	while cm[i]~=nil do
		cm[i]=nil
		i=i+1
	end
end
function cm.pfil1(c)
	return c:GetBaseAttack()==0 and c:IsLinkType(TYPE_TUNER)
end
function cm.val2(e,c)
	return c:GetAttack()+math.ceil(c:GetAttack()/2)
end
function cm.tar2(e,c)
	local g=e:GetHandler():GetLinkedGroup()
	return g:IsContains(c) and c:GetBaseAttack()==0 and c:IsType(TYPE_TUNER)
end
function cm.val3(e,te)
	local chain=Duel.GetCurrentChain()
	return te:IsHasType(EFFECT_TYPE_ACTIONS) and chain>0 and cm[chain]
end
function cm.tfil41(c)
	return c:IsAttack(0) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.tfil42(c,g)
	g:AddCard(c)
	local res=cm.tfil41(c) and g:CheckSubGroup(cm.tfun4,2,2)
	g:RemoveCard(c)
	return res
end
function cm.tfun4(g)
	local tc=g:GetFirst()
	local nc=g:GetNext()
	return ((tc:IsLoc("G") and nc:IsLoc("D")) or (tc:IsLoc("D") and nc:IsLoc("G")))
		and ((tc:IsType(TYPE_TUNER) and nc:IsRace(RACE_FAIRY)) or (tc:IsRace(RACE_FAIRY) and nc:IsType(TYPE_TUNER)))
end
function cm.tar4(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GMGroup(cm.tfil41,tp,"D",0,nil)
	if chkc then
		return false
	end
	if chk==0 then
		return Duel.IETarget(cm.tfil42,tp,"G",0,1,nil,g)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.STarget(tp,cm.tfil42,tp,"G",0,1,1,nil,g)
	Duel.SOI(0,CATEGORY_TOHAND,tg,2,tp,"DG")
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsAbleToHand() then
		local g=Duel.GMGroup(cm.tfil41,tp,"D",0,nil)
		g:AddCard(tc)
		if g:CheckSubGroup(cm.tfun4,2,2) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:SelectSubGroup(tp,cm.tfun4,false,2,2)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
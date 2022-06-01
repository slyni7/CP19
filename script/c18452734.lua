--아로할로위즈 아스카
local m=18452734
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x2d2),
		cm.pfil1,true)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"STo")
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetCategory(CATEGORY_REMOVE)
	WriteEff(e2,2,"NTO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"STo")
	e3:SetCode(EVENT_REMOVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCategory(CATEGORY_TOHAND)
	WriteEff(e3,3,"TO")
	c:RegisterEffect(e3)
end
function cm.pfil1(c)
	return c:IsFusionAttribute(ATTRIBUTE_DARK) or c:IsHasEffect(18452720)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return ev>899 and Duel.IEMRemoveCard(nil,tp,0,"HOG",1,nil)
	end
	Duel.SOI(0,CATEGORY_REMOVE,nil,1,tp,"HOG")
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local ct=math.floor(ev/900)
	local g=Duel.GMGroup(Card.IsAbleToRemove,tp,0,"HOG",nil)
	local rg=Group.CreateGroup()
	local init=1
	while ct>0 and #g>0 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=g:Select(tp,init,1,nil)
		local tc=sg:GetFirst()
		if tc then
			rg:Merge(sg)
			local loc=tc:GetLocation()
			if loc&LSTN("O")>0 then
				loc=LSTN("O")
			end
			g:Remove(Card.IsLoc,nil,loc)
			init=0
			ct=ct-1
		else
			break
		end
	end
	if #rg>0 then
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
	end
end
function cm.tfil3(c)
	return c:IsSetCard(0x2d2) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return cm.tfil3(chkc) and chkc:IsAbleToHand() and chkc:IsControler(tp)
			and chkc:IsLoc("R")
	end
	if chk==0 then
		return Duel.IEToHandTarget(cm.tfil3,tp,"R",0,1,nil)
	end
	local g=Duel.SAToHandTarget(tp,cm.tfil3,tp,"R",0,1,1,nil)
	Duel.SOI(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
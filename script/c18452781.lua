--자이네 클라이네
local m=18452781
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"F","H")
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(cm.con1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"S","MG")
	e2:SetCode(EFFECT_CHANGE_CODE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetValue(CARD_EINE_KLEINE)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"Qo","M")
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetCL(1)
	WriteEff(e3,3,"CTO")
	c:RegisterEffect(e3)
end
function cm.con1(e,c)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	return Duel.GetLocCount(tp,"M")>0
		and Duel.GetFieldGroupCount(tp,0,LSTN("M"))>=Duel.GetFieldGroupCount(tp,LSTN("M"),0)
end
function cm.cfil3(c)
	return c:IsCode(CARD_EINE_KLEINE) and c:IsAbleToRemoveAsCost()
end
function cm.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetReleaseGroup(tp):Filter(Card.IsCode,nil,CARD_EINE_KLEINE)
	if c:IsHasEffect(EFFECT_EINE_KLEINE) then
		local rg=Duel.GMGroup(cm.cfil3,tp,"G",0,nil)
		g:Merge(rg)
	end
	if chk==0 then
		return #g>0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tg=g:Select(tp,1,1,nil)
	local tc=tg:GetFirst()
	if tc:IsLoc("G") then
		Duel.Remove(tg,POS_FACEUP,REASON_COST)
		local te=c:IsHasEffect(EFFECT_EINE_KLEINE)
		te:UseCountLimit(tp)
	else
		Duel.Release(tg,REASON_COST)
	end
end
function cm.tfil3(c)
	return c:IsSetCard("클라이네") and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsCode(m)
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil3,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,cm.tfil3,tp,"D",0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
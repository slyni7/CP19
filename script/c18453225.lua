--Trick$t@r Reinc@rn@tion
local m=18453225
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e1:SetCondition(cm.con1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"A")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_DRAW)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"Qo","G")
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCost(aux.bfgcost)
	WriteEff(e3,3,"TO")
	c:RegisterEffect(e3)
end
function cm.nfil1(c)
	return c:IsFaceup() and c:IsSetCard(0x2e9)
end
function cm.con1(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IEMCard(cm.nfil1,tp,"O",0,1,nil)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,0,LSTN("H"))
	if chk==0 then
		return #g>0 and g:FilterCount(Card.IsAbleToRemove,nil)==#g and Duel.IsPlayerCanDraw(1-tp,#g)
	end
	Duel.SOI(0,CATEGORY_REMOVE,g,#g,0,0)
	Duel.SOI(0,CATEGORY_DRAW,nil,0,1-tp,#g)
	Duel.SetChainLimit(cm.clim2)
end
function cm.clim2(e,ep,tp)
	local c=e:GetHandler()
	return c:IsType(TYPE_TUNER) or tp==ep
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LSTN("H"))
	if #g>0 and g:FilterCount(Card.IsAbleToRemove,nil)==#g then
		local oc=Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		if oc>0 then
			Duel.Draw(1-tp,oc,REASON_EFFECT)
		end
	end
end
function cm.tfil3(c,e,tp)
	return c:IsSetCard(0x2e9) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(tp) and chkc:IsLocation("G") and c21076084.spfilter(chkc,e,tp)
	end
	if chk==0 then
		return Duel.GetLocCount(tp,"M")>0 and Duel.IETarget(cm.tfil3,tp,"G",0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.STarget(tp,cm.tfil3,tp,"G",0,1,1,nil,e,tp)
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	Duel.SetChainLimit(cm.clim2)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocCount(tp,"M")<1 then
		return
	end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
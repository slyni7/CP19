--July 18
local m=18452837
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"A")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"Qo","GR")
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e3:SetCountLimit(1,m+1)
	WriteEff(e3,3,"TO")
	c:RegisterEffect(e3)
end
function cm.tfil21(c)
	return c:IsSetCard(0x2d9) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and (c:IsFaceup() or not c:IsLoc("R"))
end
function cm.tfil22(c)
	return c:IsSetCard(0x2d9) and c:IsType(TYPE_FIELD) and c:IsAbleToHand() and (c:IsFaceup() or not c:IsLoc("R"))
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil21,tp,"DGR",0,1,nil) and Duel.IEMCard(cm.tfil22,tp,"DGR",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,2,tp,"DGR")
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IEMCard(cm.tfil21,tp,"DGR",0,1,nil) and Duel.IEMCard(cm.tfil22,tp,"DGR",0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g1=Duel.SMCard(tp,cm.tfil21,tp,"DGR",0,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g2=Duel.SMCard(tp,cm.tfil22,tp,"DGR",0,1,1,nil)
		g1:Merge(g2)
		Duel.SendtoHand(g1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g1)
	end	
end
function cm.tfil31(c)
	return c:IsSetCard(0x2d9) and c:IsAbleToHand() and (c:IsFaceup() or not c:IsLoc("R"))
end
function cm.tfil32(c,e,tp)
	return c:IsSetCard(0x2d9) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (c:IsFaceup() or not c:IsLoc("R"))
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	local b=tp==Duel.GetTurnPlayer()
	if chk==0 then
		return (b and Duel.IEMCard(cm.tfil31,tp,"DGR",0,1,nil)) or (not b and Duel.IEMCard(cm.tfil32,tp,"HDGR",0,1,nil,e,tp))
	end
	if b then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"DGR")
	else
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"HDGR")
	end
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local b=tp==Duel.GetTurnPlayer()
	if b then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SMCard(tp,cm.tfil31,tp,"DGR",0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SMCard(tp,cm.tfil32,tp,"HDGR",0,1,1,nil,e,tp)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
--헤븐 다크사이트 -새벽-
local m=18452841
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"Qo","H")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetCountLimit(1,m)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"Qo","M")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e2:SetCountLimit(1,m+1)
	WriteEff(e2,2,"CTO")
	c:RegisterEffect(e2)
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsDiscardable()
	end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function cm.tfil11(c)
	return c:IsSetCard(0x2d9) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil11,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,cm.tfil11,tp,"D",0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.cfil2(c,tp)
	return Duel.GetMZoneCount(tp,c)>0
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then
		return Duel.CheckReleaseGroup(tp,cm.cfil2,1,nil,tp)
	end
	local g=Duel.SelectReleaseGroup(tp,cm.cfil2,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function cm.tfil21(c,e,tp)
	return c:IsAttack(0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IEMCard(cm.tfil22,tp,"D",0,1,c,c:GetCode())
end
function cm.tfil22(c,code)
	return c:IsCode(code) and c:IsAttack(0) and c:IsAbleToHand()
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local res=e:GetLabel()>0 or Duel.GetLocCount(tp,"M")>0
	if chk==0 then
		e:SetLabel(0)
		return res and Duel.IEMCard(cm.tfil21,tp,"D",0,1,nil,e,tp)
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"D")
	Duel.SOI(0,CATEOGRY_TOHAND,nil,1,tp,"D")
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocCount(tp,"M")<1 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SMCard(tp,cm.tfil21,tp,"D",0,1,1,nil,e,tp)
	local tc=g1:GetFirst()
	if not tc then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g2=Duel.SMCard(tp,cm.tfil22,tp,"D",0,1,1,tc,tc:GetCode())
	Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
	Duel.SendtoHand(g2,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g2)
end
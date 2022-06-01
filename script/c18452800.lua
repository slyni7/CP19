--어둠의 조립공장
local m=18452800
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
end
function cm.tfil11(c,tp)
	if not c:IsAbleToHand() or not c:IsType(TYPE_MONSTER) then
		return false
	end
	if c:IsSetCard(0xe1d) then
		return true
	end
	if Duel.IEMCard(cm.tfil12,tp,"SG",0,1,nil,99970016) and c:IsRace(RACE_FIEND) then
		return true
	end
	if Duel.IEMCard(cm.tfil12,tp,"SG",0,1,nil,99970433) and c:IsRace(RACE_SPELLCASTER) then
		return true
	end
	if Duel.IEMCard(cm.tfil12,tp,"SG",0,1,nil,99970434) and c:IsRace(RACE_FAIRY) then
		return true
	end
	if Duel.IEMCard(cm.tfil12,tp,"SG",0,1,nil,99970435) and c:IsAttribute(ATTRIBUTE_FIRE) then
		return true
	end
	return false
end
function cm.tfil12(c,code)
	return (c:IsLoc("G") or c:IsFaceup()) and c:IsSetCard(0xe1d) and c:GetType()&TYPE_SPELL+TYPE_EQUIP==TYPE_SPELL+TYPE_EQUIP
		and c:GetOriginalCode()==code
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil11,tp,"D",0,1,nil,tp)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,cm.tfil11,tp,"D",0,1,1,nil,tp)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
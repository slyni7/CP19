--벨로시티즌 나이트 드라이브
local m=18452934
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	WriteEff(e1,1,"T")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"F","F")
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetTR("M",0)
	e2:SetValue(200)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x2dc))
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_EXTRA_SQUARE_MANA)
	e4:SetValue(cm.val4)
	c:RegisterEffect(e4)
end
function cm.tfil1(c,e,tp)
	return c:IsSetCard(0x2dc) and c:IsType(TYPE_MONSTER) and (c:IsAbleToHand() or c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE))
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(tp) and chkc:IsLoc("G") and cm.tfil1(chkc,e,tp)
	end
	if chk==0 then
		return true
	end
	if Duel.IETarget(cm.tfil1,tp,"G",0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(m,00)) then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
		e:SetOperation(cm.op1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local g=Duel.STarget(tp,cm.tfil1,tp,"G",0,1,1,nil,e,tp)
		Duel.SOI(0,CATEGORY_TOHAND,g,0,0,0)
		Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,g,0,0,0)
	else
		e:SetProperty(0)
		e:SetCategory(0)
		e:SetOperation(nil)
	end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and (not tc:IsAbleToHand() or Duel.SelectOption(tp,1190,1152)==1) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		else
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end
function cm.val4(e,c)
	return ATTRIBUTE_DARK
end
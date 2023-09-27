--유클리드라코스트
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"STf")
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetCL(1,id)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"STf")
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCL(1,{id,1})
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
end
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	if r&REASON_COST==0 or not re then
		return false
	end
	return (re:GetActivateLocation()&LSTN("O")~=0 or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and rp==tp
		and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then
		return false
	end
	if chk==0 then
		return true
	end
	local rc=re:GetHandler()
	if rc:IsLoc("OGR") and rc:IsFaceup() then
		Duel.SetTargetCard(rc)
		Duel.SOI(0,CATEGORY_TOHAND,rc,2,tp,"D")
	end
end
function s.ofil1(c,code)
	return c:IsCode(code) and c:IsAbleToHand()
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SMCard(tp,s.ofil1,tp,"D",0,1,1,nil,tc:GetCode())
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function s.tfil2(c)
	return c:IsSetCard("드라코스트") and c:IsMonster()
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return false
	end
	if chk==0 then
		return true
	end
	local g=Duel.STarget(tp,s.tfil2,tp,"G",0,1,1,nil)
	if #g>0 then
		Duel.SPOI(0,CATEGORY_TOHAND,tc,1,0,0)
		Duel.SPOI(0,CATEGORY_SPECIAL_SUMMON,tc,1,0,0)
	end
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) then
		return
	end
	aux.ToHandOrElse(tc,tp,
		function(sc)
			return sc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocCount(tp,"M")>0
		end,
		function(sc)
			Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
		end,
		aux.Stringid(id,3)
	)
end
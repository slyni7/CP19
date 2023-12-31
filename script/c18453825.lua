--건물 사이에 피어난 장미
local s,id=GetID()
function s.initial_effect(c)
	c:SetUniqueOnField(1,1,id)
	local e1=MakeEff(c,"Qo","H")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	WriteEff(e1,1,"NCTO")
	c:RegisterEffect(e1)
	local e4=e1:Clone()
	e4:SetCode(EVENT_CHAINING)
	WriteEff(e4,4,"N")
	c:RegisterEffect(e4)
	local e2=MakeEff(c,"STo")
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function s.nfil1(c)
	return c:IsFaceup() and (c:IsRace(RACE_PLANT) or c:IsAttribute(ATTRIBUTE_FIRE))
end
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	local cc=Duel.GetCurrentChain()
	return cc==0 and not Duel.IEMCard(s.nfil1,tp,"M",0,1,nil)
end
function s.con4(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsCode(id) then
		return false
	end
	return not Duel.IEMCard(s.nfil1,tp,"M",0,1,nil)
end
function s.cfil1(c,e,tp)
	return not c:IsCode(id) and (c:IsRace(RACE_PLANT) or c:IsAttribute(ATTRIBUTE_FIRE))
		and (
			(c:IsLoc("D") and c:IsAbleToGraveAsCost())
				or (c:IsLoc("G") and c:IsAbleToHandAsCost())
				or (c:IsLoc("H") and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocCount(tp,"M")>1)
			)
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(s.cfil1,tp,"DGH",0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,0)
	local g=Duel.SMCard(tp,s.cfil1,tp,"DGH",0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc:IsLoc("D") then
		Duel.SendtoGrave(g,REASON_COST)
	elseif tc:IsLoc("G") then
		Duel.SendtoHand(g,nil,REASON_COST)
		Duel.ConfirmCards(1-tp,g)
	elseif tc:IsLoc("H") then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocCount(tp,"M")>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.tfil2(c)
	local atk=c:GetAttack()
	return (c:IsRace(RACE_PLANT) or c:IsAttribute(ATTRIBUTE_FIRE)) and (c:IsAbleToHand() or c:IsAbleToGrave())
		and (math.floor(atk/1850)*1850==atk or (c:IsCode(18453842) and c:IsAbleToHand()))
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(s.tfil2,tp,"D",0,1,nil)
	end
	Duel.SPOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
	Duel.SPOI(0,CATEGORY_TOGRAVE,nil,1,tp,"D")
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SMCard(tp,s.tfil2,tp,"D",0,1,1,nil):GetFirst()
	if tc:IsCode(18453842) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	else
		aux.ToHandOrElse(tc,tp)
	end
end
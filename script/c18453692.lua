--유리유리☆나이트피버
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"Qo","M")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCountLimit(1,id)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"STo")
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetCountLimit(1,{id,1})
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"Qo","G")
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetCountLimit(1,{id,2})
	WriteEff(e3,3,"CTO")
	c:RegisterEffect(e3)
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function s.cfil1(c,e,tp,ft)
	return c:IsSetCard("나이트피버") and (ft>0 or (c:GetSequence()<5 and c:IsControler(tp))) 
		and Duel.IsExistingMatchingCard(s.tfil1,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetCode())
end
function s.tfil1(c,e,tp,cd)
	return c:IsSetCard("나이트피버") and not c:IsCode(cd) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		return ft>-1 and Duel.CheckReleaseGroupCost(tp,s.cfil1,1,false,nil,nil,e,tp,ft)
	end
	local rg=Duel.SelectReleaseGroupCost(tp,s.cfil1,1,1,false,nil,nil,e,tp,ft)
	Duel.SetTargetParam(rg:GetFirst():GetCode())
	Duel.Release(rg,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local code=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,s.tfil1,tp,LOCATION_DECK,0,1,1,nil,e,tp,code):GetFirst()
	if tc then 
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.tfil2(c)
	return c:IsSetCard("나이트피버") and c:IsAbleToHand() and c:IsMonster() and not c:IsCode(id)
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(s.tfil2,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,s.tfil2,tp,"D",0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToDeckAsCost()
	end
	Duel.SendtoDeck(c,nil,2,REASON_COST)
end
function s.tfil3(c,e,tp)
	return c:IsSetCard("나이트피버") and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.tar3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and s.tfil3(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(s.tfil3,tp,LOCATION_GRAVE,0,1,e:GetHandler(),e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.tfil3,tp,LOCATION_GRAVE,0,1,1,e:GetHandler(),e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRace(RACE_ZOMBIE) and tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end

--신천지에 내리는 비
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(id)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCL(1,id)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"FTo","G")
	e2:SetCode(EVENT_DESTROY)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetCL(1,{id,1})
	WriteEff(e2,2,"NTO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"S")
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e3:SetCondition(function(e)
		local tp=e:GetHandlerPlayer()
		return Duel.CheckLPCost(tp,1500)
	end)
	e3:SetD(id,0)
	e3:SetValue(function(e,c)
		e:SetLabel(1)
	end)
	c:RegisterEffect(e3)
	e1:SetLabelObject(e3)
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		e:GetLabelObject():SetLabel(0)
		return true
	end
	if e:GetLabelObject():GetLabel()>0 then
		e:GetLabelObject():SetLabel(0)
		Duel.PayLPCost(tp,1500)
	end
end
function s.tfil1(c,e,tp)
	return c:IsCode(CARD_NEW_HEAVEN_AND_EARTH) and c:GetActivateEffect() and c:GetActivateEffect():IsActivatable(tp,true,true)
		or (Duel.IEMCard(s.ofil1,tp,"O",0,1,nil) and 
			c:IsLevel(3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
				and c:IsSetCard("신천지"))
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(s.tfil1,tp,"D",0,1,nil,e,tp)
	end
	Duel.SPOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"D")
end
function s.ofil1(c)
	return c:IsCode(CARD_NEW_HEAVEN_AND_EARTH) and c:IsFaceup()
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,s.tfil1,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	if tc:IsCode(CARD_NEW_HEAVEN_AND_EARTH) then
		Duel.ActivateFieldSpell(tc,e,tp,eg,ep,ev,re,r,rp)
	else
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function s.nfil2(c)
	return c:IsHasEffect(CARD_NEW_HEAVEN_AND_EARTH)
end
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.nfil2,1,nil)
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToHand()
	end
	Duel.SOI(0,CATEGORY_TOHAND,c,1,0,0)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
	local e1=MakeEff(c,"F")
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTR(0,"M")
	e1:SetTarget(function(e,c)
		return c:IsSummonType(SUMMON_TYPE_SPECIAL)
	end)
	e1:SetValue(-200)
	Duel.RegisterEffect(e1,tp)
end
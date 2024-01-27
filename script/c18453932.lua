--코인비터 보일블러드
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Synchro.AddProcedure(c,nil,1,1,Synchro.NonTuner(nil),1,99,s.pfil1)
	local e1=MakeEff(c,"FTo","G")
	e1:SetCode(EVENT_TOSS_COIN)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCL(1,{id,1})
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"F","M")
	e2:SetCode(EFFECT_COINBEAT_EFFECT)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetOperation(s.op2)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"STo")
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e3:SetCL(1,id)
	WriteEff(e3,3,"TO")
	c:RegisterEffect(e3)
end
function s.pfil1(c,scard,sumtype,tp)
	return c:IsSetCard("코인비터",scard,sumtype,tp)
end
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
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
function s.op2(e,tp)
	local result=true
	if Duel.CheckLPCost(tp,1000) then
		Duel.PayLPCost(tp,1000)
	else
		result=false
	end
	local g=Duel.GetReleaseGroup(tp)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local sg=g:Select(tp,1,1,nil)
		Duel.Release(sg,REASON_RULE)
	else
		result=false
	end
	return result
end
function s.tfil3(c,e)
	return c:IsSetCard("코인비터") and c:IsCanBeEffectTarget(e) and not c:IsCode(id) and c:IsType(TYPE_MONSTER)
end
function s.tfun3(g,e,tp)
	local fc=g:GetFirst()
	local nc=g:GetNext()
	return (fc:IsAbleToHand() and nc:IsCanBeSpecialSummoned(e,0,tp,false,false))
		or (nc:IsAbleToHand() and fc:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function s.tar3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return false
	end
	local g=Duel.GMGroup(s.tfil3,tp,"G",0,nil,e)
	if chk==0 then
		return Duel.GetLocCount(tp,"M")>0
			and g:CheckSubGroup(s.tfun3,2,2,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:SelectSubGroup(tp,s.tfun3,false,2,2,e,tp)
	Duel.SetTargetCard(sg)
	Duel.SOI(0,CATEGORY_TOHAND,sg,1,0,0)
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,sg,1,0,0)
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetCards(e)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:FilterSelect(tp,Card.IsAbleToHand,1,1,nil)
		if #sg>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
			local tg=g:Sub(sg)
			if #tg>0 then
				Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
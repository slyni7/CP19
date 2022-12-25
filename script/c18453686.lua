--릿카릿카☆나이트피버
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"I","H")
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCL(1,id)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"Qo","M")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetCL(1,{id,1})
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"FC","M")
	e3:SetCode(EVENT_ADJUST)
	WriteEff(e3,3,"NO")
	c:RegisterEffect(e3)
end
function s.nfil1(c)
	return c:IsFacedown() or not c:IsSetCard("나이트피버")
end
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IEMCard(s.nfil1,tp,"M",0,1,nil)
end
function s.tfil1(c,e,tp)
	return c:IsSetCard("나이트피버") and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(id)
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocCount(tp,"M")>1 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and Duel.IEMCard(s.tfil1,tp,"D",0,1,nil,e,tp)
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,c,2,tp,"D")
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocCount(tp,"M")<2 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SMCard(tp,s.tfil1,tp,"D",0,1,1,nil,e,tp)
	if #g>0 then
		g:AddCard(c)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.tfil2(c)
	return c:IsSetCard("나이트피버") and c:IsFaceup() and c:IsAbleToHand()
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLoc("M") and chkc:IsControler(tp) and s.tfil2(chkc)
	end
	if chk==0 then
		return Duel.IETarget(s.tfil2,tp,"M",0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.STarget(tp,s.tfil2,tp,"M",0,1,1,nil)
	Duel.SOI(0,CATEGORY_TOHAND,g,1,0,0)
end
function s.ofil2(c,e,tp)
	return c:IsSetCard("나이트피버") and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 and Duel.GetLocCount(tp,"M")>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SMCard(tp,s.ofil2,tp,"H",0,0,1,nil,e,tp)
		if #sg>0 then
			Duel.BreakEffect()
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function s.nfil3(c)
	return c:IsType(TYPE_TRAP) and c:IsType(TYPE_COUNTER) and c:IsSSetable() and c:CheckActivateEffect(false,true,true)~=nil
		and c:IsSetCard("약식")
end
function s.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(id)==0 and Duel.IEMCard(s.nfil3,tp,"D",0,1,nil)
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(id)==0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,0))
		local g=Duel.SMCard(tp,s.nfil3,tp,"D",0,0,1,nil)
		if #g>0 then
			c:RegisterFlagEffect(id,RESET_PHASE+PHASE_END+RESET_EVENT+0x1ec0000,0,1)
			Duel.Hint(HINT_CARD,0,id)
			Duel.SSet(tp,g)
			local tc=g:GetFirst()
			local e1=MakeEff(c,"S")
			e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	end
end
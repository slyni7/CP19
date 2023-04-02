--노래는 사랑을 포장한다(에이프릴 러브샷)
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"I","H")
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCL(1,id)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"STo")
	e2:SetCode(EVENT_TO_HAND)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCL(1,id)
	WriteEff(e2,2,"C")
	WriteEff(e2,1,"TO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"Qo","M")
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e3:SetCL(1,{id,1})
	WriteEff(e3,3,"CTO")
	c:RegisterEffect(e3)
end
function s.cfil1(c)
	return c:IsSetCard("에이프릴") and c:IsDiscardable()
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IEMCard(s.cfil1,tp,"H",0,1,c)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SMCard(tp,s.cfil1,tp,"H",0,1,1,c)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
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
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b=re and re:GetHandler():IsSetCard("에이프릴")
	if chk==0 then
		return Duel.IEMCard(s.cfil1,tp,"H",0,1,c) or b
	end
	if not b then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		local g=Duel.SMCard(tp,s.cfil1,tp,"H",0,1,1,c)
		Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
	end
end
function s.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function s.tfil3(c,lv)
	if not c:IsCustomType(CUSTOMTYPE_EQUAL) then
		return false
	end
	local ch=c:GetChart()
	return ch>0 and ch==lv
end
function s.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if e:GetLabel()~=1 then
			return false
		end
		e:SetLabel(0)
		return Duel.GetLocCount(tp,"M")>0 and Duel.IEMCard(s.tfil3,tp,"E",0,1,nil,c:GetLevel())
			 and Duel.IsPlayerCanSpecialSummonMonster(tp,18453725,0,TYPES_TOKEN,-2,0,0,RACE_FAIRY,ATTRIBUTE_FAIRY)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SMCard(tp,s.tfil3,tp,"E",0,1,1,nil,c:GetLevel())
	local tc=g:GetFirst()
	e:SetLabel(tc:GetNote())
	Duel.ConfirmCards(1-tp,g)
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SOI(0,CATEGORY_TOKEN,nil,1,0,0)
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocCount(tp,"M")<1
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,18453725,0,TYPES_TOKEN,-2,0,0,RACE_FAIRY,ATTRIBUTE_FAIRY) then
		return
	end
	local token=Duel.CreateToken(tp,18453725)
	Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetValue(e:GetLabel())
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	token:RegisterEffect(e1)
	Duel.SpecialSummonComplete()
end
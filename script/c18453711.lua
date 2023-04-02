--노래는 4분의 시간이며(에이프릴 루나)
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"STo")
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetCL(1,id)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"Qo","M")
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e3:SetCL(1,{id,1})
	WriteEff(e3,3,"CTO")
	c:RegisterEffect(e3)
end
function s.tfil1(c)
	return c:IsSetCard("에이프릴") and c:IsMonster() and c:IsAbleToHand() and not c:IsCode(id)
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(s.tfil1,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,s.tfil1,tp,"D",0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
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
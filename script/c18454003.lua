--고시스토피아 블레이더
local s,id=GetID()
function s.initial_effect(c)
	aux.AddSequenceProcedure(c,s.pfun1,aux.TRUE,2,99)
	local e1=MakeEff(c,"STo")
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCategory(CATEGORY_TOGRAVE)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"FC","G")
	e3:SetCode(EVENT_CHAIN_END)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	WriteEff(e3,3,"O")
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"STf")
	e4:SetCode(id)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	WriteEff(e4,4,"TO")
	c:RegisterEffect(e4)
end
function s.pfun1(tp,chain)
	return aux.GlobalChainInARow>=1
end
s.custom_type=CUSTOMTYPE_SEQUENCE
function s.tfil1(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsAbleToGrave() and not c:IsCode(id)
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(s.tfil1,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOGRAVE,nil,1,tp,"D")
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SMCard(tp,s.tfil1,tp,"D",0,1,1,nil)
	if #g>0 and Duel.SendtoGrave(g,REASON_EFFECT)>0 then
		if e:GetCode()==EVENT_SPSUMMON_SUCCESS
			and Duel.IsPlayerCanDraw(tp,1)
			and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
			Duel.ShuffleDeck(tp)
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(id-1,RESET_EVENT+RESETS_STANDARD,0,0)
	if c:GetFlagEffect(id-1)==2 then
		Duel.RaiseSingleEvent(c,id,e,REASON_EFFECT,tp,tp,0)
	end
end
function s.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return true
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
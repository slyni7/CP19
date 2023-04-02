--봄눈을 노래하는 시(에이프릴 제타)
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddEqualProcedure(c,8,2,nil,nil,1,99,nil)
	local e1=MakeEff(c,"FC","M")
	e1:SetCode(EVENT_TO_HAND)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	WriteEff(e1,1,"NO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"STo")
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetCL(1,id)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"SC")
	e3:SetCode(EVENT_LEAVE_FIELD_P)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	WriteEff(e3,3,"O")
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"STo")
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetCL(1,{id,1})
	e4:SetLabelObject(e3)
	WriteEff(e4,4,"NTO")
	c:RegisterEffect(e4)
end
function s.nfil1(c,tp)
	return c:IsPreviousLocation(LSTN("D")) and c:IsControler(tp)
end
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.nfil1,1,nil,tp)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_UPDATE_NOTE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(2)
	c:RegisterEffect(e1)
end
function s.tfil2(c)
	return c:IsSetCard("에이프릴") and c:IsAbleToHand() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GMGroup(s.tfil2,tp,"D",0,nil)
	if chk==0 then
		return g:GetClassCount(Card.GetCode)>1
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,2,tp,"D")
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GMGroup(s.tfil2,tp,"D",0,nil)
	if g:GetClassCount(Card.GetCode)>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:SelectSubGroup(tp,aux.dncheck,false,2,2)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFinaleState() then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
end
function s.con4(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetLabel()==1
end
function s.tfil4(c,e,tp)
	return c:IsSetCard("에이프릴") and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function s.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GMGroup(s.tfil4,tp,"D",0,nil,e,tp)
	if chk==0 then
		return Duel.GetLocCount(tp,"M")>1 and g:GetClassCount(Card.GetLevel)>1
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,"D")
end
function s.op4(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GMGroup(s.tfil4,tp,"D",0,nil,e,tp)
	if Duel.GetLocCount(tp,"M")>1 and g:GetClassCount(Card.GetLevel)>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:SelectSubGroup(tp,aux.dncheck,false,2,2)
		Duel.SpecialSummon(sg,0,tp,tp,false,flase,POS_FACEUP_DEFENSE)
	end
end
--​4월과 벚꽃과 사랑(에이프릴 체리)
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddEqualProcedure(c,4,2,nil,nil,1,99,nil)
	local e1=MakeEff(c,"FC","M")
	e1:SetCode(EVENT_RELEASE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	WriteEff(e1,1,"NO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"I","M")
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetD(id,0)
	e2:SetCL(2,id)
	WriteEff(e2,2,"CTO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"Qo","M")
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetD(id,1)
	WriteEff(e3,3,"NCTO")
	c:RegisterEffect(e3)
end
function s.nfil1(c)
	return c:IsPreviousLocation(LSTN("O"))
end
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.nfil1,1,nil)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_UPDATE_NOTE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(1)
	c:RegisterEffect(e1)
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function s.tfil2(c,tp)
	if not c:IsCustomType(CUSTOMTYPE_EQUAL) then
		return false
	end
	local ch=c:GetChart()
	local nt=c:GetNote()
	return ch>0 and nt>0 and Duel.GetMZoneCount(tp,c)>1
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if e:GetLabel()~=1 then
			return false
		end
		e:SetLabel(0)
		return Duel.CheckReleaseGroupCost(tp,s.tfil2,1,1,false,nil,nil,tp)
			 and Duel.IsPlayerCanSpecialSummonMonster(tp,18453725,0,TYPES_TOKEN,-2,0,0,RACE_FAIRY,ATTRIBUTE_FAIRY)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectReleaseGroupCost(tp,s.tfil2,1,1,false,nil,nil,tp)
	local tc=g:GetFirst()
	e:SetLabelObject({tc:GetChart(),tc:GetNote()})
	Duel.Release(g,REASON_COST)
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
	Duel.SOI(0,CATEGORY_TOKEN,nil,2,0,0)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocCount(tp,"M")<2
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,18453725,0,TYPES_TOKEN,-2,0,0,RACE_FAIRY,ATTRIBUTE_FAIRY) then
		return
	end
	local lo=e:GetLabelObject()
	for i=1,2 do
		local token=Duel.CreateToken(tp,18453725)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		local e1=MakeEff(c,"S")
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(lo[i])
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e1)
	end
	Duel.SpecialSummonComplete()
end
function s.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsFinaleState()
end
function s.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsReleasable()
	end
	Duel.Release(c,REASON_COST)
end
function s.tar3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then
		return chkc:IsOnField() and chkc:IsAbleToHand()
	end
	if chk==0 then
		local ec=e:GetLabel()==1 and c or nil
		e:SetLabel(0)
		return Duel.IETarget(Card.IsAbleToHand,tp,"O","O",1,nil)
	end
	local g=Duel.STarget(tp,Card.IsAbleToHand,tp,"O","O",1,1,nil)
	Duel.SOI(0,CATEGORY_TOHAND,g,1,0,0)
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
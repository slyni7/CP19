--메데타시 메타픽션
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCL(1,id,EFFECT_COUNT_CODE_OATH)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"FTo","S")
	e2:SetCode(EVENT_REMOVE)
	e2:SetCL(1,{id,1})
	WriteEff(e2,2,"NCTO")
	c:RegisterEffect(e2)
	if s.global_check==nil then
		s.global_check=true
		s[0]={}
		local ge1=MakeEff(c,"FC")
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(s.gop1)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.gop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsSummonType(SUMMON_TYPE_DELIGHT) then
			local mg=tc:GetMaterial()
			if mg and mg:IsExists(Card.IsOriginalCode,1,nil,18453790) then
				s[0][tc:GetOriginalCode()]=true
			end
		end
		tc=eg:GetNext()
	end
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SPOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"R")
end
function s.tfil1(c,e,tp)
	return (c:IsCode(18453790) or s[0][c:GetOriginalCode()]) and c:IsFacedown()
		--and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocCount(tp,"M")>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.tfil1,tp,LSTN("R"),0,0,1,nil,e,tp)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsFacedown,16,nil)
end
function s.cfil2(c)
	return c:IsCode(18453790) and c:IsAbleToRemoveAsCost(POS_FACEDOWN)
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IEMCard(s.cfil2,tp,"HO",0,1,nil)
	end
	local fid=c:GetFieldID()
	local g=Duel.SMCard(tp,s.cfil2,tp,"HO",0,1,1,nil)
	local tc=g:GetFirst()
	local loc=tc:GetLocation()
	Duel.Remove(tc,POS_FACEDOWN,REASON_COST+REASON_TEMPORARY)
	tc:RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END,0,1,fid)
	local e1=MakeEff(c,"FC")
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetCondition(s.ccon21)
	e1:SetOperation(s.cop21)
	e1:SetLabelObject(tc)
	e1:SetLabel(loc,fid)
	e1:SetReset(RESET_PHASE|PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.ccon21(e,tp,eg,ep,ev,re,r,rp)
	local loc,fid=e:GetLabel()
	local tc=e:GetLabelObject()
	return tc:GetFlagEffectLabel(id)==fid
end
function s.cop21(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local loc,fid=e:GetLabel()
	if loc==LOCATION_HAND then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	else
		Duel.ReturnToField(tc)
	end
	e:Reset()
end
function s.tfil2(c)
	return c:IsSSetable() and (c:IsFacedown() or c:IsLoc("D")) and c:IsSetCard("메타픽션") and not c:IsCode(id)
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.tfil2,tp,LSTN("DR"),0,1,nil)
	end
end
function s.op2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,s.tfil2,tp,LSTN("DR"),0,1,1,nil)
	if #g>0 then
		Duel.SSet(tp,g)
	end
end
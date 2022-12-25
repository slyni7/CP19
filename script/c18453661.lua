--제피라이언 시무르그
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"I","H")
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"STo")
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"I","G")
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER)
	e3:SetCountLimit(1,id)
	WriteEff(e3,3,"CTO")
	c:RegisterEffect(e3)
end
function s.cfil1(c)
	return c:IsSetCard(0x12d) and c:IsFaceup() and c:IsAbleToHandAsCost() and not c:IsCode(id)
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocCount(tp,"M")
	if chk==0 then
		if ft<0 then return false end
		if ft==0 then
			return Duel.IEMCard(s.cfil1,tp,"M",0,1,nil)
		else
			return Duel.IEMCard(s.cfil1,tp,"O","O",1,nil)
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	if ft==0 then
		local g=Duel.SMCard(tp,s.cfil1,tp,"M",0,1,1,nil)
		Duel.SendtoHand(g,nil,REASON_COST)
	else
		local g=Duel.SMCard(tp,s.cfil1,tp,"O","O",1,1,nil)
		Duel.SendtoHand(g,nil,REASON_COST)
	end
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocCount(tp,"M")>1
			and Duel.IsPlayerCanSpecialSummonMonster(tp,18453669,0x12d,TYPES_TOKEN,0,0,1,RACE_WINGEDBEAST,ATTRIBUTE_FIRE)
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
	Duel.SOI(0,CATEGORY_TOKEN,nil,2,0,0)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocCount(tp,"M")>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,18453669,0x12d,TYPES_TOKEN,0,0,1,RACE_WINGEDBEAST,ATTRIBUTE_FIRE) then
		for i=1,2 do
			local token=Duel.CreateToken(tp,18453701)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
			local e1=MakeEff(c,"S")
			e1:SetCode(EFFECT_SIMORGH_EGG_TOKEN)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
			token:RegisterEffect(e1)
		end
		Duel.SpecialSummonComplete()
	end
end
function s.cfil3(c)
	return c:IsSetCard(0x12d) and c:IsFaceup() and c:IsAbleToHandAsCost()
end
function s.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocCount(tp,"M")
	if chk==0 then
		if ft<0 then return false end
		if ft==0 then
			return Duel.IEMCard(s.cfil3,tp,"M",0,1,nil)
		else
			return Duel.IEMCard(s.cfil3,tp,"O","O",1,nil)
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	if ft==0 then
		local g=Duel.SMCard(tp,s.cfil3,tp,"M",0,1,1,nil)
		Duel.SendtoHand(g,nil,REASON_COST)
	else
		local g=Duel.SMCard(tp,s.cfil3,tp,"O","O",1,1,nil)
		Duel.SendtoHand(g,nil,REASON_COST)
	end
end
function s.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_RECVOER,nil,0,tp,400)
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.Recover(tp,400,REASON_EFFECT)
	end
end
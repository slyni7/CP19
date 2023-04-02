--사일런트 머조리티: 옥틸리온
local s,id=GetID()
function s.initial_effect(c)
	aux.AddSquareProcedure(c)
	local e1=MakeEff(c,"STo")
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCategory(CATEGORY_TOGRAVE)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"I","G")
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetCL(1,id)
	WriteEff(e3,3,"TO")
	c:RegisterEffect(e3)
end
s.square_mana={0x0}
s.custom_type=CUSTOMTYPE_SQUARE
function s.tfil1(c)
	local st=c:GetSquareMana()
	--TEST
	local res=Duel.AnyOtherResult(
		function()
			if not st or #st==0 then
				return false
			end
			local res=true
			for i=1,#st do
				if st[i]~=0 then
					res=false
					break
				end
			end
			return res
		end
	)
	if not res then
		return false
	end
	return c:IsSetCard(0x2e0) and c:IsAbleToGrave()
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
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function s.tfil3(c,e,tp)
	local st=c:GetSquareMana()
	--TEST
	local res=Duel.AnyOtherResult(
		function()
			if not st or #st==0 then
				return false
			end
			local res=true
			for i=1,#st do
				if st[i]~=0 then
					res=false
					break
				end
			end
			return res
		end
	)
	if not res then
		return false
	end
	return c:IsSetCard(0x2e0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(id)
end
function s.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocCount(tp,"M")>1
			and Duel.IETarget(s.tfil3,tp,"G",0,1,cc,e,tp)
	end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.STarget(tp,s.tfil3,tp,"G",0,1,1,c,e,tp)
	g:AddCard(c)
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,g,2,0,0)
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocCount(tp,"M")<2 or not c:IsRelateToEffect(e) or not tc:IsRelateToEffect(e) then
		return
	end
	local g=Group.FromCards(c,tc)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end
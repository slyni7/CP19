--피닉스 시무르그
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"I","H")
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"Qo","H")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetD(EFFECT_ANGEL_SIMORGH,0)
	WriteEff(e2,2,"C")
	WriteEff(e2,1,"TO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"I","G")
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	WriteEff(e3,3,"C")
	WriteEff(e3,1,"TO")
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"Qo","G")
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetD(EFFECT_ANGEL_SIMORGH,0)
	WriteEff(e4,4,"C")
	WriteEff(e4,1,"TO")
	c:RegisterEffect(e4)
	local e5=MakeEff(c,"S","M")
	e5:SetCode(EFFECT_ADD_ATTRIBUTE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetValue(ATTRIBUTE_WIND)
	c:RegisterEffect(e5)
	local e6=MakeEff(c,"F","M")
	e6:SetCode(EFFECT_CANNOT_SUMMON)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetTR(0,1)
	e6:SetValue(1)
	c:RegisterEffect(e6)
	local e7=MakeEff(c,"F","M")
	e7:SetCode(EFFECT_FORCE_SPSUMMON_POSITION)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetTR(0,1)
	e7:SetValue(POS_DEFENSE)
	c:RegisterEffect(e7)
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg=Duel.GMGroup(aux.SimorghBanishFilter1,tp,"OG",0,nil,ATTRIBUTE_FIRE)
	if chk==0 then
		return #rg>0 and aux.SelectUnselectGroup(rg,e,tp,1,2,aux.SimorghBanishResult(ATTRIBUTE_FIRE),0)
	end
	local g=Group.CreateGroup()
	while not aux.SimorghBanishResult(ATTRIBUTE_FIRE)(g,e,tp,Group.CreateGroup()) do
		g=aux.SelectUnselectGroup(rg,e,tp,1,2,aux.SimorghBanishResult(ATTRIBUTE_FIRE),1,tp,HINTMSG_REMOVE,nil,nil,false)
	end
	if #g==1 then
		local tc=g:GetFirst()
		local te=tc:IsHasEffect(EFFECT_SIMORGH_HEAVEN)
		local ec=te:GetHandler()
		ec:RegisterFlagEffect(EFFECT_SIMORGH_HEAVEN,RESET_PHASE+PHASE_END+RESET_EVENT+0x1ec0000,0,1)
	end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
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
	local ae=Duel.IsPlayerAffectedByEffect(tp,EFFECT_ANGEL_SIMORGH)
	local rg=Duel.GMGroup(aux.SimorghBanishFilterAngel1,tp,"OG","M",nil,ATTRIBUTE_FIRE,tp)
	if chk==0 then
		return ae and #rg>0 and aux.SelectUnselectGroup(rg,e,tp,1,2,aux.SimorghBanishResult(ATTRIBUTE_FIRE),0)
	end
	local ac=ae:GetHandler()
	if ac:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) then
		ac:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	end
	local g=Group.CreateGroup()
	while not aux.SimorghBanishResult(ATTRIBUTE_FIRE)(g,e,tp,Group.CreateGroup()) do
		g=aux.SelectUnselectGroup(rg,e,tp,1,2,aux.SimorghBanishResult(ATTRIBUTE_FIRE),1,tp,HINTMSG_REMOVE,nil,nil,false)
	end
	if #g==1 then
		local tc=g:GetFirst()
		local te=tc:IsHasEffect(EFFECT_SIMORGH_HEAVEN)
		local ec=te:GetHandler()
		ec:RegisterFlagEffect(EFFECT_SIMORGH_HEAVEN,RESET_PHASE+PHASE_END+RESET_EVENT+0x1ec0000,0,1)
	end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function s.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg=Duel.GMGroup(aux.SimorghBanishFilter2,tp,"OH",0,nil,ATTRIBUTE_FIRE)
	if chk==0 then
		return #rg>0 and aux.SelectUnselectGroup(rg,e,tp,1,2,aux.SimorghBanishResult(ATTRIBUTE_FIRE),0)
	end
	local g=Group.CreateGroup()
	while not aux.SimorghBanishResult(ATTRIBUTE_FIRE)(g,e,tp,Group.CreateGroup()) do
		g=aux.SelectUnselectGroup(rg,e,tp,1,2,aux.SimorghBanishResult(ATTRIBUTE_FIRE),1,tp,HINTMSG_REMOVE,nil,nil,false)
	end
	if #g==1 then
		local tc=g:GetFirst()
		local te=tc:IsHasEffect(EFFECT_SIMORGH_HEAVEN)
		local ec=te:GetHandler()
		ec:RegisterFlagEffect(EFFECT_SIMORGH_HEAVEN,RESET_PHASE+PHASE_END+RESET_EVENT+0x1ec0000,0,1)
	end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function s.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	local ae=Duel.IsPlayerAffectedByEffect(tp,EFFECT_ANGEL_SIMORGH)
	local rg=Duel.GMGroup(aux.SimorghBanishFilterAngel2,tp,"OH","M",nil,ATTRIBUTE_FIRE,tp)
	if chk==0 then
		return ae and #rg>0 and aux.SelectUnselectGroup(rg,e,tp,1,2,aux.SimorghBanishResult(ATTRIBUTE_FIRE),0)
	end
	local ac=ae:GetHandler()
	if ac:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) then
		ac:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	end
	local g=Group.CreateGroup()
	while not aux.SimorghBanishResult(ATTRIBUTE_FIRE)(g,e,tp,Group.CreateGroup()) do
		g=aux.SelectUnselectGroup(rg,e,tp,1,2,aux.SimorghBanishResult(ATTRIBUTE_FIRE),1,tp,HINTMSG_REMOVE,nil,nil,false)
	end
	if #g==1 then
		local tc=g:GetFirst()
		local te=tc:IsHasEffect(EFFECT_SIMORGH_HEAVEN)
		local ec=te:GetHandler()
		ec:RegisterFlagEffect(EFFECT_SIMORGH_HEAVEN,RESET_PHASE+PHASE_END+RESET_EVENT+0x1ec0000,0,1)
	end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
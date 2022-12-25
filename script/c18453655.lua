--유리 시무르그
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
	e6:SetCode(EFFECT_ACTIVATE_COST)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetTR(0,1)
	e6:SetCost(s.cost6)
	c:RegisterEffect(e6)
	local e7=MakeEff(c,"F","M")
	e7:SetCode(EFFECT_CANNOT_USE_AS_COST)
	e7:SetTR(0xff,0xff)
	e7:SetTarget(s.tar7)
	c:RegisterEffect(e7)
	if not s.global_check then
		s[0]=nil
	end
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg=Duel.GMGroup(aux.SimorghBanishFilter1,tp,"OG",0,nil,ATTRIBUTE_LIGHT)
	if chk==0 then
		return #rg>0 and aux.SelectUnselectGroup(rg,e,tp,1,2,aux.SimorghBanishResult(ATTRIBUTE_LIGHT),0)
	end
	local g=Group.CreateGroup()
	while not aux.SimorghBanishResult(ATTRIBUTE_LIGHT)(g,e,tp,Group.CreateGroup()) do
		g=aux.SelectUnselectGroup(rg,e,tp,1,2,aux.SimorghBanishResult(ATTRIBUTE_LIGHT),1,tp,HINTMSG_REMOVE,nil,nil,false)
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
	local rg=Duel.GMGroup(aux.SimorghBanishFilterAngel1,tp,"OG","M",nil,ATTRIBUTE_LIGHT,tp)
	if chk==0 then
		return ae and #rg>0 and aux.SelectUnselectGroup(rg,e,tp,1,2,aux.SimorghBanishResult(ATTRIBUTE_LIGHT),0)
	end
	local ac=ae:GetHandler()
	if ac:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) then
		ac:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	end
	local g=Group.CreateGroup()
	while not aux.SimorghBanishResult(ATTRIBUTE_LIGHT)(g,e,tp,Group.CreateGroup()) do
		g=aux.SelectUnselectGroup(rg,e,tp,1,2,aux.SimorghBanishResult(ATTRIBUTE_LIGHT),1,tp,HINTMSG_REMOVE,nil,nil,false)
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
	local rg=Duel.GMGroup(aux.SimorghBanishFilter2,tp,"OH",0,nil,ATTRIBUTE_LIGHT)
	if chk==0 then
		return #rg>0 and aux.SelectUnselectGroup(rg,e,tp,1,2,aux.SimorghBanishResult(ATTRIBUTE_LIGHT),0)
	end
	local g=Group.CreateGroup()
	while not aux.SimorghBanishResult(ATTRIBUTE_LIGHT)(g,e,tp,Group.CreateGroup()) do
		g=aux.SelectUnselectGroup(rg,e,tp,1,2,aux.SimorghBanishResult(ATTRIBUTE_LIGHT),1,tp,HINTMSG_REMOVE,nil,nil,false)
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
	local rg=Duel.GMGroup(aux.SimorghBanishFilterAngel2,tp,"OH","M",nil,ATTRIBUTE_LIGHT,tp)
	if chk==0 then
		return ae and #rg>0 and aux.SelectUnselectGroup(rg,e,tp,1,2,aux.SimorghBanishResult(ATTRIBUTE_LIGHT),0)
	end
	local ac=ae:GetHandler()
	if ac:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) then
		ac:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	end
	local g=Group.CreateGroup()
	while not aux.SimorghBanishResult(ATTRIBUTE_LIGHT)(g,e,tp,Group.CreateGroup()) do
		g=aux.SelectUnselectGroup(rg,e,tp,1,2,aux.SimorghBanishResult(ATTRIBUTE_LIGHT),1,tp,HINTMSG_REMOVE,nil,nil,false)
	end
	if #g==1 then
		local tc=g:GetFirst()
		local te=tc:IsHasEffect(EFFECT_SIMORGH_HEAVEN)
		local ec=te:GetHandler()
		ec:RegisterFlagEffect(EFFECT_SIMORGH_HEAVEN,RESET_PHASE+PHASE_END+RESET_EVENT+0x1ec0000,0,1)
	end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function s.cost6(e,te,tp)
	if tp==e:GetHandlerPlayer() then
		return true
	end
	local tc=te:GetHandler()
	s[0]=tc
	local con=te:GetCondition()
	local cost=te:GetCost()
	local tar=te:GetTarget()
	local res=false
	local chain=Duel.GetCurrentChain()
	local event=te:GetCode()
	local tres,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(event,true)
	if (not con or con(te,tp,teg,tep,tev,tre,tr,trp))
		and (not cost or cost(te,tp,teg,tep,tev,tre,tr,trp,0))
		and (not tar or tar(te,tp,teg,tep,tev,tre,tr,trp,0)) then
		res=true
	end
	s[0]=nil
	return res
end
function s.tar7(e,c)
	if s[0] and c==s[0] then
		return true
	end
	local tp=e:GetHandlerPlayer()
	local ce,cp=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	if not ce or not ce:IsHasType(EFFECT_TYPE_ACTIONS) then
		return false
	end
	local cc=ce:GetHandlerPlayer()
	return c==cc and cp~=tp
end
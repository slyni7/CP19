--이상물질(아이딜 매터) 「청사」
local s,id=GetID()
function s.initial_effect(c)
	if not s.global_check then
		s.global_check=true
		aux.RegisterIdealMatter(c,id)
	end
	c:SetUniqueOnField(1,0,id)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"Qo","M")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCL(1)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if e:GetLabel()==0 then
			return false
		end
		e:SetLabel(0)
		return Duel.GetLocCount(tp,"M")>0
			and Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,0x21,0,3300,9,RACE_CYBERSE,ATTRIBUTE_WATER) end
	e:SetLabel(0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocCount(tp,"M")<1 then
		return
	end
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,0x21,0,3300,9,RACE_CYBERSE,ATTRIBUTE_WATER) then
		c:AddMonsterAttribute(TYPE_EFFECT)
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP_DEFENSE)
	end
end
function s.tfil2(c)
	local chain_related=false
	local cc=Duel.GetCurrentChain()
	for i=1,cc do
		local ce=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
		local ec=ce:GetHandler()
		if ec==c and c:IsRelateToEffect(ce) then
			chain_related=true
		end
	end
	return ((c:IsLoc("H") and chain_related)
		or (c:IsLoc("E") and chain_related and c:IsFaceup())
		or (c:IsOnField() and c:IsFaceup())
		or c:IsLoc("G") or (c:IsLoc("R") and c:IsFaceup()))
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(s.tfil3,tp,0,"HEOGR",1,nil)
	end
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SMCard(tp,s.tfil3,tp,0,"HEOGR",1,1,nil)
	local tc=g:GetFirst()
	if tc then
		local code=tc:GetOriginalCodeRule()
		local e1=MakeEff(c,"S")
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD)
		e1:SetLabel(code)
		e1:SetValue(s.oval21)
		c:RegisterEffect(e1)
		local e2=MakeEff(c,"S")
		e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e2:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD)
		e2:SetLabel(code)
		e2:SetValue(s.oval22)
		c:RegisterEffect(e2)
	end
end
function s.oval21(e,te)
	local tc=te:GetHandler()
	local code=e:GetLabel()
	return tc:GetOriginalCodeRule()==code and te:GetHandlerPlayer()~=e:GetOwnerPlayer()
end
function s.oval22(e,c)
	local code=e:GetLabel()
	return c and c:GetOriginalCodeRule()==code
end
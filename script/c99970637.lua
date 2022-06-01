--[ hololive 1st Gen ]
local m=99970637
local cm=_G["c"..m]
function cm.initial_effect(c)

	--특수 소환 + 효과 부여
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	WriteEff(e0,0,"TO")
	c:RegisterEffect(e0)

end

--특수 소환 + 효과 부여
function cm.filter(c,e,tp)
	return c:IsCode(99970635) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.tar0(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local mg=Duel.GetMatchingGroup(cm.filter,tp,LSTN("G"),0,nil,e,tp)
	mg:Merge(Duel.GetOverlayGroup(tp,1,1):Filter(cm.filter,nil,e,tp))
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and #mg>0 end
	local opt=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1),aux.Stringid(m,2))
	e:SetLabel(opt)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_OVERLAY)
end
function cm.op0(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local opt=e:GetLabel()
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(cm.filter,tp,LSTN("G"),0,nil,e,tp)
	mg:Merge(Duel.GetOverlayGroup(tp,1,1):Filter(cm.filter,nil,e,tp))
	if #mg>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=mg:Select(tp,1,1,nil)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		if opt==0 then
			local e1=MakeEff(c,"I","M")
			e1:SetCategory(CATEGORY_DESTROY)
			WriteEff(e1,1,"CTO")
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			g:GetFirst():RegisterEffect(e1,true)
		elseif opt==1 then
			local e2=MakeEff(c,"FTf","M")
			e2:SetCategory(CATEGORY_ATKCHANGE)
			e2:SetCode(EVENT_SUMMON_SUCCESS)
			WriteEff(e2,2,"NTO")
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			g:GetFirst():RegisterEffect(e2,true)
			local e4=e2:Clone()
			e4:SetCode(EVENT_SPSUMMON_SUCCESS)
			g:GetFirst():RegisterEffect(e4,true)
		else
			local e3=MakeEff(c,"I","M")
			e3:SetCategory(CATEGORY_DESTROY)
			e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
			e3:SetCost(YuL.LPcost(1000))
			WriteEff(e3,3,"TO")
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			g:GetFirst():RegisterEffect(e3,true)
		end
		if not g:GetFirst():IsType(TYPE_EFFECT) then
			local e0=Effect.CreateEffect(e:GetHandler())
			e0:SetType(EFFECT_TYPE_SINGLE)
			e0:SetCode(EFFECT_ADD_TYPE)
			e0:SetValue(TYPE_EFFECT)
			e0:SetReset(RESET_EVENT+RESETS_STANDARD)
			g:GetFirst():RegisterEffect(e0,true)
		end
	end
end

--오벨리스크의 거신병
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local dg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return e:GetHandler():GetAttackAnnouncedCount()==0 and Duel.CheckReleaseGroupCost(tp,nil,2,false,aux.ReleaseCheckTarget,nil,dg) end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
	local g=Duel.SelectReleaseGroupCost(tp,nil,2,2,false,aux.ReleaseCheckTarget,nil,dg)
	Duel.Release(g,REASON_COST)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(g,REASON_EFFECT)
end

--오시리스의 천공룡
function cm.atkfilter(c,e,tp)
	return c:IsControler(tp) and c:IsPosition(POS_FACEUP_ATTACK) and (not e or c:IsRelateToEffect(e))
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.atkfilter,1,nil,nil,1-tp)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
	Duel.SetTargetCard(eg)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cm.atkfilter,nil,e,1-tp)
	local dg=Group.CreateGroup()
	local c=e:GetHandler()
	local tc=g:GetFirst()
	for tc in aux.Next(g) do
		local preatk=tc:GetAttack()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-2000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		if preatk~=0 and tc:GetAttack()==0 then dg:AddCard(tc) end
	end
	Duel.Destroy(dg,REASON_EFFECT)
end

--라의 익신룡
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end

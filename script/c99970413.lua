--[ Tinnitus ]
local m=99970413
local cm=_G["c"..m]
function cm.initial_effect(c)

	--타깃 설정
	local e0=MakeEff(c,"FC","M")
	e0:SetCategory(CATEGORY_COUNTER)
	e0:SetCode(EVENT_ADJUST)
	WriteEff(e0,0,"NO")
	c:RegisterEffect(e0)
	
	--파괴 + 특수 소환
	local e1=MakeEff(c,"Qo","H")
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCL(1,m)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)

	--바운스 + 특수 소환
	local e2=MakeEff(c,"STf","M")
	e2:SetD(m,0)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetCode(m)
	e2:SetCL(1)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"FC","M")
	e3:SetCode(EVENT_ADJUST)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	WriteEff(e3,3,"O")
	c:RegisterEffect(e3)

end

--타깃 설정
function cm.con0fil(c)
	return c:GetCounter(0x1e1c)>0
end
function cm.con0(e)
	return not Duel.IsExistingMatchingCard(cm.con0fil,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil) and Duel.IsExistingMatchingCard(cm.op0fil,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil,e)
end
function cm.op0fil(c,e)
	return not c:IsImmuneToEffect(e) and c:IsFaceup()
end
function cm.op0(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.op0fil,tp,0,LOCATION_MZONE,nil,e)
	if #g>0 then
		Duel.Hint(HINT_CARD,0,m)
		local sg=g:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		sg:GetFirst():AddCounter(0x1e1c,1,REASON_EFFECT)
	end
end

--파괴 + 특수 소환
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function cm.tar1fil(c)
	return c:GetCounter(0x1e1c)>0
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.tar1fil(chkc) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE,1-tp)
		and Duel.IsExistingTarget(cm.tar1fil,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,cm.tar1fil,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,1-tp,false,false,POS_FACEUP_DEFENSE)
	end
end

--바운스 + 특수 소환
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function cm.op2fil(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(m)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SendtoHand(c,nil,REASON_EFFECT)==0 then return end
	local g=Duel.GetMatchingGroup(cm.op2fil,tp,LOCATION_HAND,0,nil,e,tp)
	if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetCounter(0x1e1c)>0 then
		Duel.RaiseSingleEvent(c,m,e,0,tp,tp,0)
	end
end

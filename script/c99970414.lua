--[ Tinnitus ]
local m=99970414
local cm=_G["c"..m]
function cm.initial_effect(c)

	--타깃 설정
	local e0=MakeEff(c,"FC","M")
	e0:SetCategory(CATEGORY_COUNTER)
	e0:SetCode(EVENT_ADJUST)
	WriteEff(e0,0,"NO")
	c:RegisterEffect(e0)
	
	--특수 소환 + 공수 감소
	local e1=MakeEff(c,"I","HG")
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCL(1,m)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)
	
	--카운터
	local e2=MakeEff(c,"STo")
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)

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

--특수 소환 + 공수 감소
function cm.con1(e)
	return Duel.GetCounter(e:GetHandlerPlayer(),1,1,0x1e1c)>=3
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.BreakEffect()
		local g=Duel.GetMatchingGroup(cm.con0fil,tp,0,LOCATION_MZONE,nil)
		for tc in aux.Next(g) do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(-600*tc:GetCounter(0x1e1c))
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			tc:RegisterEffect(e2)
		end
	end
end

--카운터
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.op0fil,tp,0,LOCATION_MZONE,nil,e)
	if chk==0 then return #g>0 end
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,cm.op0fil,tp,0,LOCATION_MZONE,1,1,nil,e)
	if #g>0 then
		g:GetFirst():AddCounter(0x1e1c,1,REASON_EFFECT)
	end
end

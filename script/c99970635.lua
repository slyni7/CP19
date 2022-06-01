--[ hololive 1st Gen ]
local m=99970635
local cm=_G["c"..m]
function cm.initial_effect(c)

	--엑시즈 소환
	RevLim(c)
	aux.AddXyzProcedure(c,aux.FBF(Card.IsSetCard,0xe19),4,2,cm.ovfilter,aux.Stringid(m,0),2,cm.xyzop)

	--엑시즈 레벨	
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_XYZ_LEVEL)
	e1:SetValue(cm.xyzlv)
	c:RegisterEffect(e1)
	
	--특수 소환 + 엑시즈
	local e2=MakeEff(c,"Qo","M")
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCL(1,m)
	e2:SetCost(spinel.rmovcost(1))
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)

	--전투 내성 부여
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_XMATERIAL)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetCondition(cm.con3)
	e3:SetValue(1)
	c:RegisterEffect(e3)

end

--엑시즈 소환
function cm.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xe19)
end
function cm.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,m)==0 end
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
	return true
end

--엑시즈 레벨	
function cm.xyzlv(e,c,rc)
	return c:GetRank()
end

--특수 소환 + 엑시즈
function cm.spfilter(c,e,tp)
	return c:IsLevel(4) and c:IsSetCard(0xe19) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.xyzchk(c,sg,minc,maxc,tp)
	return c:IsXyzSummonable(nil,sg,minc,maxc) and Duel.GetLocationCountFromEx(tp,tp,sg,c)>0
end
function cm.spcheck(sg,e,tp,mg)
	return sg:GetClassCount(Card.GetLocation)==#sg and sg:GetClassCount(Card.GetLevel)==1
		and Duel.IsExistingMatchingCard(cm.xyzchk,tp,LOCATION_EXTRA,0,1,nil,sg,2,2,tp)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,cm.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
	end
	Duel.SpecialSummonComplete()
	Duel.BreakEffect()
	local sg=Group.CreateGroup()
	sg:AddCard(tc)
	sg:AddCard(c)
	local xyzg=Duel.GetMatchingGroup(cm.xyzchk,tp,LOCATION_EXTRA,0,nil,sg,2,2,tp)
	if #xyzg>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		Duel.XyzSummon(tp,xyz,sg,sg)
	end
end

--전투 내성 부여
function cm.con3(e)
	return e:GetHandler():IsType(TYPE_XYZ)
end

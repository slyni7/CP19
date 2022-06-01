--[ Tinnitus ]
local m=99970475
local cm=_G["c"..m]
function cm.initial_effect(c)

	--융합 소환
	RevLim(c)
	Fusion.AddProcMixRep(c,true,true,cm.matfilter,1,1,aux.FilterBoolFunctionEx(Card.IsSetCard,0xe1c))
	Fusion.AddContactProc(c,cm.contactfil,cm.contactop,cm.splimit,cm.conF)
	
	--융합 제약
	YuL.NoMat(c,"F")
	
	--타깃 설정
	local e0=MakeEff(c,"FC","M")
	e0:SetCategory(CATEGORY_COUNTER)
	e0:SetCode(EVENT_ADJUST)
	WriteEff(e0,0,"NO")
	c:RegisterEffect(e0)
	
	--특수 소환
	local e1=MakeEff(c,"FTo","M")
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1,m)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)

	--공수 증가
	local e3=MakeEff(c,"STo")
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	WriteEff(e3,3,"CNO")
	c:RegisterEffect(e3)

	aux.GlobalCheck(cm,function()
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetLabel(m)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		ge1:SetOperation(aux.sumreg)
		Duel.RegisterEffect(ge1,0)
	end)
	
end

cm.material_setcode={0xe1c}

--융합 소환
function cm.matfilter(c,fc,sumtype,tp)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL) and c:GetCounter(0x1e1c)>0
		and c:IsLocation(LOCATION_MZONE) and (c:IsControler(tp) or c:IsFaceup())
end
function cm.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function cm.cfilter(c,tp)
	return c:IsAbleToGraveAsCost() and (c:IsControler(tp) or c:IsFaceup())
end
function cm.contactfil(tp)
	return Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
end
function cm.contactop(g,tp,c)
	Duel.SendtoGrave(g,REASON_COST+REASON_MATERIAL)
	Duel.RegisterFlagEffect(tp,m+1,RESET_PHASE+PHASE_END,0,1)
end
function cm.conF(tp)
	return Duel.GetFlagEffect(tp,m+1)==0
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
	local g1=Duel.GetMatchingGroup(cm.op0fil,tp,0,LOCATION_MZONE,nil,e)
	local g2=Duel.GetMatchingGroup(cm.op0fil,tp,LOCATION_MZONE,0,nil,e)
	if #g1>0 and #g2>0 then
		Duel.Hint(HINT_CARD,0,m)
		local sg=g1:Select(tp,1,1,nil)
		sg:Merge(g2:Select(tp,1,1,nil))
		Duel.HintSelection(sg)
		sg:GetFirst():AddCounter(0x1e1c,1,REASON_EFFECT)
		sg:GetNext():AddCounter(0x1e1c,1,REASON_EFFECT)
	end
end

--특수 소환
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(m)~=0 end
	e:GetHandler():ResetFlagEffect(m)
end
function cm.tar1fil(c,e,tp)
	return c:IsSetCard(0xe1c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.tar1fil(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(cm.tar1fil,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,cm.tar1fil,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,LOCATION_GRAVE)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end

--공수 증가
function cm.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x1e1c,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x1e1c,1,REASON_COST)
end
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and bc and bc:IsFaceup() and bc:IsRelateToBattle()
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	local ct=c:GetCounter(0x1e1c)+bc:GetCounter(0x1e1c)
	if c:IsRelateToEffect(e) and c:IsFaceup() and ct>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
		e1:SetValue(ct*1000)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e2)
	end
end

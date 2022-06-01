--이형의 계 - 손짓
--카드군 번호: 0xc86
local m=81243060
local cm=_G["c"..m]
function cm.initial_effect(c)

	--공통 효과
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(0x10)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(0x02)
	e2:SetHintTiming(0,TIMING_MAIN_END)
	c:RegisterEffect(e2)
	
	--엑시즈 소환
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,m)
	e3:SetCondition(cm.cn3)
	e3:SetTarget(cm.tg3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
end

--엑시즈 소재로 한다
function cm.tfil0(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0xc86)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(0x04) and chkc:IsControler(tp) and cm.tfil0(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(cm.tfil0,tp,0x04,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,cm.tfil0,tp,0x04,0,1,1,nil)
	if e:GetHandler():IsLocation(0x10) then
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
	end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not c:IsImmuneToEffect(e) then
		local og=c:GetOverlayGroup()
		if #og>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(tc,Group.FromCards(c))
	end
end

--특수 소환
function cm.cn3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0x04,0)==0
end
function cm.mfil0(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) and c:IsSetCard(0xc86)
	and Duel.IsExistingMatchingCard(cm.mfil1,tp,0x02+0x10,0,1,c,e,tp,c,c:GetLevel())
end
function cm.mfil1(c,e,tp,mc,lv)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) and c:IsSetCard(0xc86)
	and Duel.IsExistingMatchingCard(cm.spfil0,tp,0x40,0,1,nil,e,tp,lv+c:GetLevel(),Group.FromCards(c,mc))
end
function cm.spfil0(c,e,tp,lv,mg)
	return c:GetRank()<=math.floor(lv/2) and c:IsSetCard(0xc86) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,false,false,POS_FACEUP)
	and Duel.GetLocationCountFromEx(tp,tp,mg,c)>0
end
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,0x04)>1
		and Duel.IsExistingMatchingCard(cm.mfil0,tp,0x02+0x10,0,2,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,0x10)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x40)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) or Duel.GetLocationCount(tp,0x04)<=1 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.mfil0),tp,0x02+0x10,0,1,1,nil,e,tp)
	local tc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.mfil1),tp,0x02+0x10,0,1,1,tc,e,tp,tc,tc:GetLevel())
	g1:Merge(g2)
	if g1 and #g1==2 then
		local tc1=g1:GetFirst()
		local tc2=g1:GetNext()
		Duel.SpecialSummonStep(tc1,0,tp,tp,false,false,POS_FACEUP)
		Duel.SpecialSummonStep(tc2,0,tp,tp,false,false,POS_FACEUP)
		Duel.SpecialSummonComplete()
		local og=Duel.GetOperatedGroup()
		if og:FilterCount(Card.IsLocation,nil,0x04)~=2 then
			return
		end
		local sg=Duel.GetMatchingGroup(cm.spfil0,tp,0x40,0,nil,e,tp,tc1:GetLevel()+tc2:GetLevel(),nil)
		if #sg==0 then
			return
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local ssg=sg:Select(tp,1,1,nil)
		local sc=ssg:GetFirst()
		if sc then
			Duel.BreakEffect()
			sc:SetMaterial(Group.FromCards(og))
			Duel.Overlay(sc,Group.FromCards(og))
			Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
			sc:CompleteProcedure()
		end
	end
end

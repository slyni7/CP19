--L:P(라스트 판타즘) - 혼돈의 지배자
--카드군 번호: 0xc9b
local m=81257010
local cm=_G["c"..m]
function cm.initial_effect(c)

	--특수 소환
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(0x02)
	e1:SetCondition(cm.cn1)
	e1:SetCost(cm.co1)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	c:RegisterEffect(e1)

	--세트
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(81257000)
	e4:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e4)
end

--특수 소환
function cm.cn1(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function cm.co1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetFlagEffect(tp,m)==0
	end
	Duel.RegisterFlagEffect(tp,m,RESET_CHAIN,0,1)
end
function cm.tfil0(c)
	return c:IsSetCard(0xc9b) and ( c:IsLocation(0x02) or c:IsFaceup() )
end
function cm.tfil1(c)
	return c:IsFaceup() and c:GetSequence()<5
end
function cm.tfil2(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=nil
	if ft>0 then
		g=Duel.GetMatchingGroup(cm.tfil0,tp,LOCATION_MZONE+0x02,0,c)
	else
		g=Duel.GetMatchingGroup(cm.tfil1,tp,LOCATION_MZONE,0,c)
	end
	if chk==0 then
		return ft>-1 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and #g>=1 and ( ft~=0 or g:IsExists(cm.tfil2,1,nil,tp) )
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOCATION_MZONE+0x02)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=nil
	if ft>0 then
		g=Duel.GetMatchingGroup(cm.tfil0,tp,LOCATION_MZONE+0x02,0,c)
	else
		g=Duel.GetMatchingGroup(cm.tfil1,tp,LOCATION_MZONE,0,c)
	end
	if #g<1 then
		return
	end
	local g1=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	if ft==0 then
		g1=g:FilterSelect(tp,cm.tfil2,1,1,nil,tp)
	else
		g1=g:Select(tp,1,1,nil)
	end
	if #g>1 and Duel.SelectYesNo(tp,aux.Stringid(m,4)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g2=g:Select(tp,1,1,g1:GetFirst())
		g1:Merge(g2)
	end
	if Duel.SendtoGrave(g1,REASON_EFFECT)>0 then
		if not c:IsRelateToEffect(e) then
			return
		end
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
	e:SetLabel(#g1)
end

--세트
function cm.tfil3(c)
	return c:IsSSetable() and c:IsSetCard(0xc9b) and c:IsType(0x2+0x4)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(cm.tfil3,tp,0x01,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,0,1-tp,0x0c)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabelObject():GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,cm.tfil3,tp,0x01,0,1,1,nil)
	if #g>0 and Duel.SSet(tp,g) then
		local mg=Duel.GetMatchingGroup(aux.TRUE,tp,0,0x0c,nil)
		if ct>0 and #mg>0 and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sg=mg:Select(tp,1,ct,nil)
			Duel.HintSelection(sg)
			Duel.SendtoGrave(sg,REASON_EFFECT)
		end
	end
end

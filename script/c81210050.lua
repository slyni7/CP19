--자유의 깃발
local m=81210050
local cm=_G["c"..m]
function cm.initial_effect(c)

	--activation
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
end

--ritual
function cm.exfil0(c)
	return c:IsAbleToGrave() and c:IsRace(RACE_MACHINE) and c:IsType(TYPE_PENDULUM)
end
function cm.spfil0(c,e,tp,mg)
	if not c:IsSetCard(0xcb9) or bit.band(c:GetType(),0x81)~=0x81 then
		return false
	end
	local m=mg:Clone()
	m:RemoveCard(c)
	aux.GCheckAdditional=aux.RitualCheckAdditional(c,c:GetLevel(),"Greater")
	local res=m:CheckSubGroup(cm.mfil0,1,c:GetLevel(),e,tp,c)
	aux.GCheckAdditional=nil
	return res
end
function cm.mfil0(sg,e,tp,rc)
	Duel.SetSelectedCard(sg)
	return sg:CheckWithSumGreater(Card.GetRitualLevel,rc:GetLevel(),rc)
	and 
		( (rc:IsLocation(0x40) and rc:IsFaceup() and Duel.GetLocationCountFromEx(tp,tp,sg,rc)>0) 
	or
		(not rc:IsLocation(0x40) and Duel.GetMZoneCount(tp,sg)>0) )
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetRitualMaterial(tp)
	local exg=Duel.GetMatchingGroup(cm.exfil0,tp,0x01,0,nil)
	mg:Merge(exg)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.spfil0,tp,0x02+0x40,0,1,nil,e,tp,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x02+0x40)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=Duel.GetRitualMaterial(tp)
	local exg=Duel.GetMatchingGroup(cm.exfil0,tp,0x01,0,nil)
	mg:Merge(exg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,cm.spfil0,tp,0x02+0x40,0,1,1,nil,e,tp,mg)
	local tc=tg:GetFirst()
	if tc then
		mg:RemoveCard(tc)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Greater")
		local mat=mg:SelectSubGroup(tp,cm.mfil0,false,1,tc:GetLevel(),e,tp,tc)
		aux.GCheckAdditional=nil
		tc:SetMaterial(mat)
		local mat2=mat:Filter(Card.IsLocation,nil,0x01)
		mat:Sub(mat2)
		Duel.ReleaseRitualMaterial(mat)
		Duel.SendtoGrave(mat2,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end

--salvage
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then
		return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_PZONE) and chkc:IsFaceup()
	end
	if chk==0 then
		return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_PZONE,0,1,nil)
		and c:IsAbleToDeck()
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_PZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
end
function cm.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsRelateToEffect(e) and c:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		Duel.SendtoDeck(c,nil,1,REASON_EFFECT)
		local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_HAND,0,nil,e,tp)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
			local sg=g:Select(tp,1,1,nil)
			local cg=sg:GetFirst()
			if cg then
				Duel.BreakEffect()
				Duel.SpecialSummon(cg,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end



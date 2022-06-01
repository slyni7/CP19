--뱀피어스 루나스펠
--카드군 번호: 0xc98
local m=81259090
local cm=_G["c"..m]
function cm.initial_effect(c)

	--싱크로
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	
	--묘지 효과
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_RECOVER+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(0x10)
	e2:SetCountLimit(1,m+1)
	e2:SetCondition(cm.cn2)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	
	--패 유발
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(0x02)
	e3:SetCountLimit(1,m+EFFECT_COUNT_CODE_DUEL)
	e3:SetCost(cm.co3)
	e3:SetTarget(cm.tg3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
end

--싱크로
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_MZONE,0,nil,0xc98)
		return Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,0x40,0,1,nil,nil,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x40)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_MZONE,0,nil,0xc98)
	local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,0x40,0,nil,nil,mg)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,sg:GetFirst(),nil,mg)
	end
end

--묘지 효과
function cm.cn2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=e:GetHandlerPlayer()
end
function cm.cfil1(c)
	return c:IsReleasable() and c:IsSetCard(0xc98) and c:IsType(0x1)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.cfil1,tp,LOCATION_MZONE,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rg=Duel.SelectMatchingCard(tp,cm.cfil1,tp,LOCATION_MZONE,0,1,1,nil)
	local rc=Duel.SendtoGrave(rg,REASON_COST)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(rg:GetFirst():GetBaseAttack())
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rg:GetFirst():GetBaseAttack())
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	local p,lp=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Remove(c,POS_FACEUP,REASON_EFFECT) and Duel.Recover(p,lp,REASON_EFFECT)>999 then
		local d=math.floor((lp)/1000)
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,0x0c,nil)
		if d>0 and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(m,4)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local sg=g:Select(tp,1,d,REASON_EFFECT)
			Duel.HintSelection(sg)
			Duel.Destroy(sg,REASON_EFFECT)
		end
	end
end

--패 유발
function cm.cfil0(c)
	return c:IsAbleToGraveAsCost() and c:IsSetCard(0xc98)
end
function cm.co3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.cfil0,tp,0x02,0,1,c)
		and c:IsAbleToGraveAsCost()
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.cfil0,tp,0x02,0,1,1,c)
	g:AddCard(c)
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.mfil0(c,e,tp,g,ft)
	local lv=c:GetLevel()
	return lv>0 and Duel.GetMZoneCount(tp,c)>0 	and g:CheckWithSumEqual(Card.GetLevel,lv,1,ft+1)
	and c:IsType(TYPE_SYNCHRO) and c:IsAttribute(ATTRIBUTE_WIND) and c:IsAbleToGrave()
end
function cm.spfil0(c,e,tp)
	return c:IsSetCard(0xc98) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.spfil0,tp,0x01+0x02,0,nil,e,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	if chk==0 then
		return ft>0 and Duel.IsExistingMatchingCard(cm.mfil0,tp,0x40,0,1,nil,e,tp,g,ft)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x01+0x02)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.spfil0,tp,0x01+0x02,0,nil,e,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then
		return
	end
	if ft>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(tp,cm.mfil0,tp,0x40,0,1,1,nil,e,tp,g,ft)
	if #g2>0 and Duel.SendtoGrave(g2,REASON_EFFECT)~=0 then
		local tc=g2:GetFirst()
		local glv=tc:GetLevel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:SelectWithSumEqual(tp,Card.GetLevel,glv,1,ft)
		if #sg>0 then
			local tg=sg:GetFirst()
			while tg do
				Duel.SpecialSummonStep(tg,0,tp,tp,false,false,POS_FACEUP_ATTACK)
				tg=sg:GetNext()
			end
			Duel.SpecialSummonComplete()
		end
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_SUMMON)
		e1:SetTargetRange(1,0)
		e1:SetTarget(cm.otg1)
		if Duel.GetTurnPlayer()==tp then
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
		else
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN)
		end
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		Duel.RegisterEffect(e2,tp)
	end
end
function cm.otg1(e,c,sump,sumtype,sumpos,targetp)
	return not c:IsSetCard(0xc98)
end

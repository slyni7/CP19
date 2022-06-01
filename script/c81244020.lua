--영의 성령화
--카드군 번호: 0x307a
local m=81244020
local cm=_G["c"..m]
function cm.initial_effect(c)

	--특수 소환
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(0x01+0x02)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.cn1)
	e1:SetOperation(cm.op1)
	e1:SetValue(SUMMON_VALUE_SELF)
	c:RegisterEffect(e1)
	
	--레벨 참조
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_SET_BASE_ATTACK)
	e2:SetRange(0x04)
	e2:SetValue(cm.va2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_SET_BASE_DEFENSE)
	c:RegisterEffect(e3)
	
	--내성
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetRange(0x04)
	e4:SetCondition(cm.cn4)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e6:SetValue(aux.tgoval)
	c:RegisterEffect(e6)
	
	--특수 소환
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e7:SetCode(EVENT_TO_GRAVE)
	e7:SetCountLimit(1,m+1)
	e7:SetCondition(cm.cn7)
	e7:SetTarget(cm.tg7)
	e7:SetOperation(cm.op7)
	c:RegisterEffect(e7)
end

--특수 소환
function cm.mfil0(c)
	return c:IsAbleToRemoveAsCost() and c:IsAttribute(0x08) and c:IsRace(RACE_FAIRY)
end
function cm.mfil1(c)
	return c:IsAbleToRemoveAsCost() and c:GetSequence()<5 and c:IsAttribute(0x08) and c:IsRace(RACE_FAIRY)
end
function cm.mzfil0(c,tp)
	return c:IsControler(tp) and c:IsLocation(0x04) and c:GetSequence()<5
end
function cm.cn1(e,c)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,0x04)
	local g=nil
	if ft>-1 then
		local loc=0
		if Duel.IsPlayerAffectedByEffect(tp,88581108) then loc=0x04 end
		g=Duel.GetMatchingGroup(cm.mfil0,tp,0x04+0x10,loc,c)
	else
		g=Duel.GetMatchingGroup(cm.mfil1,tp,0x04,0,c)
	end
	return ft>-2 and #g>=2 and g:IsExists(Card.IsSetCard,1,nil,0x307a)
	and (ft~=0 or g:IsExists(cm.mzfil0,1,nil,tp))
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,0x04)
	local g=nil
	if ft>-1 then
		local loc=0
		if Duel.IsPlayerAffectedByEffect(tp,88581108) then loc=0x04 end
		g=Duel.GetMatchingGroup(cm.mfil0,tp,0x04+0x10,loc,c)
	else
		g=Duel.GetMatchingGroup(cm.mfil1,tp,0x04,0,c)
	end
	if #g<2 or not g:IsExists(Card.IsSetCard,1,nil,0x307a) then
		return
	end
	local g1=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	if ft==0 then
		g1=g:FilterSelect(tp,cm.mzfil0,1,1,nil,tp)
	else
		g1=g:Select(tp,1,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	if g1:GetFirst():IsSetCard(0x307a) then
		local g2=g:Select(tp,1,1,g1:GetFirst())
		g1:Merge(g2)
	else
		local g2=g:FilterSelect(tp,Card.IsSetCard,1,1,g1:GetFirst(),0x307a)
		g1:Merge(g2)
	end
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end

--레벨 참조
function cm.vfil0(c)
	return c:IsFaceup() and c:IsSetCard(0x307a) and c:GetLevel()>0
end
function cm.va2(e,c)
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(cm.vfil0,tp,0x20,0,nil)
	return g:GetSum(Card.GetLevel)*200
end

--내성
function cm.nfil0(c)
	return c:IsFaceup() and c:IsSetCard(0x307a)
end
function cm.cn4(e)
	return Duel.IsExistingMatchingCard(cm.nfil0,e:GetHandlerPlayer(),0x04,0,1,e:GetHandler())
end

--특수 소환
function cm.cn7(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_DESTROY) and c:GetPreviousControler()==tp and c:GetReasonPlayer()==1-tp
end
function cm.spfil0(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsFaceup() and c:IsSetCard(0x307a)
end
function cm.tg7(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(0x20) and chkc:IsControler(tp) and cm.spfil0(chkc,e,tp)
	end
	if chk==0 then
		return Duel.GetLocationCount(tp,0x04)>0
		and Duel.IsExistingTarget(cm.spfil0,tp,0x20,0,1,nil,e,tp)
	end
	local ft=Duel.GetLocationCount(tp,0x04)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,cm.spfil0,tp,0x20,0,1,ft,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,#g,0,0)
end
function cm.op7(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,0x04)
	if ft<=0 then
		return
	end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if #sg>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then
		return
	end
	if #sg>ft then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		sg=sg:Select(tp,ft,ft,nil)
	end
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e1:SetTargetRange(1,0)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end

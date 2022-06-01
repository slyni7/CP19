--하니야스신 케이키
--카드군 번호: 0xc9c, 0xc9d
local m=81256020
local tkn=81255990
local cm=_G["c"..m]
function cm.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddFusionProcMixRep(c,true,true,cm.mat0,1,2,cm.mat1)
	
	--내성
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(cm.va1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(cm.tg2)
	c:RegisterEffect(e2)
	
	--스테이터스
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(cm.tg3)
	e3:SetValue(cm.va3)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
	
	--토큰
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,m)
	e5:SetCost(cm.co5)
	e5:SetTarget(cm.tg5)
	e5:SetOperation(cm.op5)
	c:RegisterEffect(e5)
	
	--바운스
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,0))
	e6:SetCategory(CATEGORY_TODECK)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(0x04)
	e6:SetCountLimit(1)
	e6:SetCondition(cm.cn6)
	e6:SetCost(cm.co6)
	e6:SetTarget(cm.tg6)
	e6:SetOperation(cm.op6)
	c:RegisterEffect(e6)
end

--융합 소환
function cm.mat0(c)
	return c:GetSummonLocation()==0x40 and c:IsLocation(LOCATION_MZONE)
end
function cm.mat1(c)
	return c:IsType(TYPE_FUSION) and c:IsFusionSetCard(0xc9c)
end

--내성
function cm.va1(e,te)
	return te:GetOwner()~=e:GetOwner() and te:IsActiveType(0x1)
end
function cm.tg2(e,c)
	return c:IsFaceup() and c:IsSetCard(0xc9d)
end

--스테이터스
function cm.tg3(e,c)
	return c:IsFaceup() and c:IsSetCard(0xc9d)
end
function cm.va3(e,c)
	local tp=e:GetHandlerPlayer()
	return Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_MZONE,LOCATION_MZONE,nil,TYPE_TOKEN)*500
end

--토큰
function cm.cfil0(c)
	return c:IsAbleToDeckOrExtraAsCost() and c:IsSetCard(0xc9c)
end
function cm.co5(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then
		return ft>0 and Duel.IsExistingMatchingCard(cm.cfil0,tp,0x02+0x10,0,1,nil)
	end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.cfil0,tp,0x02+0x10,0,1,ft,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
	e:SetLabel(#g)
end
function cm.tg5(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabel()
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,tkn,0,0x4011,500,500,2,RACE_ROCK,ATTRIBUTE_EARTH)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,ct,0,0)
end
function cm.op5(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<ct or ( ct>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) ) 
	or not Duel.IsPlayerCanSpecialSummonMonster(tp,tkn,0,0x4011,500,500,2,RACE_ROCK,ATTRIBUTE_EARTH) then
		return
	end
	for i=1,ct do
		local token=Duel.CreateToken(tp,tkn)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
	Duel.SpecialSummonComplete()
end


--덱 바운스
function cm.cn6(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2) and c:IsSummonType(SUMMON_TYPE_FUSION) and c:GetMaterialCount()>=3
end
function cm.filter1(c)
	return c:IsFaceup() and c:IsAbleToDeck()
end
function cm.co6(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.CheckReleaseGroup(tp,aux.TRUE,1,nil,tp)
	end
	local g=Duel.SelectReleaseGroup(tp,aux.TRUE,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc:IsCode(tkn) or (tc:IsType(TYPE_FUSION) and tc:IsSetCard(0xc9c)) then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
	Duel.Release(g,REASON_COST)
end
function cm.tg6(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.filter1,tp,0,0x0c,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,0x0c)
end
function cm.op6(e,tp,eg,ep,ev,re,r,rp)
	local ct=1
	if e:GetLabel()>0 then ct=ct+1 end
	local g=Duel.GetMatchingGroup(cm.filter1,tp,0,0x0c,nil)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=g:Select(tp,1,ct,nil)
		Duel.HintSelection(sg)
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	end
end

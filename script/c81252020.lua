--프리즈스타의 얼음비
--카드군 번호: 0xc81
local m=81252020
local cm=_G["c"..m]
function cm.initial_effect(c)

	--스탯
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(0x04)
	e1:SetValue(cm.va1)
	c:RegisterEffect(e1)
	
	--서치
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,m+1)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	
	--리쿠르트
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_FLIP)
	e3:SetCountLimit(1,m)
	e3:SetTarget(cm.tg3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
end


--스탯
function cm.tfil0(c,tp)
	return c:IsFaceup() and c:GetOwner()==tp
end
function cm.va1(e,c)
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(cm.tfil0,tp,0x04,0,nil,1-tp)
	local ct=g:GetSum(Card.GetLevel)
	if g:IsExists(Card.IsType,1,nil,TYPE_XYZ) then
		local ct2=g:GetSum(Card.GetRank)
		ct=ct+ct2
	end
	return ct*300
end

--서치
function cm.tfil1(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0xc81)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.tfil1,tp,0x01,0,1,nil,e,tp)
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0x02,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x01)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,0x02)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,cm.tfil1,tp,0x01,0,1,1,nil,e,tp)
	if #g1>0 and Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0x02,0,nil)
		if #g2>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local sg=g2:Select(tp,1,1,nil)
			Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
		end
	end
end

--리쿠르트
function cm.spfil0(c,e,tp)
	if c:IsSetCard(0xc81) and c:IsType(0x2+0x4) then
		return c:IsSSetable() and Duel.GetLocationCount(tp,0x08)>0
	end
	if c:IsSetCard(0xc81) and c:IsType(0x1) and not c:IsCode(m) then
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and Duel.GetLocationCount(tp,0x04)>0
	end
	return false
end
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.spfil0,tp,0x01+0x10,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x01+0x10)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATEDCARD)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfil0),tp,0x01+0x10,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if not tc then
		return
	end
	if tc:IsType(0x2+0x4) then
		if tc:IsSSetable() and Duel.GetLocationCount(tp,0x08)>0 then
			Duel.SSet(tp,tc)
		end
	else
		if tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and Duel.GetLocationCount(tp,0x04)>0 then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end

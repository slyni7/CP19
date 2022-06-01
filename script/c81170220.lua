--USS(이글 유니온) 피닉스
--카드군 번호: 0xcb4
local m=81170220
local cm=_G["c"..m]
function cm.initial_effect(c)

	--특수 소환
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.cn1)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
end

--특수 소환
function cm.cn1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousLocation(0x04) and c:IsControler(tp)
end
function cm.tfil0(c)
	return c:IsFaceup() and c:IsSetCard(0xcb4)
end
function cm.spfil0(c,e,tp,rcv)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0xcb4) and c:GetAttack()<=rcv
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCount(tp,0x04)>0
	end
	local g=Duel.GetMatchingGroup(cm.tfil0,tp,0x04,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x02+0x10)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,0,0,tp,#g*300)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,0x04)<=0 then
		return
	end
	local lp=Duel.GetMatchingGroup(cm.tfil0,tp,0x04,0,nil)
	local rcv=#lp*300
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_ATTACK) and Duel.Recover(tp,rcv,REASON_EFFECT)>0 then
		local g2=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.spfil0),tp,0x02+0x10,0,nil,e,tp,rcv)
		if #g2>0 and Duel.GetLocationCount(tp,0x04)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g2:Select(tp,1,1,nil)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end

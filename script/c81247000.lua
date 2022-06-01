--저승의 꽃 - 사화
--카드군 번호: 0xc85
local m=81247000
local cm=_G["c"..m]
function cm.initial_effect(c)

	--스피릿
	aux.EnableSpiritReturn(c,EVENT_SUMMON_SUCCESS,EVENT_FLIP)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	
	--제외 유발
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	
	--링크 소환
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,m+1)
	e3:SetRange(0x04)
	e3:SetCondition(cm.cn3)
	e3:SetTarget(cm.tg3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetOperation(cm.op4)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_FLIP)
	c:RegisterEffect(e5)
end

--서치
function cm.tfil0(c)
	return c:IsAbleToHand() and c:IsSetCard(0xc85) and c:IsType(0x2+0x4)
end
function cm.nfil0(c)
	return c:IsFaceup() and c:IsCode(81247060)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.tfil0,tp,0x01,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x01)
	if Duel.IsExistingMatchingCard(cm.nfil0,tp,0x100,0,1,nil) then
		e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_DRAW)
	end
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.tfil0,tp,0x01,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if Duel.IsPlayerCanDraw(tp,1)
			and Duel.IsExistingMatchingCard(cm.nfil0,tp,0x100,0,1,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
			Duel.BreakEffect()
			Duel.ShuffleDeck(tp)
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end

--링크 소환
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function cm.cn3(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ( ph==PHASE_MAIN1 or ph==PHASE_MAIN2 ) and e:GetHandler():GetFlagEffect(m)>0 
end
function cm.mfil0(c)
	return c:IsAbleToRemove() and c:IsSetCard(0xc85)
end
function cm.mfil1(g,tg,c)
	return tg:IsExists(Card.IsLink,1,nil,#g) and g:IsContains(c)
	and Duel.GetLocationCountFromEx(tp,tp,g)>0
end
function cm.spfil0(c,e,tp)
	return c:IsType(TYPE_LINK) and c:IsRace(RACE_FIEND) and c:IsAttribute(ATTRIBUTE_FIRE)
	and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false)
end
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local cg=Duel.GetMatchingGroup(cm.mfil0,tp,0x02+0x10+0x0c,0,nil)
	local tg=Duel.GetMatchingGroup(cm.spfil0,tp,0x40,0,nil,e,tp)
	local _,maxlink=tg:GetMaxGroup(Card.GetLink)
	if chk==0 then
		if #tg==0 then
			return false
		end
		return cg:CheckSubGroup(cm.mfil1,1,maxlink,tg,c)
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,0x02+0x10+0x0c)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x40)
end
function cm.spfil1(c,e,tp,lk)
	return cm.spfil0(c,e,tp) and c:IsLink(lk)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetControler()~=tp or not c:IsRelateToEffect(e) then
		return
	end
	local cg=Duel.GetMatchingGroup(cm.mfil0,tp,0x02+0x10+0x0c,0,nil,c)
	local tg=Duel.GetMatchingGroup(cm.spfil0,tp,0x40,0,nil,e,tp)
	local _,maxlink=tg:GetMaxGroup(Card.GetLink)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=cg:SelectSubGroup(tp,cm.mfil1,false,1,maxlink,tg,c)
	if #rg>0 and Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.spfil1,tp,0x40,0,1,1,nil,e,tp,#rg)
		local tc=g:GetFirst()
		if tc then
			Duel.SpecialSummon(tc,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP)
		end
	end
end

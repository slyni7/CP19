--귀매 대안
--카드군 번호: 0xcac
local m=81090200
local cm=_G["c"..m]
function cm.initial_effect(c)

	--특수 소환
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xcac),4,2,cm.mfilter,aux.Stringid(m,0),3,cm.mop)

	--언데드족
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_RACE)
	e1:SetRange(0x10)
	e1:SetValue(0x10)
	c:RegisterEffect(e1)
	
	--샐비지
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(0x04)
	e2:SetCountLimit(1,m)
	e2:SetCost(cm.co2)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	
	--유언 효과
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCountLimit(1,m+1)
	e3:SetCondition(cm.cn3)
	e3:SetTarget(cm.tg3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
end

--특수 소환
function cm.mfilter(c,tp,xyzc)
	return c:IsFaceup() and c:IsSetCard(0xcac) and c:IsType(TYPE_XYZ,xyzc,SUMMON_TYPE_XYZ,tp)
	and c:GetOverlayCount()==0 and not c:IsCode(m)
end
function cm.mop(e,tp,chk)
	if chk==0 then
		return Duel.GetFlagEffect(tp,m)==0
	end
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
	return true
end

--샐비지
function cm.co2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:CheckRemoveOverlayCard(tp,1,REASON_COST)
	end
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.tfilter1(c,e,tp)
	local ft=Duel.GetLocationCount(tp,0x04)
	return c:IsRace(0x10) and ( c:IsAbleToHand() or (ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)))
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.tfilter1,tp,0x10,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x10)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x10)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local g=Duel.SelectMatchingCard(tp,cm.tfilter1,tp,0x10,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		if Duel.GetLocationCount(tp,0x04)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and (not tc:IsAbleToHand() or Duel.SelectOption(tp,1190,1152)==1) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		else
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end

--유언
function cm.cn3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(0x04) and bit.band(c:GetSummonType(),SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ
end
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,0x0c)
end
function cm.tfilter2(c,att)
	return c:IsAbleToHand() and c:IsSetCard(0xcac) and c:IsAttribute(att)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,0x0c,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.HintSelection(g)
		Duel.SendtoGrave(tc,REASON_EFFECT)
		if tc:IsLocation(0x10) then
			if tc:IsType(0x1) then
				Duel.BreakEffect()
				local att=tc:GetAttribute()
				local g2=Duel.GetMatchingGroup(cm.tfilter2,tp,0x01,0,nil,att)
				if #g2>0 then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
					local sg=g2:Select(tp,1,1,nil)
					Duel.SendtoHand(sg,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,sg)
				end
			elseif tc:IsType(0x2) then
				Duel.BreakEffect()
				Duel.Draw(tp,1,REASON_EFFECT)
			else
				Duel.BreakEffect()
				Duel.Damage(1-tp,1300,REASON_EFFECT)
			end
		end
	end
end

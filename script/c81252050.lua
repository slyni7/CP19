--프리즈스타의 자장가
--카드군 번호: 0xc81
local m=81252050
local cm=_G["c"..m]
function cm.initial_effect(c)

	--의식 소환
	local e1=aux.AddRitualProcGreater2(c,cm.ritual,nil,cm.ritual)
	
	--서치
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCondition(cm.cn2)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	
	--표시 형식
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(0x10)
	e3:SetCondition(cm.cn3)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(cm.tg3)
	e3:SetOperation(cm.op3)
	e3:SetHintTiming(0,TIMING_MAIN_END)
	c:RegisterEffect(e3)
end

--의식 소환
function cm.ritual(c)
	return c:IsSetCard(0xc81)
end

--서치
function cm.cn2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(0x02) and c:GetPreviousControler()==tp
end
function cm.tfil0(c)
	return c:IsAbleToHand() and c:IsSetCard(0xc81) and not c:IsCode(m)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.tfil0,tp,0x01,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x01)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.tfil0,tp,0x01,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

--프리체인
function cm.cn3(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ( ph==PHASE_MAIN1 or ph==PHASE_MAIN2) and aux.exccon(e)
end
function cm.posfil0(c)
	return c:IsFacedown() and c:IsSetCard(0xc81)
end
function cm.posfil1(c)
	return c:IsCanTurnSet() and c:IsSetCard(0xc81)
end
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(cm.posfil0,tp,0x04,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(cm.posfil1,tp,0x04,0,1,nil)
	if chk==0 then
		return b1 or b2
	end
	local s=0
	if b1 and not b2 then
		s=Duel.SelectOption(tp,aux.Stringid(m,0))
	end
	if not b1 and b2 then
		s=Duel.SelectOption(tp,aux.Stringid(m,1))+1
	end
	if b1 and b2 then
		s=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))
	end
	e:SetLabel(s)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,0,0)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
		local g=Duel.SelectMatchingCard(tp,cm.posfil0,tp,0x04,0,1,1,nil)
		if #g>0 then
			Duel.HintSelection(g)
			Duel.ChangePosition(g:GetFirst(),POS_FACEUP_DEFENSE)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
		local g=Duel.SelectMatchingCard(tp,cm.posfil1,tp,0x04,0,1,1,nil)
		if #g>0 then
			Duel.HintSelection(g)
			Duel.ChangePosition(g:GetFirst(),POS_FACEDOWN_DEFENSE)
		end
	end
end

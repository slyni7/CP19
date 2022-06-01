--기연 듈라한 나이트
--카드군 번호: 0xcba
local m=81232060
local cm=_G["c"..m]
function cm.initial_effect(c)

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	
	--공격 선언시
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(0x08)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.cn2)
	e2:SetCost(cm.co2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	
	--기동 효과
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(0x08)
	e3:SetCountLimit(1,m)
	e3:SetTarget(cm.tg3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
	
	--묘지 기동
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE+CATEGORY_DRAW+CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(0x10)
	e4:SetCountLimit(1,m+1)
	e4:SetCost(aux.bfgcost)
	e4:SetTarget(cm.tg4)
	e4:SetOperation(cm.op4)
	c:RegisterEffect(e4)
end

--공격력 / 수비력 상승
function cm.cn2(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not a:IsControler(tp) then a,d=d,a end
	return a and a:IsControler(tp) and a:IsFaceup() and a:IsSetCard(0x1cba)
end
function cm.cfilter1(c)
	return c:IsAbleToGraveAsCost() and c:IsSetCard(0x1cba) and c:IsType(0x1)
end
function cm.co2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.cfilter1,tp,0x01,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter1,tp,0x01,0,1,1,nil)
	e:SetValue(g:GetFirst():GetBaseDefense())
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	if Duel.GetTurnPlayer()~=tp then a=Duel.GetAttackTarget() end
	if not a:IsRelateToBattle() then
		return
	end
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(e:GetValue())
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	a:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	a:RegisterEffect(e2)
end

--서치 및 세트
function cm.tfilter1(c)
	return c:IsSSetable() and c:IsSetCard(0x2cba) and c:IsType(0x4)
end
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.tfilter1,tp,0x01,0,1,nil)
	end
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,cm.tfilter1,tp,0x01,0,1,1,nil)
	if #g>0 then
		Duel.SSet(tp,g)
	end
end

--효과 사용
function cm.tg4(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(0x08) and chkc:IsControler(tp) and chkc:IsFacedown()
	end
	if chk==0 then
		return Duel.IsExistingTarget(Card.IsFacedown,tp,0x08,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	Duel.SelectTarget(tp,Card.IsFacedown,tp,0x08,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,1,0x08)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1200)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if tc:IsFacedown() then Duel.ConfirmCards(tp,tc) end
		if tc:GetOriginalType()&TYPE_MONSTER==TYPE_MONSTER and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
		and Duel.GetLocationCount(tp,0x04)>0 then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		elseif tc:GetOriginalType()&TYPE_SPELL==TYPE_SPELL then
			if Duel.SendtoGrave(tc,REASON_EFFECT)~=0 then
				Duel.Draw(tp,1,REASON_EFFECT)
			end
		else
			if Duel.SendtoGrave(tc,REASON_EFFECT)~=0 then
				Duel.Damage(1-tp,1200,REASON_EFFECT)
			end	
		end
	end
end

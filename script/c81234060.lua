--멘헤라이터 스톰프
--카드군 번호: 0xc8e
local m=81234060
local cm=_G["c"..m]
function cm.initial_effect(c)

	--공통 트리거
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(cm.cn1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DECKDES+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e2:SetRange(0x10)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.cn2)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	
	--발동
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,m+1)
	e3:SetCondition(cm.cn3)
	e3:SetCost(cm.co3)
	e3:SetTarget(cm.tg3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.GlobalEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_BATTLED)
		ge1:SetOperation(cm.gop1)
		Duel.RegisterEffect(ge1,0)
	end
end

--공통 트리거
function cm.cn1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE,0,1)
end
function cm.cn2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(m)~=0
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToDeck()
		and Duel.IsPlayerCanDiscardDeck(tp,4)
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,4)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,0,0)
end
function cm.filter1(c)
	return c:IsSetCard(0xc8e) and c:IsLocation(0x10)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,1,REASON_EFFECT)~=0 then
		Duel.DiscardDeck(tp,4,REASON_EFFECT)
		local g=Duel.GetOperatedGroup()
		local ct=g:FilterCount(cm.filter1,nil)
		if ct>0 then
			Duel.BreakEffect()
			Duel.Damage(1-tp,ct*300,REASON_EFFECT)
		end
	end
end

--발동
function cm.chk(c)
	return c and c:IsSetCard(0xc8e)
end
function cm.gop1(e,tp,chk)
	if cm.chk(Duel.GetAttacker()) or cm.chk(Duel.GetAttackTarget()) then
		Duel.RegisterFlagEffect(tp,m+1,RESET_PHASE+PHASE_END,0,1)
	end
end
function cm.cn3(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) and Duel.GetFlagEffect(tp,m+1)>0
end
function cm.co3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetCustomActivityCount(m,tp,ACTIVITY_CHAIN)==0
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(cm.actlimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.actlimit(e,re,tp)
	return re:IsActiveType(0x1) and not re:GetHandler():IsSetCard(0xc8e)
end
function cm.tfilter1(c)
	return c:IsAbleToGrave() and c:IsSetCard(0xc8e)
end
function cm.tfilter2(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) and c:IsSetCard(0xc8e)
end
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local off=1
	local ops={}
	local opval={}
	if Duel.IsExistingMatchingCard(cm.tfilter1,tp,0x01,0,1,nil) then
		ops[off]=aux.Stringid(m,3)
		opval[off]=1
		off=off+1
	end
	if Duel.IsExistingMatchingCard(cm.tfilter2,tp,0x02+0x10,0,1,nil,e,tp) then
		ops[off]=aux.Stringid(m,4)
		opval[off]=2
		off=off+1
	end
	local ph=Duel.GetCurrentPhase()
	if Duel.GetTurnPlayer()==tp and (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) then
		ops[off]=aux.Stringid(m,5)
		opval[off]=3
		off=off+1
	end
	if chk==0 then
		return off>2
	end
	local sel=Duel.SelectOption(tp,table.unpack(ops))+1
	local op=opval[sel]
	table.remove(ops,sel)
	table.remove(opval,sel)
	sel=Duel.SelectOption(tp,table.unpack(ops))+1
	op=op+(opval[sel]<<4)
	e:SetLabel(op)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,0x01)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x02+0x10)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	local op1=op&0xf
	local op2=op>>4
	if op1==1 or op2==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,cm.tfilter1,tp,0x01,0,1,1,nil)
		if #g>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
	if op1==2 or op2==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.tfilter2,tp,0x02+0x10,0,1,1,nil,e,tp)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		end
	end
	if op1==3 or op2==3 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_BP_TWICE)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_SELF_TURN)
		Duel.RegisterEffect(e1,tp)
	end
end

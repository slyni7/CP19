--영원검 라플라스
local m=18452937
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetCategory(CATEGORY_EQUIP)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"S")
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(aux.TargetBoolFunction(Card.IsCustomType,CUSTOMTYPE_SQUARE))
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"E")
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(cm.val3)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
	local e5=MakeEff(c,"F","S")
	e5:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e5:SetDescription(aux.Stringid(m,0))
	e5:SetTR("HM",0)
	e5:SetTarget(aux.TargetBoolFunction(Card.IsCustomType,CUSTOMTYPE_SQUARE))
	e5:SetOperation(cm.op5)
	c:RegisterEffect(e5)
	local e6=MakeEff(c,"FC","S")
	e6:SetCode(EVENT_SUMMON_SUCCESS)
	WriteEff(e6,6,"NO")
	c:RegisterEffect(e6)
	local e7=MakeEff(c,"Qo","S")
	e7:SetCode(EVENT_CHAINING)
	e7:SetCategory(CATEGORY_DESTROY)
	WriteEff(e7,7,"NTO")
	c:RegisterEffect(e7)
	local e8=MakeEff(c,"I","G")
	e8:SetCategory(CATEGORY_TOHAND)
	e8:SetCountLimit(1,m)
	WriteEff(e8,8,"NTO")
	c:RegisterEffect(e8)
end
function cm.tfil1(c)
	return c:IsFaceup() and c:IsCustomType(CUSTOMTYPE_SQUARE)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLoc("M") and cm.tfil1(chkc)
	end
	if chk==0 then
		return Duel.IETarget(cm.tfil1,tp,"M","M",1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.STarget(tp,cm.tfil1,tp,"M","M",1,1,nil)
	Duel.SOI(0,CATEGORY_EQUIP,c,1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end
function cm.val3(e,c)
	return #c:GetSquareMana()*100
end
function cm.op5(e,tp,eg,ep,ev,re,r,rp,c)
	c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END,0,1)
end
function cm.con6(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return tc:GetFlagEffect(m)>0
end
function cm.op6(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=MakeEff(c,"E")
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(1)
	c:RegisterEffect(e1)
end
function cm.con7(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	local ec=c:GetEquipTarget()
	return rc==ec and rc:GetOriginalRace()&RACE_FAIRY>0
end
function cm.tar7(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return true
	end
	Duel.SOI(0,CATEGORY_DESTROY,c,1,0,0)
end
function cm.op7(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	local ec=c:GetEquipTarget()
	local t=ec:GetSquareMana()
	local color=0
	for i=1,#t do
		color=t[i]|color
	end
	local pct=0
	for i=0,31 do
		if color&(1<<i)>0 then
			pct=pct+1
		end
	end
	if pct<1 then
		return
	end
	local ph=0
	if not Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_SKIP_DP) then
		ph=ph|PHASE_DRAW
	end
	if not Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_SKIP_SP) then	
		ph=ph|PHASE_STANDBY
	end
	if not Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_SKIP_M1) then	
		ph=ph|PHASE_MAIN1
	end
	if not Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_SKIP_BP) then	
		ph=ph|PHASE_BATTLE
	end
	if not Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_SKIP_M2) then	
		ph=ph|PHASE_MAIN2
	end
	if not Duel.IsPlayerAffectedByEffect(1-tp,189) then	
		ph=ph|PHASE_END
	end
	if ph<1 then
		return
	end
	local sel=0
	while pct>0 do
		local off=1
		local ops={}
		local opval={}
		if ph&PHASE_DRAW>0 and sel&PHASE_DRAW<1 then
			ops[off]=aux.Stringid(m,2)
			opval[off-1]=1
			off=off+1
		end
		if ph&PHASE_STANDBY>0 and sel&PHASE_STANDBY<1 then
			ops[off]=aux.Stringid(m,3)
			opval[off-1]=2
			off=off+1
		end
		if ph&PHASE_MAIN1>0 and sel&PHASE_MAIN1<1 then
			ops[off]=aux.Stringid(m,4)
			opval[off-1]=3
			off=off+1
		end
		if ph&PHASE_BATTLE>0 and sel&PHASE_BATTLE<1 then
			ops[off]=aux.Stringid(m,5)
			opval[off-1]=4
			off=off+1
		end
		if ph&PHASE_MAIN2>0 and sel&PHASE_MAIN2<1 then
			ops[off]=aux.Stringid(m,6)
			opval[off-1]=5
			off=off+1
		end
		if ph&PHASE_END>0 and sel&PHASE_END<1 then
			ops[off]=aux.Stringid(m,7)
			opval[off-1]=6
			off=off+1
		end
		if off<2 then
			break
		end
		if sel>0 and Duel.SelectYesNo(tp,aux.Stringid(m,01)) then
			break
		end
		local op=Duel.SelectOption(tp,table.unpack(ops))
		if opval[op]==1 then
			local e1=MakeEff(c,"F")
			e1:SetCode(EFFECT_SKIP_DP)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			local ct=1
			if Duel.GetTurnPlayer()~=tp and Duel.GetCurrentPhase()>PHASE_DRAW then
				ct=2
			end
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,ct)
			e1:SetTR(0,1)
			Duel.RegisterEffect(e1,tp)
			sel=sel|PHASE_DRAW
		elseif opval[op]==2 then
			local e1=MakeEff(c,"F")
			e1:SetCode(EFFECT_SKIP_SP)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			local ct=1
			if Duel.GetTurnPlayer()~=tp and Duel.GetCurrentPhase()>PHASE_STANDBY then
				ct=2
			end
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,ct)
			e1:SetTR(0,1)
			Duel.RegisterEffect(e1,tp)
			sel=sel|PHASE_STANDBY
		elseif opval[op]==3 then
			local e1=MakeEff(c,"F")
			e1:SetCode(EFFECT_SKIP_M1)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			local ct=1
			if Duel.GetTurnPlayer()~=tp and Duel.GetCurrentPhase()>PHASE_MAIN1 then
				ct=2
			end
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,ct)
			e1:SetTR(0,1)
			Duel.RegisterEffect(e1,tp)
			sel=sel|PHASE_MAIN1
		elseif opval[op]==4 then
			local e1=MakeEff(c,"F")
			e1:SetCode(EFFECT_SKIP_BP)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			local ct=1
			if Duel.GetTurnPlayer()~=tp and Duel.GetCurrentPhase()>PHASE_BATTLE then
				ct=2
			end
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,ct)
			e1:SetTR(0,1)
			Duel.RegisterEffect(e1,tp)
			sel=sel|PHASE_BATTLE
		elseif opval[op]==5 then
			local e1=MakeEff(c,"F")
			e1:SetCode(EFFECT_SKIP_M2)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			local ct=1
			if Duel.GetTurnPlayer()~=tp and Duel.GetCurrentPhase()>PHASE_MAIN2 then
				ct=2
			end
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,ct)
			e1:SetTR(0,1)
			Duel.RegisterEffect(e1,tp)
			sel=sel|PHASE_MAIN2
		elseif opval[op]==6 then
			local e1=MakeEff(c,"F")
			e1:SetCode(189)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			local ct=1
			if Duel.GetTurnPlayer()~=tp and Duel.GetCurrentPhase()>PHASE_END then
				ct=2
			end
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,ct)
			e1:SetTR(0,1)
			Duel.RegisterEffect(e1,tp)
			sel=sel|PHASE_END
		end
		pct=pct-1
	end
	Duel.BreakEffect()
	Duel.Destroy(c,REASON_EFFECT)
end
function cm.nfil8(c)
	local t=c:GetSquareMana()
	return t and c:IsFaceup()
end
function cm.nval8(c)
	return #c:GetSquareMana()
end
function cm.con8(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GMGroup(cm.nfil8,tp,"M",0,nil)
	return g:GetSum(cm.nval8)>8
end
function cm.tar8(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToHand()
	end
	Duel.SOI(0,CATEGORY_TOHAND,c,1,0,0)
end
function cm.op8(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end
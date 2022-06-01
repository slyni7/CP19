--N·U·L·L
local m=18453130
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"FTf","M")
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	WriteEff(e1,1,"NO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"STf")
	e2:SetCode(EVENT_BATTLE_DESTROYED)
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	WriteEff(e2,2,"O")
	c:RegisterEffect(e2)
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsDefensePos()
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() or c:IsControler(1-tp) then
		return
	end
	local seq=c:GetSequence()
	if seq>4 then
		seq=seq*2-9
	end
	local nseq,tc
	for i=1,4 do
		nseq=seq-i
		if nseq>=0 and nseq<=4 then
			if nseq+1>=0 and nseq+1<=4 then
				tc=Duel.GetFieldCard(tp,LOCATION_MZONE,nseq)
				if tc and not tc:IsImmuneToEffect(e) then
					if Duel.CheckLocation(tp,LOCATION_MZONE,nseq+1) then
						Duel.MoveSequence(tc,nseq+1)
					else
						Duel.Destroy(tc,REASON_RULE)
					end
				end
				tc=Duel.GetFieldCard(tp,LOCATION_SZONE,nseq)
				if tc and not tc:IsImmuneToEffect(e) then
					if Duel.CheckLocation(tp,LOCATION_SZONE,nseq+1) then
						Duel.MoveSequence(tc,nseq+1)
					else
						Duel.Destroy(tc,REASON_RULE)
					end
				end
			end
			nseq=4-nseq
			if nseq-1>=0 and nseq-1<=4 then
				tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,nseq)
				if tc and not tc:IsImmuneToEffect(e) then
					if Duel.CheckLocation(1-tp,LOCATION_MZONE,nseq-1) then
						Duel.MoveSequence(tc,nseq-1)
					else
						Duel.Destroy(tc,REASON_RULE)
					end
				end
				tc=Duel.GetFieldCard(1-tp,LOCATION_SZONE,nseq)
				if tc and not tc:IsImmuneToEffect(e) then
					if Duel.CheckLocation(1-tp,LOCATION_SZONE,nseq-1) then
						Duel.MoveSequence(tc,nseq-1)
					else
						Duel.Destroy(tc,REASON_RULE)
					end
				end
			end
		end
		nseq=seq+i
		if nseq>=0 and nseq<=4 then
			if nseq-1>=0 and nseq-1<=4 then
				tc=Duel.GetFieldCard(tp,LOCATION_MZONE,nseq)
				if tc and not tc:IsImmuneToEffect(e) then
					if Duel.CheckLocation(tp,LOCATION_MZONE,nseq-1) then
						Duel.MoveSequence(tc,nseq-1)
					else
						Duel.Destroy(tc,REASON_RULE)
					end
				end
				tc=Duel.GetFieldCard(tp,LOCATION_SZONE,nseq)
				if tc and not tc:IsImmuneToEffect(e) then
					if Duel.CheckLocation(tp,LOCATION_SZONE,nseq-1) then
						Duel.MoveSequence(tc,nseq-1)
					else
						Duel.Destroy(tc,REASON_RULE)
					end
				end
			end
			nseq=4-nseq
			if nseq+1>=0 and nseq+1<=4 then
				tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,nseq)
				if tc and not tc:IsImmuneToEffect(e) then
					if Duel.CheckLocation(1-tp,LOCATION_MZONE,nseq+1) then
						Duel.MoveSequence(tc,nseq+1)
					else
						Duel.Destroy(tc,REASON_RULE)
					end
				end
				tc=Duel.GetFieldCard(1-tp,LOCATION_SZONE,nseq)
				if tc and not tc:IsImmuneToEffect(e) then
					if Duel.CheckLocation(1-tp,LOCATION_SZONE,nseq+1) then
						Duel.MoveSequence(tc,nseq+1)
					else
						Duel.Destroy(tc,REASON_RULE)
					end
				end
			end
		end
	end
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if c==tc then
		tc=Duel.GetAttackTarget()
	end
	if not tc:IsRelateToBattle() then
		return
	end
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(-500)
	tc:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	tc:RegisterEffect(e2)
end
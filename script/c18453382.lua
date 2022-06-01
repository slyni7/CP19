--치킨 오븐
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"FC","S")
	e2:SetCode(EVENT_ADJUST)
	WriteEff(e2,2,"O")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"F","S")
	e3:SetCode(EFFECT_CANNOT_ATTACK)
	e3:SetTR("M","M")
	e3:SetTarget(aux.PersistentTargetFilter)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_TRIGGER)
	c:RegisterEffect(e4)
	local e5=MakeEff(c,"FC","S")
	e5:SetCode(EVENT_ADJUST)
	e5:SetLabelObject(e2)
	WriteEff(e5,5,"O")
	c:RegisterEffect(e5)
end
function s.ofil2(c,e)
	return c:IsFaceup() and c:IsCanBeEffectTarget(e)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GMGroup(s.ofil2,tp,0,"M",nil,e)
	if c:GetFirstCardTarget()==nil and c:GetFlagEffect(id)==0 and #g>0 then
		local tg=g:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		c:SetCardTarget(tc)
		c:CreateRelation(tc,RESET_EVENT+RESETS_STANDARD)
		e:SetLabelObject(tc)
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
function s.op5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local te=e:GetLabelObject()
	local tc=te:GetLabelObject()
	if c:GetFirstCardTarget()==nil and tc then
		local atk=tc:GetTextAttack()
		if atk>0 then
			Duel.Damage(1-tp,atk,REASON_EFFECT)
		end
		te:SetLabelObject(nil)
	end
end
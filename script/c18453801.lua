--신천지
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"F","F")
	e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e2:SetTR("MG","MG")
	e2:SetValue(ATTRIBUTE_LIGHT)
	--
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"F","F")
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetTR("M","M")
	e3:SetTarget(s.tar3)
	e3:SetValue(s.val3)
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"F","F")
	e4:SetCode(EFFECT_SELF_DESTROY)
	e4:SetTR("M","M")
	e4:SetTarget(s.tar4)
	c:RegisterEffect(e4)
	local e5=MakeEff(c,"FC","F")
	e5:SetCode(EVENT_ADJUST)
	local g=Group.CreateGroup()
	g:KeepAlive()
	e5:SetLabelObject(g)
	e4:SetLabelObject(e5)
	WriteEff(e5,5,"O")
	c:RegisterEffect(e5)
	if not s.global_check then
		s.global_check=true
		local ge1=MakeEff(c,"FC")
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(s.gop1)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.gop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=eg:GetFirst()
	while tc do
		local tatk=tc:GetTextAttack()
		local trc=tc:GetReasonCard()
		local tre=tc:GetReasonEffect()
		if not trc and tre:GetCode()==EFFECT_SPSUMMON_PROC then
			trc=tre:GetHandler()
		end
		if (tc:GetPreviousAttributeOnField()&ATTRIBUTE_LIGHT>0
			or (tc:GetPreviousLocation()&LOCATION_ONFIELD==0 and tc:GetOriginalAttribute()&ATTRIBUTE_LIGHT>0))
			and trc and tatk>0 then
			local e1=MakeEff(c,"S")
			e1:SetCode(id)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
			e1:SetValue(tatk)
			trc:RegisterEffect(e1)
		end
		tc=eg:GetNext()
	end
end
function s.tar3(e,c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function s.val3(e,c)
	local val=0
	local eset={c:IsHasEffect(id)}
	for _,te in pairs(eset) do
		local tval=te:GetValue()
		val=val-tval
	end
	local atk=c:GetAttack()
	if atk>0 and atk+val<=0 then
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,0)
	end
	return val
end
function s.tar4(e,c)
	if c:GetFlagEffect(id)>0 then
		local e1=MakeEff(e:GetHandler(),"S")
		e1:SetCode(EFFECT_ALICE_SCARLET)
		e1:SetValue(id)
		c:RegisterEffect(e1)
		local g=e:GetLabelObject():GetLabelObject()
		g:AddCard(c)
		return true
	end
	return false
end
function s.op5(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tc=g:GetFirst()
	local sg=Group.CreateGroup()
	while tc do
		sg:AddCard(tc)
		local eset={tc:IsHasEffect(EFFECT_ALICE_SCARLET)}
		for _,te in pairs(eset) do
			local tval=te:GetValue()
			if tval==id then
				te:Reset()
			end
		end
		tc:ResetFlagEffect(id)
		tc=g:GetNext()
	end
	g:Sub(sg)
end
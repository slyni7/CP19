--슬로우 스타터
local m=18452728
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddSquareProcedure(c)
	local e1=MakeEff(c,"FC","M")
	e1:SetCode(EVENT_CHAINING)
	WriteEff(e1,1,"O")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"SC","M")
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetTarget(cm.tar2)
	c:RegisterEffect(e2)
end
cm.square_mana={ATTRIBUTE_DIVINE,ATTRIBUTE_LIGHT,ATTRIBUTE_WIND,ATTRIBUTE_WATER}
cm.custom_type=CUSTOMTYPE_SQUARE
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	local e1=MakeEff(c,"F")
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetReset(RESET_PHASE+PHASE_END,3)
	e1:SetTR(1,0)
	e1:SetLabel(rc:GetCode())
	e1:SetValue(cm.oval11)
	Duel.RegisterEffect(e1,ep)
	local e2=MakeEff(c,"S")
	e2:SetCode(m)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,3)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
end
function cm.oval11(e,re,tp)
	local rc=re:GetHandler()
	return rc:IsCode(e:GetLabel())
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local eset={c:IsHasEffect(m)}
	local codes={}
	for _,te in ipairs(eset) do
		local le=te:GetLabelObject()
		local lp=le:GetHandlerPlayer()
		if lp~=tp then
			table.insert(codes,le:GetLabel())
		end
	end
	if chk==0 then
		return (c:IsReason(REASON_BATTLE) or (c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp))
			and not c:IsReason(REASON_REPLACE) and #codes>0
	end
	if Duel.SelectEffectYesNo(tp,c,96) then
		Duel.Hint(HINT_CARD,1-tp,m)
		local g=Group.CreateGroup()
		for _,code in ipairs(codes) do
			local token=Duel.CreateToken(tp,code)
			g:AddCard(token)
		end
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,0))
		local sg=g:Select(tp,1,1,nil)
		local tc=sg:GetFirst()
		local ac=tc:GetCode()
		Duel.Hint(HINT_CARD,1-tp,ac)
		for _,te in ipairs(eset) do
			local le=te:GetLabelObject()
			local lp=le:GetHandlerPlayer()
			if lp~=tp and ac==le:GetLabel() then
				te:Reset()
				le:Reset()
				break
			end
		end
		return true
	end
	return false
end
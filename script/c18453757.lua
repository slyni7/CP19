--디펜시브 딜레이
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddDelightProcedure(c,s.pfil1,1,1)
	c:SetSPSummonOnce(id)
	c:SetUniqueOnField(1,0,id)
	local e1=MakeEff(c,"FC","M")
	e1:SetCode(EFFECT_SEND_REPLACE)
	e1:SetTarget(s.tar1)
	e1:SetValue(s.val1)
	e1:SetOperation(s.op1)
	c:RegisterEffect(e1)
end
s.custom_type=CUSTOMTYPE_DELIGHT
function s.pfil1(c)
	return c:IsLoc("M") and c:IsSummonLocation(LSTN("E")) and c:IsDefensePos()
end
function s.tfil1(c,tp)
	return c:IsControler(tp) and c:IsDefensePos() and c:GetFlagEffect(id)==0 and c:GetReasonPlayer()==1-tp
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return eg:IsExists(s.tfil1,1,nil,tp)
	end
	local g=eg:Filter(s.tfil1,nil,tp)
	e:SetLabelObject(g)
	g:KeepAlive()
	return true
end
function s.val1(e,c)
	return s.tfil1(c,c:GetControler())
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,0,id)
	local g=e:GetLabelObject()
	Duel.HintSelection(g)
	local ct=1
	if Duel.GetCurrentPhase()<=PHASE_STANDBY then
		ct=2
	end
	local tc=g:GetFirst()
	while tc do
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,0)
		aux.DelayTillPhase(tc,tp,PHASE_STANDBY,ct)
		tc=g:GetNext()
	end
end
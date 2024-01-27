--이상물질(아이딜 매터) 「청아」
local s,id=GetID()
function s.initial_effect(c)
	if not s.global_check then
		s.global_check=true
		aux.RegisterIdealMatter(c,id)
	end
	local e1=MakeEff(c,"S","H")
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetD(id,0)
	e1:SetCondition(s.con1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"FC","M")
	e2:SetCode(EVENT_CHAIN_ACTIVATING)
	WriteEff(e2,2,"O")
	c:RegisterEffect(e2)
end
function s.con1(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetFieldGroupCount(tp,LSTN("M"),0)==0
		and Duel.GetLocCount(tp,"M")>0
end
function s.ofil2(c,ec)
	return not ec:GetCardTarget():IsContains(c)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if rp~=tp and re:GetActivateLocation()&LSTN("HEOGR")>0 then
		local tg=Duel.GMGroup(s.ofil2,tp,0,"O",nil,c)
		if #tg>0 and Duel.SelectEffectYesNo(1-tp,c,aux.Stringid(id,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
			local g=tg:Select(1-tp,1,1,nil)
			c:SetCardTarget(g:GetFirst())
			local e1=MakeEff(c,"FC","M")
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCL(1)
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD)
			e1:SetLabelObject(g:GetFirst())
			e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
				local c=e:GetHandler()
				local tc=e:GetLabelObject()
				c:CancelCardTarget(tc)
			end)
			c:RegisterEffect(e1)
		else
			local rc=re:GetHandler()
			if rc then
				Duel.Hint(HINT_CARD,0,id)
				local code=rc:GetOriginalCodeRule()
				local e1=MakeEff(c,"F")
				e1:SetCode(EFFECT_DISABLE)
				e1:SetTR(0,"O")
				e1:SetLabel(code)
				e1:SetTarget(s.otar21)
				e1:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e1,tp)
				local e2=MakeEff(c,"FC")
				e2:SetCode(EVENT_CHAIN_SOLVING)
				e2:SetLabel(code)
				e2:SetCondition(s.ocon22)
				e2:SetOperation(s.oop22)
				e2:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e2,tp)
				local e3=e1:Clone()
				e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
				e3:SetTR(0,"M")
				Duel.RegisterEffect(e3,tp)
			end		
		end
	end
end
function s.otar21(e,c)
	return c:IsOriginalCodeRule(e:GetLabel())
end
function s.ocon22(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rc:IsOriginalCodeRule(e:GetLabel()) and rp~=tp
end
function s.oop22(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
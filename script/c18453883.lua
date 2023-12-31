--신천지에 부는 바람
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_CHAINING)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetCL(1,id)
	WriteEff(e1,1,"NCTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"FTo","G")
	e2:SetCode(EVENT_DESTROY)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCL(1,{id,1})
	WriteEff(e2,2,"NTO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"S")
	e3:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetCondition(function(e)
		local tp=e:GetHandlerPlayer()
		return Duel.CheckLPCost(tp,1500)
	end)
	e3:SetD(id,0)
	e3:SetValue(function(e,c)
		e:SetLabel(1)
	end)
	c:RegisterEffect(e3)
	e1:SetLabelObject(e3)
end
function s.nfil1(c)
	return c:IsSetCard("신천지") and c:IsFaceup()
end
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IEMCard(s.nfil1,tp,"O",0,1,nil) and rp~=tp and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE))
		and Duel.IsChainNegatable(ev)
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		e:GetLabelObject():SetLabel(0)
		return true
	end
	if e:GetLabelObject():GetLabel()>0 then
		e:GetLabelObject():SetLabel(0)
		Duel.PayLPCost(tp,1500)
	end
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SOI(0,CATEGORY_NEGATE,eg,1,0,0)
	local rc=re:GetHandler()
	if rc:IsRelateToEffect(re) then
		Duel.SOI(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function s.ofil11(c)
	return c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function s.ofil12(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if Duel.NegateActivation(ev) then
		if rc:IsRelateToEffect(re) then
			Duel.Destroy(rc,REASON_EFFECT)
		end
		local g=Duel.GMGroup(s.ofil11,tp,0,"M",nil)
		if #g>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			local tc=Duel.SMCard(tp,s.ofil12,tp,"M",0,0,1,nil)
			if tc then
				local sc=g:GetFirst()
				while sc do
					local e1=MakeEff(c,"S","M")
					e1:SetCode(CARD_NEW_HEAVEN_AND_EARTH)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					e1:SetValue(math.max(tc:GetAttack(),0))
					sc:RegisterEffect(e1)
					sc=g:GetNext()
				end
			end
		end
	end
end
function s.nfil2(c)
	return c:IsHasEffect(CARD_NEW_HEAVEN_AND_EARTH)
end
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.nfil2,1,nil)
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsSSetable()
	end
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SSet(tp,c)
	end
	local e1=MakeEff(c,"F")
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTR("M",0)
	e1:SetTarget(function(e,c)
		return c:IsAttribute(ATTRIBUTE_LIGHT)
	end)
	e1:SetValue(200)
	Duel.RegisterEffect(e1,tp)
end
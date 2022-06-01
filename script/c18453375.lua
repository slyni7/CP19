--카이저 페넥스 치킨
local s,id=GetID()
function s.initial_effect(c)
	--link summon
	Link.AddProcedure(c,s.pfil1,4,4,s.pfun1)
	c:EnableReviveLimit()
	local e1=MakeEff(c,"S","E")
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(aux.lnklimit)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"S")
	e2:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCondition(s.con2)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"S","M")
	e3:SetCode(EFFECT_SET_BASE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCondition(s.con2)
	e3:SetValue(4000)
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"S","M")
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)
	local e5=MakeEff(c,"Qo","M")
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetCategory(CATEGORY_TOGRAVE+CATEGORY_RECOVER)
	e5:SetCL(4)
	e5:SetD(id,0)
	WriteEff(e5,5,"CTO")
	c:RegisterEffect(e5)
	local e6=MakeEff(c,"Qo","M")
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e6:SetCategory(CATEGORY_ATKCHANGE)
	e6:SetD(id,1)
	WriteEff(e6,6,"CTO")
	c:RegisterEffect(e6)
	local e7=MakeEff(c,"S","M")
	e7:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e7:SetCondition(s.con7)
	e7:SetValue(1)
	c:RegisterEffect(e7)
	local e8=MakeEff(c,"FC","M")
	e8:SetCode(EVENT_PHASE+PHASE_END)
	e8:SetCL(1)
	WriteEff(e8,8,"O")
	c:RegisterEffect(e8)
end
function s.pfil1(c)
	return c:IsLink(4)
end
function s.pfun1(g,lc,sumtype,tp)
	return g:CheckDifferentProperty(Card.GetCode,lc,sumtype,tp)
end
function s.con2(e)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_LINK)
end
function s.cost5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.CheckLPCost(tp,1000)
	end
	Duel.PayLPCost(tp,1000)
end
function s.tar5(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GMGroup(Card.IsAbleToGrave,tp,"M","M",nil)
	if chk==0 then
		return #g>0
	end
	Duel.SOI(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function s.op5(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SMCard(tp,Card.IsAbleToGrave,tp,"M","M",1,1,nil)
	local tc=g:GetFirst()
	if tc then
		local atk=tc:GetAttack()
		if Duel.SendtoGrave(tc,REASON_EFFECT)>0 and atk>0 then
			Duel.Recover(tp,atk,REASON_EFFECT)
		end
	end
end
function s.cost6(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function s.tar6(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=1 then
			return false
		end
		e:SetLabel(0)
		return Duel.CheckLPCost(tp,100)
	end
	local maxpay=Duel.GetLP(tp)
	maxc=math.floor(maxpay/100)*100
	local t={}
	for i=1,maxc/100 do
		t[i]=i*100
	end
	local cost=Duel.AnnounceNumber(tp,table.unpack(t))
	Duel.PayLPCost(tp,cost)
	Duel.SetTargetParam(cost)
end
function s.op6(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local val=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	if not c:IsRelateToEffect(e) or c:IsFacedown() then
		return
	end
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(val)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end
function s.con7(e)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_SPECIAL) and not c:IsSummonType(SUMMON_TYPE_LINK)
end
function s.op8(e)
	local c=e:GetHandler()
	if c:IsSummonType(SUMMON_TYPE_SPECIAL) and not c:IsSummonType(SUMMON_TYPE_LINK) then
		Duel.SendtoGrave(c,REASON_EFFECT)
	end
end
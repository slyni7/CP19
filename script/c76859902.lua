--클래식 메모리얼 - 쿠루미
local m=76859902
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"FQf","M")
	e1:SetCode(EVENT_CHAINING)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetCountLimit(1,m)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"I","HG")
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	WriteEff(e2,2,"NCTO")
	c:RegisterEffect(e2)
	if not cm.global_check then
		cm.global_check=true
		cm[0]=0
		local ge1=MakeEff(c,"FC")
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(cm.gop1)
		Duel.RegisterEffect(ge1,0)
		local ge2=MakeEff(c,"FC")
		ge2:SetCode(EVENT_CHAIN_END)
		ge2:SetOperation(cm.gop2)
		Duel.RegisterEffect(ge2,0)
	end
end
function cm.gop1(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	cm[0]=Duel.GetCurrentChain()
	cm[Duel.GetCurrentChain()]=rc
end
function cm.gop2(e,tp,eg,ep,ev,re,r,rp)
	local v=cm[0]
	for i=1,v do
		cm[i]=nil
	end
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SOI(0,CATEGORY_RECOVER,nil,0,tp,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local v=cm[0]
	local s=0
	for i=1,v do
		local tc=cm[i]
		if tc:IsType(TYPE_MONSTER) then
			if tc:GetLevel()>0 then
				s=s+tc:GetLevel()
			end
			if tc:GetRank()>0 then
				s=s+tc:GetRank()
			end
		end
	end
	Duel.Recover(tp,s*100,REASON_EFFECT)
	local e1=MakeEff(c,"F")
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetTR(1,0)
	Duel.RegisterEffect(e1,tp)
	local e2=MakeEff(c,"FC")
	e2:SetCode(EVENT_RECOVER)
	e2:SetLabelObject(e1)
	e2:SetOperation(cm.oop12)
	Duel.RegisterEffect(e2,tp)
end
function cm.oop12(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp then
		return
	end
	Duel.Hint(HINT_CARD,0,m)
	if Duel.Damage(1-tp,ev,REASON_EFFECT)>0 then
		Duel.Recover(tp,ev,REASON_EFFECT)
	end
	local te=e:GetLabelObject()
	te:Reset()
	e:Reset()
end
function cm.nfil2(c)
	return c:IsSetCard(0x2c0) and c:IsFaceup()
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LSTN("M"),0)==0 or Duel.IEMCard(cm.nfil2,tp,"M",0,1,nil)
end
function cm.cfil2(c)
	return c:IsSetCard(0x2c0) and c:IsType(TYPE_MONSTER) and c:IsReleasable()
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.GetFlagEffect(tp,m)==0 and Duel.IEMCard(cm.cfil2,tp,"D",0,1,nil)
	local b2=Duel.CheckLPCost(tp,3100)
	if chk==0 then
		return b1 or b2
	end
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(m,1)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(m,2)
		opval[off-1]=2
		off=off+1
	end
	if off==1 then
		return
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g=Duel.SMCard(tp,cm.cfil2,tp,"D",0,1,1,nil)
		Duel.SendtoGrave(g,REASON_COST+REASON_RELEASE)
	elseif opval[op]==2 then
		Duel.PayLPCost(tp,3100)
	end
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocCount(tp,"M")>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP)
		local e1=MakeEff(c,"S")
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		e1:SetValue(-1000)
		c:RegisterEffect(e1)
		Duel.SpecialSummonComplete()
	end
end
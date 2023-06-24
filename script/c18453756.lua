--크레이지 아케이드
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"F","H")
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(s.con1)
	e1:SetValue(SUMMON_TYPE_SPECIAL+1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"FC","H")
	e2:SetCode(EVENT_ANYTIME)
	WriteEff(e2,2,"NO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"STo")
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	WriteEff(e3,3,"O")
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"I","M")
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCategory(CATEGORY_DESTROY)
	WriteEff(e4,4,"CTO")
	c:RegisterEffect(e4)
end
function s.con1(e,c)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	return Duel.GetLocCount(tp,"M")>0 and Duel.GetFieldGroupCount(tp,LSTN("M"),0)==0
end
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSpecialSummonable(SUMMON_TYPE_SPECIAL+1) and c:GetControler()==tp
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.SpecialSummonRuleRightNow(tp,c,SUMMON_TYPE_SPECIAL+1)
	if Duel.GetCurrentChain()>0 then
		Duel.ProcessQuickEffect(1-tp)
	end
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ph=Duel.GetCurrentPhase()
	if ph>PHASE_MAIN1 and ph<PHASE_MAIN2 then
		ph=PHASE_BATTLE
	end
	local e1=MakeEff(c,"F")
	e1:SetCode(id)
	e1:SetLabel(0)
	e1:SetReset(RESET_PHASE+ph)
	Duel.RegisterEffect(e1,tp)
	for i=0x0,0xff do
		local e2=MakeEff(c,"FC")
		e2:SetCode(EVENT_ANYTIME)
		e2:SetReset(RESET_PHASE+ph)
		e2:SetLabel(i)
		e2:SetLabelObject(e1)
		e2:SetCondition(s.ocon32)
		e2:SetOperation(s.oop32)
		Duel.RegisterEffect(e2,tp)
	end
end
function s.ocon32(e,tp,eg,ep,ev,re,r,rp)
	if Duel.CheckEvent(EVENT_SUMMON,false) or Duel.CheckEvent(EVENT_SPSUMMON,false) or Duel.CheckEvent(EVENT_FLIP_SUMMON,false) then
		return false
	end
	local te=e:GetLabelObject()
	return te:GetLabel()&0xff==e:GetLabel() and Duel.GetIdleCmdPlayer()==PLAYER_NONE
end
function s.oop32(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local te=e:GetLabelObject()
	te:SetLabel(te:GetLabel()+1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetReset(RESET_CHAIN)
	e1:SetOperation(s.ooop321)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	Duel.RegisterEffect(e2,tp)
	local e3=e1:Clone()
	e3:SetCode(EVENT_MSET)
	Duel.RegisterEffect(e3,tp)
	local e4=e1:Clone()
	e4:SetCode(EVENT_SSET)
	Duel.RegisterEffect(e4,tp)
	e1:SetLabelObject({e2,e3,e4})
	e2:SetLabelObject({e1,e3,e4})
	e3:SetLabelObject({e1,e2,e4})
	e4:SetLabelObject({e1,e2,e3})
	Duel.ProcessIdleCommand(tp)
	e1:Reset()
	e2:Reset()
	e3:Reset()
	e4:Reset()
end
function s.ooop321(e,tp,eg,ep,ev,re,r,rp)
	if (re==nil or not re:IsHasType(EFFECT_TYPE_ACTIONS)) and Duel.GetCurrentChain()>0 then
		local te=e:GetLabelObject()
		for i=1,#te do
			te[i]:Reset()
		end
		local tc=eg:GetFirst()
		while tc do
			local ge1=Effect.CreateEffect(tc)
			ge1:SetType(EFFECT_TYPE_FIELD)
			ge1:SetCode(EFFECT_SPSUMMON_PROC_G)
			ge1:SetRange(LOCATION_MZONE)
			ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			ge1:SetValue(SUMMON_TYPE_LINK)
			ge1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
			ge1:SetDescription(aux.Stringid(18453098,0))
			ge1:SetCondition(Auxiliary.SilentMajorityLinkCondition1)
			ge1:SetOperation(Auxiliary.SilentMajorityLinkOperation1)
			tc:RegisterEffect(ge1)
			local ge1=Effect.CreateEffect(tc)
			ge1:SetType(EFFECT_TYPE_FIELD)
			ge1:SetCode(EFFECT_SPSUMMON_PROC_G)
			ge1:SetRange(LOCATION_MZONE)
			ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			ge1:SetValue(SUMMON_TYPE_LINK)
			ge1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
			ge1:SetDescription(aux.Stringid(18453751,0))
			ge1:SetCondition(Auxiliary.SilentMajorityLinkCondition2)
			ge1:SetOperation(Auxiliary.SilentMajorityLinkOperation2)
			tc:RegisterEffect(ge1)
			tc=eg:GetNext()
		end
		Duel.ProcessQuickEffect(1-tp)
	end
end

function s.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function s.spcheck(sg,tp,exg,dg,ec)
	local a=0
	for c in aux.Next(sg) do
		if dg:IsContains(c) then a=a+1 end
		for tc in aux.Next(c:GetEquipGroup()) do
			if dg:IsContains(tc) then a=a+1 end
		end
	end
	return #dg-a>=#sg and sg:IsContains(ec)
end
function s.cfilter(c)
	return c:IsAttribute(ATTRIBUTE_FIRE)
end
function s.tar4(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc~=e:GetHandler() end
	local dg=Duel.GetMatchingGroup(Card.IsCanBeEffectTarget,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler(),e)
	if chk==0 then
		if e:GetLabel()==1 then
			return Duel.CheckReleaseGroupCost(tp,s.cfilter,1,false,s.spcheck,nil,dg,e:GetHandler())
		else
			return false
		end
	end
	e:SetLabel(0)
	local sg=Duel.SelectReleaseGroupCost(tp,s.cfilter,1,#dg,false,s.spcheck,nil,dg,e:GetHandler())
	Duel.Release(sg,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,#sg,#sg,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function s.oop41(tp,c)
	local dis=1<<c:GetSequence()
	if c:IsLocation(LOCATION_SZONE) then
		dis=dis<<8
	end
	if c:IsControler(1-tp) then
		dis=dis<<16
	end
	if dis<2^8 then
		local seq=math.log(dis,2)
		local g=Group.CreateGroup()
		local tc=Duel.GetFieldCard(tp,LOCATION_SZONE,seq)
		if tc then
			g:AddCard(tc)
		end
		if seq>0 then
			tc=Duel.GetFieldCard(tp,LOCATION_MZONE,seq-1)
			if tc then
				g:AddCard(tc)
			end
		end
		if seq<4 then
			tc=Duel.GetFieldCard(tp,LOCATION_MZONE,seq+1)
			if tc then
				g:AddCard(tc)
			end
		end
		if seq==1 then
			tc=Duel.GetFieldCard(tp,LOCATION_MZONE,5)
			if tc then
				g:AddCard(tc)
			end
			tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,6)
			if tc then
				g:AddCard(tc)
			end
		end
		if seq==3 then
			tc=Duel.GetFieldCard(tp,LOCATION_MZONE,6)
			if tc then
				g:AddCard(tc)
			end
			tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,5)
			if tc then
				g:AddCard(tc)
			end
		end
		if seq==5 then
			tc=Duel.GetFieldCard(tp,LOCATION_MZONE,1)
			if tc then
				g:AddCard(tc)
			end
			tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,3)
			if tc then
				g:AddCard(tc)
			end
		end
		if seq==6 then
			tc=Duel.GetFieldCard(tp,LOCATION_MZONE,3)
			if tc then
				g:AddCard(tc)
			end
			tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,1)
			if tc then
				g:AddCard(tc)
			end
		end
		return g
	else
		if dis<2^16 then
			local seq=math.log(dis,2)-8
			local g=Group.CreateGroup()
			local tc=Duel.GetFieldCard(tp,LOCATION_MZONE,seq)
			if tc then
				g:AddCard(tc)
			end
			if seq>0 then
				tc=Duel.GetFieldCard(tp,LOCATION_SZONE,seq-1)
				if tc then
					g:AddCard(tc)
				end
			end
			if seq<4 then
				tc=Duel.GetFieldCard(tp,LOCATION_SZONE,seq+1)
				if tc then
					g:AddCard(tc)
				end
			end
			return g
		else
			if dis<2^24 then
				local seq=math.log(dis,2)-16
				local g=Group.CreateGroup()
				local tc=Duel.GetFieldCard(1-tp,LOCATION_SZONE,seq)
				if tc then
					g:AddCard(tc)
				end
				if seq>0 then
					tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,seq-1)
					if tc then
						g:AddCard(tc)
					end
				end
				if seq<4 then
					tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,seq+1)
					if tc then
						g:AddCard(tc)
					end
				end
				if seq==1 then
					tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,5)
					if tc then
						g:AddCard(tc)
					end
					tc=Duel.GetFieldCard(tp,LOCATION_MZONE,6)
					if tc then
						g:AddCard(tc)
					end
				end
				if seq==3 then
					tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,6)
					if tc then
						g:AddCard(tc)
					end
					tc=Duel.GetFieldCard(tp,LOCATION_MZONE,5)
					if tc then
						g:AddCard(tc)
					end
				end
				if seq==5 then
					tc=Duel.GetFieldCard(tp,LOCATION_MZONE,3)
					if tc then
						g:AddCard(tc)
					end
					tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,1)
					if tc then
						g:AddCard(tc)
					end
				end
				if seq==6 then
					tc=Duel.GetFieldCard(tp,LOCATION_MZONE,1)
					if tc then
						g:AddCard(tc)
					end
					tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,3)
					if tc then
						g:AddCard(tc)
					end
				end
				return g
			else
				local seq=math.log(dis,2)-24
				local g=Group.CreateGroup()
				local tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,seq)
				if tc then
					g:AddCard(tc)
				end
				if seq>0 then
					tc=Duel.GetFieldCard(1-tp,LOCATION_SZONE,seq-1)
					if tc then
						g:AddCard(tc)
					end
				end
				if seq<4 then
					tc=Duel.GetFieldCard(1-tp,LOCATION_SZONE,seq+1)
					if tc then
						g:AddCard(tc)
					end
				end
				return g
			end
		end
	end
end
function s.op4(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=dg:Filter(Card.IsRelateToEffect,nil,e)
	while #sg>0 do
		local tg=Group.CreateGroup()
		for tc in aux.Next(sg) do
			local ag=s.oop41(tp,tc)
			tg:Merge(ag)
		end
		Duel.Destroy(sg,REASON_EFFECT)
		sg=tg:Clone()
	end
end
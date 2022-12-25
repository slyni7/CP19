--마방의 마법방어
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_CHAINING)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)
end
function s.nfil1(c)
	return c:IsFaceup() and c:IsSetCard("마방")
end
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IEMCard(s.nfil1,tp,"O",0,1,nil) and rp~=tp and Duel.IsChainNegatable(ev)
		and ((c:GetLevel()==0 and re:IsActiveType(TYPE_MONSTER)) or re:IsHasType(EFFECT_TYPE_ACTIVATE))
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SOI(0,CATEGORY_NEGATE,eg,1,0,0)
	local rc=re:GetHandler()
	if rc:IsRelateToEffect(re) and rc:IsDestructable() then
		Duel.SOI(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function s.ofun11(tp)
	local st={}
	local sg=Duel.GMGroup(s.ofil1,tp,"M",0,nil)
	local sc=sg:GetFirst()
	local ct=0
	while sc do
		local cst=sc:GetSquareMana()
		ct=ct+#cst
		sc=sg:GetNext()
	end
	return ct>=10
end
function s.ofil11(c)
	return c:IsSetCard("마방") and c:IsFaceup()
end
function s.ofil12(c)
	local st=c:GetSquareMana()
	return #st>0
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.NegateActivation(ev) then
		local rc=re:GetHandler()
		if rc:IsRelateToEffect(e) and Duel.Destroy(eg,REASON_EFFECT)>0 then
			if c:IsRelateToEffect(e) and s.ofun11(tp) and c:IsFaceup() and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
				local g=Duel.GMGroup(s.ofil11,tp,"M",0,nil)
				local ct=0
				while ct<10 do
					local sg=g:FilterSelect(tp,s.ofil12,1,1,nil)
					local tc=sg:GetFirst()
					local tst=tc:GetSquareMana()
					local tmg=Group.CreateGroup()
					for i=1,#tst do
						local token=Duel.CreateToken(tp,127800000+tst[i])
						tmg:AddCard(token)
					end
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
					local max=math.min(ct-10,#tmg)
					local trg=tmg:Select(tp,1,max,nil)
					local trt={}
					local trc=trg:GetFirst()
					while trc do
						local tatt=trc:GetCode()-127800000
						table.insert(trt,tatt)
						trc=trg:GetNext()
					end
					local e1=MakeEff(c,"S")
					e1:SetCode(EFFECT_SQUARE_MANA_DECLINE)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					e1:SetValue(function(_,_)
						return table.unpack(trt)
					end)
					tc:RegisterEffect(e1)
					ct=ct+#trt
				end
				c:CancelToGrave()
				Duel.ChangePosition(c,POS_FACEDOWN)
			end
		end
	end
end
--욕망의 탑
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetCL(1,id+EFFECT_COUNT_CODE_OATH)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"I","G")
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetCondition(aux.exccon)
	WriteEff(e2,2,"CTO")
	c:RegisterEffect(e2)
	aux.GlobalCheck(s,function()
		local ge1=MakeEff(c,"FC")
		ge1:SetCode(EVENT_SSET)
		ge1:SetOperation(s.gop1)
		Duel.RegisterEffect(ge1,0)
		local ge2=MakeEff(c,"FC")
		ge2:SetCode(EVENT_CHAIN_SOLVING)
		ge2:SetOperation(s.gop2)
		Duel.RegisterEffect(ge2,0)
	end)
end
function s.gop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(rp,id,RESET_PHASE+PHASE_END,0,1)
end
function s.gop2(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if rc:IsCode(id) and re:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.RegisterFlagEffect(rp,id+1,0,0,0)
	end
end
function s.con1(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.GetFlagEffect(tp,id)==0
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsPlayerCanDraw(tp,2)
	end
	Duel.SOI(0,CATEGORY_DRAW,nil,0,tp,2)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFlagEffect(tp,id+2)==0 then
		Duel.RegisterFlagEffect(tp,id+2,0,0,0)
		local e1=MakeEff(c,"F")
		e1:SetCode(EFFECT_DRAW_COUNT)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTR(1,0)
		e1:SetValue(s.oval11)
		Duel.RegisterEffect(e1,tp)
		local e2=MakeEff(c,"F")
		e2:SetCode(EFFECT_HAND_LIMIT)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTR(1,0)
		e2:SetValue(s.oval12)
		Duel.RegisterEffect(e2,tp)
		local e6=MakeEff(c,"FC")
		e6:SetCode(EVENT_DRAW)
		e6:SetOperation(s.oop16)
		Duel.RegisterEffect(e6,tp)
	end
	Duel.Draw(tp,2,REASON_EFFECT)
end
function s.oval11(e)
	local tp=e:GetHandlerPlayer()
	return 1+Duel.GetFlagEffect(tp,id+1)
end
function s.oval12(e)
	local tp=e:GetHandlerPlayer()
	return 6+Duel.GetFlagEffect(tp,id+1)*6
end
function s.oofil161(c)
	return c:IsHasEffect(id)
end
function s.oofil162(c)
	return not c:IsPublic()
end
function s.oop16(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if rp==tp and (r&REASON_RULE>0 or re:GetHandler():IsCode(id)) then
		local hct=Duel.GetFieldGroupCount(tp,LSTN("H"),0)
		local fct=math.floor((hct*Duel.GetFlagEffect(tp,id+1))/(1+Duel.GetFlagEffect(tp,id+1)))
		local gct=#Duel.GMGroup(s.oofil161,tp,"H",0,nil)
		if fct>gct then
			local g=Duel.SMCard(tp,s.oofil162,tp,"H",0,fct-gct,fct-gct,nil)
			if #g>0 then
				local tc=g:GetFirst()
				while tc do
					local e1=MakeEff(c,"S")
					e1:SetCode(EFFECT_PUBLIC)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
					tc:RegisterEffect(e1)
					local e2=e1:Clone()
					e2:SetCode(id)
					tc:RegisterEffect(e2)
					local e3=e1:Clone()
					e3:SetCode(EFFECT_FORBIDDEN)
					tc:RegisterEffect(e3)
					local e4=e1:Clone()
					e4:SetCode(EFFECT_CANNOT_DISCARD_HAND)
					tc:RegisterEffect(e4)
					local e5=e1:Clone()
					e5:SetCode(EFFECT_CANNOT_TO_GRAVE_AS_COST)
					tc:RegisterEffect(e5)
					tc=g:GetNext()
				end
			end
		end
	end
end
function s.cfil2(c)
	return c:IsPublic() and c:IsAbleToDeck()
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(s.cfil2,tp,"H",0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SMCard(tp,s.cfil2,tp,"H",0,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToHand()
	end
	Duel.SOI(0,CATEGORY_TOHAND,c,1,0,0)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end
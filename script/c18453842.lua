--삭막한 이 도시가 아름답게 물들 때까지
local s,id=GetID()
function s.initial_effect(c)
	c:SetUniqueOnField(1,1,id)
	local e1=MakeEff(c,"Qo","HG")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCL(1,id)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"S","M")
	e2:SetCode(EFFECT_SET_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetValue(5550)
	e2:SetCondition(function(e)
		return e:GetHandler():IsType(TYPE_TOKEN)
	end)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_SET_DEFENSE)
	e3:SetValue(3000)
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"STo")
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetCL(1,{id,1})
	WriteEff(e4,4,"CTO")
	c:RegisterEffect(e4)
end
function s.cfil1(c)
	return not c:IsType(TYPE_TOKEN) and not c:IsPublic()
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GMGroup(s.cfil1,tp,"H",0,nil)
	if chk==0 then
		return #g>0 and #g==#Duel.GMGroup(function(c)
				return not c:IsType(TYPE_TOKEN)
			end,tp,"H",0,nil)
	end
	Duel.ConfirmCards(1-tp,g)
	local tg=Group.CreateGroup()
	local tc=g:GetFirst()
	while tc do
		local token=Duel.CreateToken(tp,tc:GetOriginalCode())
		tg:AddCard(token)
		tc=g:GetNext()
	end
	Duel.SendtoHand(tg,nil,REASON_EFFECT)
	tc=tg:GetFirst()
	while tc do
		local e1=MakeEff(c,"S")
		e1:SetCode(EFFECT_SUMMONABLE_CARD)
		e1:SetD(id,0)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc:Type(tc:GetType()|TYPE_TOKEN)
		tc=tg:GetNext()
	end
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocCount(tp,"M")>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(10000)
	return true
end
function s.cfil4(c)
	return c:IsType(TYPE_TOKEN) and not c:IsPublic()
end
function s.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsPlayerCanDraw(tp,1)
			and Duel.IEMCard(s.cfil4,tp,"H",0,1,nil)
	end
	local ct=#Duel.GMGroup(nil,tp,"D",0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SMCard(tp,s.cfil4,tp,"H",0,1,ct,nil)
	Duel.ConfirmCards(1-tp,g)
	e:SetLabel(#g)
	Duel.SOI(0,CATEGORY_DRAW,nil,0,tp,#g)
end
function s.op4(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,e:GetLabel(),REASON_EFFECT)
end
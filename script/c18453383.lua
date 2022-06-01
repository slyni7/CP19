--EE(이터널 엘릭서) 아빌라
local s,id=GetID()
function s.initial_effect(c)
	Synchro.AddProcedure(c,nil,1,1,Synchro.NonTuner(nil),1,99)
	c:EnableReviveLimit()
	local e1=MakeEff(c,"STo")
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_HANDES)
	e1:SetCL(1,id)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"Qo","M")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetCL(1,id+1)
	e2:SetD(id,1)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"I","M")
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetCL(1,id+2)
	e3:SetD(id,2)
	WriteEff(e3,3,"CTO")
	c:RegisterEffect(e3)
end
function s.tfil1(c)
	return c:IsSetCard(0x2ea) and c:IsAbleToHand()
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GMGroup(s.tfil1,tp,"D",0,nil)
	local ct=#Duel.GMGroup(Card.IsCode,tp,"M",0,nil,18453234)
	if chk==0 then
		return g:GetClassCount(Card.GetCode)>=ct+1
	end
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GMGroup(s.tfil1,tp,"D",0,nil)
	local ct=#Duel.GMGroup(Card.IsCode,tp,"M",0,nil,18453234)
	if g:GetClassCount(Card.GetCode)<ct+1 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,ct+1,ct+1)
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local dg=Duel.SMCard(tp,aux.TRUE,tp,"H",0,ct,ct,nil)
	if #dg>0 then
		Duel.SendtoGrave(dg,REASON_EFFECT+REASON_DISCARD)
	end
end
function s.tfil2(c)
	return c:IsSetCard(0x2ea) and c:IsFaceup()
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(s.tfil2,tp,"M",0,1,nil)
			and Duel.IsPlayerCanSpecialSummonMonster(tp,18453234,0x2ea,0x4011,1000,1000,2,RACE_FAIRY,ATTRIBUTE_LIGHT)
	end
	Duel.SOI(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,18453234,0x2ea,0x4011,1000,1000,2,RACE_FAIRY,ATTRIBUTE_LIGHT) then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SMCard(tp,s.tfil2,tp,"M",0,1,1,nil)
	local tc=g:GetFirst()
	while tc do
		Duel.Exile(tc,REASON_EFFECT+REASON_TEMPORARY)
		local token=Duel.CreateToken(tp,18453234)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
		local e1=MakeEff(c,"FC")
		e1:SetCode(EVENT_LEAVE_FIELD)
		e1:SetLabelObject({tc,token})
		e1:SetOperation(s.oop21)
		Duel.RegisterEffect(e1,tp)
		if not Duel.IsPlayerCanSpecialSummonMonster(tp,18453234,0x2ea,0x4011,1000,1000,2,RACE_FAIRY,ATTRIBUTE_LIGHT) then
			break
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local tg=Duel.SMCard(tp,s.tfil2,tp,"M",0,0,1,nil)
		tc=tg:GetFirst()
	end
end
function s.oop21(e,tp,eg,ep,ev,re,r,rp)
	local t=e:GetLabelObject()
	local tc,token=table.unpack(t)
	if eg:IsContains(token) then
		Duel.ReturnToField(tc)
		e:Reset()
	end
end
function s.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetFieldGroupCount(tp,LSTN("D"),0)
	if chk==0 then
		return Duel.CheckReleaseGroupCost(tp,Card.IsCode,1,false,nil,nil,18453234)
			and Duel.IsPlayerCanDraw(tp) and ct>1
	end
	local g=Duel.SelectReleaseGroupCost(tp,Card.IsCode,1,ct-1,false,nil,nil,18453234)
	e:SetLabel(#g+1)
	Duel.Release(g,REASON_COST)
end
function s.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SOI(0,CATEGORY_DRAW,nil,0,tp,e:GetLabel())
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,e:GetLabel(),REASON_EFFECT)
end
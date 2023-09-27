--여우요괴 가면
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"SC","S")
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetTarget(s.tar1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"A")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_SEARCH)
	WriteEff(e2,2,"O")
	c:RegisterEffect(e2)
	c:SetUniqueOnField(1,0,id)
	local e3=MakeEff(c,"S")
	e3:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"S")
	e4:SetCode(EFFECT_EQUIP_LIMIT)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetValue(s.val4)
	c:RegisterEffect(e4)
	local e5=MakeEff(c,"FC","S")
	e5:SetCode(EVENT_ADJUST)
	WriteEff(e5,5,"O")
	c:RegisterEffect(e5)
	local e6=MakeEff(c,"F")
	e6:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetTR(1,0)
	e6:SetTarget(s.tar6)
	c:RegisterEffect(e6)
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsReason(REASON_LOST_TARGET)
	end
	return true
end
function s.ofil2(c)
	return c:IsCode("가면") and c:IsAbleToHand()
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,s.ofil2,tp,"D",0,0,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if Duel.IEMCard(s.ofil5,tp,"O",0,1,nil) and Duel.GetLocCount(tp,"S")>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
			Duel.MoveToField(c,1-tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	end
	c:Type(TYPE_SPELL)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(TYPE_SPELL+TYPE_EQUIP)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"FC")
	e2:SetCode(EVENT_CHAIN_END)
	e2:SetCL(1)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetLabelObject(e1)
	e2:SetOperation(s.oop22)
	Duel.RegisterEffect(e2,tp)
end
function s.oop22(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local te=e:GetLabelObject()
	c:Type(TYPE_SPELL+TYPE_EQUIP)
	te:Reset()
	e:Reset()
end
function s.val4(e,c)
	return c:IsCode(18453827)
end
function s.ofil5(c)
	return c:IsCode(18453827) and c:IsFaceup()
end
function s.op5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	if not ec then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SMCard(tp,s.ofil5,tp,"M","M",1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.Equip(tp,c,tc)
		end
	end
end
function s.tar6(e,c)
	return not c:IsRace(RACE_ZOMBIE) and not c:IsLocation(LOCATION_EXTRA)
end